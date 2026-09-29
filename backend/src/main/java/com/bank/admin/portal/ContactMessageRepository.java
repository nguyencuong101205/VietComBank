package com.bank.admin.portal;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ContactMessageRepository extends JpaRepository<ContactMessage, Long> {

    @Query("""
        SELECT c FROM ContactMessage c
        WHERE (:keyword IS NULL OR c.fullName LIKE CONCAT('%', :keyword, '%')
               OR c.phoneNumber LIKE CONCAT('%', :keyword, '%')
               OR c.subject LIKE CONCAT('%', :keyword, '%'))
          AND (:status IS NULL OR c.status = :status)
        ORDER BY c.createdAt DESC
        """)
    Page<ContactMessage> search(@Param("keyword") String keyword,
                                @Param("status") ContactMessage.Status status,
                                Pageable pageable);
}
