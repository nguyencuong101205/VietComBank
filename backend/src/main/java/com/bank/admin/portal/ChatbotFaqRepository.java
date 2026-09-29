package com.bank.admin.portal;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ChatbotFaqRepository extends JpaRepository<ChatbotFaq, Integer> {

    @Query("""
        SELECT f FROM ChatbotFaq f
        WHERE (:category IS NULL OR f.category = :category)
          AND (:keyword IS NULL OR f.keywords LIKE CONCAT('%', :keyword, '%')
               OR f.question LIKE CONCAT('%', :keyword, '%')
               OR f.answer LIKE CONCAT('%', :keyword, '%'))
        ORDER BY f.id ASC
        """)
    List<ChatbotFaq> searchFaqs(@Param("category") ChatbotFaq.Category category,
                                @Param("keyword") String keyword);
}
