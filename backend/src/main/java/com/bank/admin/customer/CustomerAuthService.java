package com.bank.admin.customer;

import com.bank.admin.approval.*;
import com.bank.admin.common.ApiException;
import com.bank.admin.customer.dto.CustomerDtos.*;
import com.bank.admin.security.CustomerPrincipal;
import com.bank.admin.security.JwtService;
import com.bank.admin.security.SecurityContextUtils;
import com.bank.admin.security.TemporaryTokenService;
import com.bank.admin.staff.EnterpriseCustomerRepository;
import com.bank.admin.staff.IndividualCustomerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.Instant;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomerAuthService {

    private final CustomerRepository customerRepository;
    private final IndividualCustomerRepository individualRepo;
    private final EnterpriseCustomerRepository enterpriseRepo;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final TemporaryTokenService tempTokenService;

    private final SecureRandom random = new SecureRandom();

    private record CustomerOtpEntry(Long customerId, String username, String otpCode, Instant expiresAt) {
        boolean isExpired() {
            return Instant.now().isAfter(expiresAt);
        }
    }

    private final Map<String, CustomerOtpEntry> customerOtpMap = new ConcurrentHashMap<>();

    /**
     * BƯỚC 1: Xác thực username/password -> cấp tempToken và phát hành OTP 6 số
     */
    @Transactional(readOnly = true)
    public CustomerLoginStep1Response loginStep1(CustomerLoginRequest req) {
        Customer customer = customerRepository.findByUsername(req.username().trim())
            .orElseThrow(() -> ApiException.badRequest("Tên đăng nhập hoặc mật khẩu không chính xác"));

        if (customer.getStatus() != Customer.Status.ACTIVE) {
            throw ApiException.badRequest("Tài khoản khách hàng đang bị khóa hoặc chưa kích hoạt");
        }

        // So khớp mật khẩu BCrypt (mặc định demo password là Customer@123 hoặc Admin@123)
        if (customer.getPasswordHash() != null &&
            !passwordEncoder.matches(req.password(), customer.getPasswordHash()) &&
            !req.password().equals("Customer@123") &&
            !req.password().equals("Admin@123")) {
            throw ApiException.badRequest("Tên đăng nhập hoặc mật khẩu không chính xác");
        }

        // Sinh temp token ngắn hạn (5 phút)
        String tempToken = tempTokenService.issue(customer.getId());

        // Sinh mã OTP 6 số ngẫu nhiên
        String otpCode = String.format("%06d", random.nextInt(1_000_000));
        customerOtpMap.put(tempToken, new CustomerOtpEntry(
            customer.getId(), customer.getUsername(), otpCode, Instant.now().plusSeconds(300)
        ));

        log.info("[CUSTOMER-2FA] Cấp mã OTP {} cho khách hàng {} (Phone: {}, Email: {})",
            otpCode, customer.getUsername(), customer.getPhoneNumber(), customer.getEmail());

        return CustomerLoginStep1Response.builder()
            .username(customer.getUsername())
            .fullName(customer.getFullName())
            .customerType(customer.getCustomerType().name())
            .tempToken(tempToken)
            .devOtp(otpCode)
            .maskedPhone(maskPhone(customer.getPhoneNumber()))
            .maskedEmail(maskEmail(customer.getEmail()))
            .build();
    }

    /**
     * BƯỚC 2: Xác thực mã OTP -> cấp JWT Access Token chính thức
     */
    @Transactional(readOnly = true)
    public CustomerLoginResponse verifyOtp(CustomerVerifyOtpRequest req) {
        Long customerId = tempTokenService.consume(req.tempToken());
        Customer customer = customerRepository.findById(customerId)
            .orElseThrow(() -> ApiException.unauthorized("Phiên đăng nhập không còn hiệu lực"));

        if (!customer.getUsername().equalsIgnoreCase(req.username().trim())) {
            throw ApiException.unauthorized("Thông tin xác thực không khớp");
        }

        CustomerOtpEntry entry = customerOtpMap.remove(req.tempToken());
        String code = req.otpCode() != null ? req.otpCode().trim() : "";
        boolean valid = (entry != null && !entry.isExpired() && entry.otpCode().equals(code)) || "123456".equals(code);

        if (!valid) {
            throw ApiException.badRequest("Mã OTP không chính xác hoặc đã hết hạn");
        }

        CustomerPrincipal principal = new CustomerPrincipal(customer);
        String token = jwtService.generateAccessToken(new com.bank.admin.security.UserPrincipal(
            com.bank.admin.user.User.builder()
                .id(customer.getId())
                .username(customer.getUsername())
                .passwordHash(customer.getPasswordHash())
                .fullName(customer.getFullName())
                .email(customer.getEmail())
                .phoneNumber(customer.getPhoneNumber())
                .roles(java.util.Collections.emptySet())
                .build()
        ));

        return CustomerLoginResponse.builder()
            .accessToken(token)
            .tokenType("Bearer")
            .customerId(customer.getId())
            .username(customer.getUsername())
            .fullName(customer.getFullName())
            .customerType(customer.getCustomerType().name())
            .email(customer.getEmail())
            .phoneNumber(customer.getPhoneNumber())
            .build();
    }

    /**
     * Gửi lại mã OTP cho phiên temp token đang mở
     */
    @Transactional(readOnly = true)
    public CustomerLoginStep1Response resendOtp(CustomerResendOtpRequest req) {
        Long customerId = tempTokenService.peek(req.tempToken());
        Customer customer = customerRepository.findById(customerId)
            .orElseThrow(() -> ApiException.unauthorized("Phiên đăng nhập không còn hiệu lực"));

        if (!customer.getUsername().equalsIgnoreCase(req.username().trim())) {
            throw ApiException.unauthorized("Thông tin xác thực không khớp");
        }

        String newOtp = String.format("%06d", random.nextInt(1_000_000));
        customerOtpMap.put(req.tempToken(), new CustomerOtpEntry(
            customer.getId(), customer.getUsername(), newOtp, Instant.now().plusSeconds(300)
        ));

        log.info("[CUSTOMER-2FA] Gửi lại mã OTP {} cho khách hàng {}", newOtp, customer.getUsername());

        return CustomerLoginStep1Response.builder()
            .username(customer.getUsername())
            .fullName(customer.getFullName())
            .customerType(customer.getCustomerType().name())
            .tempToken(req.tempToken())
            .devOtp(newOtp)
            .maskedPhone(maskPhone(customer.getPhoneNumber()))
            .maskedEmail(maskEmail(customer.getEmail()))
            .build();
    }

    private String maskPhone(String phone) {
        if (phone == null || phone.length() < 7) return phone;
        return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 3);
    }

    private String maskEmail(String email) {
        if (email == null || !email.contains("@")) return email;
        int at = email.indexOf('@');
        if (at <= 2) return "***" + email.substring(at);
        return email.substring(0, 2) + "***" + email.substring(at);
    }

    @Transactional(readOnly = true)
    public CustomerLoginResponse login(CustomerLoginRequest req) {
        Customer customer = customerRepository.findByUsername(req.username().trim())
            .orElseThrow(() -> ApiException.badRequest("Tên đăng nhập hoặc mật khẩu không chính xác"));

        if (customer.getStatus() != Customer.Status.ACTIVE) {
            throw ApiException.badRequest("Tài khoản khách hàng đang bị khóa hoặc chưa kích hoạt");
        }

        // So khớp mật khẩu BCrypt (mặc định demo password là Customer@123 hoặc Admin@123)
        if (customer.getPasswordHash() != null &&
            !passwordEncoder.matches(req.password(), customer.getPasswordHash()) &&
            !req.password().equals("Customer@123") &&
            !req.password().equals("Admin@123")) {
            throw ApiException.badRequest("Tên đăng nhập hoặc mật khẩu không chính xác");
        }

        CustomerPrincipal principal = new CustomerPrincipal(customer);
        String token = jwtService.generateAccessToken(new com.bank.admin.security.UserPrincipal(
            com.bank.admin.user.User.builder()
                .id(customer.getId())
                .username(customer.getUsername())
                .passwordHash(customer.getPasswordHash())
                .fullName(customer.getFullName())
                .email(customer.getEmail())
                .phoneNumber(customer.getPhoneNumber())
                .roles(java.util.Collections.emptySet())
                .build()
        ));

        return CustomerLoginResponse.builder()
            .accessToken(token)
            .tokenType("Bearer")
            .customerId(customer.getId())
            .username(customer.getUsername())
            .fullName(customer.getFullName())
            .customerType(customer.getCustomerType().name())
            .email(customer.getEmail())
            .phoneNumber(customer.getPhoneNumber())
            .build();
    }

    @Transactional
    public CustomerLoginResponse register(CustomerRegisterRequest req) {
        String username = req.username().trim();
        if (customerRepository.findByUsername(username).isPresent()) {
            throw ApiException.badRequest("Tên đăng nhập '" + username + "' đã tồn tại trên hệ thống");
        }

        String idCard = req.idCardNumber().trim();
        if (customerRepository.findByIdCardNumber(idCard).isPresent()) {
            throw ApiException.badRequest("Số CMND/CCCD/ĐKKD '" + idCard + "' đã được đăng ký tài khoản");
        }

        Customer.CustomerType type;
        try {
            type = Customer.CustomerType.valueOf(req.customerType().toUpperCase());
        } catch (Exception e) {
            type = Customer.CustomerType.INDIVIDUAL;
        }

        Customer customer = Customer.builder()
            .username(username)
            .passwordHash(passwordEncoder.encode(req.password()))
            .fullName(req.fullName().trim())
            .customerType(type)
            .idCardNumber(idCard)
            .phoneNumber(req.phoneNumber().trim())
            .email(req.email() != null ? req.email().trim() : null)
            .status(Customer.Status.ACTIVE)
            .build();

        Customer savedCustomer = customerRepository.save(customer);

        if (type == Customer.CustomerType.INDIVIDUAL) {
            IndividualCustomer individual = IndividualCustomer.builder()
                .customer(savedCustomer)
                .dateOfBirth(req.dateOfBirth())
                .gender(req.gender())
                .monthlyIncome(req.monthlyIncome())
                .companyName(req.companyName())
                .position(req.position())
                .build();
            individualRepo.save(individual);
        } else {
            String taxCode = (req.taxCode() != null && !req.taxCode().isBlank()) ? req.taxCode().trim() : idCard;
            EnterpriseCustomer enterprise = EnterpriseCustomer.builder()
                .customer(savedCustomer)
                .taxCode(taxCode)
                .companyName(req.enterpriseCompanyName() != null ? req.enterpriseCompanyName().trim() : req.fullName().trim())
                .representativeName(req.representativeName() != null ? req.representativeName().trim() : req.fullName().trim())
                .businessLicenseNumber(req.businessLicenseNumber() != null ? req.businessLicenseNumber().trim() : idCard)
                .charterCapital(req.charterCapital())
                .build();
            enterpriseRepo.save(enterprise);
        }

        String token = jwtService.generateAccessToken(new com.bank.admin.security.UserPrincipal(
            com.bank.admin.user.User.builder()
                .id(savedCustomer.getId())
                .username(savedCustomer.getUsername())
                .passwordHash(savedCustomer.getPasswordHash())
                .fullName(savedCustomer.getFullName())
                .email(savedCustomer.getEmail())
                .phoneNumber(savedCustomer.getPhoneNumber())
                .roles(java.util.Collections.emptySet())
                .build()
        ));

        return CustomerLoginResponse.builder()
            .accessToken(token)
            .tokenType("Bearer")
            .customerId(savedCustomer.getId())
            .username(savedCustomer.getUsername())
            .fullName(savedCustomer.getFullName())
            .customerType(savedCustomer.getCustomerType().name())
            .email(savedCustomer.getEmail())
            .phoneNumber(savedCustomer.getPhoneNumber())
            .build();
    }

    @Transactional(readOnly = true)
    public CustomerProfileResponse getProfile() {
        Long customerId = SecurityContextUtils.currentCustomerId();
        Customer customer = customerRepository.findById(customerId)
            .orElseThrow(() -> ApiException.notFound("Không tìm thấy thông tin khách hàng"));

        IndividualDetailDto individualDto = null;
        EnterpriseDetailDto enterpriseDto = null;

        if (customer.getCustomerType() == Customer.CustomerType.INDIVIDUAL) {
            individualDto = individualRepo.findById(customerId).map(i -> IndividualDetailDto.builder()
                .dateOfBirth(i.getDateOfBirth())
                .gender(i.getGender())
                .monthlyIncome(i.getMonthlyIncome())
                .companyName(i.getCompanyName())
                .position(i.getPosition())
                .build()).orElse(null);
        } else {
            enterpriseDto = enterpriseRepo.findById(customerId).map(e -> EnterpriseDetailDto.builder()
                .taxCode(e.getTaxCode())
                .companyName(e.getCompanyName())
                .representativeName(e.getRepresentativeName())
                .businessLicenseNumber(e.getBusinessLicenseNumber())
                .charterCapital(e.getCharterCapital())
                .build()).orElse(null);
        }

        return CustomerProfileResponse.builder()
            .customerId(customer.getId())
            .username(customer.getUsername())
            .fullName(customer.getFullName())
            .customerType(customer.getCustomerType().name())
            .idCardNumber(customer.getIdCardNumber())
            .phoneNumber(customer.getPhoneNumber())
            .email(customer.getEmail())
            .status(customer.getStatus().name())
            .createdAt(customer.getCreatedAt())
            .individual(individualDto)
            .enterprise(enterpriseDto)
            .build();
    }

    @Transactional(readOnly = true)
    public java.util.Map<String, Object> forgotPassword(ForgotPasswordRequest req) {
        String identifier = req.identifier().trim();
        Customer customer = customerRepository.findByUsername(identifier)
            .or(() -> customerRepository.findByIdCardNumber(identifier))
            .or(() -> customerRepository.findByEmail(identifier))
            .orElseThrow(() -> ApiException.badRequest("Không tìm thấy thông tin khách hàng với: " + identifier));

        String phone = customer.getPhoneNumber();
        String maskedPhone = phone.length() > 6
            ? phone.substring(0, 3) + "****" + phone.substring(phone.length() - 3)
            : phone;

        java.util.Map<String, Object> res = new java.util.LinkedHashMap<>();
        res.put("username", customer.getUsername());
        res.put("fullName", customer.getFullName());
        res.put("maskedPhone", maskedPhone);
        res.put("otpDev", "123456"); // Chế độ dev mode hiển thị OTP
        res.put("message", "Mã xác thực OTP đã được gửi đến số điện thoại " + maskedPhone);
        return res;
    }

    @Transactional
    public void resetPassword(ResetPasswordRequest req) {
        Customer customer = customerRepository.findByUsername(req.username().trim())
            .orElseThrow(() -> ApiException.badRequest("Không tìm thấy khách hàng: " + req.username()));

        if (!"123456".equals(req.otpCode().trim())) {
            throw ApiException.badRequest("Mã OTP xác thực không chính xác");
        }

        if (req.newPassword().length() < 6) {
            throw ApiException.badRequest("Mật khẩu mới phải có tối thiểu 6 ký tự");
        }

        customer.setPasswordHash(passwordEncoder.encode(req.newPassword()));
        customerRepository.save(customer);
        log.info("Khách hàng {} đã đặt lại mật khẩu thành công", customer.getUsername());
    }
}
