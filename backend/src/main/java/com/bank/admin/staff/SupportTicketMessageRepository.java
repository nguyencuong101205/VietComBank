package com.bank.admin.staff;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SupportTicketMessageRepository extends JpaRepository<SupportTicketMessage, Long> {
    List<SupportTicketMessage> findByTicketIdOrderByCreatedAtAsc(Long ticketId);
    long countByTicketId(Long ticketId);
}
