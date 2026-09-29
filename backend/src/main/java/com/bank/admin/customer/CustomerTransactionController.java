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
