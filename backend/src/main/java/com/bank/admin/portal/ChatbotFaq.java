package com.bank.admin.portal;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.Instant;

@Entity
@Table(name = "chatbot_faqs")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @Builder
public class ChatbotFaq {

    public enum Category { APPOINTMENT, CONTACT, USER_GUIDE, RATES, LOAN_SERVICE, CARD_SERVICE }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "faq_id")
    private Integer id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, columnDefinition = "ENUM('APPOINTMENT','CONTACT','USER_GUIDE','RATES','LOAN_SERVICE','CARD_SERVICE')")
    private Category category;

    @Column(nullable = false, length = 255)
    private String keywords;

    @Column(nullable = false, length = 255)
    private String question;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String answer;

    @Column(name = "action_type", length = 50)
    private String actionType;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private Instant createdAt;
}
