package com.bank.admin.portal;

import com.bank.admin.approval.Application;
import com.bank.admin.approval.ApplicationRepository;
import com.bank.admin.approval.Customer;
import com.bank.admin.approval.CustomerRepository;
import com.bank.admin.cms.Post;
import com.bank.admin.cms.PostRepository;
import com.bank.admin.common.ApiResponse;
import com.bank.admin.data.ExchangeRateRepository;
import com.bank.admin.data.GoldRateRepository;
import com.bank.admin.data.InterestRateRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

/**
 * Public API phục vụ Cổng thông tin khách hàng (Public Portal - Vietcombank Style).
 * Không yêu cầu đăng nhập cán bộ.
 */
@Slf4j
@Tag(name = "Public Portal (Vietcombank)")
@RestController
@RequestMapping("/api/v1/public")
@RequiredArgsConstructor
public class PublicPortalController {

    private final ExchangeRateRepository exchangeRateRepo;
    private final GoldRateRepository goldRateRepo;
    private final InterestRateRepository interestRateRepo;
    private final PostRepository postRepo;
    private final ApplicationRepository applicationRepo;
    private final CustomerRepository customerRepo;
    private final com.bank.admin.staff.StaffService staffService;
    private final com.bank.admin.data.FeeTemplateRepository feeTemplateRepo;
    private final ContactMessageRepository contactMessageRepo;
    private final ChatbotFaqRepository chatbotFaqRepo;
    private final BranchRepository branchRepo;
    private final com.bank.admin.staff.DisputeRequestRepository disputeRepo;
    private final com.bank.admin.staff.SupportTicketRepository ticketRepo;

    // ================= DTOs =================
    public record CreateContactMessageRequest(
        @NotBlank(message = "Họ tên không được để trống") String fullName,
        @NotBlank(message = "Số điện thoại không được để trống") String phoneNumber,
        String email,
        @NotBlank(message = "Tiêu đề không được để trống") String subject,
        @NotBlank(message = "Nội dung liên hệ không được để trống") String message
    ) {}

    public record PublicApplyRequest(
        @NotBlank(message = "Họ tên không được để trống") String fullName,
        @NotBlank(message = "Số CCCD/CMND không được để trống") String idCardNumber,
        @NotBlank(message = "Số điện thoại không được để trống") String phoneNumber,
        String email,
        @NotBlank(message = "Loại hồ sơ không được để trống (LOAN, CARD_ISSUANCE, LIMIT_APPROVAL)") String applicationType,
        @NotNull(message = "Số tiền đề xuất không được để trống")
        @DecimalMin(value = "1000000", message = "Số tiền tối thiểu là 1,000,000 VND") BigDecimal requestedAmount,
        String note
    ) {}

    @Builder
    public record PublicApplyResponse(
        String applicationCode,
        String customerName,
        String applicationType,
        BigDecimal requestedAmount,
        String status,
        String message
    ) {}

    @Operation(summary = "Lấy tỷ giá ngoại tệ mới nhất cho bảng tra cứu trang chủ")
    @GetMapping("/rates/exchange")
    public ApiResponse<List<Map<String, Object>>> getLatestExchangeRates() {
        var page = exchangeRateRepo.search(null, null, null, PageRequest.of(0, 30));
        var list = page.getContent().stream().map(e -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("currencyCode", e.getCurrencyCode());
            m.put("buyRate", e.getBuyRate());
            m.put("transferRate", e.getTransferRate());
            m.put("sellRate", e.getSellRate());
            m.put("effectiveDate", e.getEffectiveDate());
            return m;
        }).toList();
        return ApiResponse.ok(list);
    }

    @Operation(summary = "Lấy bảng giá vàng mới nhất")
    @GetMapping("/rates/gold")
    public ApiResponse<List<Map<String, Object>>> getLatestGoldRates() {
        var page = goldRateRepo.search(null, null, null, PageRequest.of(0, 20));
        var list = page.getContent().stream().map(g -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("goldType", g.getGoldType());
            m.put("buyPrice", g.getBuyPrice());
            m.put("sellPrice", g.getSellPrice());
            m.put("effectiveDate", g.getEffectiveDate());
            return m;
        }).toList();
        return ApiResponse.ok(list);
    }

    @Operation(summary = "Lấy bảng lãi suất tiết kiệm theo kỳ hạn")
    @GetMapping("/rates/interest")
    public ApiResponse<List<Map<String, Object>>> getLatestInterestRates() {
        var page = interestRateRepo.search(null, null, null, PageRequest.of(0, 30));
        var list = page.getContent().stream().map(i -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("productCode", i.getProductCode());
            m.put("termMonths", i.getTermMonths());
            m.put("ratePercentage", i.getRatePercentage());
            m.put("effectiveDate", i.getEffectiveDate());
            return m;
        }).toList();
        return ApiResponse.ok(list);
    }

    @Operation(summary = "Lấy danh sách tin tức / ưu đãi Vietcombank nổi bật")
    @GetMapping("/posts")
    public ApiResponse<List<Map<String, Object>>> getPublicPosts() {
        var page = postRepo.search(null, Post.Status.PUBLISHED, null, PageRequest.of(0, 6));
        var list = page.getContent().stream().map(p -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", p.getId());
            m.put("title", p.getTitle());
            m.put("slug", p.getSlug());
            m.put("summary", p.getSummary());
            m.put("thumbnailUrl", p.getThumbnailUrl());
            m.put("categoryName", p.getCategory() != null ? p.getCategory().getName() : "Tin tức");
            m.put("createdAt", p.getCreatedAt());
            return m;
        }).toList();
        return ApiResponse.ok(list);
    }

    @Operation(summary = "Khách hàng gửi yêu cầu Vay vốn / Mở thẻ trực tuyến")
    @PostMapping("/apply")
    @Transactional
    public ResponseEntity<ApiResponse<PublicApplyResponse>> submitApplication(@Valid @RequestBody PublicApplyRequest req) {
        Customer customer = customerRepo.findByIdCardNumber(req.idCardNumber())
            .orElseGet(() -> {
                Customer newCust = Customer.builder()
                    .fullName(req.fullName().trim())
                    .idCardNumber(req.idCardNumber().trim())
                    .phoneNumber(req.phoneNumber().trim())
                    .email(req.email() != null ? req.email().trim() : null)
                    .build();
                return customerRepo.save(newCust);
            });

        // Tạo mã hồ sơ ngẫu nhiên chuẩn ngân hàng (vd: VCB-2026-XXXX)
        String appCode = "VCB-" + LocalDate.now().getYear() + "-" + String.format("%05d", (int)(Math.random() * 90000) + 10000);
        while (applicationRepo.existsByApplicationCode(appCode)) {
            appCode = "VCB-" + LocalDate.now().getYear() + "-" + String.format("%05d", (int)(Math.random() * 90000) + 10000);
        }

        Application.Type appType;
        try {
            appType = Application.Type.valueOf(req.applicationType().toUpperCase());
        } catch (Exception e) {
            appType = Application.Type.LOAN;
        }

        Application application = Application.builder()
            .applicationCode(appCode)
            .customer(customer)
            .type(appType)
            .requestedAmount(req.requestedAmount())
            .status(Application.Status.PENDING)
            .build();

        applicationRepo.save(application);
        log.info("Khách hàng {} ({}) đã gửi hồ sơ trực tuyến {}", customer.getFullName(), customer.getPhoneNumber(), appCode);

        PublicApplyResponse res = PublicApplyResponse.builder()
            .applicationCode(appCode)
            .customerName(customer.getFullName())
            .applicationType(appType.name())
            .requestedAmount(req.requestedAmount())
            .status("PENDING")
            .message("Hồ sơ đã được gửi thành công. Cán bộ Vietcombank sẽ liên hệ trong vòng 24h làm việc.")
            .build();

        return ResponseEntity.status(201).body(ApiResponse.ok("Nộp hồ sơ thành công", res));
    }

    @Operation(summary = "Khách hàng đặt lịch hẹn tại quầy qua Chatbot / Cổng điện tử")
    @PostMapping("/appointments")
    public ResponseEntity<ApiResponse<com.bank.admin.staff.dto.StaffDtos.AppointmentResponse>> submitAppointment(
            @Valid @RequestBody com.bank.admin.staff.dto.StaffDtos.CreateAppointmentRequest req
    ) {
        var res = staffService.createAppointment(req);
        return ResponseEntity.status(201).body(ApiResponse.ok("Đặt lịch hẹn thành công", res));
    }

    @Operation(summary = "Lấy danh sách biểu phí và mẫu biểu dịch vụ công khai")
    @GetMapping("/fees")
    public ApiResponse<List<Map<String, Object>>> getPublicFeeTemplates() {
        var page = feeTemplateRepo.search(null, true, PageRequest.of(0, 50));
        var list = page.getContent().stream().map(f -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("templateId", f.getId());
            m.put("title", f.getTitle());
            m.put("filePath", f.getFilePath());
            m.put("fileType", f.getFileType());
            m.put("createdAt", f.getCreatedAt());
            return m;
        }).toList();
        return ApiResponse.ok(list);
    }

    @Operation(summary = "Gửi tin nhắn liên hệ / góp ý tới Vietcombank")
    @PostMapping("/contacts")
    @Transactional
    public ResponseEntity<ApiResponse<Map<String, Object>>> submitContact(@Valid @RequestBody CreateContactMessageRequest req) {
        ContactMessage msg = ContactMessage.builder()
            .fullName(req.fullName().trim())
            .phoneNumber(req.phoneNumber().trim())
            .email(req.email() != null && !req.email().isBlank() ? req.email().trim() : null)
            .subject(req.subject().trim())
            .message(req.message().trim())
            .status(ContactMessage.Status.NEW)
            .build();
        contactMessageRepo.save(msg);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("messageId", msg.getId());
        res.put("fullName", msg.getFullName());
        res.put("subject", msg.getSubject());
        res.put("status", msg.getStatus().name());
        res.put("message", "Cảm ơn quý khách đã gửi tin nhắn liên hệ. Vietcombank sẽ phản hồi sớm nhất!");
        return ResponseEntity.status(201).body(ApiResponse.ok("Gửi liên hệ thành công", res));
    }

    @Operation(summary = "Lấy danh sách câu hỏi thường gặp FAQ Chatbot")
    @GetMapping("/faqs")
    public ApiResponse<List<Map<String, Object>>> getFaqs(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String keyword
    ) {
        ChatbotFaq.Category cat = null;
        if (category != null && !category.isBlank()) {
            try {
                cat = ChatbotFaq.Category.valueOf(category.toUpperCase());
            } catch (Exception ignored) {}
        }
        var faqs = chatbotFaqRepo.searchFaqs(cat, (keyword != null && !keyword.isBlank()) ? keyword.trim() : null);
        var list = faqs.stream().map(f -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("faqId", f.getId());
            m.put("category", f.getCategory().name());
            m.put("keywords", f.getKeywords());
            m.put("question", f.getQuestion());
            m.put("answer", f.getAnswer());
            m.put("actionType", f.getActionType());
            return m;
        }).toList();
        return ApiResponse.ok(list);
    }

    @Operation(summary = "Lấy danh sách chi nhánh / phòng giao dịch Vietcombank")
    @GetMapping("/branches")
    public ApiResponse<List<Branch>> getBranches(
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String keyword
    ) {
        var branches = branchRepo.searchBranches(
            (city != null && !city.isBlank()) ? city.trim() : null,
            (keyword != null && !keyword.isBlank()) ? keyword.trim() : null
        );
        return ApiResponse.ok(branches);
    }

    @Operation(summary = "Tra cứu tiến độ hồ sơ / tra soát / yêu cầu hỗ trợ theo mã")
    @GetMapping("/track")
    @Transactional(readOnly = true)
    public ApiResponse<Map<String, Object>> trackByCode(@RequestParam String code) {
        String queryCode = code.trim();
        Map<String, Object> result = new LinkedHashMap<>();

        // 1. Kiểm tra hồ sơ (Application)
        var optApp = applicationRepo.findByApplicationCode(queryCode);
        if (optApp.isPresent()) {
            var app = optApp.get();
            result.put("type", "APPLICATION");
            result.put("code", app.getApplicationCode());
            result.put("customerName", app.getCustomer() != null ? app.getCustomer().getFullName() : "Khách hàng");
            result.put("itemType", app.getType().name());
            result.put("requestedAmount", app.getRequestedAmount());
            result.put("status", app.getStatus().name());
            result.put("createdAt", app.getCreatedAt());
            result.put("description", "Hồ sơ " + app.getType() + " - Trạng thái: " + app.getStatus());
            return ApiResponse.ok("Tìm thấy thông tin hồ sơ", result);
        }

        // 2. Kiểm tra tra soát (Dispute)
        var optDispute = disputeRepo.findByDisputeCode(queryCode);
        if (optDispute.isPresent()) {
            var d = optDispute.get();
            result.put("type", "DISPUTE");
            result.put("code", d.getDisputeCode());
            result.put("customerName", d.getCustomer() != null ? d.getCustomer().getFullName() : "Khách hàng");
            result.put("transactionCode", d.getTransactionCode());
            result.put("status", d.getStatus().name());
            result.put("reason", d.getReason());
            result.put("resolutionNote", d.getResolutionNote());
            result.put("createdAt", d.getCreatedAt());
            result.put("description", "Yêu cầu tra soát " + d.getDisputeCode() + " - Trạng thái: " + d.getStatus());
            return ApiResponse.ok("Tìm thấy yêu cầu tra soát", result);
        }

        // 3. Kiểm tra phiếu hỗ trợ (Ticket)
        var optTicket = ticketRepo.findByTicketCode(queryCode);
        if (optTicket.isPresent()) {
            var t = optTicket.get();
            result.put("type", "TICKET");
            result.put("code", t.getTicketCode());
            result.put("customerName", t.getCustomer() != null ? t.getCustomer().getFullName() : "Khách hàng");
            result.put("title", t.getTitle());
            result.put("status", t.getStatus().name());
            result.put("priority", t.getPriority().name());
            result.put("createdAt", t.getCreatedAt());
            result.put("description", "Phiếu hỗ trợ " + t.getTicketCode() + " - Trạng thái: " + t.getStatus());
            return ApiResponse.ok("Tìm thấy phiếu hỗ trợ", result);
        }

        return ApiResponse.ok("Không tìm thấy thông tin tương ứng với mã tra cứu: " + queryCode, null);
    }
}
