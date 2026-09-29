package com.bank.admin.portal;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "branches")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor @Builder
public class Branch {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "branch_id")
    private Integer id;

    @Column(name = "branch_name", nullable = false, length = 150)
    private String branchName;

    @Column(nullable = false, length = 255)
    private String address;

    @Column(length = 100)
    private String district;

    @Column(nullable = false, length = 100)
    private String city;

    @Column(name = "phone_number", length = 50)
    private String phoneNumber;

    @Column(name = "working_hours", length = 100)
    @Builder.Default
    private String workingHours = "08:00 - 17:00 (Thứ 2 - Thứ 6)";
}
