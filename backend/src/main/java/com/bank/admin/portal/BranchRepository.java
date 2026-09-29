package com.bank.admin.portal;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BranchRepository extends JpaRepository<Branch, Integer> {

    @Query("""
        SELECT b FROM Branch b
        WHERE (:city IS NULL OR b.city = :city)
          AND (:keyword IS NULL OR b.branchName LIKE CONCAT('%', :keyword, '%')
               OR b.address LIKE CONCAT('%', :keyword, '%')
               OR b.district LIKE CONCAT('%', :keyword, '%'))
        ORDER BY b.city ASC, b.branchName ASC
        """)
    List<Branch> searchBranches(@Param("city") String city,
                                @Param("keyword") String keyword);
}
