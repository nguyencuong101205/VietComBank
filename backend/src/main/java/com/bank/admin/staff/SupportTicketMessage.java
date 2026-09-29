package com.bank.admin.staff;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.Instant;

/**
 * Tin nhắn trao đổi hai chiều giữa Khách hàng và Nhân viên CSKH trong phiếu hỗ trợ (Ticket).
 */
@Entity
@Table(name = "support_ticket_messages")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @Builder
public class SupportTicketMessage {

    public enum SenderType {
        CUSTOMER, // Tin nhắn do Khách hàng gửi
        STAFF     // Tin nhắn do Nhân viên / Cán bộ CSKH gửi
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "message_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ticket_id", nullable = false)
    private SupportTicket ticket;

    @Enumerated(EnumType.STRING)
    @Column(name = "sender_type", nullable = false, length = 20)
    private SenderType senderType;

    @Column(name = "sender_id", nullable = false)
    private Long senderId;

    @Column(name = "sender_name", nullable = false, length = 150)
    private String senderName;

    @Column(name = "message_text", nullable = false, columnDefinition = "TEXT")
    private String messageText;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private Instant createdAt;
}
