-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 100.86.222.38    Database: admin_portal_db
-- ------------------------------------------------------
-- Server version	11.8.6-MariaDB-0+deb13u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `admin_portal_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `admin_portal_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `admin_portal_db`;

--
-- Table structure for table `application_approvals`
--

DROP TABLE IF EXISTS `application_approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_approvals` (
  `approval_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) NOT NULL,
  `manager_id` bigint(20) NOT NULL,
  `action` enum('APPROVED','REJECTED','REQUEST_DOCS') NOT NULL,
  `reason_note` text DEFAULT NULL,
  `processed_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`approval_id`),
  KEY `application_id` (`application_id`),
  KEY `manager_id` (`manager_id`),
  CONSTRAINT `application_approvals_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`),
  CONSTRAINT `application_approvals_ibfk_2` FOREIGN KEY (`manager_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_approvals`
--

LOCK TABLES `application_approvals` WRITE;
/*!40000 ALTER TABLE `application_approvals` DISABLE KEYS */;
INSERT INTO `application_approvals` VALUES (1,1001,102,'APPROVED','Hồ sơ pháp lý và năng lực tài chính đáp ứng tiêu chuẩn thẩm định tín dụng Vietcombank.','2026-09-09 11:53:09'),(2,1004,101,'APPROVED','Khách hàng có CIC chuẩn, thu nhập chuyển khoản ngân hàng rõ ràng, tài sản thế chấp đạt chuẩn định giá.','2026-09-10 01:54:14'),(3,1006,101,'REQUEST_DOCS','Yêu cầu khách hàng bổ sung hợp đồng mua bán căn hộ có công chứng và sao kê thuế thu nhập cá nhân 6 tháng gần nhất.','2026-09-10 01:54:14'),(4,1004,101,'APPROVED','Khách hàng có CIC chuẩn, thu nhập chuyển khoản ngân hàng rõ ràng, tài sản thế chấp đạt chuẩn định giá.','2026-09-10 01:54:28'),(5,1006,101,'REQUEST_DOCS','Yêu cầu khách hàng bổ sung hợp đồng mua bán căn hộ có công chứng và sao kê thuế thu nhập cá nhân 6 tháng gần nhất.','2026-09-10 01:54:28'),(6,1002,103,'REQUEST_DOCS','Yêu cầu khách hàng nộp bổ sung hóa đơn GTGT mua xe và biên lai đóng thuế trước bạ.','2026-09-13 08:34:21'),(7,1003,103,'REJECTED','Khách hàng có nợ chú ý nhóm 2 trên cổng tra cứu CIC, không đủ điều kiện cấp tín dụng.','2026-09-13 08:34:21'),(8,1010,103,'APPROVED','Hồ sơ đạt tiêu chuẩn tín dụng, nguồn thu nhập chứng minh minh bạch.','2026-09-13 08:36:21'),(9,1012,103,'APPROVED','Hồ sơ đạt tiêu chuẩn tín dụng, nguồn thu nhập chứng minh minh bạch.','2026-09-13 08:40:11'),(10,1016,103,'APPROVED','Hồ sơ đạt tiêu chuẩn tín dụng, nguồn thu nhập chứng minh minh bạch.','2026-09-13 08:41:06'),(11,1025,103,'APPROVED','Hồ sơ đạt tiêu chuẩn tín dụng, nguồn thu nhập chứng minh minh bạch.','2026-09-13 21:25:52'),(12,1001,103,'APPROVED','Khách hàng có lịch sử tín dụng CIC nhóm 1 chuẩn, thu nhập chuyển khoản ổn định trên 35 triệu/tháng.','2026-09-14 04:30:58'),(13,1002,103,'APPROVED','Hồ sơ tài sản bảo đảm pháp lý minh bạch, thẩm định giá trị tài sản vượt 150% hạn mức vay đề xuất.','2026-09-14 04:30:58'),(14,1003,103,'REQUEST_DOCS','Yêu cầu doanh nghiệp bổ sung phụ lục hợp đồng thương mại xuất khẩu Quý 4/2026.','2026-09-14 04:30:58'),(15,1004,103,'APPROVED','Phê duyệt hạn mức cấp thẻ tín dụng đen Vietcombank Visa Signature 120 triệu đồng.','2026-09-14 04:30:58'),(16,1005,103,'APPROVED','Duyệt phương án tài trợ vốn lưu động ngắn hạn cho doanh nghiệp, lãi suất 7.2%/năm.','2026-09-14 04:30:58'),(17,1029,103,'APPROVED','Hồ sơ đạt tiêu chuẩn tín dụng, nguồn thu nhập chứng minh minh bạch.','2026-09-13 21:31:56');
/*!40000 ALTER TABLE `application_approvals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_documents`
--

DROP TABLE IF EXISTS `application_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_documents` (
  `document_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) NOT NULL,
  `document_name` varchar(255) NOT NULL,
  `file_url` varchar(500) NOT NULL,
  `uploaded_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`document_id`),
  KEY `application_id` (`application_id`),
  CONSTRAINT `application_documents_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_documents`
--

LOCK TABLES `application_documents` WRITE;
/*!40000 ALTER TABLE `application_documents` DISABLE KEYS */;
INSERT INTO `application_documents` VALUES (1,1015,'Sao kê lương & Giấy tờ thu nhập','/uploads/sao_ke_luong.pdf','2026-09-13 08:41:05'),(2,1020,'Sao kê lương & Giấy tờ thu nhập','/uploads/docs/sao_ke_luong_vcb.pdf','2026-09-13 21:23:32'),(3,1024,'Sao kê lương & Giấy tờ thu nhập','/uploads/sao_ke_luong.pdf','2026-09-13 21:25:44'),(4,1001,'Hợp đồng lao động không xác định thời hạn & Giấy xác nhận thu nhập','/uploads/docs/HDLD_Xac_nhan_thu_nhap.pdf','2026-09-14 04:30:57'),(5,1002,'Sao kê tài khoản ngân hàng nhận lương 6 tháng gần nhất','/uploads/docs/Sao_ke_luong_6_thang.pdf','2026-09-14 04:30:57'),(6,1003,'Báo cáo kiểm toán tài chính và Tờ khai thuế doanh nghiệp năm 2025','/uploads/docs/BCTC_Kiem_toan_2025.pdf','2026-09-14 04:30:57'),(7,1004,'Hợp đồng mua bán căn hộ chung cư có công chứng','/uploads/docs/HD_Mua_ban_can_ho_cong_chung.pdf','2026-09-14 04:30:57'),(8,1005,'Giấy phép đăng ký kinh doanh và Điều lệ công ty','/uploads/docs/GPKD_Dieu_le_doanh_nghiep.pdf','2026-09-14 04:30:57'),(9,1028,'Sao kê lương & Giấy tờ thu nhập','/uploads/sao_ke_luong.pdf','2026-09-13 21:31:48'),(10,1031,'Báo cáo tài chính & Phương án kinh doanh','https://vcb-storage.vn/docs/financial_statements_2025_audited.pdf','2026-09-17 18:11:19'),(11,1032,'Báo cáo tài chính & Phương án kinh doanh','https://vcb-storage.vn/docs/financial_statements_2025_audited.pdf','2026-09-17 19:41:21'),(12,1033,'Báo cáo tài chính & Phương án kinh doanh','https://vcb-storage.vn/docs/financial_statements_2025_audited.pdf','2026-09-17 19:41:38'),(13,1034,'Hợp đồng mua bán xe & Báo giá đại lý','https://vcb-storage.vn/docs/car_contract_quote.pdf','2026-09-17 19:44:59'),(14,1035,'Hợp đồng mua bán xe & Báo giá đại lý','https://vcb-storage.vn/docs/car_contract_quote.pdf','2026-09-17 19:45:35');
/*!40000 ALTER TABLE `application_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `application_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `application_code` varchar(50) NOT NULL,
  `customer_id` bigint(20) NOT NULL,
  `application_type` enum('LOAN','CARD_ISSUANCE','LIMIT_APPROVAL') NOT NULL,
  `requested_amount` decimal(18,2) DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','DOCS_REQUIRED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`application_id`),
  UNIQUE KEY `application_code` (`application_code`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1036 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (1001,'APP-2026-001',501,'LOAN',500000000.00,'APPROVED','2026-09-09 11:53:08','2026-09-09 11:53:08'),(1002,'APP-2026-002',502,'CARD_ISSUANCE',50000000.00,'DOCS_REQUIRED','2026-09-09 11:53:08','2026-09-09 11:53:08'),(1003,'APP-2026-003',601,'LOAN',800000000.00,'REJECTED','2026-09-09 11:53:08','2026-09-13 08:34:21'),(1004,'VCB-APP-2026-9001',501,'LOAN',800000000.00,'APPROVED','2026-09-10 01:54:14','2026-09-10 01:54:14'),(1005,'VCB-APP-2026-9002',501,'CARD_ISSUANCE',100000000.00,'PENDING','2026-09-10 01:54:14','2026-09-10 01:54:14'),(1006,'VCB-APP-2026-9003',501,'LOAN',1500000000.00,'DOCS_REQUIRED','2026-09-10 01:54:14','2026-09-10 01:54:14'),(1010,'VCB-2026-98047',604,'LOAN',300000000.00,'APPROVED','2026-09-13 08:34:24','2026-09-13 08:36:21'),(1011,'VCB-2026-33382',605,'LOAN',200000000.00,'PENDING','2026-09-13 08:36:22','2026-09-13 08:36:22'),(1012,'APP-CARD-2026-5799',601,'CARD_ISSUANCE',50000000.00,'APPROVED','2026-09-13 08:40:10','2026-09-13 08:40:11'),(1013,'VCB-2026-84545',605,'LOAN',200000000.00,'PENDING','2026-09-13 08:40:12','2026-09-13 08:40:12'),(1014,'APP-AUTO-2026-8044',601,'LOAN',650000000.00,'PENDING','2026-09-13 08:41:05','2026-09-13 08:41:05'),(1015,'APP-CONSUMER-2026-5295',601,'LOAN',80000000.00,'PENDING','2026-09-13 08:41:05','2026-09-13 08:41:05'),(1016,'APP-CARD-2026-4499',601,'CARD_ISSUANCE',50000000.00,'APPROVED','2026-09-13 08:41:05','2026-09-13 08:41:06'),(1017,'VCB-2026-29691',605,'LOAN',200000000.00,'PENDING','2026-09-13 08:41:07','2026-09-13 08:41:07'),(1018,'APP-AUTO-2026-8784',601,'LOAN',750000000.00,'PENDING','2026-09-13 21:23:29','2026-09-13 21:23:29'),(1019,'APP-AUTO-2026-9089',601,'LOAN',900000000.00,'PENDING','2026-09-13 21:23:31','2026-09-13 21:23:31'),(1020,'APP-CONSUMER-2026-5596',601,'LOAN',180000000.00,'PENDING','2026-09-13 21:23:32','2026-09-13 21:23:32'),(1021,'APP-CARD-2026-7186',601,'CARD_ISSUANCE',120000000.00,'PENDING','2026-09-13 21:23:33','2026-09-13 21:23:33'),(1022,'APP-CARD-2026-2905',601,'CARD_ISSUANCE',60000000.00,'PENDING','2026-09-13 21:23:34','2026-09-13 21:23:34'),(1023,'APP-AUTO-2026-6133',601,'LOAN',650000000.00,'PENDING','2026-09-13 21:25:43','2026-09-13 21:25:43'),(1024,'APP-CONSUMER-2026-8525',601,'LOAN',80000000.00,'PENDING','2026-09-13 21:25:44','2026-09-13 21:25:44'),(1025,'APP-CARD-2026-9212',601,'CARD_ISSUANCE',50000000.00,'APPROVED','2026-09-13 21:25:45','2026-09-13 21:25:52'),(1026,'VCB-2026-95159',605,'LOAN',200000000.00,'PENDING','2026-09-13 21:26:00','2026-09-13 21:26:00'),(1027,'APP-AUTO-2026-6504',601,'LOAN',650000000.00,'PENDING','2026-09-13 21:31:47','2026-09-13 21:31:47'),(1028,'APP-CONSUMER-2026-9843',601,'LOAN',80000000.00,'PENDING','2026-09-13 21:31:48','2026-09-13 21:31:48'),(1029,'APP-CARD-2026-3488',601,'CARD_ISSUANCE',50000000.00,'APPROVED','2026-09-13 21:31:49','2026-09-13 21:31:57'),(1030,'VCB-2026-83853',605,'LOAN',200000000.00,'PENDING','2026-09-13 21:32:04','2026-09-13 21:32:04'),(1031,'APP-BUSINESS-2026-8205',602,'LOAN',2000000000.00,'PENDING','2026-09-17 18:11:19','2026-09-17 18:11:19'),(1032,'APP-BUSINESS-2026-7709',602,'LOAN',2000000000.00,'PENDING','2026-09-17 19:41:19','2026-09-17 19:41:19'),(1033,'APP-BUSINESS-2026-8218',602,'LOAN',100000000.00,'PENDING','2026-09-17 19:41:37','2026-09-17 19:41:37'),(1034,'APP-AUTO-2026-6651',601,'LOAN',600000000.00,'PENDING','2026-09-17 19:44:59','2026-09-17 19:44:59'),(1035,'APP-AUTO-2026-4610',601,'LOAN',600000000.00,'PENDING','2026-09-17 19:45:34','2026-09-17 19:45:34');
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `appointment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `appointment_code` varchar(50) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `branch_name` varchar(150) DEFAULT NULL,
  `service_type` varchar(100) NOT NULL,
  `appointment_date` date NOT NULL,
  `time_slot` varchar(50) NOT NULL,
  `note` text DEFAULT NULL,
  `status` enum('PENDING','CONFIRMED','COMPLETED','CANCELLED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`appointment_id`),
  UNIQUE KEY `appointment_code` (`appointment_code`),
  KEY `branch_id` (`branch_id`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`branch_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (1,'APT-2026-90001','Trần Văn Kiên','0988223311','kien.tran@gmail.com',1,'Chi nhánh Vietcombank Hoàn Kiếm','Tư vấn tín dụng bất động sản','2026-09-15','09:00 - 10:00','Vay mua chung cư cao cấp Discovery Complex','PENDING','2026-09-14 04:30:45'),(2,'APT-2026-90002','Lê Quỳnh Nga','0912334488','nga.le@outlook.com',2,'Chi nhánh Vietcombank Ba Đình','Dịch vụ thẻ và Ngân hàng số','2026-09-15','10:30 - 11:30','Đổi thẻ vật lý sang thẻ gắn chip không tiếp xúc EMV','CONFIRMED','2026-09-14 04:30:45'),(3,'APT-2026-90003','Công ty CP Đầu tư Nam Long','0243666555','tckt@namlong.com.vn',3,'Chi nhánh Vietcombank TP.HCM - Hội sở Bến Thành','Dịch vụ Doanh nghiệp & Vốn lưu động','2026-09-16','14:00 - 15:00','Thẩm định hồ sơ bảo lãnh gói thầu xây dựng 5 tỷ','PENDING','2026-09-14 04:30:45'),(4,'APT-2026-90004','Hoàng Minh Châu','0903778811','chau.hoang@vinamilk.com',4,'Chi nhánh Vietcombank Bến Thành','Gửi tiết kiệm & Mở tài khoản số đẹp','2026-09-16','15:30 - 16:30','Gửi tiết kiệm bậc thang 800 triệu kỳ hạn 18 tháng','CONFIRMED','2026-09-14 04:30:45'),(5,'APT-2026-90005','Nguyễn Thị Tuyết Mai','0977661122','mai.nguyen@danang.gov.vn',5,'Chi nhánh Vietcombank Đà Nẵng','Tra soát và hỗ trợ tài khoản','2026-09-13','08:30 - 09:30','Đăng ký dịch vụ ngân hàng điện tử doanh nghiệp','COMPLETED','2026-09-14 04:30:45');
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `action_type` varchar(100) NOT NULL,
  `module_name` varchar(50) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `status` enum('SUCCESS','FAILED') NOT NULL,
  `description` text DEFAULT NULL,
  `payload_before` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload_before`)),
  `payload_after` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload_after`)),
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`log_id`),
  KEY `idx_user_action` (`user_id`,`action_type`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,104,'PROCESS_TICKET','StaffModule','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0','SUCCESS','Xử lý / phản hồi yêu cầu CSKH',NULL,'{\"id\":1,\"ticketCode\":\"TCK-2026-001\",\"customerId\":501,\"customerName\":\"Lê Hoàng Nam\",\"customerPhone\":\"0988777666\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Hỗ trợ nâng hạn mức thẻ tín dụng\",\"content\":\"Khách hàng có lịch sử tín dụng tốt, yêu cầu nâng hạn mức thẻ Platinum từ 50tr lên 100tr.\",\"priority\":\"HIGH\",\"status\":\"RESOLVED\",\"createdAt\":\"2026-09-09T18:53:08Z\",\"updatedAt\":\"2026-09-09T18:53:08Z\",\"logs\":[{\"id\":1,\"staffName\":\"Nguyễn Hoàng Nam\",\"actionNote\":\"Đã hoàn thiện chu trình\",\"createdAt\":\"2026-09-10T01:50:58.646903Z\"}]}','2026-09-09 18:50:58'),(2,101,'UPDATE_EXCHANGE_RATE','FluctuatingData','192.168.1.10',NULL,'SUCCESS','Cập nhật bảng tỷ giá ngoại tệ ngày hôm nay (USD, EUR, GBP, JPY)',NULL,'{\"currencies\": [\"USD\", \"EUR\", \"GBP\", \"JPY\"], \"status\": \"ACTIVE\"}','2026-09-10 01:54:14'),(3,101,'APPROVE_LOAN_APPLICATION','Approval','192.168.1.15',NULL,'SUCCESS','Phê duyệt hồ sơ vay tiêu dùng VCB-APP-2026-9001 số tiền 800,000,000 VND',NULL,'{\"appCode\": \"VCB-APP-2026-9001\", \"decision\": \"APPROVED\", \"amount\": 800000000}','2026-09-10 01:54:14'),(4,104,'PROCESS_APPOINTMENT','StaffModule','192.168.1.25',NULL,'SUCCESS','Giao dịch viên tiếp nhận và hoàn tất phục vụ lịch hẹn chatbot VCB-APT-2026-20004',NULL,'{\"appointmentCode\": \"VCB-APT-2026-20004\", \"status\": \"COMPLETED\"}','2026-09-10 01:54:14'),(5,101,'UPDATE_EXCHANGE_RATE','FluctuatingData','192.168.1.10',NULL,'SUCCESS','Cập nhật bảng tỷ giá ngoại tệ ngày hôm nay (USD, EUR, GBP, JPY)',NULL,'{\"currencies\": [\"USD\", \"EUR\", \"GBP\", \"JPY\"], \"status\": \"ACTIVE\"}','2026-09-10 01:54:28'),(6,101,'APPROVE_LOAN_APPLICATION','Approval','192.168.1.15',NULL,'SUCCESS','Phê duyệt hồ sơ vay tiêu dùng VCB-APP-2026-9001 số tiền 800,000,000 VND',NULL,'{\"appCode\": \"VCB-APP-2026-9001\", \"decision\": \"APPROVED\", \"amount\": 800000000}','2026-09-10 01:54:28'),(7,104,'PROCESS_APPOINTMENT','StaffModule','192.168.1.25',NULL,'SUCCESS','Giao dịch viên tiếp nhận và hoàn tất phục vụ lịch hẹn chatbot VCB-APT-2026-20004',NULL,'{\"appointmentCode\": \"VCB-APT-2026-20004\", \"status\": \"COMPLETED\"}','2026-09-10 01:54:28'),(8,101,'UPDATE_USER','System','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0','SUCCESS','Cập nhật tài khoản nhân sự',NULL,'{\"id\":102,\"username\":\"manager_dev\",\"email\":\"manager@bank.com\",\"fullName\":\"Trần Thị Lý\",\"phoneNumber\":\"0912345678\",\"status\":\"ACTIVE\",\"roles\":[{\"id\":2,\"code\":\"ROLE_MANAGER\",\"name\":\"Quản lý phê duyệt\"}],\"lastLogin\":\"2026-09-09T15:26:25Z\",\"createdAt\":\"2026-09-09T18:53:07Z\"}','2026-09-09 18:59:16'),(9,103,'PROCESS_APPLICATION','APPROVAL','0:0:0:0:0:0:0:1','PostmanRuntime/7.56.1','SUCCESS','Xử lý phê duyệt hồ sơ',NULL,'{\"id\":1002,\"applicationCode\":\"APP-2026-002\",\"type\":\"CARD_ISSUANCE\",\"requestedAmount\":50000000.00,\"status\":\"DOCS_REQUIRED\",\"createdAt\":\"2026-09-09T18:53:08Z\",\"updatedAt\":\"2026-09-09T18:53:08Z\",\"customer\":{\"id\":502,\"fullName\":\"Phạm Minh Anh\",\"idCardNumber\":\"001099005678\",\"phoneNumber\":\"0977111222\",\"email\":\"minhanh@gmail.com\"},\"documents\":[],\"approvals\":[{\"id\":6,\"action\":\"REQUEST_DOCS\",\"reasonNote\":\"Yêu cầu khách hàng nộp bổ sung hóa đơn GTGT mua xe và biên lai đóng thuế trước bạ.\",\"managerName\":\"Lê Minh Tuấn\",\"processedAt\":\"2026-09-13T15:34:21.066827Z\"}]}','2026-09-13 08:34:21'),(10,103,'PROCESS_APPLICATION','APPROVAL','0:0:0:0:0:0:0:1','PostmanRuntime/7.56.1','SUCCESS','Xử lý phê duyệt hồ sơ',NULL,'{\"id\":1003,\"applicationCode\":\"APP-2026-003\",\"type\":\"LOAN\",\"requestedAmount\":800000000.00,\"status\":\"REJECTED\",\"createdAt\":\"2026-09-09T18:53:08Z\",\"updatedAt\":\"2026-09-09T18:53:08Z\",\"customer\":{\"id\":601,\"fullName\":\"Trần Thị Thu Hà\",\"idCardNumber\":\"001198004567\",\"phoneNumber\":\"0911222333\",\"email\":\"ha.tran@gmail.com\"},\"documents\":[],\"approvals\":[{\"id\":7,\"action\":\"REJECTED\",\"reasonNote\":\"Khách hàng có nợ chú ý nhóm 2 trên cổng tra cứu CIC, không đủ điều kiện cấp tín dụng.\",\"managerName\":\"Lê Minh Tuấn\",\"processedAt\":\"2026-09-13T15:34:21.679117Z\"}]}','2026-09-13 08:34:21'),(11,104,'UPDATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','PostmanRuntime/7.56.1','SUCCESS','Cập nhật tiến độ tư vấn khách hàng',NULL,'{\"id\":1,\"customerId\":501,\"customerName\":\"Lê Hoàng Nam\",\"customerPhone\":\"0988777666\",\"customerEmail\":\"nam.le@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Gói vay mua nhà an cư 35 năm\",\"notes\":\"Khách hàng đã đồng ý gói vay lãi suất 6.8%/năm và ký hoàn tất hồ sơ giải ngân.\",\"status\":\"COMPLETED\",\"createdAt\":\"2026-09-09T18:53:08Z\",\"updatedAt\":\"2026-09-09T18:53:08Z\"}','2026-09-13 08:34:22'),(12,104,'PROCESS_TICKET','StaffModule','0:0:0:0:0:0:0:1','PostmanRuntime/7.56.1','SUCCESS','Xử lý / phản hồi yêu cầu CSKH',NULL,'{\"id\":1,\"ticketCode\":\"TCK-2026-001\",\"customerId\":501,\"customerName\":\"Lê Hoàng Nam\",\"customerPhone\":\"0988777666\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Hỗ trợ nâng hạn mức thẻ tín dụng\",\"content\":\"Khách hàng có lịch sử tín dụng tốt, yêu cầu nâng hạn mức thẻ Platinum từ 50tr lên 100tr.\",\"priority\":\"HIGH\",\"status\":\"RESOLVED\",\"createdAt\":\"2026-09-09T18:53:08Z\",\"updatedAt\":\"2026-09-10T01:50:58Z\",\"logs\":[{\"id\":1,\"staffName\":\"Nguyễn Hoàng Nam\",\"actionNote\":\"Đã hoàn thiện chu trình\",\"createdAt\":\"2026-09-10T01:50:58Z\"},{\"id\":6,\"staffName\":\"Nguyễn Hoàng Nam\",\"actionNote\":\"Đã hướng dẫn khách hàng quét chip CCCD vào phần đỉnh lưng iPhone và kích hoạt lại Smart OTP thành công.\",\"createdAt\":\"2026-09-13T15:34:22.965501Z\"}]}','2026-09-13 08:34:23'),(13,104,'PROCESS_DISPUTE','StaffModule','0:0:0:0:0:0:0:1','PostmanRuntime/7.56.1','SUCCESS','Xử lý kết quả yêu cầu tra soát',NULL,'{\"id\":1,\"disputeCode\":\"DSP-2026-001\",\"customerId\":502,\"customerName\":\"Phạm Minh Anh\",\"customerPhone\":\"0977111222\",\"transactionCode\":\"TXN-99887766\",\"reason\":\"Giao dịch rút tiền tại cây ATM Vietcombank Ba Đình bị trừ tiền nhưng máy không nhả tiền mặt do lỗi nhả thẻ.\",\"status\":\"APPROVED_REFUND\",\"handlerStaffId\":104,\"handlerStaffName\":\"Nguyễn Hoàng Nam\",\"resolutionNote\":\"Kiểm quỹ cây ATM khớp dư 2.000.000 VNĐ. Đã lập lệnh hoàn trả tiền vào tài khoản thanh toán của khách hàng.\",\"createdAt\":\"2026-09-09T18:53:08Z\",\"updatedAt\":\"2026-09-09T18:53:08Z\"}','2026-09-13 08:34:23'),(14,104,'CREATE_FINANCIAL_TX','StaffModule','0:0:0:0:0:0:0:1','PostmanRuntime/7.56.1','SUCCESS','Thực hiện giao dịch chuyển/nạp tiền',NULL,'{\"id\":14,\"transactionCode\":\"TXN-2026-789179\",\"senderCustomerName\":\"Nộp tiền mặt tại quầy\",\"receiverAccountNumber\":\"0011009988776\",\"receiverName\":\"NGUYEN VAN HUONG\",\"bankName\":\"VIETCOMBANK\",\"amount\":25000000,\"fee\":0,\"description\":\"Nop tien mat thanh toan tai quay VCB\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"status\":\"SUCCESS\",\"createdAt\":\"2026-09-13T15:34:23.554302Z\"}','2026-09-13 08:34:23'),(15,104,'UPDATE_APPOINTMENT_STATUS','StaffModule','0:0:0:0:0:0:0:1','PostmanRuntime/7.56.1','SUCCESS','Cập nhật trạng thái lịch hẹn Chatbot',NULL,'{\"id\":1,\"appointmentCode\":\"VCB-APT-2026-10001\",\"fullName\":\"Nguyễn Văn Tuấn\",\"phoneNumber\":\"0912345678\",\"email\":\"tuan.nguyen@gmail.com\",\"branchName\":\"Chi nhánh Vietcombank Hoàn Kiếm\",\"serviceType\":\"Đăng ký Gói vay mua nhà an cư\",\"appointmentDate\":\"2026-09-12\",\"timeSlot\":\"09:00 - 10:00\",\"note\":\"Cần tư vấn lãi suất ưu đãi cố định 2 năm đầu\",\"status\":\"COMPLETED\",\"handledBy\":\"Nguyễn Hoàng Nam\",\"createdAt\":\"2026-09-10T01:48:26.586609Z\",\"updatedAt\":\"2026-09-10T01:48:26.586609Z\"}','2026-09-13 08:34:24'),(16,101,'CREATE_EXCHANGE_RATE','DATA','0:0:0:0:0:0:0:1','PostmanRuntime/7.56.1','SUCCESS','Thêm mới tỷ giá ngoại tệ',NULL,'{\"id\":39,\"currencyCode\":\"USD\",\"buyRate\":25420.00,\"sellRate\":25820.00,\"transferRate\":25450.00,\"effectiveDate\":\"2026-09-13\",\"createdBy\":101,\"createdByName\":\"Nguyễn Văn Admin\"}','2026-09-13 08:34:25'),(17,101,'CREATE_POST','CMS','0:0:0:0:0:0:0:1','PostmanRuntime/7.56.1','SUCCESS','Tạo bài viết mới',NULL,'{\"id\":11,\"title\":\"Vietcombank dẫn đầu kỷ nguyên Ngân hàng số thông minh 2026\",\"slug\":\"vietcombank-dan-dau-ky-nguyen-ngan-hang-so-thong-minh-2026\",\"summary\":\"Ứng dụng công nghệ Trí tuệ nhân tạo AI và dữ liệu lớn trong tối ưu hóa trải nghiệm tài chính cá nhân hóa.\",\"content\":\"<p>Vietcombank tiếp tục khẳng định vị thế ngân hàng số hàng đầu với chuỗi tiện ích thanh toán thông minh...</p>\",\"thumbnailUrl\":\"https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800\",\"category\":{\"id\":1,\"name\":\"Tin tức ngân hàng\",\"slug\":\"tin-tuc-ngan-hang\"},\"authorId\":101,\"authorName\":\"admin_super\",\"status\":\"PUBLISHED\",\"publishedAt\":\"2026-09-13T15:34:25.733389900Z\",\"createdAt\":\"2026-09-13T15:34:25.733996Z\",\"updatedAt\":\"2026-09-13T15:34:25.733996Z\"}','2026-09-13 08:34:25'),(18,103,'EXPORT_REPORT','REPORT','0:0:0:0:0:0:0:1','PostmanRuntime/7.56.1','SUCCESS','Xuất báo cáo hồ sơ',NULL,'{\"format\":\"EXCEL\",\"rowCount\":\"7\",\"downloadUrl\":\"/uploads/reports/bao-cao-ho-so_20260913_223427_6adc.xlsx\"}','2026-09-13 08:34:27'),(19,103,'PROCESS_APPLICATION','APPROVAL','0:0:0:0:0:0:0:1','node','SUCCESS','Xử lý phê duyệt hồ sơ',NULL,'{\"id\":1010,\"applicationCode\":\"VCB-2026-98047\",\"type\":\"LOAN\",\"requestedAmount\":300000000.00,\"status\":\"APPROVED\",\"createdAt\":\"2026-09-13T15:34:24Z\",\"updatedAt\":\"2026-09-13T15:34:24Z\",\"customer\":{\"id\":604,\"fullName\":\"Phạm Thanh Tùng\",\"idCardNumber\":\"024095009988\",\"phoneNumber\":\"0912345678\",\"email\":\"tung.pham@gmail.com\"},\"documents\":[],\"approvals\":[{\"id\":8,\"action\":\"APPROVED\",\"reasonNote\":\"Hồ sơ đạt tiêu chuẩn tín dụng, nguồn thu nhập chứng minh minh bạch.\",\"managerName\":\"Lê Minh Tuấn\",\"processedAt\":\"2026-09-13T15:36:21.858233Z\"}]}','2026-09-13 08:36:21'),(20,104,'CREATE_FINANCIAL_TX','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Thực hiện giao dịch chuyển/nạp tiền',NULL,'{\"id\":15,\"transactionCode\":\"TXN-2026-156129\",\"senderCustomerName\":\"Nộp tiền mặt tại quầy\",\"receiverAccountNumber\":\"0011001234567\",\"receiverName\":\"LE HOANG PHUC\",\"bankName\":\"VIETCOMBANK\",\"amount\":15000000,\"fee\":0,\"description\":\"Nop tien tai quay chi nhanh Ba Dinh\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"status\":\"SUCCESS\",\"createdAt\":\"2026-09-13T15:36:22.176671Z\"}','2026-09-13 08:36:22'),(21,104,'CREATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Ghi nhận tư vấn khách hàng',NULL,'{\"id\":9,\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"customerEmail\":\"ha.tran@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Vay mua nhà\",\"notes\":\"Khách hàng có nhu cầu vay\",\"status\":\"FOLLOW_UP\",\"createdAt\":\"2026-09-13T15:37:53.433380Z\",\"updatedAt\":\"2026-09-13T15:37:53.433380Z\"}','2026-09-13 08:37:53'),(22,103,'PROCESS_APPLICATION','APPROVAL','0:0:0:0:0:0:0:1','node','SUCCESS','Xử lý phê duyệt hồ sơ',NULL,'{\"id\":1012,\"applicationCode\":\"APP-CARD-2026-5799\",\"type\":\"CARD_ISSUANCE\",\"requestedAmount\":50000000.00,\"status\":\"APPROVED\",\"createdAt\":\"2026-09-13T15:40:10Z\",\"updatedAt\":\"2026-09-13T15:40:10Z\",\"customer\":{\"id\":601,\"fullName\":\"Trần Thị Thu Hà\",\"idCardNumber\":\"001198004567\",\"phoneNumber\":\"0911222333\",\"email\":\"ha.tran@gmail.com\"},\"documents\":[],\"approvals\":[{\"id\":9,\"action\":\"APPROVED\",\"reasonNote\":\"Hồ sơ đạt tiêu chuẩn tín dụng, nguồn thu nhập chứng minh minh bạch.\",\"managerName\":\"Lê Minh Tuấn\",\"processedAt\":\"2026-09-13T15:40:11.199980Z\"}]}','2026-09-13 08:40:11'),(23,104,'CREATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Ghi nhận tư vấn khách hàng',NULL,'{\"id\":10,\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"customerEmail\":\"ha.tran@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Vay mua nhà ở dự án\",\"notes\":\"Khách hàng có nhu cầu vay mua căn hộ Vinhomes Smart City 1.2 tỷ\",\"status\":\"FOLLOW_UP\",\"createdAt\":\"2026-09-13T15:40:11.380138Z\",\"updatedAt\":\"2026-09-13T15:40:11.380138Z\"}','2026-09-13 08:40:11'),(24,104,'CREATE_TICKET','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Mở yêu cầu hỗ trợ khách hàng mới',NULL,'{\"id\":9,\"ticketCode\":\"TK-2026-7537\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Hỗ trợ cấp lại mã PIN thẻ tín dụng\",\"content\":\"Khách hàng quên mã PIN thẻ Visa Platinum tại cây ATM\",\"priority\":\"HIGH\",\"status\":\"NEW\",\"createdAt\":\"2026-09-13T15:40:11.481118Z\",\"updatedAt\":\"2026-09-13T15:40:11.481118Z\",\"logs\":[]}','2026-09-13 08:40:11'),(25,104,'CREATE_FINANCIAL_TX','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Thực hiện giao dịch chuyển/nạp tiền',NULL,'{\"id\":16,\"transactionCode\":\"TXN-2026-624654\",\"senderCustomerId\":601,\"senderCustomerName\":\"Trần Thị Thu Hà\",\"receiverAccountNumber\":\"0011001234567\",\"receiverName\":\"LE HOANG PHUC\",\"bankName\":\"VIETCOMBANK\",\"amount\":15000000,\"fee\":0,\"description\":\"Nop tien tai quay chi nhanh Ba Dinh\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"status\":\"SUCCESS\",\"createdAt\":\"2026-09-13T15:40:11.591782Z\"}','2026-09-13 08:40:11'),(26,103,'PROCESS_APPLICATION','APPROVAL','0:0:0:0:0:0:0:1','node','SUCCESS','Xử lý phê duyệt hồ sơ',NULL,'{\"id\":1016,\"applicationCode\":\"APP-CARD-2026-4499\",\"type\":\"CARD_ISSUANCE\",\"requestedAmount\":50000000.00,\"status\":\"APPROVED\",\"createdAt\":\"2026-09-13T15:41:05Z\",\"updatedAt\":\"2026-09-13T15:41:05Z\",\"customer\":{\"id\":601,\"fullName\":\"Trần Thị Thu Hà\",\"idCardNumber\":\"001198004567\",\"phoneNumber\":\"0911222333\",\"email\":\"ha.tran@gmail.com\"},\"documents\":[],\"approvals\":[{\"id\":10,\"action\":\"APPROVED\",\"reasonNote\":\"Hồ sơ đạt tiêu chuẩn tín dụng, nguồn thu nhập chứng minh minh bạch.\",\"managerName\":\"Lê Minh Tuấn\",\"processedAt\":\"2026-09-13T15:41:06.613746Z\"}]}','2026-09-13 08:41:06'),(27,104,'CREATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Ghi nhận tư vấn khách hàng',NULL,'{\"id\":11,\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"customerEmail\":\"ha.tran@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Vay mua nhà ở dự án\",\"notes\":\"Khách hàng có nhu cầu vay mua căn hộ Vinhomes Smart City 1.2 tỷ\",\"status\":\"FOLLOW_UP\",\"createdAt\":\"2026-09-13T15:41:06.773597Z\",\"updatedAt\":\"2026-09-13T15:41:06.773597Z\"}','2026-09-13 08:41:06'),(28,104,'CREATE_TICKET','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Mở yêu cầu hỗ trợ khách hàng mới',NULL,'{\"id\":10,\"ticketCode\":\"TK-2026-7586\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Hỗ trợ cấp lại mã PIN thẻ tín dụng\",\"content\":\"Khách hàng quên mã PIN thẻ Visa Platinum tại cây ATM\",\"priority\":\"HIGH\",\"status\":\"NEW\",\"createdAt\":\"2026-09-13T15:41:06.882688Z\",\"updatedAt\":\"2026-09-13T15:41:06.882688Z\",\"logs\":[]}','2026-09-13 08:41:06'),(29,104,'CREATE_FINANCIAL_TX','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Thực hiện giao dịch chuyển/nạp tiền',NULL,'{\"id\":17,\"transactionCode\":\"TXN-2026-385765\",\"senderCustomerId\":601,\"senderCustomerName\":\"Trần Thị Thu Hà\",\"receiverAccountNumber\":\"0011001234567\",\"receiverName\":\"LE HOANG PHUC\",\"bankName\":\"VIETCOMBANK\",\"amount\":15000000,\"fee\":0,\"description\":\"Nop tien tai quay chi nhanh Ba Dinh\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"status\":\"SUCCESS\",\"createdAt\":\"2026-09-13T15:41:07.016714Z\"}','2026-09-13 08:41:07'),(30,104,'CREATE_FINANCIAL_TX','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Thực hiện giao dịch chuyển/nạp tiền',NULL,'{\"id\":18,\"transactionCode\":\"TXN-2026-680160\",\"senderCustomerId\":601,\"senderCustomerName\":\"Trần Thị Thu Hà\",\"receiverAccountNumber\":\"0071009988112\",\"receiverName\":\"NGUYEN THI KIM NGAN\",\"bankName\":\"VIETCOMBANK\",\"amount\":35000000,\"fee\":0,\"description\":\"Nop tien mat tai quay thanh toan tien hang\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"status\":\"SUCCESS\",\"createdAt\":\"2026-09-14T04:23:40.112002Z\"}','2026-09-13 21:23:40'),(31,104,'CREATE_FINANCIAL_TX','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Thực hiện giao dịch chuyển/nạp tiền',NULL,'{\"id\":19,\"transactionCode\":\"TXN-2026-885831\",\"senderCustomerId\":601,\"senderCustomerName\":\"Trần Thị Thu Hà\",\"receiverAccountNumber\":\"1903666888999\",\"receiverName\":\"CONG TY CP DIEN MAY XANH\",\"bankName\":\"Techcombank\",\"amount\":18500000,\"fee\":11000,\"description\":\"Thanh toan tien mua may giat va tu lanh\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"status\":\"SUCCESS\",\"createdAt\":\"2026-09-14T04:23:41.202060Z\"}','2026-09-13 21:23:41'),(32,104,'CREATE_FINANCIAL_TX','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Thực hiện giao dịch chuyển/nạp tiền',NULL,'{\"id\":20,\"transactionCode\":\"TXN-2026-448041\",\"senderCustomerId\":601,\"senderCustomerName\":\"Trần Thị Thu Hà\",\"receiverAccountNumber\":\"0911222333\",\"receiverName\":\"TRAN THI THU HA\",\"bankName\":\"VIETCOMBANK\",\"amount\":50000000,\"fee\":0,\"description\":\"Nop tien vao tai khoan thanh toan dinh ky\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"status\":\"SUCCESS\",\"createdAt\":\"2026-09-14T04:23:42.254873Z\"}','2026-09-13 21:23:42'),(33,104,'CREATE_FINANCIAL_TX','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Thực hiện giao dịch chuyển/nạp tiền',NULL,'{\"id\":21,\"transactionCode\":\"TXN-2026-433024\",\"senderCustomerId\":601,\"senderCustomerName\":\"Trần Thị Thu Hà\",\"receiverAccountNumber\":\"1028777999\",\"receiverName\":\"LE HOANG ANH\",\"bankName\":\"VietinBank\",\"amount\":12000000,\"fee\":9900,\"description\":\"Chuyen tien thanh toan tien thue nha thang 9\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"status\":\"SUCCESS\",\"createdAt\":\"2026-09-14T04:23:43.302747Z\"}','2026-09-13 21:23:43'),(34,104,'CREATE_FINANCIAL_TX','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Thực hiện giao dịch chuyển/nạp tiền',NULL,'{\"id\":22,\"transactionCode\":\"TXN-2026-902396\",\"senderCustomerId\":601,\"senderCustomerName\":\"Trần Thị Thu Hà\",\"receiverAccountNumber\":\"0011005544332\",\"receiverName\":\"VIETCOMBANK LOAN RECOVERY\",\"bankName\":\"VIETCOMBANK\",\"amount\":6850000,\"fee\":0,\"description\":\"Trich nop tien lai va goc vay tieu dung dinh ky\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"status\":\"SUCCESS\",\"createdAt\":\"2026-09-14T04:23:44.342464Z\"}','2026-09-13 21:23:44'),(35,104,'CREATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Ghi nhận tư vấn khách hàng',NULL,'{\"id\":12,\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"customerEmail\":\"ha.tran@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Vay mua xe ô tô điện VinFast VF8\",\"notes\":\"Khách hàng có nhu cầu vay 750 triệu trong 5 năm, hưởng ưu đãi miễn phí trạm sạc 2 năm và lãi suất 6.5%.\",\"status\":\"FOLLOW_UP\",\"createdAt\":\"2026-09-14T04:23:45.393084Z\",\"updatedAt\":\"2026-09-14T04:23:45.393084Z\"}','2026-09-13 21:23:45'),(36,104,'CREATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Ghi nhận tư vấn khách hàng',NULL,'{\"id\":13,\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"customerEmail\":\"ha.tran@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Thẻ tín dụng Vietcombank Visa Signature\",\"notes\":\"Tư vấn mở thẻ đen đặc quyền phòng chờ sân bay và bảo hiểm du lịch 10.5 tỷ VND. Khách hàng quan tâm và đã nộp hồ sơ.\",\"status\":\"COMPLETED\",\"createdAt\":\"2026-09-14T04:23:46.738025Z\",\"updatedAt\":\"2026-09-14T04:23:46.738025Z\"}','2026-09-13 21:23:46'),(37,104,'CREATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Ghi nhận tư vấn khách hàng',NULL,'{\"id\":14,\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"customerEmail\":\"ha.tran@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Tiết kiệm bậc thang phát lộc\",\"notes\":\"Khách hàng có 500 triệu nhàn rỗi, tư vấn gửi kỳ hạn 12 tháng lãi suất 6.8% kèm quay số trúng thưởng sổ tiết kiệm.\",\"status\":\"FOLLOW_UP\",\"createdAt\":\"2026-09-14T04:23:47.769434Z\",\"updatedAt\":\"2026-09-14T04:23:47.769434Z\"}','2026-09-13 21:23:47'),(38,104,'CREATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Ghi nhận tư vấn khách hàng',NULL,'{\"id\":15,\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"customerEmail\":\"ha.tran@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Bảo hiểm nhân thọ liên kết đầu tư FWD\",\"notes\":\"Tư vấn giải pháp bảo vệ tài chính kết hợp gia tăng tài sản, mức phí bảo hiểm 30 triệu/năm.\",\"status\":\"CONSULTED\",\"createdAt\":\"2026-09-14T04:23:48.862746Z\",\"updatedAt\":\"2026-09-14T04:23:48.862746Z\"}','2026-09-13 21:23:49'),(39,104,'CREATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Ghi nhận tư vấn khách hàng',NULL,'{\"id\":16,\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"customerEmail\":\"ha.tran@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Tài khoản số đẹp Như ý Phong thủy\",\"notes\":\"Khách hàng đăng ký mở tài khoản đuôi lộc phát 686868 để phục vụ kinh doanh online.\",\"status\":\"COMPLETED\",\"createdAt\":\"2026-09-14T04:23:49.919700Z\",\"updatedAt\":\"2026-09-14T04:23:49.919700Z\"}','2026-09-13 21:23:50'),(40,104,'CREATE_TICKET','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Mở yêu cầu hỗ trợ khách hàng mới',NULL,'{\"id\":11,\"ticketCode\":\"TK-2026-4820\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Hỗ trợ kích hoạt sinh trắc học khuôn mặt theo Quyết định 2345\",\"content\":\"Khách hàng đổi sang điện thoại iPhone mới, quét NFC căn cước CCCD gắn chip bị lỗi không nhận diện.\",\"priority\":\"HIGH\",\"status\":\"NEW\",\"createdAt\":\"2026-09-14T04:23:51.011133Z\",\"updatedAt\":\"2026-09-14T04:23:51.011133Z\",\"logs\":[]}','2026-09-13 21:23:51'),(41,104,'CREATE_TICKET','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Mở yêu cầu hỗ trợ khách hàng mới',NULL,'{\"id\":12,\"ticketCode\":\"TK-2026-7105\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Cần nâng hạn mức chuyển tiền trực tuyến trong ngày lên 1 tỷ\",\"content\":\"Khách hàng cần thanh toán tiền đặt cọc mua căn hộ chung cư trong chiều nay, hạn mức hiện tại 500 triệu/ngày không đủ.\",\"priority\":\"URGENT\",\"status\":\"NEW\",\"createdAt\":\"2026-09-14T04:23:52.159102Z\",\"updatedAt\":\"2026-09-14T04:23:52.159102Z\",\"logs\":[]}','2026-09-13 21:23:52'),(42,104,'CREATE_TICKET','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Mở yêu cầu hỗ trợ khách hàng mới',NULL,'{\"id\":13,\"ticketCode\":\"TK-2026-4880\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Thẻ tín dụng Visa Platinum bị trừ phí thường niên\",\"content\":\"Khách hàng hỏi điều kiện hoàn phí thường niên năm đầu khi chi tiêu đạt mốc 20 triệu đồng theo thể lệ chương trình.\",\"priority\":\"MEDIUM\",\"status\":\"NEW\",\"createdAt\":\"2026-09-14T04:23:53.287161Z\",\"updatedAt\":\"2026-09-14T04:23:53.287161Z\",\"logs\":[]}','2026-09-13 21:23:53'),(43,104,'CREATE_TICKET','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Mở yêu cầu hỗ trợ khách hàng mới',NULL,'{\"id\":14,\"ticketCode\":\"TK-2026-5520\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Cấp lại mã PIN thẻ ghi nợ quốc tế Vietcombank Connect24\",\"content\":\"Khách hàng quên mã PIN thẻ vật lý khi đi du lịch nước ngoài, cần cấp lại mã e-PIN trực tuyến trên app VCB Digibank.\",\"priority\":\"HIGH\",\"status\":\"NEW\",\"createdAt\":\"2026-09-14T04:23:54.446942Z\",\"updatedAt\":\"2026-09-14T04:23:54.446942Z\",\"logs\":[]}','2026-09-13 21:23:54'),(44,104,'CREATE_TICKET','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Mở yêu cầu hỗ trợ khách hàng mới',NULL,'{\"id\":15,\"ticketCode\":\"TK-2026-6592\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Đăng ký dịch vụ nhận biến động số dư qua tin nhắn OTT miễn phí\",\"content\":\"Khách hàng muốn hủy nhận tin nhắn SMS để chuyển sang nhận thông báo biến động số dư hoàn toàn miễn phí trên app.\",\"priority\":\"LOW\",\"status\":\"NEW\",\"createdAt\":\"2026-09-14T04:23:55.607156Z\",\"updatedAt\":\"2026-09-14T04:23:55.607156Z\",\"logs\":[]}','2026-09-13 21:23:56'),(45,104,'CREATE_DISPUTE','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Tạo mới yêu cầu tra soát giao dịch',NULL,'{\"id\":8,\"disputeCode\":\"TS-2026-6607\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"transactionCode\":\"TXN-2026-889901\",\"reason\":\"Rút tiền tại cây ATM Vietcombank Ba Đình tài khoản bị trừ 3.000.000 VNĐ nhưng máy chỉ nhả 2.000.000 VNĐ.\",\"status\":\"PENDING\",\"createdAt\":\"2026-09-14T04:23:56.860337Z\",\"updatedAt\":\"2026-09-14T04:23:56.860337Z\"}','2026-09-13 21:23:56'),(46,104,'CREATE_DISPUTE','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Tạo mới yêu cầu tra soát giao dịch',NULL,'{\"id\":9,\"disputeCode\":\"TS-2026-9339\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"transactionCode\":\"TXN-2026-889902\",\"reason\":\"Quẹt thẻ Visa tại máy POS nhà hàng King BBQ báo lỗi giao dịch nhưng ứng dụng ngân hàng vẫn trừ 1.450.000 VNĐ.\",\"status\":\"PENDING\",\"createdAt\":\"2026-09-14T04:23:57.802553Z\",\"updatedAt\":\"2026-09-14T04:23:57.802553Z\"}','2026-09-13 21:23:57'),(47,104,'CREATE_DISPUTE','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Tạo mới yêu cầu tra soát giao dịch',NULL,'{\"id\":10,\"disputeCode\":\"TS-2026-7540\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"transactionCode\":\"TXN-2026-889903\",\"reason\":\"Chuyển tiền nhanh 24/7 sang Techcombank người nhận chưa nhận được tiền dù tài khoản Vietcombank đã bị trừ 25.000.000 VNĐ.\",\"status\":\"PENDING\",\"createdAt\":\"2026-09-14T04:23:58.739094Z\",\"updatedAt\":\"2026-09-14T04:23:58.739094Z\"}','2026-09-13 21:23:58'),(48,104,'CREATE_DISPUTE','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Tạo mới yêu cầu tra soát giao dịch',NULL,'{\"id\":11,\"disputeCode\":\"TS-2026-8155\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"transactionCode\":\"TXN-2026-889904\",\"reason\":\"Thanh toán đơn hàng Shopee qua cổng Napas bị trừ 2 lần cùng một mã giao dịch 890.000 VNĐ.\",\"status\":\"PENDING\",\"createdAt\":\"2026-09-14T04:23:59.731454Z\",\"updatedAt\":\"2026-09-14T04:23:59.731454Z\"}','2026-09-13 21:23:59'),(49,104,'CREATE_DISPUTE','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Tạo mới yêu cầu tra soát giao dịch',NULL,'{\"id\":12,\"disputeCode\":\"TS-2026-8048\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"transactionCode\":\"TXN-2026-889905\",\"reason\":\"Giao dịch lạ trừ tiền 45 USD từ trang thương mại điện tử quốc tế do nghi ngờ bị lộ thông tin thẻ.\",\"status\":\"PENDING\",\"createdAt\":\"2026-09-14T04:24:01.000161Z\",\"updatedAt\":\"2026-09-14T04:24:01.000161Z\"}','2026-09-13 21:24:01'),(50,101,'CREATE_POST','CMS','0:0:0:0:0:0:0:1','node','SUCCESS','Tạo bài viết mới',NULL,'{\"id\":12,\"title\":\"Vietcombank ra mắt tính năng Mở sổ tiết kiệm tích lũy số linh hoạt trên VCB Digibank\",\"slug\":\"vietcombank-ra-mat-tinh-nang-mo-so-tiet-kiem-tich-luy-so-linh-hoat-tren-vcb-digibank\",\"summary\":\"Khách hàng có thể gửi tích lũy định kỳ hàng ngày, hàng tuần hoặc hàng tháng chỉ từ 100.000 VNĐ với mức sinh lời tối ưu.\",\"content\":\"<p>Vietcombank chính thức giới thiệu sản phẩm Tiết kiệm tích lũy số trên ứng dụng VCB Digibank. Với tính năng này, việc tích lũy tài chính trở nên dễ dàng và thông minh hơn bao giờ hết, cho phép cài đặt trích tiền tự động và hưởng lãi suất sinh lời hấp dẫn theo ngày...</p>\",\"thumbnailUrl\":\"https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800\",\"category\":{\"id\":1,\"name\":\"Tin tức ngân hàng\",\"slug\":\"tin-tuc-ngan-hang\"},\"authorId\":101,\"authorName\":\"admin_super\",\"status\":\"PUBLISHED\",\"publishedAt\":\"2026-09-14T04:24:05.442915500Z\",\"createdAt\":\"2026-09-14T04:24:05.444928Z\",\"updatedAt\":\"2026-09-14T04:24:05.444928Z\"}','2026-09-13 21:24:05'),(51,101,'CREATE_POST','CMS','0:0:0:0:0:0:0:1','node','SUCCESS','Tạo bài viết mới',NULL,'{\"id\":13,\"title\":\"Giải pháp Tài trợ thương mại số toàn diện cho doanh nghiệp xuất nhập khẩu 2026\",\"slug\":\"giai-phap-tai-tro-thuong-mai-so-toan-dien-cho-doanh-nghiep-xuat-nhap-khau-2026\",\"summary\":\"Gói hỗ trợ hạn mức tín dụng 30.000 tỷ đồng với cơ chế phát hành L/C online và bảo lãnh điện tử siêu tốc trong 2 giờ.\",\"content\":\"<p>Đồng hành cùng cộng đồng doanh nghiệp trong xu hướng hội nhập kinh tế toàn cầu, Vietcombank triển khai nền tảng Tài trợ thương mại số (Trade Finance Digital Platform). Nền tảng giúp tối ưu hóa thời gian xử lý phát hành thư tín dụng L/C và bảo lãnh ngân hàng...</p>\",\"thumbnailUrl\":\"https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800\",\"category\":{\"id\":1,\"name\":\"Tin tức ngân hàng\",\"slug\":\"tin-tuc-ngan-hang\"},\"authorId\":101,\"authorName\":\"admin_super\",\"status\":\"PUBLISHED\",\"publishedAt\":\"2026-09-14T04:24:06.516754700Z\",\"createdAt\":\"2026-09-14T04:24:06.517790Z\",\"updatedAt\":\"2026-09-14T04:24:06.518787Z\"}','2026-09-13 21:24:06'),(52,101,'CREATE_POST','CMS','0:0:0:0:0:0:0:1','node','SUCCESS','Tạo bài viết mới',NULL,'{\"id\":14,\"title\":\"Ưu đãi hoàn tiền 15% khi chi tiêu qua thẻ Vietcombank JCB Platinum tại các nhà hàng Nhật Bản\",\"slug\":\"uu-dai-hoan-tien-15-khi-chi-tieu-qua-the-vietcombank-jcb-platinum-tai-cac-nha-hang-nhat-ban\",\"summary\":\"Trải nghiệm ẩm thực tinh hoa xứ sở hoa anh đào với chương trình hoàn tiền hấp dẫn lên tới 1.500.000 VNĐ mỗi tháng.\",\"content\":\"<p>Từ nay đến hết tháng 12/2026, toàn bộ chủ thẻ tín dụng quốc tế Vietcombank JCB Platinum khi thanh toán tại chuỗi nhà hàng ẩm thực Nhật Bản cao cấp trên toàn quốc sẽ được tận hưởng ưu đãi hoàn tiền 15% trực tiếp vào sao kê thẻ tín dụng...</p>\",\"thumbnailUrl\":\"https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800\",\"category\":{\"id\":2,\"name\":\"Ưu đãi thẻ\",\"slug\":\"uu-dai-the\"},\"authorId\":101,\"authorName\":\"admin_super\",\"status\":\"PUBLISHED\",\"publishedAt\":\"2026-09-14T04:24:07.548741200Z\",\"createdAt\":\"2026-09-14T04:24:07.549248Z\",\"updatedAt\":\"2026-09-14T04:24:07.549248Z\"}','2026-09-13 21:24:07'),(53,101,'CREATE_POST','CMS','0:0:0:0:0:0:0:1','node','SUCCESS','Tạo bài viết mới',NULL,'{\"id\":15,\"title\":\"Gói vay mua ô tô điện VinFast: Lãi suất siêu ưu đãi 5.8%/năm đồng hành cùng kỷ nguyên xanh\",\"slug\":\"goi-vay-mua-o-to-dien-vinfast-lai-suat-sieu-uu-dai-58nam-dong-hanh-cung-ky-nguyen-xanh\",\"summary\":\"Vietcombank liên kết độc quyền hỗ trợ khách hàng vay tới 85% giá trị xe với thời hạn vay linh hoạt đến 8 năm.\",\"content\":\"<p>Nhằm khuyến khích lối sống xanh và phương tiện giao thông thân thiện với môi trường, Vietcombank cùng VinFast triển khai gói tài chính chuyên biệt cho các dòng xe điện thông minh VF3, VF5, VF6, VF7, VF8, VF9 với thủ tục thẩm định trực tuyến giải ngân trong ngày...</p>\",\"thumbnailUrl\":\"https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=800\",\"category\":{\"id\":1,\"name\":\"Tin tức ngân hàng\",\"slug\":\"tin-tuc-ngan-hang\"},\"authorId\":101,\"authorName\":\"admin_super\",\"status\":\"PUBLISHED\",\"publishedAt\":\"2026-09-14T04:24:08.576360900Z\",\"createdAt\":\"2026-09-14T04:24:08.577452Z\",\"updatedAt\":\"2026-09-14T04:24:08.577452Z\"}','2026-09-13 21:24:08'),(54,101,'CREATE_POST','CMS','0:0:0:0:0:0:0:1','node','SUCCESS','Tạo bài viết mới',NULL,'{\"id\":16,\"title\":\"Cảnh báo an toàn bảo mật: Hướng dẫn kích hoạt xác thực sinh trắc học trên ứng dụng VCB Digibank\",\"slug\":\"canh-bao-an-toan-bao-mat-huong-dan-kich-hoat-xac-thuc-sinh-trac-hoc-tren-ung-dung-vcb-digibank\",\"summary\":\"Bảo vệ tài sản tài chính tối đa với công nghệ xác thực khuôn mặt khớp nối với cơ sở dữ liệu định danh quốc gia.\",\"content\":\"<p>Thực hiện Quyết định số 2345/QĐ-NHNN của Ngân hàng Nhà nước, Vietcombank khuyến nghị toàn bộ quý khách hàng nhanh chóng cập nhật thông tin sinh trắc học bằng cách quét chip CCCD trên ứng dụng VCB Digibank để đảm bảo giao dịch thông suốt và an toàn bảo mật cao nhất...</p>\",\"thumbnailUrl\":\"https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800\",\"category\":{\"id\":3,\"name\":\"Tín dụng & Lãi suất\",\"slug\":\"tin-dung-lai-suat\"},\"authorId\":101,\"authorName\":\"admin_super\",\"status\":\"PUBLISHED\",\"publishedAt\":\"2026-09-14T04:24:09.633463800Z\",\"createdAt\":\"2026-09-14T04:24:09.635497Z\",\"updatedAt\":\"2026-09-14T04:24:09.635497Z\"}','2026-09-13 21:24:09'),(55,103,'PROCESS_APPLICATION','APPROVAL','0:0:0:0:0:0:0:1','node','SUCCESS','Xử lý phê duyệt hồ sơ',NULL,'{\"id\":1025,\"applicationCode\":\"APP-CARD-2026-9212\",\"type\":\"CARD_ISSUANCE\",\"requestedAmount\":50000000.00,\"status\":\"APPROVED\",\"createdAt\":\"2026-09-14T04:25:45Z\",\"updatedAt\":\"2026-09-14T04:25:45Z\",\"customer\":{\"id\":601,\"fullName\":\"Trần Thị Thu Hà\",\"idCardNumber\":\"001198004567\",\"phoneNumber\":\"0911222333\",\"email\":\"ha.tran@gmail.com\"},\"documents\":[],\"approvals\":[{\"id\":11,\"action\":\"APPROVED\",\"reasonNote\":\"Hồ sơ đạt tiêu chuẩn tín dụng, nguồn thu nhập chứng minh minh bạch.\",\"managerName\":\"Lê Minh Tuấn\",\"processedAt\":\"2026-09-14T04:25:52.114481Z\"}]}','2026-09-13 21:25:52'),(56,104,'CREATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Ghi nhận tư vấn khách hàng',NULL,'{\"id\":17,\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"customerEmail\":\"ha.tran@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Vay mua nhà ở dự án\",\"notes\":\"Khách hàng có nhu cầu vay mua căn hộ Vinhomes Smart City 1.2 tỷ\",\"status\":\"FOLLOW_UP\",\"createdAt\":\"2026-09-14T04:25:53.484894Z\",\"updatedAt\":\"2026-09-14T04:25:53.484894Z\"}','2026-09-13 21:25:53'),(57,104,'CREATE_TICKET','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Mở yêu cầu hỗ trợ khách hàng mới',NULL,'{\"id\":16,\"ticketCode\":\"TK-2026-9227\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Hỗ trợ cấp lại mã PIN thẻ tín dụng\",\"content\":\"Khách hàng quên mã PIN thẻ Visa Platinum tại cây ATM\",\"priority\":\"HIGH\",\"status\":\"NEW\",\"createdAt\":\"2026-09-14T04:25:54.518229Z\",\"updatedAt\":\"2026-09-14T04:25:54.518229Z\",\"logs\":[]}','2026-09-13 21:25:54'),(58,104,'CREATE_FINANCIAL_TX','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Thực hiện giao dịch chuyển/nạp tiền',NULL,'{\"id\":23,\"transactionCode\":\"TXN-2026-961391\",\"senderCustomerId\":601,\"senderCustomerName\":\"Trần Thị Thu Hà\",\"receiverAccountNumber\":\"0011001234567\",\"receiverName\":\"LE HOANG PHUC\",\"bankName\":\"VIETCOMBANK\",\"amount\":15000000,\"fee\":0,\"description\":\"Nop tien tai quay chi nhanh Ba Dinh\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"status\":\"SUCCESS\",\"createdAt\":\"2026-09-14T04:25:55.652441Z\"}','2026-09-13 21:25:55'),(59,101,'SECURITY_CONFIG_UPDATE','SYSTEM_SECURITY','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64)','SUCCESS','Admin Super kích hoạt chính sách bắt buộc xác thực 2FA qua OTP cho toàn bộ cán bộ',NULL,NULL,'2026-09-14 04:30:58'),(60,103,'CREDIT_APPROVAL_DECISION','APPROVAL_MODULE','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64)','SUCCESS','Quản lý Minh Tuấn phê duyệt hồ sơ vay mua ô tô điện VinFast VF8 hạn mức 750 triệu',NULL,NULL,'2026-09-14 04:30:58'),(61,104,'CASH_DEPOSIT_TRANSACTION','STAFF_COUNTER','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64)','SUCCESS','Giao dịch viên Hoàng Nam thực hiện lệnh nộp tiền mặt 50.000.000 đ tại quầy số 02',NULL,NULL,'2026-09-14 04:30:58'),(62,104,'CUSTOMER_ADVISORY_CREATE','STAFF_CRM','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64)','SUCCESS','Ghi nhận phiếu tư vấn giải pháp bảo hiểm FWD liên kết đầu tư cho khách hàng VIP',NULL,NULL,'2026-09-14 04:30:58'),(63,103,'EXPORT_EXCEL_REPORT','REPORT_MODULE','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64)','SUCCESS','Quản lý xuất báo cáo tổng hợp thẩm định và chỉ số tăng trưởng tín dụng Quý 3/2026',NULL,NULL,'2026-09-14 04:30:58'),(64,103,'PROCESS_APPLICATION','APPROVAL','0:0:0:0:0:0:0:1','node','SUCCESS','Xử lý phê duyệt hồ sơ',NULL,'{\"id\":1029,\"applicationCode\":\"APP-CARD-2026-3488\",\"type\":\"CARD_ISSUANCE\",\"requestedAmount\":50000000.00,\"status\":\"APPROVED\",\"createdAt\":\"2026-09-14T04:31:49Z\",\"updatedAt\":\"2026-09-14T04:31:49Z\",\"customer\":{\"id\":601,\"fullName\":\"Trần Thị Thu Hà\",\"idCardNumber\":\"001198004567\",\"phoneNumber\":\"0911222333\",\"email\":\"ha.tran@gmail.com\"},\"documents\":[],\"approvals\":[{\"id\":17,\"action\":\"APPROVED\",\"reasonNote\":\"Hồ sơ đạt tiêu chuẩn tín dụng, nguồn thu nhập chứng minh minh bạch.\",\"managerName\":\"Lê Minh Tuấn\",\"processedAt\":\"2026-09-14T04:31:56.607130Z\"}]}','2026-09-13 21:31:57'),(65,104,'CREATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Ghi nhận tư vấn khách hàng',NULL,'{\"id\":18,\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"customerEmail\":\"ha.tran@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Vay mua nhà ở dự án\",\"notes\":\"Khách hàng có nhu cầu vay mua căn hộ Vinhomes Smart City 1.2 tỷ\",\"status\":\"FOLLOW_UP\",\"createdAt\":\"2026-09-14T04:31:57.970283Z\",\"updatedAt\":\"2026-09-14T04:31:57.970283Z\"}','2026-09-13 21:31:58'),(66,104,'CREATE_TICKET','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Mở yêu cầu hỗ trợ khách hàng mới',NULL,'{\"id\":17,\"ticketCode\":\"TK-2026-5648\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Hỗ trợ cấp lại mã PIN thẻ tín dụng\",\"content\":\"Khách hàng quên mã PIN thẻ Visa Platinum tại cây ATM\",\"priority\":\"HIGH\",\"status\":\"NEW\",\"createdAt\":\"2026-09-14T04:31:58.996329Z\",\"updatedAt\":\"2026-09-14T04:31:58.996329Z\",\"logs\":[]}','2026-09-13 21:31:59'),(67,104,'CREATE_FINANCIAL_TX','StaffModule','0:0:0:0:0:0:0:1','node','SUCCESS','Thực hiện giao dịch chuyển/nạp tiền',NULL,'{\"id\":29,\"transactionCode\":\"TXN-2026-326188\",\"senderCustomerId\":601,\"senderCustomerName\":\"Trần Thị Thu Hà\",\"receiverAccountNumber\":\"0011001234567\",\"receiverName\":\"LE HOANG PHUC\",\"bankName\":\"VIETCOMBANK\",\"amount\":15000000,\"fee\":0,\"description\":\"Nop tien tai quay chi nhanh Ba Dinh\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"status\":\"SUCCESS\",\"createdAt\":\"2026-09-14T04:32:00.157294Z\"}','2026-09-13 21:32:00'),(68,104,'PROCESS_TICKET','StaffModule','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0','SUCCESS','Xử lý / phản hồi yêu cầu CSKH',NULL,'{\"id\":17,\"ticketCode\":\"TK-2026-5648\",\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Hỗ trợ cấp lại mã PIN thẻ tín dụng\",\"content\":\"Khách hàng quên mã PIN thẻ Visa Platinum tại cây ATM\",\"priority\":\"HIGH\",\"status\":\"IN_PROGRESS\",\"createdAt\":\"2026-09-14T04:31:58Z\",\"updatedAt\":\"2026-09-14T04:31:58Z\",\"logs\":[{\"id\":12,\"staffName\":\"Nguyễn Hoàng Nam\",\"actionNote\":\"ABCDEF\",\"createdAt\":\"2026-09-18T01:23:23.958587Z\"}]}','2026-09-17 18:23:24'),(69,104,'CREATE_TICKET','StaffModule','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','SUCCESS','Mở yêu cầu hỗ trợ khách hàng mới',NULL,'{\"id\":18,\"ticketCode\":\"TK-2026-6271\",\"customerId\":501,\"customerName\":\"Lê Hoàng Nam\",\"customerPhone\":\"0988777666\",\"assignedStaffId\":104,\"assignedStaffName\":\"Nguyễn Hoàng Nam\",\"title\":\"Không đăng nhập được\",\"content\":\"Tôi không đăng nhập được vào bằng tài khoản\",\"priority\":\"MEDIUM\",\"status\":\"NEW\",\"createdAt\":\"2026-09-18T02:38:16.595399Z\",\"updatedAt\":\"2026-09-18T02:38:16.595399Z\",\"logs\":[]}','2026-09-17 19:38:18'),(70,104,'UPDATE_ADVISORY','StaffModule','0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36','SUCCESS','Cập nhật tiến độ tư vấn khách hàng',NULL,'{\"id\":18,\"customerId\":601,\"customerName\":\"Trần Thị Thu Hà\",\"customerPhone\":\"0911222333\",\"customerEmail\":\"ha.tran@gmail.com\",\"customerType\":\"INDIVIDUAL\",\"staffId\":104,\"staffName\":\"Nguyễn Hoàng Nam\",\"productType\":\"Vay mua nhà ở dự án\",\"notes\":\"Khách hàng có nhu cầu vay mua căn hộ Vinhomes Smart City 1.2 tỷ\",\"status\":\"COMPLETED\",\"createdAt\":\"2026-09-14T04:31:57Z\",\"updatedAt\":\"2026-09-14T04:31:57Z\"}','2026-09-17 19:43:45');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branches` (
  `branch_id` int(11) NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(150) NOT NULL,
  `address` varchar(255) NOT NULL,
  `district` varchar(100) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `phone_number` varchar(50) DEFAULT NULL,
  `working_hours` varchar(100) DEFAULT '08:00 - 17:00 (Thứ 2 - Thứ 6)',
  PRIMARY KEY (`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branches`
--

LOCK TABLES `branches` WRITE;
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
INSERT INTO `branches` VALUES (1,'Chi nhánh Vietcombank Hoàn Kiếm','198 Trần Quang Khải','Quận Hoàn Kiếm','Hà Nội','024 3934 3137','08:00 - 17:00 (Thứ 2 - Thứ 6)'),(2,'Chi nhánh Vietcombank Ba Đình','521 Kim Mã','Quận Ba Đình','Hà Nội','024 3726 1234','08:00 - 17:00 (Thứ 2 - Thứ 6)'),(3,'Chi nhánh Vietcombank TP.HCM - Hội sở Bến Thành','Tòa nhà Vietcombank Tower, Công trường Mê Linh','Quận 1','TP. Hồ Chí Minh','028 3829 7245','08:00 - 17:00 (Thứ 2 - Thứ 6)'),(4,'Chi nhánh Vietcombank Bến Thành','69 Bùi Thị Xuân','Quận 1','TP. Hồ Chí Minh','028 3833 0888','08:00 - 17:00 (Thứ 2 - Thứ 6)'),(5,'Chi nhánh Vietcombank Đà Nẵng','140-142 Lê Lợi','Quận Hải Châu','Đà Nẵng','0236 382 2110','08:00 - 17:00 (Thứ 2 - Thứ 6)'),(6,'Chi nhánh Vietcombank Cần Thơ','3-5-7 Hòa Bình','Quận Ninh Kiều','Cần Thơ','0292 382 0422','08:00 - 17:00 (Thứ 2 - Thứ 6)'),(7,'Chi nhánh Vietcombank Hai Bà Trưng','Số 52 phố Lê Đại Hành, phường Lê Đại Hành','Quận Hai Bà Trưng','Hà Nội','024.3974.6666','Thứ 2 - Thứ 6: 08:00 - 16:30'),(8,'Chi nhánh Vietcombank Tân Bình','Số 108 đường Cộng Hòa, Phường 4','Quận Tân Bình','TP. Hồ Chí Minh','028.3811.8888','Thứ 2 - Thứ 6: 08:00 - 16:30'),(9,'Chi nhánh Vietcombank Hải Phòng','Số 11 đường Trần Phú, phường Lương Khánh Thiện','Quận Ngô Quyền','Hải Phòng','0225.385.9999','Thứ 2 - Thứ 6: 08:00 - 16:30'),(10,'Chi nhánh Vietcombank Bình Dương','Số 314 Đại lộ Bình Dương, phường Phú Hòa','TP. Thủ Dầu Một','Bình Dương','0274.382.5555','Thứ 2 - Thứ 6: 08:00 - 16:30'),(11,'Chi nhánh Vietcombank Nha Trang','Số 17 đường Quang Trung, phường Vạn Thạnh','TP. Nha Trang','Khánh Hòa','0258.382.4444','Thứ 2 - Thứ 6: 08:00 - 16:30'),(12,'Chi nhánh Vietcombank Hai Bà Trưng','Số 52 phố Lê Đại Hành, phường Lê Đại Hành','Quận Hai Bà Trưng','Hà Nội','024.3974.6666','Thứ 2 - Thứ 6: 08:00 - 16:30'),(13,'Chi nhánh Vietcombank Tân Bình','Số 108 đường Cộng Hòa, Phường 4','Quận Tân Bình','TP. Hồ Chí Minh','028.3811.8888','Thứ 2 - Thứ 6: 08:00 - 16:30'),(14,'Chi nhánh Vietcombank Hải Phòng','Số 11 đường Trần Phú, phường Lương Khánh Thiện','Quận Ngô Quyền','Hải Phòng','0225.385.9999','Thứ 2 - Thứ 6: 08:00 - 16:30'),(15,'Chi nhánh Vietcombank Bình Dương','Số 314 Đại lộ Bình Dương, phường Phú Hòa','TP. Thủ Dầu Một','Bình Dương','0274.382.5555','Thứ 2 - Thứ 6: 08:00 - 16:30'),(16,'Chi nhánh Vietcombank Nha Trang','Số 17 đường Quang Trung, phường Vạn Thạnh','TP. Nha Trang','Khánh Hòa','0258.382.4444','Thứ 2 - Thứ 6: 08:00 - 16:30');
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `car_loan_details`
--

DROP TABLE IF EXISTS `car_loan_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `car_loan_details` (
  `car_detail_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_app_id` bigint(20) NOT NULL,
  `car_brand` varchar(100) NOT NULL,
  `car_model` varchar(100) NOT NULL,
  `manufacture_year` int(11) NOT NULL,
  `car_price` decimal(18,2) NOT NULL,
  `is_new_car` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`car_detail_id`),
  UNIQUE KEY `loan_app_id` (`loan_app_id`),
  CONSTRAINT `car_loan_details_ibfk_1` FOREIGN KEY (`loan_app_id`) REFERENCES `loan_applications` (`loan_app_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `car_loan_details`
--

LOCK TABLES `car_loan_details` WRITE;
/*!40000 ALTER TABLE `car_loan_details` DISABLE KEYS */;
INSERT INTO `car_loan_details` VALUES (1,2,'Toyota','Camry 2.5Q Hybrid',2026,1450000000.00,1),(2,5,'Hyundai','Tucson 2.0 Turbo 2026',2026,1050000000.00,1),(3,7,'VinFast','VF8 Plus Dual Motor 2026',2026,1270000000.00,1),(4,8,'Mercedes-Benz','C300 AMG 2026',2026,2099000000.00,1),(5,10,'Hyundai','Tucson 2.0 Turbo 2026',2026,1050000000.00,1),(6,12,'Hyundai','Tucson 2.0 Turbo 2026',2026,1050000000.00,1),(7,17,'Toyota','Corolla Cross 1.8V',2026,800000000.00,1),(8,18,'Toyota','Corolla Cross 1.8V',2026,800000000.00,1);
/*!40000 ALTER TABLE `car_loan_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Tin tức ngân hàng','tin-tuc-ngan-hang'),(2,'Ưu đãi thẻ','uu-dai-the'),(3,'Tín dụng & Lãi suất','tin-dung-lai-suat'),(4,'Chuyển đổi số','chuyen-doi-so');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatbot_appointments`
--

DROP TABLE IF EXISTS `chatbot_appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot_appointments` (
  `appointment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `appointment_code` varchar(50) NOT NULL,
  `appointment_date` date NOT NULL,
  `branch_name` varchar(150) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `full_name` varchar(100) NOT NULL,
  `handled_by` varchar(100) DEFAULT NULL,
  `handler_note` text DEFAULT NULL,
  `note` text DEFAULT NULL,
  `phone_number` varchar(20) NOT NULL,
  `service_type` varchar(150) NOT NULL,
  `status` enum('CANCELLED','COMPLETED','CONFIRMED','PENDING') NOT NULL,
  `time_slot` varchar(50) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`appointment_id`),
  UNIQUE KEY `UKs1dn3961a39618ms01u66i6fq` (`appointment_code`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot_appointments`
--

LOCK TABLES `chatbot_appointments` WRITE;
/*!40000 ALTER TABLE `chatbot_appointments` DISABLE KEYS */;
INSERT INTO `chatbot_appointments` VALUES (1,'VCB-APT-2026-10001','2026-09-12','Chi nhánh Vietcombank Hoàn Kiếm','2026-09-10 01:48:26.586609','tuan.nguyen@gmail.com','Nguyễn Văn Tuấn','Nguyễn Hoàng Nam',NULL,'Cần tư vấn lãi suất ưu đãi cố định 2 năm đầu','0912345678','Đăng ký Gói vay mua nhà an cư','COMPLETED','09:00 - 10:00','2026-09-13 15:34:24.186059'),(2,'VCB-APT-2026-10002','2026-09-11','Chi nhánh Vietcombank Ba Đình','2026-09-10 01:48:26.621393','thuha.tran@outlook.com','Trần Thị Thu Hà','Nguyễn Hoàng Nam','Đã gọi điện xác nhận và chuẩn bị sẵn biểu mẫu','Muốn chọn đuôi số tài khoản tứ quý 8888','0987654321','Mở tài khoản thanh toán số đẹp & Thẻ Visa','CONFIRMED','10:30 - 11:30','2026-09-10 01:48:26.621393'),(3,'VCB-APT-2026-10003','2026-09-10','Chi nhánh Vietcombank Sở Giao dịch','2026-09-10 01:48:26.631688','nam.le@gmail.com','Lê Hoàng Nam','Nguyễn Hoàng Nam','Khách hàng đã hoàn tất mở sổ tiết kiệm tại quầy 03','Gửi tiết kiệm 1 tỷ đồng','0933112233','Tư vấn Tiết kiệm lãi suất bậc thang','COMPLETED','14:00 - 15:00','2026-09-10 01:48:26.631688'),(4,'VCB-APT-2026-10004','2026-09-13','Chi nhánh Vietcombank Cầu Giấy','2026-09-10 01:48:26.642515','contact@vinatech.vn','Công ty Cổ phần VinaTech',NULL,NULL,'Hạn mức tín dụng xuất nhập khẩu 15 tỷ VND','0243888999','Tín dụng Doanh nghiệp & Phát hành L/C','PENDING','15:00 - 16:00','2026-09-10 01:48:26.642515'),(5,'VCB-APT-2026-10005','2026-09-09','Chi nhánh Vietcombank Đống Đa','2026-09-10 01:48:26.653956','cuong.pham@yahoo.com','Phạm Quốc Cường','Nguyễn Hoàng Nam','Khách hàng bận đột xuất, đã hỗ trợ hướng dẫn nhận qua Digibank','Nhận tiền từ người thân tại Hoa Kỳ','0905123987','Nhận tiền kiều hối Western Union','CANCELLED','08:30 - 09:30','2026-09-10 01:48:26.653956'),(6,'VCB-APT-2026-65362','2026-09-10','Chi nhánh Hoàn Kiếm - Hà Nội','2026-09-10 01:49:44.971770',NULL,'Nguyễn Văn B',NULL,NULL,'Đặt lịch vay vốn','0987654321','Gửi tiền tiết kiệm & Mở tài khoản','PENDING','09:00 - 10:00','2026-09-10 01:49:44.971770'),(7,'VCB-APT-2026-20001','2026-09-11','Chi nhánh Vietcombank Hoàn Kiếm - Hà Nội',NULL,'hanh.nguyen@gmail.com','Nguyễn Thị Hồng Hạnh',NULL,NULL,'Cần tư vấn gói vay mua chung cư Vinhomes Smart City 2 tỷ, vay 15 năm','0915666777','Tư vấn hồ sơ vay vốn (Mua nhà/Mua xe/Kinh doanh)','PENDING','09:30 - 10:30',NULL),(8,'VCB-APT-2026-20002','2026-09-11','Chi nhánh Vietcombank Bến Thành - TP.HCM',NULL,'trong.vu@outlook.com','Vũ Đình Trọng','Nguyễn Hoàng Nam','Đã gọi xác nhận lúc 09h sáng, đã giữ quầy ưu tiên số 02','Gửi tiết kiệm bậc thang 500 triệu, cần tư vấn kỳ hạn sinh lời tốt nhất','0982334455','Gửi tiền tiết kiệm & Mở tài khoản','CONFIRMED','10:30 - 11:30',NULL),(9,'VCB-APT-2026-20003','2026-09-12','Chi nhánh Vietcombank Cầu Giấy',NULL,'tckt@saomai.vn','Công ty CP Đầu tư & Công nghệ Sao Mai',NULL,NULL,'Hồ sơ mở L/C nhập khẩu thiết bị máy móc từ Hàn Quốc giá trị 350,000 USD','0243777888','Dịch vụ Doanh nghiệp & Tài trợ thương mại','PENDING','14:30 - 15:30',NULL),(10,'VCB-APT-2026-20004','2026-09-10','Chi nhánh Vietcombank Ba Đình - Hà Nội',NULL,'duc.hoang@fpt.com.vn','Hoàng Minh Đức','Nguyễn Hoàng Nam','Đã hoàn tất tiếp nhận hồ sơ, phát hành thẻ hạn mức 150 triệu VND','Muốn phát hành thẻ Vietcombank Visa Signature hoàn tiền mua sắm','0903112244','Phát hành thẻ tín dụng quốc tế','COMPLETED','08:30 - 09:30',NULL),(11,'VCB-APT-2026-20005','2026-09-09','Chi nhánh Vietcombank TP.HCM - Q.1',NULL,'dung.dang@yahoo.com','Đặng Thùy Dung','Nguyễn Hoàng Nam','Đã kích hoạt lại Smart OTP và cấp lại PIN thẻ tại quầy','Quên mã PIN Smart OTP và thẻ ghi nợ quốc tế bị khóa','0979445566','Tra soát giao dịch & Hỗ trợ ngân hàng số','COMPLETED','13:30 - 14:30',NULL),(12,'VCB-APT-2026-20006','2026-09-12','Chi nhánh Vietcombank Đà Nẵng',NULL,'hau.phan@gmail.com','Phan Văn Hậu','Nguyễn Hoàng Nam','Đã báo kho quỹ chi nhánh chuẩn bị sẵn tiền mặt','Rút tiền mặt 800 triệu chuẩn bị thanh toán tiền cọc mua đất','0938999111','Giao dịch nộp / rút tiền mặt số lượng lớn','CONFIRMED','09:00 - 10:00',NULL),(13,'VCB-APT-2026-20007','2026-09-13','Chi nhánh Vietcombank Hoàn Kiếm - Hà Nội',NULL,'huyen.le@vnpay.vn','Lê Khánh Huyền',NULL,NULL,'Chọn tài khoản số đẹp lộc phát đuôi 6868','0912888333','Mở tài khoản thanh toán số đẹp & Thẻ Visa','PENDING','15:30 - 16:30',NULL),(14,'VCB-APT-2026-20008','2026-09-08','Chi nhánh Vietcombank Cần Thơ',NULL,'bao.ngo@vinamilk.com.vn','Ngô Quốc Bảo','Nguyễn Hoàng Nam','Khách hàng đổi kế hoạch sang tháng sau, đã hủy lịch hẹn theo yêu cầu','Vay mua xe ô tô tải phục vụ kinh doanh trang trại','0908777888','Tư vấn hồ sơ vay vốn (Mua nhà/Mua xe/Kinh doanh)','CANCELLED','10:00 - 11:00',NULL),(24,'VCB-APT-2026-35737','2026-09-18','Chi nhánh Vietcombank Hoàn Kiếm','2026-09-13 15:34:25.024703','giabao@gmail.com','Hoàng Gia Bảo',NULL,NULL,'Cần tư vấn gói phát hành thẻ Visa Signature','0912999888','Mở tài khoản & Thẻ tín dụng cao cấp','PENDING','09:00 - 10:00','2026-09-13 15:34:25.024703'),(25,'VCB-APT-2026-97819','2026-09-20','Chi nhánh Vietcombank Hoàn Kiếm','2026-09-13 15:36:22.948856','van.ngo@gmail.com','Ngô Thanh Vân',NULL,NULL,'Tư vấn mở thẻ Visa Platinum cao cấp','0909123456','Mở thẻ tín dụng & Tư vấn gói vay','PENDING','14:00 - 15:00','2026-09-13 15:36:22.948856'),(26,'VCB-APT-2026-71221','2026-09-20','Chi nhánh Vietcombank Hoàn Kiếm','2026-09-13 15:40:12.058477','van.ngo@gmail.com','Ngô Thanh Vân',NULL,NULL,'Tư vấn mở thẻ Visa Platinum cao cấp','0909123456','Mở thẻ tín dụng & Tư vấn gói vay','PENDING','14:00 - 15:00','2026-09-13 15:40:12.058477'),(27,'VCB-APT-2026-70393','2026-09-20','Chi nhánh Vietcombank Hoàn Kiếm','2026-09-13 15:41:07.562314','van.ngo@gmail.com','Ngô Thanh Vân',NULL,NULL,'Tư vấn mở thẻ Visa Platinum cao cấp','0909123456','Mở thẻ tín dụng & Tư vấn gói vay','PENDING','14:00 - 15:00','2026-09-13 15:41:07.562314'),(28,'VCB-APT-2026-64342','2026-09-18','Chi nhánh Vietcombank Hoàn Kiếm - Hà Nội','2026-09-14 04:24:01.841205','phong.tran@gmail.com','Trần Đình Phong',NULL,NULL,'Tư vấn gói vay sản xuất kinh doanh hạn mức 1.5 tỷ cho cơ sở chế biến thực phẩm','0988112244','Tư vấn hồ sơ vay vốn (Mua nhà/Mua xe/Kinh doanh)','PENDING','09:00 - 10:00','2026-09-14 04:24:01.841205'),(29,'VCB-APT-2026-95275','2026-09-18','Chi nhánh Vietcombank Ba Đình - Hà Nội','2026-09-14 04:24:02.503473','duyen.le@outlook.com','Lê Mỹ Duyên',NULL,NULL,'Nhận thẻ vật lý Vietcombank Visa Signature và kích hoạt thanh toán không tiếp xúc','0912334455','Phát hành thẻ tín dụng quốc tế','PENDING','10:30 - 11:30','2026-09-14 04:24:02.503473'),(30,'VCB-APT-2026-58408','2026-09-19','Chi nhánh Vietcombank Cầu Giấy','2026-09-14 04:24:03.161824','contact@minhlong.vn','Công ty TNHH Đầu tư Minh Long',NULL,NULL,'Mở tài khoản thanh toán số đẹp doanh nghiệp và ký hợp đồng bảo lãnh tạm ứng thầu','0243888777','Dịch vụ Doanh nghiệp & Tài trợ thương mại','PENDING','14:00 - 15:00','2026-09-14 04:24:03.161824'),(31,'VCB-APT-2026-77485','2026-09-19','Chi nhánh Vietcombank Bến Thành - TP.HCM','2026-09-14 04:24:03.824043','haidang@vinamilk.com.vn','Nguyễn Hải Đăng',NULL,NULL,'Gửi tiết kiệm bậc thang 1.2 tỷ VND, cần được tiếp đón tại quầy Priority VIP','0903889911','Gửi tiền tiết kiệm & Mở tài khoản','PENDING','15:30 - 16:30','2026-09-14 04:24:03.824043'),(32,'VCB-APT-2026-28029','2026-09-20','Chi nhánh Vietcombank Đà Nẵng','2026-09-14 04:24:04.500477','mai.pham@vietjetair.com','Phạm Ngọc Mai',NULL,NULL,'Hỗ trợ quét chip căn cước CCCD và cập nhật dữ liệu sinh trắc học trực tiếp tại quầy','0977665544','Tra soát giao dịch & Hỗ trợ ngân hàng số','PENDING','08:30 - 09:30','2026-09-14 04:24:04.500477'),(33,'VCB-APT-2026-73323','2026-09-20','Chi nhánh Vietcombank Hoàn Kiếm','2026-09-14 04:26:00.867788','van.ngo@gmail.com','Ngô Thanh Vân',NULL,NULL,'Tư vấn mở thẻ Visa Platinum cao cấp','0909123456','Mở thẻ tín dụng & Tư vấn gói vay','PENDING','14:00 - 15:00','2026-09-14 04:26:00.867788'),(34,'VCB-APT-2026-76357','2026-09-20','Chi nhánh Vietcombank Hoàn Kiếm','2026-09-14 04:32:05.234252','van.ngo@gmail.com','Ngô Thanh Vân',NULL,NULL,'Tư vấn mở thẻ Visa Platinum cao cấp','0909123456','Mở thẻ tín dụng & Tư vấn gói vay','PENDING','14:00 - 15:00','2026-09-14 04:32:05.234252');
/*!40000 ALTER TABLE `chatbot_appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatbot_faqs`
--

DROP TABLE IF EXISTS `chatbot_faqs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot_faqs` (
  `faq_id` int(11) NOT NULL AUTO_INCREMENT,
  `category` enum('APPOINTMENT','CONTACT','USER_GUIDE','RATES','LOAN_SERVICE','CARD_SERVICE') NOT NULL,
  `keywords` varchar(255) NOT NULL,
  `question` varchar(255) NOT NULL,
  `answer` text NOT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`faq_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot_faqs`
--

LOCK TABLES `chatbot_faqs` WRITE;
/*!40000 ALTER TABLE `chatbot_faqs` DISABLE KEYS */;
INSERT INTO `chatbot_faqs` VALUES (1,'CONTACT','hotline, tổng đài, số điện thoại, cskh, liên hệ','Tổng đài Hotline hỗ trợ khách hàng Vietcombank là số nào?','Trung tâm Hỗ trợ Khách hàng Vietcombank phục vụ 24/7:\n📞 Hotline trong nước: 1900 54 54 13\n📞 Hotline quốc tế: (+84) 243 8243524\n✉️ Email: contact@vietcombank.com.vn','OPEN_TAB_CONTACT','2026-09-09 11:53:09'),(2,'APPOINTMENT','đặt lịch, hẹn quầy, chi nhánh, lấy số thứ tự','Làm thế nào để đặt lịch hẹn giao dịch trước tại quầy Vietcombank?','Quý khách có thể chọn tab \"📅 Đặt lịch hẹn\" ngay trong Chatbot hoặc trên cổng thông tin để chọn chi nhánh, khung giờ và dịch vụ cần giao dịch. Quý khách sẽ được tiếp đón tại quầy ưu tiên mà không cần bốc số chờ đợi.','OPEN_TAB_APPOINTMENT','2026-09-09 11:53:09'),(3,'USER_GUIDE','quên mật khẩu, khóa tài khoản, digibank','Tôi quên mật khẩu đăng nhập ứng dụng VCB Digibank thì phải làm sao?','Tại màn hình đăng nhập VCB Digibank, Quý khách bấm \"Quên mật khẩu\" → Nhập Tên đăng nhập, số CCCD và Email đã đăng ký → Hệ thống xác thực bằng khuôn mặt eKYC và gửi mật khẩu tạm thời về SMS/Email của quý khách trong 1 phút.','USER_GUIDE','2026-09-09 11:53:09'),(4,'USER_GUIDE','mở tài khoản, đăng ký mới, ekyc','Làm thế nào để mở tài khoản Vietcombank online tại nhà?','Quý khách tải ứng dụng VCB Digibank trên App Store hoặc Google Play → Chọn \"Mở tài khoản mới\" → Chụp ảnh 2 mặt CCCD gắn chip → Xác thực khuôn mặt sinh trắc học và nhận số tài khoản đẹp kích hoạt ngay.','USER_GUIDE','2026-09-09 11:53:09'),(5,'RATES','lãi suất, gửi tiết kiệm, tiền gửi','Mức lãi suất tiền gửi tiết kiệm cao nhất hiện nay tại Vietcombank là bao nhiêu?','Mức lãi suất tiết kiệm trực tuyến tại Vietcombank hiện lên tới 6.8%/năm cho kỳ hạn 12 đến 24 tháng. Quý khách có thể sử dụng \"Công cụ tính lãi\" ngay trên trang chủ để xem trước số tiền lãi nhận được.','OPEN_CALC','2026-09-09 11:53:09'),(6,'LOAN_SERVICE','vay vốn, mua nhà, mua ô tô, lãi suất vay','Chương trình cho vay mua nhà và mua xe ô tô của Vietcombank có ưu đãi gì?','Vietcombank đang áp dụng gói tín dụng ưu đãi với lãi suất vay chỉ từ 6.0%/năm, tài trợ tới 85% giá trị tài sản đảm bảo, thời hạn vay lên đến 35 năm. Quý khách có thể bấm nút \"Đăng ký nộp hồ sơ vay online\" để được cán bộ tín dụng tư vấn trong 24h.','OPEN_CALC','2026-09-09 11:53:09'),(7,'USER_GUIDE','sinh trắc học, 2345, cccd gắn chip, nfc, quét khuôn mặt','Hướng dẫn kích hoạt xác thực sinh trắc học theo Quyết định 2345?','Quý khách vui lòng mở ứng dụng VCB Digibank -> Chọn Cài đặt -> Cập nhật sinh trắc học -> Đặt chip căn cước CCCD sát lưng điện thoại và thực hiện quét khuôn mặt theo hướng dẫn.','NAVIGATE_BIOMETRICS','2026-09-14 04:30:45'),(8,'CARD_SERVICE','kích hoạt thẻ, mở thẻ, e-pin, đổi pin, quên pin','Làm thế nào để kích hoạt thẻ tín dụng và cấp lại mã PIN?','Quý khách có thể kích hoạt thẻ và tạo mã PIN điện tử (e-PIN) tức thì trên ứng dụng VCB Digibank tại mục Dịch vụ thẻ -> Quản lý dịch vụ thẻ -> Kích hoạt thẻ / Cấp mới PIN.','NAVIGATE_CARD_PIN','2026-09-14 04:30:45'),(9,'LOAN_SERVICE','vay mua ô tô điện vinfast, vf8, vf9, lãi suất ưu đãi','Gói vay mua ô tô điện VinFast của Vietcombank có ưu đãi gì?','Vietcombank hỗ trợ vay tới 85% giá trị xe trong thời gian tối đa 8 năm, lãi suất ưu đãi cố định chỉ từ 5.8%/năm, miễn phí sạc pin tại trạm sạc công cộng trong 2 năm.','NAVIGATE_AUTO_LOAN','2026-09-14 04:30:45'),(10,'RATES','lãi suất tiết kiệm cao nhất, gửi online, tích lũy','Lãi suất gửi tiết kiệm Online cao nhất tại Vietcombank là bao nhiêu?','Lãi suất tiết kiệm trực tuyến trên VCB Digibank hiện nay lên tới 7.2%/năm đối với kỳ hạn từ 24 tháng trở lên, cộng thêm ưu đãi lãi suất bậc thang cho số tiền gửi từ 100 triệu.','NAVIGATE_SAVINGS','2026-09-14 04:30:45'),(11,'APPOINTMENT','đặt lịch hẹn quầy, tiếp đón ưu tiên, không chờ đợi','Làm sao để đặt lịch hẹn tiếp đón tại quầy giao dịch chi nhánh?','Quý khách có thể chọn trực tiếp Đặt lịch hẹn trên màn hình Chatbot AI này hoặc vào Cổng thông tin Vietcombank -> Chọn chi nhánh, khung giờ và dịch vụ để được phục vụ tại quầy ưu tiên.','OPEN_APPOINTMENT_MODAL','2026-09-14 04:30:45'),(12,'USER_GUIDE','sinh trắc học, 2345, cccd gắn chip, nfc, quét khuôn mặt','Hướng dẫn kích hoạt xác thực sinh trắc học theo Quyết định 2345?','Quý khách vui lòng mở ứng dụng VCB Digibank -> Chọn Cài đặt -> Cập nhật sinh trắc học -> Đặt chip căn cước CCCD sát lưng điện thoại và thực hiện quét khuôn mặt theo hướng dẫn.','NAVIGATE_BIOMETRICS','2026-09-14 04:30:57'),(13,'CARD_SERVICE','kích hoạt thẻ, mở thẻ, e-pin, đổi pin, quên pin','Làm thế nào để kích hoạt thẻ tín dụng và cấp lại mã PIN?','Quý khách có thể kích hoạt thẻ và tạo mã PIN điện tử (e-PIN) tức thì trên ứng dụng VCB Digibank tại mục Dịch vụ thẻ -> Quản lý dịch vụ thẻ -> Kích hoạt thẻ / Cấp mới PIN.','NAVIGATE_CARD_PIN','2026-09-14 04:30:57'),(14,'LOAN_SERVICE','vay mua ô tô điện vinfast, vf8, vf9, lãi suất ưu đãi','Gói vay mua ô tô điện VinFast của Vietcombank có ưu đãi gì?','Vietcombank hỗ trợ vay tới 85% giá trị xe trong thời gian tối đa 8 năm, lãi suất ưu đãi cố định chỉ từ 5.8%/năm, miễn phí sạc pin tại trạm sạc công cộng trong 2 năm.','NAVIGATE_AUTO_LOAN','2026-09-14 04:30:57'),(15,'RATES','lãi suất tiết kiệm cao nhất, gửi online, tích lũy','Lãi suất gửi tiết kiệm Online cao nhất tại Vietcombank là bao nhiêu?','Lãi suất tiết kiệm trực tuyến trên VCB Digibank hiện nay lên tới 7.2%/năm đối với kỳ hạn từ 24 tháng trở lên, cộng thêm ưu đãi lãi suất bậc thang cho số tiền gửi từ 100 triệu.','NAVIGATE_SAVINGS','2026-09-14 04:30:57'),(16,'APPOINTMENT','đặt lịch hẹn quầy, tiếp đón ưu tiên, không chờ đợi','Làm sao để đặt lịch hẹn tiếp đón tại quầy giao dịch chi nhánh?','Quý khách có thể chọn trực tiếp Đặt lịch hẹn trên màn hình Chatbot AI này hoặc vào Cổng thông tin Vietcombank -> Chọn chi nhánh, khung giờ và dịch vụ để được phục vụ tại quầy ưu tiên.','OPEN_APPOINTMENT_MODAL','2026-09-14 04:30:57');
/*!40000 ALTER TABLE `chatbot_faqs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `message_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `subject` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `status` enum('NEW','PROCESSING','RESOLVED') DEFAULT 'NEW',
  `response_note` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`message_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
INSERT INTO `contact_messages` VALUES (1,'Nguyễn Văn Tuấn','0981223344','tuan.nguyen@vinatex.com','Tìm hiểu gói vay ưu đãi cho doanh nghiệp dệt may xuất khẩu','Doanh nghiệp chúng tôi muốn tìm hiểu thủ tục mở L/C và vay vốn lưu động mùa vụ cuối năm với hạn mức 15 tỷ đồng.','NEW',NULL,'2026-09-14 04:30:45'),(2,'Trần Mai Hương','0912445566','huong.tran@gmail.com','Hỏi về điều kiện phát hành thẻ tín dụng phụ cho người thân','Tôi hiện đang sở hữu thẻ Vietcombank Visa Signature, muốn phát hành thêm 01 thẻ phụ cho con gái du học tại Úc.','PROCESSING','Chuyên viên CSKH đã liên hệ gửi hướng dẫn hồ sơ qua email.','2026-09-14 04:30:45'),(3,'Lê Quốc Doanh','0903556677','doanh.lq@saigontech.vn','Đề nghị liên kết cổng thanh toán trực tuyến cho website thương mại điện tử','Công ty chúng tôi cần tích hợp cổng thanh toán Vietcombank Payment Gateway trên nền tảng bán lẻ công nghệ.','RESOLVED','Đã chuyển thông tin sang Trung tâm Chuyển đổi số & Thanh toán trực tuyến.','2026-09-14 04:30:45'),(4,'Võ Thị Bích Ngọc','0978991122','bichngoc@fpt.edu.vn','Góp ý về tính năng quét NFC căn cước CCCD trên VCB Digibank','Đề xuất ngân hàng tối ưu hóa luồng hướng dẫn vị trí đặt chip NFC trên các dòng điện thoại Android để quét nhanh hơn.','RESOLVED','Đã ghi nhận phản hồi và chuyển giao cho đội ngũ phát triển Mobile App.','2026-09-14 04:30:45'),(5,'Đoàn Thanh Tùng','0934778899','tung.doan@vietjetair.com','Hỏi về hạn mức rút tiền mặt ngoại tệ tại chi nhánh trước khi công tác','Tôi có nhu cầu rút 5,000 USD tiền mặt tại chi nhánh Hoàn Kiếm vào thứ Sáu tới, cần chuẩn bị thủ tục giấy tờ gì?','NEW',NULL,'2026-09-14 04:30:45'),(6,'Nguyễn Văn Tuấn','0981223344','tuan.nguyen@vinatex.com','Tìm hiểu gói vay ưu đãi cho doanh nghiệp dệt may xuất khẩu','Doanh nghiệp chúng tôi muốn tìm hiểu thủ tục mở L/C và vay vốn lưu động mùa vụ cuối năm với hạn mức 15 tỷ đồng.','NEW',NULL,'2026-09-14 04:30:56'),(7,'Trần Mai Hương','0912445566','huong.tran@gmail.com','Hỏi về điều kiện phát hành thẻ tín dụng phụ cho người thân','Tôi hiện đang sở hữu thẻ Vietcombank Visa Signature, muốn phát hành thêm 01 thẻ phụ cho con gái du học tại Úc.','PROCESSING','Chuyên viên CSKH đã liên hệ gửi hướng dẫn hồ sơ qua email.','2026-09-14 04:30:56'),(8,'Lê Quốc Doanh','0903556677','doanh.lq@saigontech.vn','Đề nghị liên kết cổng thanh toán trực tuyến cho website thương mại điện tử','Công ty chúng tôi cần tích hợp cổng thanh toán Vietcombank Payment Gateway trên nền tảng bán lẻ công nghệ.','RESOLVED','Đã chuyển thông tin sang Trung tâm Chuyển đổi số & Thanh toán trực tuyến.','2026-09-14 04:30:56'),(9,'Võ Thị Bích Ngọc','0978991122','bichngoc@fpt.edu.vn','Góp ý về tính năng quét NFC căn cước CCCD trên VCB Digibank','Đề xuất ngân hàng tối ưu hóa luồng hướng dẫn vị trí đặt chip NFC trên các dòng điện thoại Android để quét nhanh hơn.','RESOLVED','Đã ghi nhận phản hồi và chuyển giao cho đội ngũ phát triển Mobile App.','2026-09-14 04:30:56'),(10,'Đoàn Thanh Tùng','0934778899','tung.doan@vietjetair.com','Hỏi về hạn mức rút tiền mặt ngoại tệ tại chi nhánh trước khi công tác','Tôi có nhu cầu rút 5,000 USD tiền mặt tại chi nhánh Hoàn Kiếm vào thứ Sáu tới, cần chuẩn bị thủ tục giấy tờ gì?','NEW',NULL,'2026-09-14 04:30:56');
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_advisories`
--

DROP TABLE IF EXISTS `customer_advisories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_advisories` (
  `advisory_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) NOT NULL,
  `staff_id` bigint(20) NOT NULL,
  `product_type` varchar(100) NOT NULL,
  `notes` text NOT NULL,
  `status` enum('CONSULTED','FOLLOW_UP','COMPLETED','CANCELLED') DEFAULT 'CONSULTED',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`advisory_id`),
  KEY `customer_id` (`customer_id`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `customer_advisories_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `customer_advisories_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_advisories`
--

LOCK TABLES `customer_advisories` WRITE;
/*!40000 ALTER TABLE `customer_advisories` DISABLE KEYS */;
INSERT INTO `customer_advisories` VALUES (1,501,104,'Gói vay mua nhà an cư 35 năm','Khách hàng đã đồng ý gói vay lãi suất 6.8%/năm và ký hoàn tất hồ sơ giải ngân.','COMPLETED','2026-09-09 11:53:08','2026-09-13 08:34:22'),(2,602,104,'Tín dụng doanh nghiệp & L/C','Doanh nghiệp xuất nhập khẩu linh kiện, nhu cầu bảo lãnh thanh toán 3 tỷ đồng.','COMPLETED','2026-09-09 11:53:08','2026-09-09 11:53:08'),(3,501,104,'Gói vay mua nhà an cư 15 năm','Khách hàng có thu nhập ổn định 35 triệu/tháng, đã giải thích biểu phí và lãi suất cố định 24 tháng đầu 6.0%. Đang chờ khách chuẩn bị sổ đỏ đối ứng.','FOLLOW_UP','2026-09-10 01:54:14','2026-09-10 01:54:14'),(4,501,104,'Thẻ tín dụng Vietcombank CashBack Plus','Tư vấn mở thẻ tín dụng hạn mức 80 triệu, hoàn tiền 10% chi tiêu ẩm thực và siêu thị. Khách hàng đã nộp sao kê tài khoản ngân hàng.','COMPLETED','2026-09-10 01:54:14','2026-09-10 01:54:14'),(5,501,104,'Dịch vụ Tiền gửi Doanh nghiệp lãi suất thỏa thuận','Tư vấn doanh nghiệp mở tài khoản thanh toán và gửi tiền gửi có kỳ hạn 3 tháng với số dư 10 tỷ đồng.','CONSULTED','2026-09-10 01:54:14','2026-09-10 01:54:14'),(6,501,104,'Gói vay mua nhà an cư 15 năm','Khách hàng có thu nhập ổn định 35 triệu/tháng, đã giải thích biểu phí và lãi suất cố định 24 tháng đầu 6.0%. Đang chờ khách chuẩn bị sổ đỏ đối ứng.','FOLLOW_UP','2026-09-10 01:54:28','2026-09-10 01:54:28'),(7,501,104,'Thẻ tín dụng Vietcombank CashBack Plus','Tư vấn mở thẻ tín dụng hạn mức 80 triệu, hoàn tiền 10% chi tiêu ẩm thực và siêu thị. Khách hàng đã nộp sao kê tài khoản ngân hàng.','COMPLETED','2026-09-10 01:54:28','2026-09-10 01:54:28'),(8,501,104,'Dịch vụ Tiền gửi Doanh nghiệp lãi suất thỏa thuận','Tư vấn doanh nghiệp mở tài khoản thanh toán và gửi tiền gửi có kỳ hạn 3 tháng với số dư 10 tỷ đồng.','CONSULTED','2026-09-10 01:54:28','2026-09-10 01:54:28'),(9,601,104,'Vay mua nhà','Khách hàng có nhu cầu vay','FOLLOW_UP','2026-09-13 08:37:53','2026-09-13 08:37:53'),(10,601,104,'Vay mua nhà ở dự án','Khách hàng có nhu cầu vay mua căn hộ Vinhomes Smart City 1.2 tỷ','FOLLOW_UP','2026-09-13 08:40:11','2026-09-13 08:40:11'),(11,601,104,'Vay mua nhà ở dự án','Khách hàng có nhu cầu vay mua căn hộ Vinhomes Smart City 1.2 tỷ','FOLLOW_UP','2026-09-13 08:41:06','2026-09-13 08:41:06'),(12,601,104,'Vay mua xe ô tô điện VinFast VF8','Khách hàng có nhu cầu vay 750 triệu trong 5 năm, hưởng ưu đãi miễn phí trạm sạc 2 năm và lãi suất 6.5%.','FOLLOW_UP','2026-09-13 21:23:45','2026-09-13 21:23:45'),(13,601,104,'Thẻ tín dụng Vietcombank Visa Signature','Tư vấn mở thẻ đen đặc quyền phòng chờ sân bay và bảo hiểm du lịch 10.5 tỷ VND. Khách hàng quan tâm và đã nộp hồ sơ.','COMPLETED','2026-09-13 21:23:46','2026-09-13 21:23:46'),(14,601,104,'Tiết kiệm bậc thang phát lộc','Khách hàng có 500 triệu nhàn rỗi, tư vấn gửi kỳ hạn 12 tháng lãi suất 6.8% kèm quay số trúng thưởng sổ tiết kiệm.','FOLLOW_UP','2026-09-13 21:23:47','2026-09-13 21:23:47'),(15,601,104,'Bảo hiểm nhân thọ liên kết đầu tư FWD','Tư vấn giải pháp bảo vệ tài chính kết hợp gia tăng tài sản, mức phí bảo hiểm 30 triệu/năm.','CONSULTED','2026-09-13 21:23:48','2026-09-13 21:23:48'),(16,601,104,'Tài khoản số đẹp Như ý Phong thủy','Khách hàng đăng ký mở tài khoản đuôi lộc phát 686868 để phục vụ kinh doanh online.','COMPLETED','2026-09-13 21:23:49','2026-09-13 21:23:49'),(17,601,104,'Vay mua nhà ở dự án','Khách hàng có nhu cầu vay mua căn hộ Vinhomes Smart City 1.2 tỷ','FOLLOW_UP','2026-09-13 21:25:53','2026-09-13 21:25:53'),(18,601,104,'Vay mua nhà ở dự án','Khách hàng có nhu cầu vay mua căn hộ Vinhomes Smart City 1.2 tỷ','COMPLETED','2026-09-13 21:31:57','2026-09-17 19:43:46');
/*!40000 ALTER TABLE `customer_advisories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_savings`
--

DROP TABLE IF EXISTS `customer_savings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_savings` (
  `saving_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `saving_code` varchar(50) NOT NULL,
  `customer_id` bigint(20) NOT NULL,
  `product_code` varchar(50) NOT NULL,
  `deposit_amount` decimal(18,2) NOT NULL,
  `term_months` int(11) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `expected_interest` decimal(18,2) NOT NULL,
  `maturity_date` date NOT NULL,
  `status` enum('ACTIVE','SETTLED','CANCELLED') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`saving_id`),
  UNIQUE KEY `saving_code` (`saving_code`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `customer_savings_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_savings`
--

LOCK TABLES `customer_savings` WRITE;
/*!40000 ALTER TABLE `customer_savings` DISABLE KEYS */;
INSERT INTO `customer_savings` VALUES (1,'STK-ONLINE-001',501,'SAVING_ONLINE_12M',200000000.00,12,6.80,13600000.00,'2027-09-01','ACTIVE','2026-09-09 11:53:08'),(2,'STK-2026-436770',601,'SAVING_ONLINE_6M',50000000.00,6,5.50,1375000.00,'2027-03-13','ACTIVE','2026-09-13 08:40:10'),(3,'STK-2026-620989',601,'SAVING_ONLINE_6M',50000000.00,6,5.50,1375000.00,'2027-03-13','ACTIVE','2026-09-13 08:41:06'),(4,'STK-2026-692247',601,'TIET_KIEM_ONLINE_1M',20000000.00,1,5.20,86666.67,'2026-10-14','ACTIVE','2026-09-13 21:23:25'),(5,'STK-2026-324426',601,'TIET_KIEM_ONLINE_3M',50000000.00,3,4.50,562500.00,'2026-12-14','ACTIVE','2026-09-13 21:23:26'),(6,'STK-2026-471539',601,'TIET_KIEM_ONLINE_6M',120000000.00,6,5.50,3300000.00,'2027-03-14','ACTIVE','2026-09-13 21:23:27'),(7,'STK-2026-280941',601,'TIET_KIEM_ONLINE_12M',300000000.00,12,6.80,20400000.00,'2027-09-14','ACTIVE','2026-09-13 21:23:28'),(8,'STK-2026-301890',601,'TIET_KIEM_ONLINE_24M',500000000.00,24,6.80,68000000.00,'2028-09-14','ACTIVE','2026-09-13 21:23:28'),(9,'STK-2026-258386',601,'SAVING_ONLINE_6M',50000000.00,6,5.50,1375000.00,'2027-03-14','ACTIVE','2026-09-13 21:25:46'),(10,'STK-2026-135813',601,'SAVING_ONLINE_6M',50000000.00,6,5.50,1375000.00,'2027-03-14','ACTIVE','2026-09-13 21:31:50');
/*!40000 ALTER TABLE `customer_savings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `customer_type` enum('INDIVIDUAL','ENTERPRISE') DEFAULT 'INDIVIDUAL',
  `id_card_number` varchar(20) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `status` enum('ACTIVE','LOCKED','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `id_card_number` (`id_card_number`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (501,'Lê Hoàng Nam','kh_namle','$2a$10$7/Osl1W13n8O.lT2K9R39e/5N5kG7c.H76fHspbV7g/s5V9rY9j6G','INDIVIDUAL','001098001234','0988777666','nam.le@gmail.com','ACTIVE','2026-09-09 11:53:07'),(502,'Phạm Minh Anh','kh_minhanh','$2a$10$7/Osl1W13n8O.lT2K9R39e/5N5kG7c.H76fHspbV7g/s5V9rY9j6G','INDIVIDUAL','001099005678','0977111222','minhanh@gmail.com','ACTIVE','2026-09-09 11:53:07'),(601,'Trần Thị Thu Hà','kh_thuha','$2a$10$7/Osl1W13n8O.lT2K9R39e/5N5kG7c.H76fHspbV7g/s5V9rY9j6G','INDIVIDUAL','001198004567','0911222333','ha.tran@gmail.com','ACTIVE','2026-09-09 11:53:07'),(602,'Công ty TNHH Giải Pháp Công Nghệ ABC','dn_abctech','$2a$10$7/Osl1W13n8O.lT2K9R39e/5N5kG7c.H76fHspbV7g/s5V9rY9j6G','ENTERPRISE','0101234567','0243999888','contact@abc-tech.vn','ACTIVE','2026-09-09 11:53:07'),(603,'Đỗ Hoàng Minh','kh_tester02','$2a$10$5yBN6wj5DCr2Owt6xmEEl.8pS1WUawMqtVWxuOSVoxZes8Ucr3F3W','INDIVIDUAL','001099887766','0966554433','minh.do@vcbtest.vn','ACTIVE','2026-09-13 08:34:18'),(604,'Phạm Thanh Tùng',NULL,NULL,'INDIVIDUAL','024095009988','0912345678','tung.pham@gmail.com','ACTIVE','2026-09-13 08:34:24'),(605,'Đoàn Tiến Dũng',NULL,NULL,'INDIVIDUAL','001099112233','0987654321','tiendung@gmail.com','ACTIVE','2026-09-13 08:36:22');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dispute_requests`
--

DROP TABLE IF EXISTS `dispute_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispute_requests` (
  `dispute_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dispute_code` varchar(50) NOT NULL,
  `customer_id` bigint(20) NOT NULL,
  `transaction_code` varchar(100) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('PENDING','PROCESSING','APPROVED_REFUND','REJECTED','CLOSED') DEFAULT 'PENDING',
  `handler_staff_id` bigint(20) DEFAULT NULL,
  `resolution_note` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`dispute_id`),
  UNIQUE KEY `dispute_code` (`dispute_code`),
  KEY `customer_id` (`customer_id`),
  KEY `handler_staff_id` (`handler_staff_id`),
  CONSTRAINT `dispute_requests_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `dispute_requests_ibfk_2` FOREIGN KEY (`handler_staff_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispute_requests`
--

LOCK TABLES `dispute_requests` WRITE;
/*!40000 ALTER TABLE `dispute_requests` DISABLE KEYS */;
INSERT INTO `dispute_requests` VALUES (1,'DSP-2026-001',502,'TXN-99887766','Giao dịch rút tiền tại cây ATM Vietcombank Ba Đình bị trừ tiền nhưng máy không nhả tiền mặt do lỗi nhả thẻ.','APPROVED_REFUND',104,'Kiểm quỹ cây ATM khớp dư 2.000.000 VNĐ. Đã lập lệnh hoàn trả tiền vào tài khoản thanh toán của khách hàng.','2026-09-09 11:53:08','2026-09-13 08:34:23'),(2,'TS-2026-0891',501,'FT2609019988','Chuyển nhầm tiền sang số tài khoản ngân hàng khác do nhập sai 1 chữ số','PROCESSING',104,'Đã gửi công văn tra soát NAPAS sang ngân hàng thụ hưởng yêu cầu hỗ trợ phong tỏa số tiền chuyển nhầm.','2026-09-10 01:54:14','2026-09-10 01:54:14'),(3,'TS-2026-0892',501,'FT2609025544','Rút tiền ATM 2,000,000 VND tài khoản bị trừ tiền nhưng khay tiền không nhả tiền mặt','APPROVED_REFUND',104,'Kiểm toán quỹ ATM phát hiện thừa 2,000,000 VND. Đã thực hiện hoàn tiền vào tài khoản cho khách hàng thành công.','2026-09-10 01:54:14','2026-09-10 01:54:14'),(4,'TS-2026-0893',501,'POS2609031122','Thanh toán tại quầy siêu thị POS báo lỗi giao dịch nhưng ứng dụng ngân hàng vẫn trừ 850,000 VND','PENDING',104,NULL,'2026-09-10 01:54:14','2026-09-10 01:54:14'),(8,'TS-2026-6607',601,'TXN-2026-889901','Rút tiền tại cây ATM Vietcombank Ba Đình tài khoản bị trừ 3.000.000 VNĐ nhưng máy chỉ nhả 2.000.000 VNĐ.','PENDING',NULL,NULL,'2026-09-13 21:23:56','2026-09-13 21:23:56'),(9,'TS-2026-9339',601,'TXN-2026-889902','Quẹt thẻ Visa tại máy POS nhà hàng King BBQ báo lỗi giao dịch nhưng ứng dụng ngân hàng vẫn trừ 1.450.000 VNĐ.','PENDING',NULL,NULL,'2026-09-13 21:23:57','2026-09-13 21:23:57'),(10,'TS-2026-7540',601,'TXN-2026-889903','Chuyển tiền nhanh 24/7 sang Techcombank người nhận chưa nhận được tiền dù tài khoản Vietcombank đã bị trừ 25.000.000 VNĐ.','PENDING',NULL,NULL,'2026-09-13 21:23:58','2026-09-13 21:23:58'),(11,'TS-2026-8155',601,'TXN-2026-889904','Thanh toán đơn hàng Shopee qua cổng Napas bị trừ 2 lần cùng một mã giao dịch 890.000 VNĐ.','PENDING',NULL,NULL,'2026-09-13 21:23:59','2026-09-13 21:23:59'),(12,'TS-2026-8048',601,'TXN-2026-889905','Giao dịch lạ trừ tiền 45 USD từ trang thương mại điện tử quốc tế do nghi ngờ bị lộ thông tin thẻ.','PENDING',NULL,NULL,'2026-09-13 21:24:01','2026-09-13 21:24:01');
/*!40000 ALTER TABLE `dispute_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enterprise_customers`
--

DROP TABLE IF EXISTS `enterprise_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enterprise_customers` (
  `customer_id` bigint(20) NOT NULL,
  `tax_code` varchar(50) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `representative_name` varchar(100) NOT NULL,
  `business_license_number` varchar(100) DEFAULT NULL,
  `charter_capital` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `tax_code` (`tax_code`),
  CONSTRAINT `enterprise_customers_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enterprise_customers`
--

LOCK TABLES `enterprise_customers` WRITE;
/*!40000 ALTER TABLE `enterprise_customers` DISABLE KEYS */;
INSERT INTO `enterprise_customers` VALUES (602,'0101234567','Công ty TNHH Giải Pháp Công Nghệ ABC','Nguyễn Văn Doanh','GPKD-2020-888',5000000000.00);
/*!40000 ALTER TABLE `enterprise_customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exchange_rates`
--

DROP TABLE IF EXISTS `exchange_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exchange_rates` (
  `rate_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `currency_code` varchar(10) NOT NULL,
  `buy_rate` decimal(18,4) NOT NULL,
  `sell_rate` decimal(18,4) NOT NULL,
  `transfer_rate` decimal(18,4) NOT NULL,
  `effective_date` date NOT NULL,
  `created_by` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`rate_id`),
  UNIQUE KEY `uniq_currency_date` (`currency_code`,`effective_date`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `exchange_rates_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exchange_rates`
--

LOCK TABLES `exchange_rates` WRITE;
/*!40000 ALTER TABLE `exchange_rates` DISABLE KEYS */;
INSERT INTO `exchange_rates` VALUES (1,'USD',25400.0000,25800.0000,25430.0000,'2026-09-09',101,'2026-09-09 11:53:07'),(2,'EUR',27200.0000,27950.0000,27300.0000,'2026-09-09',101,'2026-09-09 11:53:07'),(3,'GBP',32100.0000,33400.0000,32300.0000,'2026-09-09',101,'2026-09-09 11:53:07'),(4,'JPY',162.5000,172.0000,164.2000,'2026-09-09',101,'2026-09-09 11:53:07'),(5,'SGD',18900.0000,19700.0000,19100.0000,'2026-09-09',101,'2026-09-09 11:53:07'),(6,'AUD',16500.0000,17250.0000,16700.0000,'2026-09-09',101,'2026-09-09 11:53:07'),(13,'USD',25380.0000,25770.0000,25410.0000,'2026-09-10',101,'2026-09-10 01:54:13'),(14,'EUR',27450.0000,28980.0000,27720.0000,'2026-09-10',101,'2026-09-10 01:54:13'),(15,'GBP',32560.0000,33950.0000,32890.0000,'2026-09-10',101,'2026-09-10 01:54:13'),(16,'JPY',168.5000,178.2000,170.2000,'2026-09-10',101,'2026-09-10 01:54:13'),(17,'AUD',16580.0000,17290.0000,16750.0000,'2026-09-10',101,'2026-09-10 01:54:13'),(18,'SGD',19120.0000,19940.0000,19310.0000,'2026-09-10',101,'2026-09-10 01:54:13'),(19,'CAD',18350.0000,19130.0000,18540.0000,'2026-09-10',101,'2026-09-10 01:54:13'),(20,'CHF',29100.0000,30340.0000,29390.0000,'2026-09-10',101,'2026-09-10 01:54:13'),(21,'CNY',3510.0000,3660.0000,3545.0000,'2026-09-10',101,'2026-09-10 01:54:13'),(22,'KRW',18.2000,20.1000,18.9000,'2026-09-10',101,'2026-09-10 01:54:13'),(39,'USD',25420.0000,25820.0000,25450.0000,'2026-09-13',101,'2026-09-13 08:34:25');
/*!40000 ALTER TABLE `exchange_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_templates`
--

DROP TABLE IF EXISTS `fee_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_templates` (
  `template_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_type` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_by` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`template_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `fee_templates_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_templates`
--

LOCK TABLES `fee_templates` WRITE;
/*!40000 ALTER TABLE `fee_templates` DISABLE KEYS */;
INSERT INTO `fee_templates` VALUES (1,'Bảng biểu phí dịch vụ thẻ & tài khoản 2026','/uploads/fees/bieu_phi_the_2026.xlsx','EXCEL',1,101,'2026-09-09 11:53:07'),(2,'Biểu phí dịch vụ Thẻ quốc tế Vietcombank Visa / MasterCard / JCB 2026','/uploads/fees/Bieu_phi_the_quoc_te_2026.pdf','PDF',1,101,'2026-09-10 01:54:13'),(3,'Biểu mẫu đề nghị vay vốn & phương án trả nợ kiêm cam kết tài sản','/uploads/forms/Don_de_nghi_vay_von_VCB.docx','WORD',1,101,'2026-09-10 01:54:13'),(4,'Bảng tổng hợp phí chuyển tiền quốc tế qua hệ thống SWIFT & Western Union','/uploads/fees/Phi_chuyen_tien_quoc_te_SWIFT.xlsx','EXCEL',1,101,'2026-09-10 01:54:13'),(5,'Biểu phí dịch vụ Thẻ quốc tế Vietcombank Visa / MasterCard / JCB 2026','/uploads/fees/Bieu_phi_the_quoc_te_2026.pdf','PDF',1,101,'2026-09-10 01:54:27'),(6,'Biểu mẫu đề nghị vay vốn & phương án trả nợ kiêm cam kết tài sản','/uploads/forms/Don_de_nghi_vay_von_VCB.docx','WORD',1,101,'2026-09-10 01:54:27'),(7,'Bảng tổng hợp phí chuyển tiền quốc tế qua hệ thống SWIFT & Western Union','/uploads/fees/Phi_chuyen_tien_quoc_te_SWIFT.xlsx','EXCEL',1,101,'2026-09-10 01:54:27');
/*!40000 ALTER TABLE `fee_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financial_transactions`
--

DROP TABLE IF EXISTS `financial_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financial_transactions` (
  `transaction_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `transaction_code` varchar(50) NOT NULL,
  `sender_customer_id` bigint(20) DEFAULT NULL,
  `receiver_account_number` varchar(50) NOT NULL,
  `receiver_name` varchar(100) NOT NULL,
  `bank_name` varchar(100) DEFAULT 'INTERNAL',
  `amount` decimal(18,2) NOT NULL,
  `fee` decimal(18,2) DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `processed_by_staff_id` bigint(20) NOT NULL,
  `status` enum('SUCCESS','FAILED','PENDING_APPROVAL') DEFAULT 'SUCCESS',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`transaction_id`),
  UNIQUE KEY `transaction_code` (`transaction_code`),
  KEY `sender_customer_id` (`sender_customer_id`),
  KEY `processed_by_staff_id` (`processed_by_staff_id`),
  CONSTRAINT `financial_transactions_ibfk_1` FOREIGN KEY (`sender_customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `financial_transactions_ibfk_2` FOREIGN KEY (`processed_by_staff_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financial_transactions`
--

LOCK TABLES `financial_transactions` WRITE;
/*!40000 ALTER TABLE `financial_transactions` DISABLE KEYS */;
INSERT INTO `financial_transactions` VALUES (1,'FTX-2026-001',501,'0011004567890','Nguyễn Hoàng Long','INTERNAL',25000000.00,0.00,'Thanh toán tiền đặt cọc thuê văn phòng tháng 9',104,'SUCCESS','2026-09-09 11:53:08'),(2,'FTX-2026-002',602,'0071009876543','Công ty CP Đầu Tư Xây Dựng Nam Á','INTERNAL',120000000.00,11000.00,'Thanh toán đợt 2 theo hợp đồng thi công số 12/HĐ-NA',104,'SUCCESS','2026-09-09 11:53:08'),(3,'FT2609010001',501,'0071001234567','Nguyễn Thị Thu Trang','Vietcombank',35000000.00,0.00,'Nạp tiền vào tài khoản tiết kiệm online',104,'SUCCESS','2026-09-10 01:54:13'),(4,'FT2609020002',501,'1903555888999','Công ty Cổ phần Xây dựng Hà Đô','Techcombank',120000000.00,11000.00,'Chuyển tiền thanh toán đợt 2 gói thầu vật liệu',104,'SUCCESS','2026-09-10 01:54:13'),(5,'FT2609030003',501,'0451000999888','Lê Tuấn Khang','Vietcombank',5000000.00,0.00,'Rút tiền mặt tại quầy giao dịch',104,'SUCCESS','2026-09-10 01:54:13'),(6,'FT2609040004',501,'1012888999','Trần Đình Trọng','BIDV',450000000.00,22000.00,'Chuyển tiền mua xe ô tô cá nhân',104,'PENDING_APPROVAL','2026-09-10 01:54:14'),(7,'FT2609050005',501,'999988887777','Vũ Hải Đăng','MBBank',8500000.00,0.00,'Chuyển tiền sinh hoạt phí gia đình',104,'SUCCESS','2026-09-10 01:54:14'),(14,'TXN-2026-789179',NULL,'0011009988776','NGUYEN VAN HUONG','VIETCOMBANK',25000000.00,0.00,'Nop tien mat thanh toan tai quay VCB',104,'SUCCESS','2026-09-13 08:34:23'),(15,'TXN-2026-156129',NULL,'0011001234567','LE HOANG PHUC','VIETCOMBANK',15000000.00,0.00,'Nop tien tai quay chi nhanh Ba Dinh',104,'SUCCESS','2026-09-13 08:36:22'),(16,'TXN-2026-624654',601,'0011001234567','LE HOANG PHUC','VIETCOMBANK',15000000.00,0.00,'Nop tien tai quay chi nhanh Ba Dinh',104,'SUCCESS','2026-09-13 08:40:11'),(17,'TXN-2026-385765',601,'0011001234567','LE HOANG PHUC','VIETCOMBANK',15000000.00,0.00,'Nop tien tai quay chi nhanh Ba Dinh',104,'SUCCESS','2026-09-13 08:41:07'),(18,'TXN-2026-680160',601,'0071009988112','NGUYEN THI KIM NGAN','VIETCOMBANK',35000000.00,0.00,'Nop tien mat tai quay thanh toan tien hang',104,'SUCCESS','2026-09-13 21:23:40'),(19,'TXN-2026-885831',601,'1903666888999','CONG TY CP DIEN MAY XANH','Techcombank',18500000.00,11000.00,'Thanh toan tien mua may giat va tu lanh',104,'SUCCESS','2026-09-13 21:23:41'),(20,'TXN-2026-448041',601,'0911222333','TRAN THI THU HA','VIETCOMBANK',50000000.00,0.00,'Nop tien vao tai khoan thanh toan dinh ky',104,'SUCCESS','2026-09-13 21:23:42'),(21,'TXN-2026-433024',601,'1028777999','LE HOANG ANH','VietinBank',12000000.00,9900.00,'Chuyen tien thanh toan tien thue nha thang 9',104,'SUCCESS','2026-09-13 21:23:43'),(22,'TXN-2026-902396',601,'0011005544332','VIETCOMBANK LOAN RECOVERY','VIETCOMBANK',6850000.00,0.00,'Trich nop tien lai va goc vay tieu dung dinh ky',104,'SUCCESS','2026-09-13 21:23:44'),(23,'TXN-2026-961391',601,'0011001234567','LE HOANG PHUC','VIETCOMBANK',15000000.00,0.00,'Nop tien tai quay chi nhanh Ba Dinh',104,'SUCCESS','2026-09-13 21:25:55'),(24,'TXN-DN-2026-001',NULL,'0243999888','CÔNG TY TNHH GIẢI PHÁP CÔNG NGHỆ ABC','Vietcombank',350000000.00,0.00,'Khach hang Vingroup thanh toan hop dong phan mem ERP dot 1',104,'SUCCESS','2026-09-14 04:30:58'),(25,'TXN-DN-2026-002',NULL,'0243999888','CÔNG TY TNHH GIẢI PHÁP CÔNG NGHỆ ABC','Vietcombank',480000000.00,0.00,'Thanh toan hop dong gia cong xuat khau phan mem Tokyo IT',104,'SUCCESS','2026-09-14 04:30:58'),(26,'TXN-DN-2026-003',602,'0071009988776','TONG CONG TY TRA LUONG NHAN VIEN ABC','Vietcombank',185000000.00,0.00,'Chi tra luong va phu cap ky 1 thang 09/2026 cho 45 nhan vien',104,'SUCCESS','2026-09-14 04:30:58'),(27,'TXN-DN-2026-004',602,'1903888222111','CONG TY CP DAU TU TOA NHA KEANGNAM','Techcombank',65000000.00,11000.00,'Thanh toan tien thue van phong tang 18 Keangnam thang 9',104,'SUCCESS','2026-09-14 04:30:58'),(28,'TXN-DN-2026-005',602,'0451000888999','AMAZON WEB SERVICES VIETNAM','Vietcombank',42500000.00,0.00,'Thanh toan phi dich vu Cloud ha tang thang 8/2026',104,'SUCCESS','2026-09-14 04:30:58'),(29,'TXN-2026-326188',601,'0011001234567','LE HOANG PHUC','VIETCOMBANK',15000000.00,0.00,'Nop tien tai quay chi nhanh Ba Dinh',104,'SUCCESS','2026-09-13 21:32:00');
/*!40000 ALTER TABLE `financial_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gold_rates`
--

DROP TABLE IF EXISTS `gold_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gold_rates` (
  `gold_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `gold_type` varchar(50) NOT NULL,
  `buy_price` decimal(18,2) NOT NULL,
  `sell_price` decimal(18,2) NOT NULL,
  `effective_date` date NOT NULL,
  `created_by` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`gold_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `gold_rates_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gold_rates`
--

LOCK TABLES `gold_rates` WRITE;
/*!40000 ALTER TABLE `gold_rates` DISABLE KEYS */;
INSERT INTO `gold_rates` VALUES (1,'Vàng miếng SJC 999.9',84000000.00,86000000.00,'2026-09-09',101,'2026-09-09 11:53:07'),(2,'Vàng nhẫn trơn 24K',77000000.00,78500000.00,'2026-09-09',101,'2026-09-09 11:53:07'),(3,'Vàng miếng SJC 1L - 10L',84500000.00,86500000.00,'2026-09-10',101,'2026-09-10 01:54:13'),(4,'Vàng nữ trang 24K',76500000.00,78000000.00,'2026-09-10',101,'2026-09-10 01:54:13'),(5,'Vàng nữ trang 18K (75%)',56800000.00,59200000.00,'2026-09-10',101,'2026-09-10 01:54:13'),(6,'Vàng miếng SJC',84500000.00,86500000.00,'2026-09-10',101,'2026-09-10 01:54:27'),(7,'Nhẫn trơn VCB 99.99%',77800000.00,79100000.00,'2026-09-10',101,'2026-09-10 01:54:27'),(8,'Vàng nữ trang 24K',76500000.00,78000000.00,'2026-09-10',101,'2026-09-10 01:54:27'),(9,'Vàng nữ trang 18K (75%)',56800000.00,59200000.00,'2026-09-10',101,'2026-09-10 01:54:27'),(10,'Vàng miếng SJC',84500000.00,86500000.00,'2026-09-10',101,'2026-09-10 01:55:35'),(11,'Nhẫn trơn VCB 99.99%',77800000.00,79100000.00,'2026-09-10',101,'2026-09-10 01:55:35'),(12,'Vàng nữ trang 24K',76500000.00,78000000.00,'2026-09-10',101,'2026-09-10 01:55:35'),(13,'Vàng nữ trang 18K (75%)',56800000.00,59200000.00,'2026-09-10',101,'2026-09-10 01:55:35');
/*!40000 ALTER TABLE `gold_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `individual_customers`
--

DROP TABLE IF EXISTS `individual_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `individual_customers` (
  `customer_id` bigint(20) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `monthly_income` decimal(18,2) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  CONSTRAINT `individual_customers_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `individual_customers`
--

LOCK TABLES `individual_customers` WRITE;
/*!40000 ALTER TABLE `individual_customers` DISABLE KEYS */;
INSERT INTO `individual_customers` VALUES (501,'1995-03-20','MALE',35000000.00,'Tập đoàn Viettel','Trưởng nhóm kỹ thuật'),(502,'1996-08-12','FEMALE',22000000.00,'Ngân hàng VPBank','Chuyên viên QHKH'),(601,'1998-05-15','FEMALE',25000000.00,'Công ty FPT Software','Kỹ sư phần mềm'),(603,'1997-06-18','MALE',28000000.00,'Công ty Cổ phần VinaTech','Kỹ sư phần mềm');
/*!40000 ALTER TABLE `individual_customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interest_rates`
--

DROP TABLE IF EXISTS `interest_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interest_rates` (
  `rate_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_code` varchar(50) NOT NULL,
  `term_months` int(11) NOT NULL,
  `rate_percentage` decimal(5,2) NOT NULL,
  `effective_date` date NOT NULL,
  `created_by` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`rate_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `interest_rates_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interest_rates`
--

LOCK TABLES `interest_rates` WRITE;
/*!40000 ALTER TABLE `interest_rates` DISABLE KEYS */;
INSERT INTO `interest_rates` VALUES (1,'SAVING_ONLINE',1,3.20,'2026-09-01',101,'2026-09-09 11:53:07'),(2,'SAVING_ONLINE',3,3.80,'2026-09-01',101,'2026-09-09 11:53:07'),(3,'SAVING_ONLINE',6,5.20,'2026-09-01',101,'2026-09-09 11:53:07'),(4,'SAVING_ONLINE',12,6.80,'2026-09-01',101,'2026-09-09 11:53:07'),(5,'SAVING_ONLINE',24,7.00,'2026-09-01',101,'2026-09-09 11:53:07'),(6,'LOAN_CONSUMER',12,6.50,'2026-09-01',101,'2026-09-09 11:53:07'),(7,'LOAN_AUTO',36,6.00,'2026-09-01',101,'2026-09-09 11:53:07'),(8,'LOAN_MORTGAGE',120,8.50,'2026-09-01',101,'2026-09-09 11:53:07'),(9,'SAVING_ONLINE',1,3.20,'2026-09-01',101,'2026-09-09 14:20:43'),(10,'SAVING_ONLINE',3,3.80,'2026-09-01',101,'2026-09-09 14:20:43'),(11,'SAVING_ONLINE',6,5.20,'2026-09-01',101,'2026-09-09 14:20:43'),(12,'SAVING_ONLINE',12,6.80,'2026-09-01',101,'2026-09-09 14:20:43'),(13,'SAVING_ONLINE',24,7.00,'2026-09-01',101,'2026-09-09 14:20:43'),(14,'LOAN_CONSUMER',12,6.50,'2026-09-01',101,'2026-09-09 14:20:43'),(15,'LOAN_AUTO',36,6.00,'2026-09-01',101,'2026-09-09 14:20:43'),(16,'LOAN_MORTGAGE',120,8.50,'2026-09-01',101,'2026-09-09 14:20:43'),(17,'TIET_KIEM_ONLINE_1M',1,3.10,'2026-09-10',101,'2026-09-10 01:54:13'),(18,'TIET_KIEM_ONLINE_3M',3,3.60,'2026-09-10',101,'2026-09-10 01:54:13'),(19,'TIET_KIEM_ONLINE_6M',6,4.90,'2026-09-10',101,'2026-09-10 01:54:13'),(20,'TIET_KIEM_ONLINE_9M',9,5.10,'2026-09-10',101,'2026-09-10 01:54:13'),(21,'TIET_KIEM_ONLINE_12M',12,6.20,'2026-09-10',101,'2026-09-10 01:54:13'),(22,'TIET_KIEM_ONLINE_24M',24,6.50,'2026-09-10',101,'2026-09-10 01:54:13'),(23,'VAY_MUA_NHA_UU_DAI',12,5.90,'2026-09-10',101,'2026-09-10 01:54:13'),(24,'VAY_MUA_XE_TRA_GOP',12,6.80,'2026-09-10',101,'2026-09-10 01:54:13'),(25,'VAY_SAN_XUAT_KINH_DOANH',12,7.20,'2026-09-10',101,'2026-09-10 01:54:13'),(26,'TIET_KIEM_ONLINE_1M',1,3.10,'2026-09-10',101,'2026-09-10 01:54:27'),(27,'TIET_KIEM_ONLINE_3M',3,3.60,'2026-09-10',101,'2026-09-10 01:54:27'),(28,'TIET_KIEM_ONLINE_6M',6,4.90,'2026-09-10',101,'2026-09-10 01:54:27'),(29,'TIET_KIEM_ONLINE_9M',9,5.10,'2026-09-10',101,'2026-09-10 01:54:27'),(30,'TIET_KIEM_ONLINE_12M',12,6.20,'2026-09-10',101,'2026-09-10 01:54:27'),(31,'TIET_KIEM_ONLINE_24M',24,6.50,'2026-09-10',101,'2026-09-10 01:54:27'),(32,'VAY_MUA_NHA_UU_DAI',12,5.90,'2026-09-10',101,'2026-09-10 01:54:27'),(33,'VAY_MUA_XE_TRA_GOP',12,6.80,'2026-09-10',101,'2026-09-10 01:54:27'),(34,'VAY_SAN_XUAT_KINH_DOANH',12,7.20,'2026-09-10',101,'2026-09-10 01:54:27'),(35,'TIET_KIEM_ONLINE_1M',1,3.10,'2026-09-10',101,'2026-09-10 01:55:35'),(36,'TIET_KIEM_ONLINE_3M',3,3.60,'2026-09-10',101,'2026-09-10 01:55:35'),(37,'TIET_KIEM_ONLINE_6M',6,4.90,'2026-09-10',101,'2026-09-10 01:55:35'),(38,'TIET_KIEM_ONLINE_12M',12,6.20,'2026-09-10',101,'2026-09-10 01:55:35'),(39,'VAY_MUA_NHA_UU_DAI',12,5.90,'2026-09-10',101,'2026-09-10 01:55:35'),(40,'VAY_MUA_XE_TRA_GOP',12,6.80,'2026-09-10',101,'2026-09-10 01:55:35');
/*!40000 ALTER TABLE `interest_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_applications`
--

DROP TABLE IF EXISTS `loan_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_applications` (
  `loan_app_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) NOT NULL,
  `loan_purpose` enum('CONSUMER','AUTO','BUSINESS') NOT NULL,
  `loan_amount` decimal(18,2) NOT NULL,
  `loan_term_months` int(11) NOT NULL,
  `interest_rate_percentage` decimal(5,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`loan_app_id`),
  UNIQUE KEY `application_id` (`application_id`),
  CONSTRAINT `loan_applications_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `applications` (`application_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_applications`
--

LOCK TABLES `loan_applications` WRITE;
/*!40000 ALTER TABLE `loan_applications` DISABLE KEYS */;
INSERT INTO `loan_applications` VALUES (1,1001,'CONSUMER',500000000.00,60,6.50,'2026-09-09 11:53:08'),(2,1003,'AUTO',800000000.00,84,6.00,'2026-09-09 11:53:08'),(3,1004,'CONSUMER',800000000.00,60,7.50,'2026-09-10 01:54:14'),(5,1014,'AUTO',650000000.00,60,8.50,'2026-09-13 08:41:05'),(6,1015,'CONSUMER',80000000.00,24,9.50,'2026-09-13 08:41:05'),(7,1018,'AUTO',750000000.00,60,8.50,'2026-09-13 21:23:30'),(8,1019,'AUTO',900000000.00,72,8.50,'2026-09-13 21:23:31'),(9,1020,'CONSUMER',180000000.00,36,9.50,'2026-09-13 21:23:32'),(10,1023,'AUTO',650000000.00,60,8.50,'2026-09-13 21:25:43'),(11,1024,'CONSUMER',80000000.00,24,9.50,'2026-09-13 21:25:44'),(12,1027,'AUTO',650000000.00,60,8.50,'2026-09-13 21:31:47'),(13,1028,'CONSUMER',80000000.00,24,9.50,'2026-09-13 21:31:48'),(14,1031,'BUSINESS',2000000000.00,36,7.80,'2026-09-17 18:11:19'),(15,1032,'BUSINESS',2000000000.00,36,7.80,'2026-09-17 19:41:20'),(16,1033,'BUSINESS',100000000.00,36,7.80,'2026-09-17 19:41:38'),(17,1034,'AUTO',600000000.00,60,8.50,'2026-09-17 19:44:59'),(18,1035,'AUTO',600000000.00,60,8.50,'2026-09-17 19:45:35');
/*!40000 ALTER TABLE `loan_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_collaterals`
--

DROP TABLE IF EXISTS `loan_collaterals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_collaterals` (
  `collateral_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_app_id` bigint(20) NOT NULL,
  `collateral_type` enum('CAR','REAL_ESTATE','SAVING_BOOK','OTHER') NOT NULL,
  `collateral_name` varchar(255) NOT NULL,
  `estimated_value` decimal(18,2) NOT NULL,
  `document_proof_url` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`collateral_id`),
  KEY `loan_app_id` (`loan_app_id`),
  CONSTRAINT `loan_collaterals_ibfk_1` FOREIGN KEY (`loan_app_id`) REFERENCES `loan_applications` (`loan_app_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_collaterals`
--

LOCK TABLES `loan_collaterals` WRITE;
/*!40000 ALTER TABLE `loan_collaterals` DISABLE KEYS */;
INSERT INTO `loan_collaterals` VALUES (1,2,'CAR','Xe ô tô Toyota Camry 2.5Q 2026 biển số Hà Nội',1450000000.00,'/uploads/collateral/dang_ky_xe_camry.pdf'),(2,5,'CAR','Xe ô tô Hyundai Tucson 2.0 Turbo 2026 2026',1050000000.00,NULL),(3,7,'CAR','Xe ô tô VinFast VF8 Plus Dual Motor 2026 2026',1270000000.00,NULL),(4,8,'CAR','Xe ô tô Mercedes-Benz C300 AMG 2026 2026',2099000000.00,NULL),(5,10,'CAR','Xe ô tô Hyundai Tucson 2.0 Turbo 2026 2026',1050000000.00,NULL),(6,1,'REAL_ESTATE','Giấy chứng nhận QSD đất & Nhà ở 85m2 tại KĐT Gamuda Gardens, Q. Hoàng Mai, Hà Nội',5800000000.00,'/uploads/collaterals/so_do_gamuda.pdf'),(7,2,'SAVING_BOOK','Sổ tiết kiệm kỳ hạn 12 tháng tại Vietcombank Chi nhánh Hoàn Kiếm',800000000.00,'/uploads/collaterals/so_tiet_kiem_800tr.pdf'),(8,3,'REAL_ESTATE','Căn hộ chung cư Masteri Centre Point số A12-08, TP. Thủ Đức, TP.HCM',4200000000.00,'/uploads/collaterals/hop_dong_can_ho_masteri.pdf'),(9,5,'CAR','Xe ô tô VinFast VF8 Plus Dual Motor biển số 30K-888.99',1270000000.00,'/uploads/collaterals/dang_ky_xe_vf8.pdf'),(10,6,'CAR','Xe ô tô Mercedes-Benz C300 AMG model 2026',2099000000.00,'/uploads/collaterals/dang_ky_xe_mercedes.pdf'),(11,12,'CAR','Xe ô tô Hyundai Tucson 2.0 Turbo 2026 2026',1050000000.00,NULL),(12,17,'CAR','Xe ô tô Toyota Corolla Cross 1.8V 2026',800000000.00,'https://vcb-storage.vn/docs/car_contract_quote.pdf'),(13,18,'CAR','Xe ô tô Toyota Corolla Cross 1.8V 2026',800000000.00,'https://vcb-storage.vn/docs/car_contract_quote.pdf');
/*!40000 ALTER TABLE `loan_collaterals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_schedules`
--

DROP TABLE IF EXISTS `loan_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_schedules` (
  `schedule_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_app_id` bigint(20) NOT NULL,
  `period_number` int(11) NOT NULL,
  `due_date` date NOT NULL,
  `principal_amount` decimal(18,2) NOT NULL,
  `interest_amount` decimal(18,2) NOT NULL,
  `total_payment` decimal(18,2) NOT NULL,
  PRIMARY KEY (`schedule_id`),
  KEY `loan_app_id` (`loan_app_id`),
  CONSTRAINT `loan_schedules_ibfk_1` FOREIGN KEY (`loan_app_id`) REFERENCES `loan_applications` (`loan_app_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_schedules`
--

LOCK TABLES `loan_schedules` WRITE;
/*!40000 ALTER TABLE `loan_schedules` DISABLE KEYS */;
INSERT INTO `loan_schedules` VALUES (1,1,1,'2026-10-01',8333333.33,2708333.33,11041666.66),(2,1,2,'2026-11-01',8333333.33,2663194.44,10996527.77),(3,1,1,'2026-10-14',10000000.00,4250000.00,14250000.00),(4,1,2,'2026-11-14',10000000.00,4180000.00,14180000.00),(5,1,3,'2026-12-14',10000000.00,4110000.00,14110000.00),(6,1,4,'2027-01-14',10000000.00,4040000.00,14040000.00),(7,1,5,'2027-02-14',10000000.00,3970000.00,13970000.00);
/*!40000 ALTER TABLE `loan_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `permission_id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_code` varchar(100) NOT NULL,
  `permission_name` varchar(150) NOT NULL,
  `module_name` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `permission_code` (`permission_code`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'SYS_MANAGE_USERS','Tạo và phân quyền tài khoản','System','2026-09-09 11:53:06'),(2,'DATA_UPDATE_RATES','Cập nhật tỷ giá & lãi suất','FluctuatingData','2026-09-09 11:53:06'),(3,'APPROVE_LOAN','Phê duyệt hồ sơ vay & mở thẻ','Approval','2026-09-09 11:53:06'),(4,'REPORT_EXPORT','Xem và xuất file báo cáo','Report','2026-09-09 11:53:06'),(5,'CMS_MANAGE_POST','Thêm mới và sửa bài viết','CMS','2026-09-09 11:53:06'),(6,'STAFF_CUSTOMER_ADVISORY','Tư vấn và quản lý khách hàng','StaffModule','2026-09-09 11:53:06'),(7,'STAFF_SUPPORT_TICKET','Tiếp nhận và hỗ trợ CSKH','StaffModule','2026-09-09 11:53:06'),(8,'STAFF_DISPUTE_HANDLE','Xử lý yêu cầu tra soát','StaffModule','2026-09-09 11:53:06'),(9,'STAFF_FINANCIAL_TX','Thực hiện và phê duyệt giao dịch tài chính','StaffModule','2026-09-09 11:53:06');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portal_banners`
--

DROP TABLE IF EXISTS `portal_banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portal_banners` (
  `banner_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `image_url` varchar(500) NOT NULL,
  `target_url` varchar(500) DEFAULT NULL,
  `display_order` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`banner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portal_banners`
--

LOCK TABLES `portal_banners` WRITE;
/*!40000 ALTER TABLE `portal_banners` DISABLE KEYS */;
INSERT INTO `portal_banners` VALUES (1,'Chuyển đổi số cùng Vietcombank','Trải nghiệm hệ sinh thái Ngân hàng số bảo mật vượt trội','https://images.unsplash.com/photo-1563986768609-322da13575f3?w=1200','#/portal',1,1,'2026-09-09 11:53:09'),(2,'Gói vay mua nhà an cư lãi suất 6.0%','Hạn mức vay lên tới 85% giá trị bất động sản, thời hạn 35 năm','https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=1200','#/portal',2,1,'2026-09-09 11:53:09'),(3,'Thẻ tín dụng Vietcombank Cashback','Hoàn tiền chi tiêu không giới hạn cho mọi giao dịch thanh toán','https://images.unsplash.com/photo-1556742049-0a67c5574f73?w=1200','#/portal',3,1,'2026-09-09 11:53:09'),(4,'VCB Digibank thế hệ mới 2026','Tận hưởng tiện ích ngân hàng số vượt trội với trợ lý ảo AI thông minh','https://images.unsplash.com/photo-1563986768609-322da13575f3?w=1200','/#/customer/dashboard',1,1,'2026-09-14 04:30:45'),(5,'Gói vay mua ô tô điện Xanh','Lãi suất cố định 5.8%/năm cùng giải ngân siêu tốc trong 4 giờ','https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=1200','/#/customer/loans/auto',2,1,'2026-09-14 04:30:45'),(6,'Thẻ Vietcombank Visa Signature','Đặc quyền phòng chờ thương gia quốc tế và hoàn tiền 15% ẩm thực','https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200','/#/customer/cards',3,1,'2026-09-14 04:30:45'),(7,'Tiết kiệm tích lũy số linh hoạt','Sinh lời tối ưu theo ngày với lãi suất hấp dẫn lên tới 7.2%/năm','https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=1200','/#/customer/savings',4,1,'2026-09-14 04:30:45'),(8,'Nền tảng Tài trợ thương mại số','Phát hành L/C online và cấp bảo lãnh thầu điện tử tức thì cho DN','https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200','/#/customer/trade-finance',5,1,'2026-09-14 04:30:45'),(9,'VCB Digibank thế hệ mới 2026','Tận hưởng tiện ích ngân hàng số vượt trội với trợ lý ảo AI thông minh','https://images.unsplash.com/photo-1563986768609-322da13575f3?w=1200','/#/customer/dashboard',1,1,'2026-09-14 04:30:57'),(10,'Gói vay mua ô tô điện Xanh','Lãi suất cố định 5.8%/năm cùng giải ngân siêu tốc trong 4 giờ','https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=1200','/#/customer/loans/auto',2,1,'2026-09-14 04:30:57'),(11,'Thẻ Vietcombank Visa Signature','Đặc quyền phòng chờ thương gia quốc tế và hoàn tiền 15% ẩm thực','https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200','/#/customer/cards',3,1,'2026-09-14 04:30:57'),(12,'Tiết kiệm tích lũy số linh hoạt','Sinh lời tối ưu theo ngày với lãi suất hấp dẫn lên tới 7.2%/năm','https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=1200','/#/customer/savings',4,1,'2026-09-14 04:30:57'),(13,'Nền tảng Tài trợ thương mại số','Phát hành L/C online và cấp bảo lãnh thầu điện tử tức thì cho DN','https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200','/#/customer/trade-finance',5,1,'2026-09-14 04:30:57');
/*!40000 ALTER TABLE `portal_banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_attachments`
--

DROP TABLE IF EXISTS `post_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_attachments` (
  `attachment_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_url` varchar(500) NOT NULL,
  `file_type` varchar(50) DEFAULT 'IMAGE',
  `file_size` bigint(20) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`attachment_id`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `post_attachments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_attachments`
--

LOCK TABLES `post_attachments` WRITE;
/*!40000 ALTER TABLE `post_attachments` DISABLE KEYS */;
INSERT INTO `post_attachments` VALUES (1,1,'Bieu_mau_vay_von_2026.pdf','/uploads/posts/docs/bieu_mau_vay_2026.pdf','PDF',0,'2026-09-09 11:53:09'),(2,1,'Banner_chuong_trinh_tin_dung.jpg','https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=800','IMAGE',0,'2026-09-09 11:53:09'),(3,2,'Giao_dien_VCB_Digibank_AI.png','https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800','IMAGE',0,'2026-09-09 11:53:09'),(9,1,'Dieu_khoan_goi_tin_dung_uu_dai_100k_ty.pdf','/uploads/attachments/Dieu_khoan_tin_dung_100k_ty.pdf','PDF',1048576,'2026-09-14 04:30:57'),(10,2,'Huong_dan_kich_hoat_sinh_trac_hoc_VCB_Digibank.pdf','/uploads/attachments/HD_Sinh_trac_hoc_2345.pdf','PDF',2097152,'2026-09-14 04:30:57'),(11,3,'Bieu_lai_suat_tiet_kiem_chuan_thang_09_2026.xlsx','/uploads/attachments/Lai_suat_VCB_09_2026.xlsx','EXCEL',524288,'2026-09-14 04:30:57'),(12,4,'The_le_chuong_trinh_hoan_tien_Visa_Signature.pdf','/uploads/attachments/The_le_hoan_tien_Visa_Signature.pdf','PDF',840000,'2026-09-14 04:30:57'),(13,5,'Chinh_sach_Zero_Fee_mien_phi_chuyen_tien_2026.pdf','/uploads/attachments/Chinh_sach_Zero_Fee_2026.pdf','PDF',612000,'2026-09-14 04:30:57');
/*!40000 ALTER TABLE `post_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `summary` text DEFAULT NULL,
  `content` longtext NOT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `author_id` bigint(20) NOT NULL,
  `status` enum('DRAFT','PUBLISHED','ARCHIVED') DEFAULT 'DRAFT',
  `published_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`post_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `category_id` (`category_id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL,
  CONSTRAINT `posts_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (1,'Vietcombank triển khai gói tín dụng ưu đãi 100.000 tỷ đồng với lãi suất từ 6.0%/năm','goi-tin-dung-uu-dai-100k-ty','Gói vay quy mô lớn hỗ trợ khách hàng cá nhân và doanh nghiệp tiếp cận nguồn vốn ưu đãi phục hồi sản xuất, kinh doanh và mua nhà an cư.','<p>Vietcombank chính thức tung ra chương trình tín dụng quy mô 100.000 tỷ đồng với lãi suất cho vay cố định chỉ từ 6.0%/năm trong 12 tháng đầu hoặc 7.5%/năm trong 24 tháng đầu...</p>','https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=600&auto=format&fit=crop&q=80',3,101,'PUBLISHED','2026-09-08 01:30:00','2026-09-09 11:53:09','2026-09-09 11:53:09'),(2,'VCB Digibank thế hệ mới: Nâng tầm trải nghiệm với Trợ lý AI và Sinh trắc học','vcb-digibank-the-he-moi-ai-sinh-trac-hoc','Vietcombank chính thức cập nhật phiên bản VCB Digibank mới tích hợp bảo mật sinh trắc học khuôn mặt chuẩn Quyết định 2345/QĐ-NHNN.','<p>Hệ thống ngân hàng số VCB Digibank bổ sung tính năng trợ lý ảo tài chính tự động phân loại chi tiêu và xác thực giao dịch giá trị cao qua nhận diện khuôn mặt bảo mật tuyệt đối...</p>','https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&auto=format&fit=crop&q=80',4,101,'PUBLISHED','2026-09-05 02:00:00','2026-09-09 11:53:09','2026-09-09 11:53:09'),(3,'Biểu lãi suất tiền gửi tiết kiệm Vietcombank mới nhất tháng 09/2026','bieu-lai-suat-tiet-kiem-thang-09-2026','Cập nhật bảng lãi suất huy động vốn tiền gửi VND và ngoại tệ tại quầy và trực tuyến trên ứng dụng VCB Digibank kỳ hạn từ 1 đến 60 tháng.','<p>Lãi suất tiền gửi tiết kiệm online tại Vietcombank kỳ hạn 12 đến 24 tháng đạt mức hấp dẫn 6.8%/năm, cộng thêm 0.2%/năm đối với khách hàng gửi trên ứng dụng di động...</p>','https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=600&auto=format&fit=crop&q=80',3,101,'PUBLISHED','2026-09-01 03:15:00','2026-09-09 11:53:09','2026-09-09 11:53:09'),(4,'Chương trình thẻ Vietcombank Visa Signature: Hoàn tiền 15% ẩm thực và du lịch toàn cầu','vcb-visa-signature-hoan-tien-15-phan-tram','Đặc quyền thượng lưu dành riêng cho chủ thẻ tín dụng cao cấp: Miễn phí phòng chờ sân bay quốc tế hạng thương gia và tích điểm đổi dặm bay.','<p>Chủ thẻ tín dụng Vietcombank Visa Signature được hưởng quyền lợi hoàn tiền lên tới 15% tại hàng nghìn nhà hàng khách sạn 5 sao cao cấp trên toàn cầu...</p>','https://images.unsplash.com/photo-1556742049-0a67c5574f73?w=600&auto=format&fit=crop&q=80',2,101,'PUBLISHED','2026-08-28 07:20:00','2026-09-09 11:53:09','2026-09-09 11:53:09'),(5,'Vietcombank miễn 100% phí chuyển tiền trực tuyến và quản lý tài khoản trên VCB Digibank','mien-phi-chuyen-tien-digibank-2026','Chính sách zero fee toàn diện giúp hàng triệu khách hàng giao dịch tài chính hoàn toàn miễn phí, an toàn và thuận tiện.','<p>Nhằm đem lại trải nghiệm số vượt trội cho khách hàng cá nhân và doanh nghiệp, Vietcombank chính thức áp dụng chính sách miễn toàn bộ phí chuyển tiền trong và ngoài hệ thống 24/7, không thu phí duy trì tài khoản và không yêu cầu số dư tối thiểu...</p>','https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=600&auto=format&fit=crop',1,101,'PUBLISHED','2026-09-10 01:54:14','2026-09-10 01:54:14','2026-09-10 01:54:14'),(6,'Gói vay mua nhà An Cư 2026: Lãi suất cố định chỉ từ 5.5%/năm đồng hành cùng tổ ấm','goi-vay-mua-nha-an-cu-2026','Chương trình tín dụng quy mô 50.000 tỷ đồng với thời gian vay lên đến 30 năm, ân hạn nợ gốc tới 24 tháng cho khách hàng trẻ.','<p>Vietcombank tự hào ra mắt gói giải pháp tín dụng An Cư dành riêng cho khách hàng có nhu cầu mua nhà ở thực. Với mức lãi suất ưu đãi vượt trội cố định từ 5.5%/năm trong 12 tháng đầu hoặc 6.5%/năm trong 24 tháng đầu...</p>','https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=600&auto=format&fit=crop',1,101,'PUBLISHED','2026-09-10 01:54:14','2026-09-10 01:54:14','2026-09-10 01:54:14'),(7,'Ưu đãi hoàn tiền 10% cho chủ thẻ Vietcombank Visa Signature tại hệ thống nhà hàng & khách sạn 5 sao','uu-dai-hoan-tien-visa-signature-2026','Đặc quyền thượng lưu không giới hạn cùng thẻ đen Vietcombank Visa Signature: Miễn phí phòng chờ sân bay quốc tế và bảo hiểm du lịch toàn cầu.','<p>Từ ngày 01/09/2026 đến hết 31/12/2026, các chủ thẻ tín dụng Vietcombank Visa Signature khi chi tiêu ẩm thực, nghỉ dưỡng tại hệ thống đối tác liên kết sẽ nhận ngay mức hoàn tiền 10% tối đa 2.000.000 VND mỗi kỳ sao kê...</p>','https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=600&auto=format&fit=crop',2,101,'PUBLISHED','2026-09-10 01:54:14','2026-09-10 01:54:14','2026-09-10 01:54:14'),(11,'Vietcombank dẫn đầu kỷ nguyên Ngân hàng số thông minh 2026','vietcombank-dan-dau-ky-nguyen-ngan-hang-so-thong-minh-2026','Ứng dụng công nghệ Trí tuệ nhân tạo AI và dữ liệu lớn trong tối ưu hóa trải nghiệm tài chính cá nhân hóa.','<p>Vietcombank tiếp tục khẳng định vị thế ngân hàng số hàng đầu với chuỗi tiện ích thanh toán thông minh...</p>','https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800',1,101,'PUBLISHED','2026-09-13 08:34:25','2026-09-13 08:34:25','2026-09-13 08:34:25'),(12,'Vietcombank ra mắt tính năng Mở sổ tiết kiệm tích lũy số linh hoạt trên VCB Digibank','vietcombank-ra-mat-tinh-nang-mo-so-tiet-kiem-tich-luy-so-linh-hoat-tren-vcb-digibank','Khách hàng có thể gửi tích lũy định kỳ hàng ngày, hàng tuần hoặc hàng tháng chỉ từ 100.000 VNĐ với mức sinh lời tối ưu.','<p>Vietcombank chính thức giới thiệu sản phẩm Tiết kiệm tích lũy số trên ứng dụng VCB Digibank. Với tính năng này, việc tích lũy tài chính trở nên dễ dàng và thông minh hơn bao giờ hết, cho phép cài đặt trích tiền tự động và hưởng lãi suất sinh lời hấp dẫn theo ngày...</p>','https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800',1,101,'PUBLISHED','2026-09-13 21:24:05','2026-09-13 21:24:05','2026-09-13 21:24:05'),(13,'Giải pháp Tài trợ thương mại số toàn diện cho doanh nghiệp xuất nhập khẩu 2026','giai-phap-tai-tro-thuong-mai-so-toan-dien-cho-doanh-nghiep-xuat-nhap-khau-2026','Gói hỗ trợ hạn mức tín dụng 30.000 tỷ đồng với cơ chế phát hành L/C online và bảo lãnh điện tử siêu tốc trong 2 giờ.','<p>Đồng hành cùng cộng đồng doanh nghiệp trong xu hướng hội nhập kinh tế toàn cầu, Vietcombank triển khai nền tảng Tài trợ thương mại số (Trade Finance Digital Platform). Nền tảng giúp tối ưu hóa thời gian xử lý phát hành thư tín dụng L/C và bảo lãnh ngân hàng...</p>','https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',1,101,'PUBLISHED','2026-09-13 21:24:06','2026-09-13 21:24:06','2026-09-13 21:24:06'),(14,'Ưu đãi hoàn tiền 15% khi chi tiêu qua thẻ Vietcombank JCB Platinum tại các nhà hàng Nhật Bản','uu-dai-hoan-tien-15-khi-chi-tieu-qua-the-vietcombank-jcb-platinum-tai-cac-nha-hang-nhat-ban','Trải nghiệm ẩm thực tinh hoa xứ sở hoa anh đào với chương trình hoàn tiền hấp dẫn lên tới 1.500.000 VNĐ mỗi tháng.','<p>Từ nay đến hết tháng 12/2026, toàn bộ chủ thẻ tín dụng quốc tế Vietcombank JCB Platinum khi thanh toán tại chuỗi nhà hàng ẩm thực Nhật Bản cao cấp trên toàn quốc sẽ được tận hưởng ưu đãi hoàn tiền 15% trực tiếp vào sao kê thẻ tín dụng...</p>','https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',2,101,'PUBLISHED','2026-09-13 21:24:07','2026-09-13 21:24:07','2026-09-13 21:24:07'),(15,'Gói vay mua ô tô điện VinFast: Lãi suất siêu ưu đãi 5.8%/năm đồng hành cùng kỷ nguyên xanh','goi-vay-mua-o-to-dien-vinfast-lai-suat-sieu-uu-dai-58nam-dong-hanh-cung-ky-nguyen-xanh','Vietcombank liên kết độc quyền hỗ trợ khách hàng vay tới 85% giá trị xe với thời hạn vay linh hoạt đến 8 năm.','<p>Nhằm khuyến khích lối sống xanh và phương tiện giao thông thân thiện với môi trường, Vietcombank cùng VinFast triển khai gói tài chính chuyên biệt cho các dòng xe điện thông minh VF3, VF5, VF6, VF7, VF8, VF9 với thủ tục thẩm định trực tuyến giải ngân trong ngày...</p>','https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=800',1,101,'PUBLISHED','2026-09-13 21:24:08','2026-09-13 21:24:08','2026-09-13 21:24:08'),(16,'Cảnh báo an toàn bảo mật: Hướng dẫn kích hoạt xác thực sinh trắc học trên ứng dụng VCB Digibank','canh-bao-an-toan-bao-mat-huong-dan-kich-hoat-xac-thuc-sinh-trac-hoc-tren-ung-dung-vcb-digibank','Bảo vệ tài sản tài chính tối đa với công nghệ xác thực khuôn mặt khớp nối với cơ sở dữ liệu định danh quốc gia.','<p>Thực hiện Quyết định số 2345/QĐ-NHNN của Ngân hàng Nhà nước, Vietcombank khuyến nghị toàn bộ quý khách hàng nhanh chóng cập nhật thông tin sinh trắc học bằng cách quét chip CCCD trên ứng dụng VCB Digibank để đảm bảo giao dịch thông suốt và an toàn bảo mật cao nhất...</p>','https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800',3,101,'PUBLISHED','2026-09-13 21:24:09','2026-09-13 21:24:09','2026-09-13 21:24:09');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_exports`
--

DROP TABLE IF EXISTS `report_exports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_exports` (
  `export_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `report_type` varchar(100) NOT NULL,
  `filter_params` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`filter_params`)),
  `file_format` enum('EXCEL','PDF','CSV') NOT NULL,
  `file_path` varchar(500) DEFAULT NULL,
  `exported_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`export_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `report_exports_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_exports`
--

LOCK TABLES `report_exports` WRITE;
/*!40000 ALTER TABLE `report_exports` DISABLE KEYS */;
INSERT INTO `report_exports` VALUES (1,103,'APPLICATION_SUMMARY','{}','EXCEL','/uploads/reports/bao-cao-ho-so_20260913_223427_6adc.xlsx','2026-09-13 08:34:27'),(2,103,'Báo cáo Tổng hợp Thẩm định & Phê duyệt Tín dụng Quý 3/2026','{\"branch\":\"HOAN_KIEM\",\"status\":\"APPROVED\",\"quarter\":\"Q3_2026\"}','EXCEL','/exports/reports/Bao_cao_Tin_dung_Q3_2026.xlsx','2026-09-14 04:30:45'),(3,103,'Báo cáo Thống kê Dòng tiền & Giao dịch Khách hàng Doanh nghiệp','{\"customer_type\":\"ENTERPRISE\",\"date_range\":\"2026-07-01_to_2026-09-30\"}','PDF','/exports/reports/Thong_ke_Dong_tien_DN_Q3.pdf','2026-09-14 04:30:45'),(4,101,'Báo cáo Kiểm toán Hoạt động & Nhật ký Hệ thống (Security Audit)','{\"severity\":\"ALL\",\"target_module\":\"RBAC_SECURITY\"}','CSV','/exports/reports/Audit_Logs_Security_2026.csv','2026-09-14 04:30:45'),(5,104,'Báo cáo Thống kê Năng suất Phục vụ Khách hàng tại Quầy','{\"staff_id\":104,\"month\":\"09_2026\"}','EXCEL','/exports/reports/Nang_suat_Quay_Thang_09.xlsx','2026-09-14 04:30:45'),(6,103,'Báo cáo Tình hình Xử lý Khiếu nại Tra soát Giao dịch Toàn quốc','{\"status\":\"RESOLVED\",\"quarter\":\"Q3\"}','PDF','/exports/reports/Tra_soat_Khieu_nai_Q3.pdf','2026-09-14 04:30:45'),(7,103,'Báo cáo Tổng hợp Thẩm định & Phê duyệt Tín dụng Quý 3/2026','{\"branch\":\"HOAN_KIEM\",\"status\":\"APPROVED\",\"quarter\":\"Q3_2026\"}','EXCEL','/exports/reports/Bao_cao_Tin_dung_Q3_2026.xlsx','2026-09-14 04:30:56'),(8,103,'Báo cáo Thống kê Dòng tiền & Giao dịch Khách hàng Doanh nghiệp','{\"customer_type\":\"ENTERPRISE\",\"date_range\":\"2026-07-01_to_2026-09-30\"}','PDF','/exports/reports/Thong_ke_Dong_tien_DN_Q3.pdf','2026-09-14 04:30:56'),(9,101,'Báo cáo Kiểm toán Hoạt động & Nhật ký Hệ thống (Security Audit)','{\"severity\":\"ALL\",\"target_module\":\"RBAC_SECURITY\"}','CSV','/exports/reports/Audit_Logs_Security_2026.csv','2026-09-14 04:30:56'),(10,104,'Báo cáo Thống kê Năng suất Phục vụ Khách hàng tại Quầy','{\"staff_id\":104,\"month\":\"09_2026\"}','EXCEL','/exports/reports/Nang_suat_Quay_Thang_09.xlsx','2026-09-14 04:30:56'),(11,103,'Báo cáo Tình hình Xử lý Khiếu nại Tra soát Giao dịch Toàn quốc','{\"status\":\"RESOLVED\",\"quarter\":\"Q3\"}','PDF','/exports/reports/Tra_soat_Khieu_nai_Q3.pdf','2026-09-14 04:30:56');
/*!40000 ALTER TABLE `report_exports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `permission_id` (`permission_id`),
  CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE,
  CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`permission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES (1,1),(1,2),(1,3),(2,3),(1,4),(2,4),(1,5),(1,6),(3,6),(1,7),(3,7),(1,8),(3,8),(1,9),(3,9);
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_code` varchar(50) NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_code` (`role_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'ROLE_ADMIN','Quản trị hệ thống','Có toàn bộ quyền trong hệ thống','2026-09-09 11:53:06','2026-09-09 11:53:06'),(2,'ROLE_MANAGER','Quản lý phê duyệt','Chỉ có chức năng Phê duyệt hồ sơ, giao dịch tài chính và Xem báo cáo thống kê','2026-09-09 11:53:06','2026-09-09 11:53:06'),(3,'ROLE_STAFF','Nhân viên nghiệp vụ','Thực hiện tư vấn, tra soát, hỗ trợ CSKH và giao dịch','2026-09-09 11:53:06','2026-09-09 11:53:06');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_profiles`
--

DROP TABLE IF EXISTS `staff_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_profiles` (
  `staff_id` bigint(20) NOT NULL,
  `employee_code` varchar(50) NOT NULL,
  `department` varchar(100) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `address` text DEFAULT NULL,
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `employee_code` (`employee_code`),
  CONSTRAINT `staff_profiles_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_profiles`
--

LOCK TABLES `staff_profiles` WRITE;
/*!40000 ALTER TABLE `staff_profiles` DISABLE KEYS */;
INSERT INTO `staff_profiles` VALUES (104,'NV-2026-089','Dịch vụ Khách hàng','Chuyên viên Quản lý & Tư vấn',NULL,NULL);
/*!40000 ALTER TABLE `staff_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `support_ticket_logs`
--

DROP TABLE IF EXISTS `support_ticket_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `support_ticket_logs` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint(20) NOT NULL,
  `staff_id` bigint(20) NOT NULL,
  `action_note` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`log_id`),
  KEY `ticket_id` (`ticket_id`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `support_ticket_logs_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets` (`ticket_id`) ON DELETE CASCADE,
  CONSTRAINT `support_ticket_logs_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `support_ticket_logs`
--

LOCK TABLES `support_ticket_logs` WRITE;
/*!40000 ALTER TABLE `support_ticket_logs` DISABLE KEYS */;
INSERT INTO `support_ticket_logs` VALUES (1,1,104,'Đã hoàn thiện chu trình','2026-09-09 18:50:58'),(2,4,104,'Đã kiểm tra cây ATM 12, thủ quỹ đã thu hồi thẻ an toàn. Đã gọi điện mời khách hàng mang theo CCCD đến quầy nhận lại thẻ miễn phí.','2026-09-10 01:54:14'),(3,5,104,'Đã ngay lập tức khóa thẻ tạm thời trên hệ thống CMS để bảo vệ số dư tài khoản của khách và chuyển hồ sơ sang bộ phận Tra soát thẻ.','2026-09-10 01:54:14'),(4,4,104,'Đã kiểm tra cây ATM 12, thủ quỹ đã thu hồi thẻ an toàn. Đã gọi điện mời khách hàng mang theo CCCD đến quầy nhận lại thẻ miễn phí.','2026-09-10 01:54:28'),(5,5,104,'Đã ngay lập tức khóa thẻ tạm thời trên hệ thống CMS để bảo vệ số dư tài khoản của khách và chuyển hồ sơ sang bộ phận Tra soát thẻ.','2026-09-10 01:54:28'),(6,1,104,'Đã hướng dẫn khách hàng quét chip CCCD vào phần đỉnh lưng iPhone và kích hoạt lại Smart OTP thành công.','2026-09-13 08:34:22'),(7,1,104,'Đã liên hệ khách hàng qua điện thoại, hướng dẫn quy trình xác thực CCCD gắn chip qua NFC thành công.','2026-09-14 04:30:57'),(8,2,104,'Đã kiểm tra hệ thống thẻ quốc tế, thẻ khách hàng hoạt động bình thường, không ghi nhận mã lỗi khóa.','2026-09-14 04:30:57'),(9,3,104,'Đã hỗ trợ điều chỉnh nâng hạn mức chuyển khoản tạm thời trong ngày lên 1 tỷ đồng theo giấy đề nghị của khách.','2026-09-14 04:30:57'),(10,4,104,'Đã phối hợp với phòng Kế toán quỹ hoàn tất hoàn trả khoản phí thường niên thẻ do đạt doanh số chi tiêu.','2026-09-14 04:30:57'),(11,5,104,'Đã hoàn tất cấp mã e-PIN trực tuyến mới cho khách hàng trên hệ thống ngân hàng số.','2026-09-14 04:30:57'),(12,17,104,'ABCDEF','2026-09-17 18:23:23');
/*!40000 ALTER TABLE `support_ticket_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `support_tickets`
--

DROP TABLE IF EXISTS `support_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `support_tickets` (
  `ticket_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ticket_code` varchar(50) NOT NULL,
  `customer_id` bigint(20) NOT NULL,
  `assigned_staff_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') DEFAULT 'MEDIUM',
  `status` enum('NEW','IN_PROGRESS','TRANSFERRED','RESOLVED','CLOSED') DEFAULT 'NEW',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ticket_id`),
  UNIQUE KEY `ticket_code` (`ticket_code`),
  KEY `customer_id` (`customer_id`),
  KEY `assigned_staff_id` (`assigned_staff_id`),
  CONSTRAINT `support_tickets_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `support_tickets_ibfk_2` FOREIGN KEY (`assigned_staff_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `support_tickets`
--

LOCK TABLES `support_tickets` WRITE;
/*!40000 ALTER TABLE `support_tickets` DISABLE KEYS */;
INSERT INTO `support_tickets` VALUES (1,'TCK-2026-001',501,104,'Hỗ trợ nâng hạn mức thẻ tín dụng','Khách hàng có lịch sử tín dụng tốt, yêu cầu nâng hạn mức thẻ Platinum từ 50tr lên 100tr.','HIGH','RESOLVED','2026-09-09 11:53:08','2026-09-09 18:50:58'),(2,'TCK-2026-002',502,104,'Kích hoạt phương thức Smart OTP trên máy mới','Khách hàng đổi điện thoại iPhone 16 mới, cần xác thực kích hoạt lại Smart OTP qua eKYC.','MEDIUM','RESOLVED','2026-09-09 11:53:08','2026-09-09 11:53:08'),(3,'TK-2026-1011',501,104,'Cần nâng hạn mức giao dịch chuyển tiền VCB Digibank','Khách hàng muốn nâng hạn mức chuyển tiền trực tuyến từ 100 triệu lên 500 triệu/ngày để thanh toán tiền hàng cho đối tác.','HIGH','IN_PROGRESS','2026-09-10 01:54:14','2026-09-10 01:54:14'),(4,'TK-2026-1012',501,104,'Cây ATM nuốt thẻ ghi nợ Vietcombank Connect24','Khách hàng rút tiền tại cây ATM số 12 chi nhánh Hoàn Kiếm bị giữ thẻ lúc 18h30 ngày hôm qua.','MEDIUM','RESOLVED','2026-09-10 01:54:14','2026-09-10 01:54:14'),(5,'TK-2026-1013',501,104,'Thẻ tín dụng phát sinh giao dịch lạ ở trang thương mại điện tử quốc tế','Khách hàng nhận được tin nhắn trừ 25 USD tại dịch vụ nghe nhạc trực tuyến nước ngoài mà không thực hiện.','URGENT','IN_PROGRESS','2026-09-10 01:54:14','2026-09-10 01:54:14'),(9,'TK-2026-7537',601,104,'Hỗ trợ cấp lại mã PIN thẻ tín dụng','Khách hàng quên mã PIN thẻ Visa Platinum tại cây ATM','HIGH','NEW','2026-09-13 08:40:11','2026-09-13 08:40:11'),(10,'TK-2026-7586',601,104,'Hỗ trợ cấp lại mã PIN thẻ tín dụng','Khách hàng quên mã PIN thẻ Visa Platinum tại cây ATM','HIGH','NEW','2026-09-13 08:41:06','2026-09-13 08:41:06'),(11,'TK-2026-4820',601,104,'Hỗ trợ kích hoạt sinh trắc học khuôn mặt theo Quyết định 2345','Khách hàng đổi sang điện thoại iPhone mới, quét NFC căn cước CCCD gắn chip bị lỗi không nhận diện.','HIGH','NEW','2026-09-13 21:23:51','2026-09-13 21:23:51'),(12,'TK-2026-7105',601,104,'Cần nâng hạn mức chuyển tiền trực tuyến trong ngày lên 1 tỷ','Khách hàng cần thanh toán tiền đặt cọc mua căn hộ chung cư trong chiều nay, hạn mức hiện tại 500 triệu/ngày không đủ.','URGENT','NEW','2026-09-13 21:23:52','2026-09-13 21:23:52'),(13,'TK-2026-4880',601,104,'Thẻ tín dụng Visa Platinum bị trừ phí thường niên','Khách hàng hỏi điều kiện hoàn phí thường niên năm đầu khi chi tiêu đạt mốc 20 triệu đồng theo thể lệ chương trình.','MEDIUM','NEW','2026-09-13 21:23:53','2026-09-13 21:23:53'),(14,'TK-2026-5520',601,104,'Cấp lại mã PIN thẻ ghi nợ quốc tế Vietcombank Connect24','Khách hàng quên mã PIN thẻ vật lý khi đi du lịch nước ngoài, cần cấp lại mã e-PIN trực tuyến trên app VCB Digibank.','HIGH','NEW','2026-09-13 21:23:54','2026-09-13 21:23:54'),(15,'TK-2026-6592',601,104,'Đăng ký dịch vụ nhận biến động số dư qua tin nhắn OTT miễn phí','Khách hàng muốn hủy nhận tin nhắn SMS để chuyển sang nhận thông báo biến động số dư hoàn toàn miễn phí trên app.','LOW','NEW','2026-09-13 21:23:55','2026-09-13 21:23:55'),(16,'TK-2026-9227',601,104,'Hỗ trợ cấp lại mã PIN thẻ tín dụng','Khách hàng quên mã PIN thẻ Visa Platinum tại cây ATM','HIGH','NEW','2026-09-13 21:25:54','2026-09-13 21:25:54'),(17,'TK-2026-5648',601,104,'Hỗ trợ cấp lại mã PIN thẻ tín dụng','Khách hàng quên mã PIN thẻ Visa Platinum tại cây ATM','HIGH','IN_PROGRESS','2026-09-13 21:31:58','2026-09-17 18:23:24'),(18,'TK-2026-6271',501,104,'Không đăng nhập được','Tôi không đăng nhập được vào bằng tài khoản','MEDIUM','NEW','2026-09-17 19:38:16','2026-09-17 19:38:16');
/*!40000 ALTER TABLE `support_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trade_finance_requests`
--

DROP TABLE IF EXISTS `trade_finance_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trade_finance_requests` (
  `request_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `request_code` varchar(50) NOT NULL,
  `customer_id` bigint(20) NOT NULL,
  `service_type` enum('LETTER_OF_CREDIT','BANK_GUARANTEE','IMPORT_EXPORT_FINANCE') NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `currency` varchar(10) DEFAULT 'VND',
  `beneficiary_name` varchar(255) NOT NULL,
  `purpose` text NOT NULL,
  `document_url` varchar(500) DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`request_id`),
  UNIQUE KEY `request_code` (`request_code`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `trade_finance_requests_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trade_finance_requests`
--

LOCK TABLES `trade_finance_requests` WRITE;
/*!40000 ALTER TABLE `trade_finance_requests` DISABLE KEYS */;
INSERT INTO `trade_finance_requests` VALUES (1,'TF-2026-001',602,'LETTER_OF_CREDIT',1500000000.00,'VND','Samsung Electronics VN','Mở L/C nhập khẩu linh kiện điện tử viễn thông',NULL,'PENDING','2026-09-09 11:53:08','2026-09-09 11:53:08'),(2,'TF-2026-29039',602,'LETTER_OF_CREDIT',2850000000.00,'VND','Samsung Electronics Vietnam Co., Ltd','Phát hành L/C không hủy ngang nhập khẩu linh kiện điện tử bán dẫn lô hàng Quý 4/2026','/uploads/docs/hop_dong_ngoai_thuong_samsung.pdf','PENDING','2026-09-13 21:23:35','2026-09-13 21:23:35'),(3,'TF-2026-70830',602,'BANK_GUARANTEE',850000000.00,'VND','Ban Quản lý Dự án Giao thông Đô thị Hà Nội','Thư bảo lãnh dự thầu và thực hiện hợp đồng gói thầu số 06 hệ thống giám sát thông minh','/uploads/docs/ho_so_moi_thau_06.pdf','PENDING','2026-09-13 21:23:36','2026-09-13 21:23:36'),(4,'TF-2026-67099',602,'BANK_GUARANTEE',450000000.00,'VND','Tập đoàn Điện lực Việt Nam (EVN)','Bảo lãnh tiền tạm ứng thi công trạm biến áp số 2 khu công nghệ cao','/uploads/docs/hop_dong_evn_tam_ung.pdf','PENDING','2026-09-13 21:23:37','2026-09-13 21:23:37'),(5,'TF-2026-70011',602,'IMPORT_EXPORT_FINANCE',1500000000.00,'VND','Công ty Cổ phần Nông sản Xuất khẩu An Giang','Tài trợ chiết khấu bộ chứng từ xuất khẩu gạo thơm sang thị trường EU theo hạn ngạch EVFTA','/uploads/docs/bo_chung_tu_xuat_khau_gao.pdf','PENDING','2026-09-13 21:23:38','2026-09-13 21:23:38'),(6,'TF-2026-12924',602,'LETTER_OF_CREDIT',1950000000.00,'VND','Tokyo Technology & Machinery Corp (Japan)','Phát hành Thư tín dụng Standby L/C nhập khẩu dây chuyền tự động hóa công nghiệp','/uploads/docs/hop_dong_may_moc_japan.pdf','PENDING','2026-09-13 21:23:39','2026-09-13 21:23:39');
/*!40000 ALTER TABLE `trade_finance_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` bigint(20) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (101,1),(102,2),(103,2),(104,3);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `status` enum('ACTIVE','INACTIVE','LOCKED') DEFAULT 'ACTIVE',
  `otp_secret` varchar(100) DEFAULT NULL,
  `otp_expiry` timestamp NULL DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (101,'admin_super','$2a$10$FLnwmNOOaOHRbVU31u.rWe6mAiTC2VAEzgbCKU9sZwvvh5skrbISW','admin@bank.com','Nguyễn Văn Admin','0901234567','ACTIVE',NULL,NULL,'2026-09-19 07:53:54','2026-09-09 11:53:07','2026-09-19 07:53:54'),(102,'manager_dev','$2a$10$dUXu832MSQJ3HYoxuxWcvu/3zVIy0TAWNyS1f3yWzvzPziVglKaPa','manager@bank.com','Trần Thị Lý','0912345678','ACTIVE',NULL,NULL,'2026-09-09 08:26:25','2026-09-09 11:53:07','2026-09-19 07:52:29'),(103,'ql_minhtuan','$2a$10$tOIl4MBGUVqW6sfeQ7WxAuU7hw1pbXEBz/vPl0KO6XTnZ3plSsZBC','tuan.ql@bank.com','Lê Minh Tuấn','0918999888','ACTIVE',NULL,NULL,'2026-09-17 18:13:17','2026-09-09 11:53:07','2026-09-19 07:52:30'),(104,'nv_hoangnam','$2a$10$EE3.pJe0zE1FnGA9VROQMeZrx3Q0mLOKdofw/xAZdl9IOhu6hjrs6','nam.nv@bank.com','Nguyễn Hoàng Nam','0933444555','ACTIVE',NULL,NULL,'2026-09-17 19:34:56','2026-09-09 11:53:07','2026-09-19 07:52:30');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-21 13:49:25
