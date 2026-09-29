package com.bank.admin.customer;

import com.bank.admin.approval.Customer;
import com.bank.admin.approval.CustomerRepository;
import com.bank.admin.common.ApiException;
import com.bank.admin.common.ApiResponse;
import com.bank.admin.customer.dto.CustomerDtos.*;
import com.bank.admin.security.SecurityContextUtils;
import com.bank.admin.staff.*;
import com.bank.admin.user.User;
import com.bank.admin.user.UserRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.*;

@Slf4j
@RestController
@RequestMapping({"/api/v1/customer", "/api/customer"})
@RequiredArgsConstructor
public class CustomerTransactionController {

    private final FinancialTransactionRepository transactionRepo;
    private final CustomerRepository customerRepo;
    private final DisputeRequestRepository disputeRepo;
    private final SupportTicketRepository ticketRepo;
    private final com.bank.admin.staff.SupportTicketMessageRepository ticketMessageRepo;
    private final UserRepository userRepo;

    /**
     * 1. Lịch sử giao dịch: Danh sách các giao dịch gửi / nhận tiền của khách hàng
     */
    @GetMapping("/transactions")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('INDIVIDUAL') or hasRole('ENTERPRISE')")
    public ApiResponse<List<CashFlowItemDto>> getTransactions() {
        Long customerId = SecurityContextUtils.currentCustomerId();
        Customer customer = customerRepo.findById(customerId)
            .orElseThrow(() -> ApiException.notFound("Không tìm thấy khách hàng"));

        String accNum = customer.getPhoneNumber();
        List<FinancialTransaction> txs = transactionRepo.findByCustomerTransactions(customerId, accNum);

        List<CashFlowItemDto> dtos = txs.stream().map(t -> {
            boolean isSender = t.getSenderCustomer() != null && t.getSenderCustomer().getId().equals(customerId);
            return CashFlowItemDto.builder()
                .id(t.getId())
                .transactionCode(t.getTransactionCode())
                .type(isSender ? "OUTFLOW" : "INFLOW")
                .amount(t.getAmount())
                .counterpartyName(isSender ? t.getReceiverName() : (t.getSenderCustomer() != null ? t.getSenderCustomer().getFullName() : "Nộp tiền mặt"))
                .bankName(t.getBankName())
                .description(t.getDescription())
                .createdAt(t.getCreatedAt())
                .build();
        }).toList();

        return ApiResponse.ok(dtos);
    }

    /**
     * 2. Quản lý dòng tiền: Thống kê dòng tiền vào/ra (Inflow/Outflow) cho Doanh nghiệp
     */
    @GetMapping("/cash-flow")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('ENTERPRISE')")
    public ApiResponse<CashFlowStatisticResponse> getCashFlow() {
        Long customerId = SecurityContextUtils.currentCustomerId();
        Customer customer = customerRepo.findById(customerId)
            .orElseThrow(() -> ApiException.notFound("Không tìm thấy khách hàng"));

        String accNum = customer.getPhoneNumber();
        List<FinancialTransaction> txs = transactionRepo.findByCustomerTransactions(customerId, accNum);

        BigDecimal totalIn = BigDecimal.ZERO;
        BigDecimal totalOut = BigDecimal.ZERO;
        List<CashFlowItemDto> items = new ArrayList<>();

        for (FinancialTransaction t : txs) {
            boolean isSender = t.getSenderCustomer() != null && t.getSenderCustomer().getId().equals(customerId);
            if (isSender) {
                totalOut = totalOut.add(t.getAmount());
            } else {
                totalIn = totalIn.add(t.getAmount());
            }
            items.add(CashFlowItemDto.builder()
                .id(t.getId())
                .transactionCode(t.getTransactionCode())
                .type(isSender ? "OUTFLOW" : "INFLOW")
                .amount(t.getAmount())
                .counterpartyName(isSender ? t.getReceiverName() : (t.getSenderCustomer() != null ? t.getSenderCustomer().getFullName() : "Nộp tiền mặt"))
                .bankName(t.getBankName())
                .description(t.getDescription())
                .createdAt(t.getCreatedAt())
                .build());
        }

        BigDecimal net = totalIn.subtract(totalOut);

        return ApiResponse.ok(CashFlowStatisticResponse.builder()
            .totalInflow(totalIn)
            .totalOutflow(totalOut)
            .netCashFlow(net)
            .totalTransactions((long) txs.size())
            .recentTransactions(items)
            .build());
    }

    /**
     * 3. Danh sách tra soát của khách hàng
     */
    @GetMapping("/disputes")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('INDIVIDUAL') or hasRole('ENTERPRISE')")
    public ApiResponse<List<CustomerDisputeResponse>> getCustomerDisputes() {
        Long customerId = SecurityContextUtils.currentCustomerId();
        List<DisputeRequest> list = disputeRepo.findByCustomerIdOrderByCreatedAtDesc(customerId);
        List<CustomerDisputeResponse> dtos = list.stream().map(d -> CustomerDisputeResponse.builder()
            .id(d.getId())
            .disputeCode(d.getDisputeCode())
            .transactionCode(d.getTransactionCode())
            .reason(d.getReason())
            .status(d.getStatus().name())
            .resolutionNote(d.getResolutionNote())
            .createdAt(d.getCreatedAt())
            .updatedAt(d.getUpdatedAt())
            .build()).toList();
        return ApiResponse.ok(dtos);
    }

    /**
     * 4. Khách hàng gửi yêu cầu tra soát giao dịch
     */
    @PostMapping("/disputes")
    @Transactional
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('INDIVIDUAL') or hasRole('ENTERPRISE')")
    public ApiResponse<CustomerDisputeResponse> createCustomerDispute(@Valid @RequestBody CreateDisputeRequest req) {
        Long customerId = SecurityContextUtils.currentCustomerId();
        Customer customer = customerRepo.findById(customerId)
            .orElseThrow(() -> ApiException.notFound("Không tìm thấy khách hàng"));

        String code = "TS-" + LocalDate.now().getYear() + "-" + String.format("%04d", (int)(Math.random() * 9000) + 1000);

        DisputeRequest dispute = DisputeRequest.builder()
            .disputeCode(code)
            .customer(customer)
            .transactionCode(req.transactionCode().trim())
            .reason(req.reason().trim())
            .status(DisputeRequest.Status.PENDING)
            .build();
        dispute = disputeRepo.save(dispute);
        log.info("Khách hàng {} đã tạo yêu cầu tra soát {}", customer.getFullName(), code);

        return ApiResponse.ok("Gửi yêu cầu tra soát thành công", CustomerDisputeResponse.builder()
            .id(dispute.getId())
            .disputeCode(dispute.getDisputeCode())
            .transactionCode(dispute.getTransactionCode())
            .reason(dispute.getReason())
            .status(dispute.getStatus().name())
            .resolutionNote(null)
            .createdAt(dispute.getCreatedAt())
            .updatedAt(dispute.getUpdatedAt())
            .build());
    }

    /**
     * 5. Danh sách ticket hỗ trợ của khách hàng
     */
    @GetMapping("/tickets")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('INDIVIDUAL') or hasRole('ENTERPRISE')")
    public ApiResponse<List<CustomerTicketResponse>> getCustomerTickets() {
        Long customerId = SecurityContextUtils.currentCustomerId();
        List<SupportTicket> list = ticketRepo.findByCustomerIdOrderByCreatedAtDesc(customerId);
        List<CustomerTicketResponse> dtos = list.stream().map(t -> CustomerTicketResponse.builder()
            .id(t.getId())
            .ticketCode(t.getTicketCode())
            .title(t.getTitle())
            .content(t.getContent())
            .priority(t.getPriority().name())
            .status(t.getStatus().name())
            .createdAt(t.getCreatedAt())
            .updatedAt(t.getUpdatedAt())
            .build()).toList();
        return ApiResponse.ok(dtos);
    }

    /**
     * 6. Khách hàng gửi phiếu yêu cầu hỗ trợ CSKH
     */
    @PostMapping("/tickets")
    @Transactional
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('INDIVIDUAL') or hasRole('ENTERPRISE')")
    public ApiResponse<CustomerTicketResponse> createCustomerTicket(@Valid @RequestBody CreateSupportTicketRequest req) {
        Long customerId = SecurityContextUtils.currentCustomerId();
        Customer customer = customerRepo.findById(customerId)
            .orElseThrow(() -> ApiException.notFound("Không tìm thấy khách hàng"));

        String code = "TK-" + LocalDate.now().getYear() + "-" + String.format("%04d", (int)(Math.random() * 9000) + 1000);
        SupportTicket.Priority priority = SupportTicket.Priority.MEDIUM;
        if (req.priority() != null && !req.priority().isBlank()) {
            try { priority = SupportTicket.Priority.valueOf(req.priority().toUpperCase()); } catch (Exception ignored) {}
        }

        SupportTicket ticket = SupportTicket.builder()
            .ticketCode(code)
            .customer(customer)
            .title(req.title().trim())
            .content(req.content().trim())
            .priority(priority)
            .status(SupportTicket.Status.NEW)
            .build();
        ticket = ticketRepo.save(ticket);

        // Lưu tin nhắn mở đầu của khách hàng vào luồng hội thoại
        com.bank.admin.staff.SupportTicketMessage initialMsg = com.bank.admin.staff.SupportTicketMessage.builder()
            .ticket(ticket)
            .senderType(com.bank.admin.staff.SupportTicketMessage.SenderType.CUSTOMER)
            .senderId(customer.getId())
            .senderName(customer.getFullName())
            .messageText(ticket.getContent())
            .build();
        ticketMessageRepo.save(initialMsg);

        log.info("Khách hàng {} đã tạo ticket hỗ trợ {}", customer.getFullName(), code);

        return ApiResponse.ok("Tạo yêu cầu hỗ trợ thành công", CustomerTicketResponse.builder()
            .id(ticket.getId())
            .ticketCode(ticket.getTicketCode())
            .title(ticket.getTitle())
            .content(ticket.getContent())
            .priority(ticket.getPriority().name())
            .status(ticket.getStatus().name())
            .createdAt(ticket.getCreatedAt())
            .updatedAt(ticket.getUpdatedAt())
            .messages(java.util.List.of(com.bank.admin.staff.dto.StaffDtos.TicketMessageDto.builder()
                .id(initialMsg.getId())
                .ticketId(ticket.getId())
                .senderType(initialMsg.getSenderType().name())
                .senderId(initialMsg.getSenderId())
                .senderName(initialMsg.getSenderName())
                .messageText(initialMsg.getMessageText())
                .createdAt(initialMsg.getCreatedAt())
                .build()))
            .build());
    }

    /**
     * 6.1. Chi tiết phiếu hỗ trợ kèm luồng tin nhắn trao đổi hai chiều
     */
    @GetMapping("/tickets/{id}")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('INDIVIDUAL') or hasRole('ENTERPRISE')")
    public ApiResponse<CustomerTicketResponse> getCustomerTicketDetail(@PathVariable Long id) {
        Long customerId = SecurityContextUtils.currentCustomerId();
        SupportTicket t = ticketRepo.findById(id)
            .orElseThrow(() -> ApiException.notFound("Không tìm thấy phiếu hỗ trợ #" + id));
        if (!t.getCustomer().getId().equals(customerId)) {
            throw ApiException.forbidden("Bạn không có quyền truy cập phiếu hỗ trợ này");
        }

        List<com.bank.admin.staff.dto.StaffDtos.TicketMessageDto> messages = ticketMessageRepo.findByTicketIdOrderByCreatedAtAsc(t.getId()).stream()
            .map(m -> com.bank.admin.staff.dto.StaffDtos.TicketMessageDto.builder()
                .id(m.getId())
                .ticketId(m.getTicket().getId())
                .senderType(m.getSenderType().name())
                .senderId(m.getSenderId())
                .senderName(m.getSenderName())
                .messageText(m.getMessageText())
                .createdAt(m.getCreatedAt())
                .build())
            .toList();

        return ApiResponse.ok(CustomerTicketResponse.builder()
            .id(t.getId())
            .ticketCode(t.getTicketCode())
            .title(t.getTitle())
            .content(t.getContent())
            .priority(t.getPriority().name())
            .status(t.getStatus().name())
            .createdAt(t.getCreatedAt())
            .updatedAt(t.getUpdatedAt())
            .messages(messages)
            .build());
    }

    /**
     * 6.2. Danh sách tin nhắn trao đổi của một ticket
     */
    @GetMapping("/tickets/{id}/messages")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('INDIVIDUAL') or hasRole('ENTERPRISE')")
    public ApiResponse<List<com.bank.admin.staff.dto.StaffDtos.TicketMessageDto>> getCustomerTicketMessages(@PathVariable Long id) {
        Long customerId = SecurityContextUtils.currentCustomerId();
        SupportTicket t = ticketRepo.findById(id)
            .orElseThrow(() -> ApiException.notFound("Không tìm thấy phiếu hỗ trợ #" + id));
        if (!t.getCustomer().getId().equals(customerId)) {
            throw ApiException.forbidden("Bạn không có quyền truy cập phiếu hỗ trợ này");
        }

        List<com.bank.admin.staff.dto.StaffDtos.TicketMessageDto> messages = ticketMessageRepo.findByTicketIdOrderByCreatedAtAsc(t.getId()).stream()
            .map(m -> com.bank.admin.staff.dto.StaffDtos.TicketMessageDto.builder()
                .id(m.getId())
                .ticketId(m.getTicket().getId())
                .senderType(m.getSenderType().name())
                .senderId(m.getSenderId())
                .senderName(m.getSenderName())
                .messageText(m.getMessageText())
                .createdAt(m.getCreatedAt())
                .build())
            .toList();
        return ApiResponse.ok(messages);
    }

    /**
     * 6.3. Khách hàng gửi tin nhắn trao đổi tới nhân viên CSKH
     */
    @PostMapping("/tickets/{id}/messages")
    @Transactional
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('INDIVIDUAL') or hasRole('ENTERPRISE')")
    public ApiResponse<com.bank.admin.staff.dto.StaffDtos.TicketMessageDto> sendCustomerMessage(
            @PathVariable Long id,
            @Valid @RequestBody SendCustomerTicketMessageRequest req) {
        Long customerId = SecurityContextUtils.currentCustomerId();
        SupportTicket t = ticketRepo.findById(id)
            .orElseThrow(() -> ApiException.notFound("Không tìm thấy phiếu hỗ trợ #" + id));
        if (!t.getCustomer().getId().equals(customerId)) {
            throw ApiException.forbidden("Bạn không có quyền gửi tin nhắn cho phiếu hỗ trợ này");
        }

        Customer customer = customerRepo.findById(customerId)
            .orElseThrow(() -> ApiException.notFound("Không tìm thấy thông tin khách hàng"));

        // Khi khách hàng gửi tin nhắn phản hồi, nếu ticket đang NEW hoặc CLOSED/RESOLVED, mở lại trạng thái IN_PROGRESS
        if (t.getStatus() == SupportTicket.Status.RESOLVED || t.getStatus() == SupportTicket.Status.CLOSED) {
            t.setStatus(SupportTicket.Status.IN_PROGRESS);
            ticketRepo.save(t);
        }

        com.bank.admin.staff.SupportTicketMessage msg = com.bank.admin.staff.SupportTicketMessage.builder()
            .ticket(t)
            .senderType(com.bank.admin.staff.SupportTicketMessage.SenderType.CUSTOMER)
            .senderId(customer.getId())
            .senderName(customer.getFullName())
            .messageText(req.messageText().trim())
            .build();
        msg = ticketMessageRepo.save(msg);

        log.info("Khách hàng {} gửi tin nhắn trao đổi trong ticket {}", customer.getFullName(), t.getTicketCode());

        return ApiResponse.ok("Gửi tin nhắn trao đổi thành công", com.bank.admin.staff.dto.StaffDtos.TicketMessageDto.builder()
            .id(msg.getId())
            .ticketId(t.getId())
            .senderType(msg.getSenderType().name())
            .senderId(msg.getSenderId())
            .senderName(msg.getSenderName())
            .messageText(msg.getMessageText())
            .createdAt(msg.getCreatedAt())
            .build());
    }

    /**
     * 7. Khách hàng Doanh nghiệp thực hiện chi trả lương theo lô (Batch Salary Payment)
     */
    @PostMapping("/payroll/execute")
    @Transactional
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('ENTERPRISE')")
    public ApiResponse<PayrollBatchResponse> executePayroll(@Valid @RequestBody PayrollBatchRequest req) {
        Long customerId = SecurityContextUtils.currentCustomerId();
        Customer customer = customerRepo.findById(customerId)
            .orElseThrow(() -> ApiException.notFound("Không tìm thấy khách hàng"));

        if (customer.getCustomerType() != Customer.CustomerType.ENTERPRISE) {
            throw ApiException.badRequest("Dịch vụ chi trả lương chỉ dành cho Khách hàng Doanh nghiệp");
        }

        User staff = userRepo.findById(101L).orElseGet(() -> userRepo.findAll().get(0));
        String batchCode = "PAY-" + LocalDate.now().getYear() + "-" + String.format("%05d", (int)(Math.random() * 90000) + 10000);

        String batchName = req.getEffectiveBatchName();
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (PayrollItemRequest item : req.items()) {
            totalAmount = totalAmount.add(item.amount());
            String txCode = "TXN-PAY-" + System.currentTimeMillis() + "-" + ((int)(Math.random() * 900) + 100);
            FinancialTransaction tx = FinancialTransaction.builder()
                .transactionCode(txCode)
                .senderCustomer(customer)
                .receiverAccountNumber(item.getEffectiveAccountNumber())
                .receiverName(item.employeeName().trim())
                .bankName(item.bankName() != null && !item.bankName().isBlank() ? item.bankName().trim() : "Vietcombank")
                .amount(item.amount())
                .fee(BigDecimal.ZERO)
                .description("Chi lương: " + batchName + " - " + (item.note() != null ? item.note() : item.employeeName()))
                .processedByStaff(staff)
                .status(FinancialTransaction.Status.SUCCESS)
                .build();
            transactionRepo.save(tx);
        }

        log.info("Doanh nghiệp {} đã thực hiện đợt chi lương {} ({} nhân viên, tổng tiền: {})",
            customer.getFullName(), batchCode, req.items().size(), totalAmount);

        return ApiResponse.ok("Thực hiện chi trả lương theo lô thành công", PayrollBatchResponse.builder()
            .batchCode(batchCode)
            .batchName(batchName)
            .totalEmployees(req.items().size())
            .totalAmount(totalAmount)
            .status("COMPLETED")
            .executedAt(Instant.now())
            .message("Đã hoàn tất thanh toán lương cho " + req.items().size() + " nhân viên.")
            .build());
    }

    /**
     * 8. Lịch sử các giao dịch chi trả lương doanh nghiệp
     */
    @GetMapping("/payroll/history")
    @PreAuthorize("hasRole('CUSTOMER') or hasRole('ENTERPRISE')")
    public ApiResponse<List<Map<String, Object>>> getPayrollHistory() {
        Long customerId = SecurityContextUtils.currentCustomerId();
        Customer customer = customerRepo.findById(customerId)
            .orElseThrow(() -> ApiException.notFound("Không tìm thấy khách hàng"));

        String accNum = customer.getPhoneNumber();
        List<FinancialTransaction> txs = transactionRepo.findByCustomerTransactions(customerId, accNum);

        List<FinancialTransaction> payrollTxs = txs.stream()
            .filter(t -> t.getDescription() != null && t.getDescription().contains("Chi lương"))
            .toList();

        List<Map<String, Object>> result = payrollTxs.stream().map(t -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", t.getId());
            m.put("transactionCode", t.getTransactionCode());
            m.put("receiverName", t.getReceiverName());
            m.put("receiverAccountNumber", t.getReceiverAccountNumber());
            m.put("bankName", t.getBankName());
            m.put("amount", t.getAmount());
            m.put("description", t.getDescription());
            m.put("status", t.getStatus().name());
            m.put("createdAt", t.getCreatedAt());
            return m;
        }).toList();

        return ApiResponse.ok(result);
    }
}
