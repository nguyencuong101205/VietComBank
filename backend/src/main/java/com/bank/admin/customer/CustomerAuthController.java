package com.bank.admin.customer;

import com.bank.admin.common.ApiResponse;
import com.bank.admin.customer.dto.CustomerDtos.*;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping({"/api/v1/customer", "/api/customer"})
@RequiredArgsConstructor
public class CustomerAuthController {

    private final CustomerAuthService authService;

    @PostMapping({"/auth/login", "/login"})
    public ApiResponse<CustomerLoginStep1Response> login(@Valid @RequestBody CustomerLoginRequest req) {
        return ApiResponse.ok("Xác thực thông tin thành công, vui lòng nhập mã OTP để tiếp tục", authService.loginStep1(req));
    }

    @PostMapping({"/auth/verify-otp", "/verify-otp"})
    public ApiResponse<CustomerLoginResponse> verifyOtp(@Valid @RequestBody CustomerVerifyOtpRequest req) {
        return ApiResponse.ok("Đăng nhập thành công", authService.verifyOtp(req));
    }

    @PostMapping({"/auth/resend-otp", "/resend-otp"})
    public ApiResponse<CustomerLoginStep1Response> resendOtp(@Valid @RequestBody CustomerResendOtpRequest req) {
        return ApiResponse.ok("Đã gửi lại mã OTP", authService.resendOtp(req));
    }

    @PostMapping({"/auth/direct-login", "/direct-login"})
    public ApiResponse<CustomerLoginResponse> directLogin(@Valid @RequestBody CustomerLoginRequest req) {
        return ApiResponse.ok("Đăng nhập thành công", authService.login(req));
    }

    @PostMapping({"/auth/register", "/register"})
    public ApiResponse<CustomerLoginResponse> register(@Valid @RequestBody CustomerRegisterRequest req) {
        return ApiResponse.ok("Đăng ký tài khoản khách hàng thành công", authService.register(req));
    }

    @PostMapping({"/auth/forgot-password", "/forgot-password"})
    public ApiResponse<java.util.Map<String, Object>> forgotPassword(@Valid @RequestBody ForgotPasswordRequest req) {
        return ApiResponse.ok("Gửi mã xác thực thành công", authService.forgotPassword(req));
    }

    @PostMapping({"/auth/reset-password", "/reset-password"})
    public ApiResponse<Void> resetPassword(@Valid @RequestBody ResetPasswordRequest req) {
        authService.resetPassword(req);
        return ApiResponse.message("Đặt lại mật khẩu thành công");
    }

    @GetMapping("/profile")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('INDIVIDUAL') or hasRole('ENTERPRISE')")
    public ApiResponse<CustomerProfileResponse> getProfile() {
        return ApiResponse.ok(authService.getProfile());
    }
}
