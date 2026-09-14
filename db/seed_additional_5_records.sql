-- ============================================================================
-- SCRIPT SQL: BỔ SUNG 5 BẢN GHI MẪU CHO MỖI PHÂN HỆ / GIAO DIỆN HỆ THỐNG
-- Hệ thống: Vietcombank Digital Banking & Staff Operations
-- Ràng buộc: Không tạo thêm tài khoản cán bộ và khách hàng, chỉ thêm nghiệp vụ
-- ============================================================================
USE admin_portal_db;

-- ============================================================================
-- 1. TIẾT KIỆM ONLINE (Phục vụ giao diện: http://localhost:5173/#/customer/savings)
-- ============================================================================
INSERT INTO customer_savings
(saving_code, customer_id, product_code, deposit_amount, term_months, interest_rate, expected_interest, maturity_date, status, created_at)
SELECT
    'STK-2026-880101', c.customer_id, 'TIET_KIEM_ONLINE_1M', 20000000.00, 1, 3.50, 58333.33, DATE_ADD(CURDATE(), INTERVAL 1 MONTH), 'ACTIVE', NOW()
FROM customers c WHERE c.username = 'kh_thuha' LIMIT 1
ON DUPLICATE KEY UPDATE deposit_amount=VALUES(deposit_amount);

INSERT INTO customer_savings
(saving_code, customer_id, product_code, deposit_amount, term_months, interest_rate, expected_interest, maturity_date, status, created_at)
SELECT
    'STK-2026-880102', c.customer_id, 'TIET_KIEM_ONLINE_3M', 50000000.00, 3, 4.50, 562500.00, DATE_ADD(CURDATE(), INTERVAL 3 MONTH), 'ACTIVE', NOW()
FROM customers c WHERE c.username = 'kh_thuha' LIMIT 1
ON DUPLICATE KEY UPDATE deposit_amount=VALUES(deposit_amount);

INSERT INTO customer_savings
(saving_code, customer_id, product_code, deposit_amount, term_months, interest_rate, expected_interest, maturity_date, status, created_at)
SELECT
    'STK-2026-880103', c.customer_id, 'TIET_KIEM_ONLINE_6M', 120000000.00, 6, 5.50, 3300000.00, DATE_ADD(CURDATE(), INTERVAL 6 MONTH), 'ACTIVE', NOW()
FROM customers c WHERE c.username = 'kh_thuha' LIMIT 1
ON DUPLICATE KEY UPDATE deposit_amount=VALUES(deposit_amount);

INSERT INTO customer_savings
(saving_code, customer_id, product_code, deposit_amount, term_months, interest_rate, expected_interest, maturity_date, status, created_at)
SELECT
    'STK-2026-880104', c.customer_id, 'TIET_KIEM_ONLINE_12M', 300000000.00, 12, 6.80, 20400000.00, DATE_ADD(CURDATE(), INTERVAL 12 MONTH), 'ACTIVE', NOW()
FROM customers c WHERE c.username = 'kh_thuha' LIMIT 1
ON DUPLICATE KEY UPDATE deposit_amount=VALUES(deposit_amount);

INSERT INTO customer_savings
(saving_code, customer_id, product_code, deposit_amount, term_months, interest_rate, expected_interest, maturity_date, status, created_at)
SELECT
    'STK-2026-880105', c.customer_id, 'TIET_KIEM_ONLINE_24M', 500000000.00, 24, 7.20, 72000000.00, DATE_ADD(CURDATE(), INTERVAL 24 MONTH), 'ACTIVE', NOW()
FROM customers c WHERE c.username = 'kh_namle' LIMIT 1
ON DUPLICATE KEY UPDATE deposit_amount=VALUES(deposit_amount);


-- ============================================================================
-- 2. TÀI TRỢ THƯƠNG MẠI DOANH NGHIỆP (Phục vụ: http://localhost:5173/#/customer/trade-finance)
-- ============================================================================
INSERT INTO trade_finance_requests
(request_code, customer_id, service_type, amount, currency, beneficiary_name, purpose, document_url, status, created_at)
SELECT
    'TF-2026-90001', c.customer_id, 'LETTER_OF_CREDIT', 2850000000.00, 'VND', 'Samsung Electronics Vietnam Co., Ltd',
    'Phát hành L/C không hủy ngang nhập khẩu linh kiện điện tử bán dẫn lô hàng Quý 4/2026',
    '/uploads/docs/hop_dong_ngoai_thuong_samsung.pdf', 'APPROVED', NOW()
FROM customers c WHERE c.username = 'dn_abctech' LIMIT 1
ON DUPLICATE KEY UPDATE amount=VALUES(amount);

INSERT INTO trade_finance_requests
(request_code, customer_id, service_type, amount, currency, beneficiary_name, purpose, document_url, status, created_at)
SELECT
    'TF-2026-90002', c.customer_id, 'BANK_GUARANTEE', 850000000.00, 'VND', 'Ban Quản lý Dự án Giao thông Đô thị Hà Nội',
    'Thư bảo lãnh dự thầu và thực hiện hợp đồng gói thầu số 06 hệ thống giám sát thông minh',
    '/uploads/docs/ho_so_moi_thau_06.pdf', 'APPROVED', NOW()
FROM customers c WHERE c.username = 'dn_abctech' LIMIT 1
ON DUPLICATE KEY UPDATE amount=VALUES(amount);

INSERT INTO trade_finance_requests
(request_code, customer_id, service_type, amount, currency, beneficiary_name, purpose, document_url, status, created_at)
SELECT
    'TF-2026-90003', c.customer_id, 'BANK_GUARANTEE', 450000000.00, 'VND', 'Tập đoàn Điện lực Việt Nam (EVN)',
    'Bảo lãnh tiền tạm ứng thi công trạm biến áp số 2 khu công nghệ cao',
    '/uploads/docs/hop_dong_evn_tam_ung.pdf', 'PENDING', NOW()
FROM customers c WHERE c.username = 'dn_abctech' LIMIT 1
ON DUPLICATE KEY UPDATE amount=VALUES(amount);

INSERT INTO trade_finance_requests
(request_code, customer_id, service_type, amount, currency, beneficiary_name, purpose, document_url, status, created_at)
SELECT
    'TF-2026-90004', c.customer_id, 'IMPORT_EXPORT_FINANCE', 1500000000.00, 'VND', 'Công ty Cổ phần Nông sản Xuất khẩu An Giang',
    'Tài trợ chiết khấu bộ chứng từ xuất khẩu gạo thơm sang thị trường EU theo hạn ngạch EVFTA',
    '/uploads/docs/bo_chung_tu_xuat_khau_gao.pdf', 'PENDING', NOW()
FROM customers c WHERE c.username = 'dn_abctech' LIMIT 1
ON DUPLICATE KEY UPDATE amount=VALUES(amount);

INSERT INTO trade_finance_requests
(request_code, customer_id, service_type, amount, currency, beneficiary_name, purpose, document_url, status, created_at)
SELECT
    'TF-2026-90005', c.customer_id, 'LETTER_OF_CREDIT', 1950000000.00, 'VND', 'Tokyo Technology & Machinery Corp (Japan)',
    'Phát hành Thư tín dụng Standby L/C nhập khẩu dây chuyền tự động hóa công nghiệp',
    '/uploads/docs/hop_dong_may_moc_japan.pdf', 'PENDING', NOW()
FROM customers c WHERE c.username = 'dn_abctech' LIMIT 1
ON DUPLICATE KEY UPDATE amount=VALUES(amount);


-- ============================================================================
-- 3. HỒ SƠ VAY & MỞ THẺ TÍN DỤNG (Phục vụ: #/customer/my-applications, #/approvals)
-- ============================================================================
-- 3.1 Hồ sơ Vay mua ô tô VinFast VF8
INSERT INTO applications (application_code, customer_id, application_type, requested_amount, status, created_at)
SELECT 'APP-2026-8801', c.customer_id, 'LOAN', 750000000.00, 'APPROVED', NOW()
FROM customers c WHERE c.username = 'kh_thuha' LIMIT 1
ON DUPLICATE KEY UPDATE status=VALUES(status);

INSERT INTO loan_applications (application_id, loan_purpose, loan_amount, loan_term_months, interest_rate_percentage)
SELECT a.application_id, 'AUTO', 750000000.00, 60, 6.50
FROM applications a WHERE a.application_code = 'APP-2026-8801' LIMIT 1
ON DUPLICATE KEY UPDATE loan_amount=VALUES(loan_amount);

-- 3.2 Hồ sơ Vay mua ô tô Mercedes C300
INSERT INTO applications (application_code, customer_id, application_type, requested_amount, status, created_at)
SELECT 'APP-2026-8802', c.customer_id, 'LOAN', 900000000.00, 'PENDING', NOW()
FROM customers c WHERE c.username = 'kh_thuha' LIMIT 1
ON DUPLICATE KEY UPDATE status=VALUES(status);

INSERT INTO loan_applications (application_id, loan_purpose, loan_amount, loan_term_months, interest_rate_percentage)
SELECT a.application_id, 'AUTO', 900000000.00, 72, 7.50
FROM applications a WHERE a.application_code = 'APP-2026-8802' LIMIT 1
ON DUPLICATE KEY UPDATE loan_amount=VALUES(loan_amount);

-- 3.3 Hồ sơ Vay tiêu dùng sửa nhà
INSERT INTO applications (application_code, customer_id, application_type, requested_amount, status, created_at)
SELECT 'APP-2026-8803', c.customer_id, 'LOAN', 180000000.00, 'PENDING', NOW()
FROM customers c WHERE c.username = 'kh_thuha' LIMIT 1
ON DUPLICATE KEY UPDATE status=VALUES(status);

INSERT INTO loan_applications (application_id, loan_purpose, loan_amount, loan_term_months, interest_rate_percentage)
SELECT a.application_id, 'CONSUMER', 180000000.00, 36, 8.20
FROM applications a WHERE a.application_code = 'APP-2026-8803' LIMIT 1
ON DUPLICATE KEY UPDATE loan_amount=VALUES(loan_amount);

-- 3.4 Hồ sơ Mở thẻ tín dụng Vietcombank Visa Signature
INSERT INTO applications (application_code, customer_id, application_type, requested_amount, status, created_at)
SELECT 'APP-2026-8804', c.customer_id, 'CARD_ISSUANCE', 120000000.00, 'APPROVED', NOW()
FROM customers c WHERE c.username = 'kh_thuha' LIMIT 1
ON DUPLICATE KEY UPDATE status=VALUES(status);

-- 3.5 Hồ sơ Mở thẻ tín dụng Vietcombank JCB Platinum
INSERT INTO applications (application_code, customer_id, application_type, requested_amount, status, created_at)
SELECT 'APP-2026-8805', c.customer_id, 'CARD_ISSUANCE', 60000000.00, 'PENDING', NOW()
FROM customers c WHERE c.username = 'kh_thuha' LIMIT 1
ON DUPLICATE KEY UPDATE status=VALUES(status);


-- ============================================================================
-- 4. GIAO DỊCH TÀI CHÍNH TẠI QUẦY & DÒNG TIỀN (Phục vụ: #/staff/transactions, #/customer/transactions)
-- ============================================================================
INSERT INTO financial_transactions
(transaction_code, sender_customer_id, receiver_account_number, receiver_name, bank_name, amount, fee, description, processed_by_staff_id, status, created_at)
SELECT
    'FT2609200001', c.customer_id, '0071009988112', 'NGUYEN THI KIM NGAN', 'VIETCOMBANK', 35000000.00, 0.00,
    'Nop tien mat tai quay thanh toan tien hang', u.user_id, 'SUCCESS', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE amount=VALUES(amount);

INSERT INTO financial_transactions
(transaction_code, sender_customer_id, receiver_account_number, receiver_name, bank_name, amount, fee, description, processed_by_staff_id, status, created_at)
SELECT
    'FT2609200002', c.customer_id, '1903666888999', 'CONG TY CP DIEN MAY XANH', 'Techcombank', 18500000.00, 11000.00,
    'Thanh toan tien mua may giat va tu lanh', u.user_id, 'SUCCESS', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE amount=VALUES(amount);

INSERT INTO financial_transactions
(transaction_code, sender_customer_id, receiver_account_number, receiver_name, bank_name, amount, fee, description, processed_by_staff_id, status, created_at)
SELECT
    'FT2609200003', c.customer_id, '0911222333', 'TRAN THI THU HA', 'VIETCOMBANK', 50000000.00, 0.00,
    'Nop tien vao tai khoan thanh toan dinh ky', u.user_id, 'SUCCESS', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE amount=VALUES(amount);

INSERT INTO financial_transactions
(transaction_code, sender_customer_id, receiver_account_number, receiver_name, bank_name, amount, fee, description, processed_by_staff_id, status, created_at)
SELECT
    'FT2609200004', c.customer_id, '1028777999', 'LE HOANG ANH', 'VietinBank', 12000000.00, 9900.00,
    'Chuyen tien thanh toan tien thue nha thang 9', u.user_id, 'SUCCESS', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE amount=VALUES(amount);

INSERT INTO financial_transactions
(transaction_code, sender_customer_id, receiver_account_number, receiver_name, bank_name, amount, fee, description, processed_by_staff_id, status, created_at)
SELECT
    'FT2609200005', c.customer_id, '0011005544332', 'VIETCOMBANK LOAN RECOVERY', 'VIETCOMBANK', 6850000.00, 0.00,
    'Trich nop tien lai va goc vay tieu dung dinh ky', u.user_id, 'SUCCESS', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE amount=VALUES(amount);


-- ============================================================================
-- 5. TƯ VẤN KHÁCH HÀNG CRM (Phục vụ: http://localhost:5173/#/staff/advisories)
-- ============================================================================
INSERT INTO customer_advisories (customer_id, staff_id, product_type, notes, status, created_at)
SELECT c.customer_id, u.user_id, 'Vay mua xe ô tô điện VinFast VF8',
'Khách hàng có nhu cầu vay 750 triệu trong 5 năm, hưởng ưu đãi miễn phí trạm sạc 2 năm và lãi suất 6.5%.',
'FOLLOW_UP', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1;

INSERT INTO customer_advisories (customer_id, staff_id, product_type, notes, status, created_at)
SELECT c.customer_id, u.user_id, 'Thẻ tín dụng Vietcombank Visa Signature',
'Tư vấn mở thẻ đen đặc quyền phòng chờ sân bay và bảo hiểm du lịch 10.5 tỷ VND. Khách hàng quan tâm và đã nộp hồ sơ.',
'COMPLETED', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1;

INSERT INTO customer_advisories (customer_id, staff_id, product_type, notes, status, created_at)
SELECT c.customer_id, u.user_id, 'Tiết kiệm bậc thang phát lộc',
'Khách hàng có 500 triệu nhàn rỗi, tư vấn gửi kỳ hạn 12 tháng lãi suất 6.8% kèm quay số trúng thưởng sổ tiết kiệm.',
'FOLLOW_UP', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1;

INSERT INTO customer_advisories (customer_id, staff_id, product_type, notes, status, created_at)
SELECT c.customer_id, u.user_id, 'Bảo hiểm nhân thọ liên kết đầu tư FWD',
'Tư vấn giải pháp bảo vệ tài chính kết hợp gia tăng tài sản, mức phí bảo hiểm 30 triệu/năm.',
'CONSULTED', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1;

INSERT INTO customer_advisories (customer_id, staff_id, product_type, notes, status, created_at)
SELECT c.customer_id, u.user_id, 'Tài khoản số đẹp Như ý Phong thủy',
'Khách hàng đăng ký mở tài khoản đuôi lộc phát 686868 để phục vụ kinh doanh online.',
'COMPLETED', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1;


-- ============================================================================
-- 6. TICKET HỖ TRỢ CSKH (Phục vụ: http://localhost:5173/#/staff/tickets)
-- ============================================================================
INSERT INTO support_tickets (ticket_code, customer_id, assigned_staff_id, title, content, priority, status, created_at)
SELECT 'TK-2026-8001', c.customer_id, u.user_id,
'Hỗ trợ kích hoạt sinh trắc học khuôn mặt theo Quyết định 2345',
'Khách hàng đổi sang điện thoại iPhone mới, quét NFC căn cước CCCD gắn chip bị lỗi không nhận diện.',
'HIGH', 'IN_PROGRESS', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE priority=VALUES(priority);

INSERT INTO support_tickets (ticket_code, customer_id, assigned_staff_id, title, content, priority, status, created_at)
SELECT 'TK-2026-8002', c.customer_id, u.user_id,
'Cần nâng hạn mức chuyển tiền trực tuyến trong ngày lên 1 tỷ',
'Khách hàng cần thanh toán tiền đặt cọc mua căn hộ chung cư trong chiều nay, hạn mức hiện tại 500 triệu/ngày không đủ.',
'URGENT', 'RESOLVED', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE priority=VALUES(priority);

INSERT INTO support_tickets (ticket_code, customer_id, assigned_staff_id, title, content, priority, status, created_at)
SELECT 'TK-2026-8003', c.customer_id, u.user_id,
'Thẻ tín dụng Visa Platinum bị trừ phí thường niên',
'Khách hàng hỏi điều kiện hoàn phí thường niên năm đầu khi chi tiêu đạt mốc 20 triệu đồng theo thể lệ chương trình.',
'MEDIUM', 'RESOLVED', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE priority=VALUES(priority);

INSERT INTO support_tickets (ticket_code, customer_id, assigned_staff_id, title, content, priority, status, created_at)
SELECT 'TK-2026-8004', c.customer_id, u.user_id,
'Cấp lại mã PIN thẻ ghi nợ quốc tế Vietcombank Connect24',
'Khách hàng quên mã PIN thẻ vật lý khi đi du lịch nước ngoài, cần cấp lại mã e-PIN trực tuyến trên app VCB Digibank.',
'HIGH', 'OPEN', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE priority=VALUES(priority);

INSERT INTO support_tickets (ticket_code, customer_id, assigned_staff_id, title, content, priority, status, created_at)
SELECT 'TK-2026-8005', c.customer_id, u.user_id,
'Đăng ký dịch vụ nhận biến động số dư qua tin nhắn OTT miễn phí',
'Khách hàng muốn hủy nhận tin nhắn SMS để chuyển sang nhận thông báo biến động số dư hoàn toàn miễn phí trên app.',
'LOW', 'RESOLVED', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE priority=VALUES(priority);


-- ============================================================================
-- 7. TRA SOÁT KHIẾU NẠI GIAO DỊCH (Phục vụ: http://localhost:5173/#/staff/disputes)
-- ============================================================================
INSERT INTO dispute_requests (dispute_code, customer_id, transaction_code, reason, status, handler_staff_id, resolution_note, created_at)
SELECT 'TS-2026-8001', c.customer_id, 'TXN-2026-889901',
'Rút tiền tại cây ATM Vietcombank Ba Đình tài khoản bị trừ 3.000.000 VNĐ nhưng máy chỉ nhả 2.000.000 VNĐ.',
'APPROVED_REFUND', u.user_id, 'Đã kiểm tra tiếp quỹ ATM, hệ thống thừa 1.000.000 VNĐ. Đã hoàn trả vào tài khoản.', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE status=VALUES(status);

INSERT INTO dispute_requests (dispute_code, customer_id, transaction_code, reason, status, handler_staff_id, resolution_note, created_at)
SELECT 'TS-2026-8002', c.customer_id, 'TXN-2026-889902',
'Quẹt thẻ Visa tại máy POS nhà hàng King BBQ báo lỗi giao dịch nhưng ứng dụng ngân hàng vẫn trừ 1.450.000 VNĐ.',
'APPROVED_REFUND', u.user_id, 'Đã đối soát với bên chấp nhận thanh toán POS, hủy giao dịch lỗi và hoàn tiền.', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE status=VALUES(status);

INSERT INTO dispute_requests (dispute_code, customer_id, transaction_code, reason, status, handler_staff_id, resolution_note, created_at)
SELECT 'TS-2026-8003', c.customer_id, 'TXN-2026-889903',
'Chuyển tiền nhanh 24/7 sang Techcombank người nhận chưa nhận được tiền dù tài khoản Vietcombank đã bị trừ 25.000.000 VNĐ.',
'PROCESSING', u.user_id, 'Đang chờ điện đối soát từ cổng NAPAS và Techcombank.', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE status=VALUES(status);

INSERT INTO dispute_requests (dispute_code, customer_id, transaction_code, reason, status, handler_staff_id, resolution_note, created_at)
SELECT 'TS-2026-8004', c.customer_id, 'TXN-2026-889904',
'Thanh toán đơn hàng Shopee qua cổng Napas bị trừ 2 lần cùng một mã giao dịch 890.000 VNĐ.',
'APPROVED_REFUND', u.user_id, 'Xác nhận trừ tiền trùng lặp, đã hoàn tiền 890.000 VNĐ cho khách hàng.', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE status=VALUES(status);

INSERT INTO dispute_requests (dispute_code, customer_id, transaction_code, reason, status, handler_staff_id, resolution_note, created_at)
SELECT 'TS-2026-8005', c.customer_id, 'TXN-2026-889905',
'Giao dịch lạ trừ tiền 45 USD từ trang thương mại điện tử quốc tế do nghi ngờ bị lộ thông tin thẻ.',
'PROCESSING', u.user_id, 'Đã tạm khóa thẻ quốc tế và gửi tra soát đòi tiền sang tổ chức thẻ quốc tế Visa.', NOW()
FROM customers c, users u WHERE c.username = 'kh_thuha' AND u.username = 'nv_hoangnam' LIMIT 1
ON DUPLICATE KEY UPDATE status=VALUES(status);


-- ============================================================================
-- 8. LỊCH HẸN CHATBOT TIẾP ĐÓN TẠI QUẦY (Phục vụ: http://localhost:5173/#/staff/appointments)
-- ============================================================================
INSERT INTO chatbot_appointments
(appointment_code, full_name, phone_number, email, branch_name, service_type, appointment_date, time_slot, note, status, handled_by, handler_note)
VALUES
('VCB-APT-2026-30001', 'Trần Đình Phong', '0988112244', 'phong.tran@gmail.com', 'Chi nhánh Vietcombank Hoàn Kiếm - Hà Nội', 'Tư vấn hồ sơ vay vốn (Mua nhà/Mua xe/Kinh doanh)', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00 - 10:00', 'Tư vấn gói vay sản xuất kinh doanh hạn mức 1.5 tỷ cho cơ sở chế biến thực phẩm', 'PENDING', NULL, NULL),
('VCB-APT-2026-30002', 'Lê Mỹ Duyên', '0912334455', 'duyen.le@outlook.com', 'Chi nhánh Vietcombank Ba Đình - Hà Nội', 'Phát hành thẻ tín dụng quốc tế', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:30 - 11:30', 'Nhận thẻ vật lý Vietcombank Visa Signature và kích hoạt thanh toán không tiếp xúc', 'CONFIRMED', 'Nguyễn Hoàng Nam', 'Đã liên hệ khách hàng xác nhận khung giờ hẹn tại quầy số 03'),
('VCB-APT-2026-30003', 'Công ty TNHH Đầu tư Minh Long', '0243888777', 'contact@minhlong.vn', 'Chi nhánh Vietcombank Cầu Giấy', 'Dịch vụ Doanh nghiệp & Tài trợ thương mại', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '14:00 - 15:00', 'Mở tài khoản thanh toán số đẹp doanh nghiệp và ký hợp đồng bảo lãnh tạm ứng thầu', 'PENDING', NULL, NULL),
('VCB-APT-2026-30004', 'Nguyễn Hải Đăng', '0903889911', 'haidang@vinamilk.com.vn', 'Chi nhánh Vietcombank Bến Thành - TP.HCM', 'Gửi tiền tiết kiệm & Mở tài khoản', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '15:30 - 16:30', 'Gửi tiết kiệm bậc thang 1.2 tỷ VND, cần được tiếp đón tại quầy Priority VIP', 'CONFIRMED', 'Nguyễn Hoàng Nam', 'Đã thông báo quầy VIP tiếp đón chu đáo'),
('VCB-APT-2026-30005', 'Phạm Ngọc Mai', '0977665544', 'mai.pham@vietjetair.com', 'Chi nhánh Vietcombank Đà Nẵng', 'Tra soát giao dịch & Hỗ trợ ngân hàng số', DATE_ADD(CURDATE(), INTERVAL 3 DAY), '08:30 - 09:30', 'Hỗ trợ quét chip căn cước CCCD và cập nhật dữ liệu sinh trắc học trực tiếp tại quầy', 'COMPLETED', 'Nguyễn Hoàng Nam', 'Đã cập nhật xong dữ liệu sinh trắc học cho khách hàng')
ON DUPLICATE KEY UPDATE note=VALUES(note);


-- ============================================================================
-- 9. TIN TỨC & BÀI VIẾT CMS (Phục vụ: Quản trị tin tức & Cổng thông tin công khai)
-- ============================================================================
INSERT INTO posts (title, slug, summary, content, thumbnail_url, category_id, author_id, status, published_at)
SELECT
'Vietcombank ra mắt tính năng Mở sổ tiết kiệm tích lũy số linh hoạt trên VCB Digibank',
'tiet-kiem-tich-luy-so-vcb-digibank-2026',
'Khách hàng có thể gửi tích lũy định kỳ hàng ngày, hàng tuần hoặc hàng tháng chỉ từ 100.000 VNĐ với mức sinh lời tối ưu.',
'<p>Vietcombank chính thức giới thiệu sản phẩm Tiết kiệm tích lũy số trên ứng dụng VCB Digibank. Với tính năng này, việc tích lũy tài chính trở nên dễ dàng và thông minh hơn bao giờ hết, cho phép cài đặt trích tiền tự động và hưởng lãi suất sinh lời hấp dẫn theo ngày...</p>',
'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800',
1, u.user_id, 'PUBLISHED', NOW()
FROM users u WHERE u.username = 'admin_super' LIMIT 1
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO posts (title, slug, summary, content, thumbnail_url, category_id, author_id, status, published_at)
SELECT
'Giải pháp Tài trợ thương mại số toàn diện cho doanh nghiệp xuất nhập khẩu 2026',
'tai-tro-thuong-mai-so-doanh-nghiep-2026',
'Gói hỗ trợ hạn mức tín dụng 30.000 tỷ đồng với cơ chế phát hành L/C online và bảo lãnh điện tử siêu tốc trong 2 giờ.',
'<p>Đồng hành cùng cộng đồng doanh nghiệp trong xu hướng hội nhập kinh tế toàn cầu, Vietcombank triển khai nền tảng Tài trợ thương mại số (Trade Finance Digital Platform). Nền tảng giúp tối ưu hóa thời gian xử lý phát hành thư tín dụng L/C và bảo lãnh ngân hàng...</p>',
'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
1, u.user_id, 'PUBLISHED', NOW()
FROM users u WHERE u.username = 'admin_super' LIMIT 1
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO posts (title, slug, summary, content, thumbnail_url, category_id, author_id, status, published_at)
SELECT
'Ưu đãi hoàn tiền 15% khi chi tiêu qua thẻ Vietcombank JCB Platinum tại các nhà hàng Nhật Bản',
'uu-dai-hoan-tien-the-jcb-platinum-2026',
'Trải nghiệm ẩm thực tinh hoa xứ sở hoa anh đào với chương trình hoàn tiền hấp dẫn lên tới 1.500.000 VNĐ mỗi tháng.',
'<p>Từ nay đến hết tháng 12/2026, toàn bộ chủ thẻ tín dụng quốc tế Vietcombank JCB Platinum khi thanh toán tại chuỗi nhà hàng ẩm thực Nhật Bản cao cấp trên toàn quốc sẽ được tận hưởng ưu đãi hoàn tiền 15% trực tiếp vào sao kê thẻ tín dụng...</p>',
'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
2, u.user_id, 'PUBLISHED', NOW()
FROM users u WHERE u.username = 'admin_super' LIMIT 1
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO posts (title, slug, summary, content, thumbnail_url, category_id, author_id, status, published_at)
SELECT
'Gói vay mua ô tô điện VinFast: Lãi suất siêu ưu đãi 5.8%/năm đồng hành cùng kỷ nguyên xanh',
'goi-vay-mua-xe-o-to-dien-vinfast-2026',
'Vietcombank liên kết độc quyền hỗ trợ khách hàng vay tới 85% giá trị xe với thời hạn vay linh hoạt đến 8 năm.',
'<p>Nhằm khuyến khích lối sống xanh và phương tiện giao thông thân thiện với môi trường, Vietcombank cùng VinFast triển khai gói tài chính chuyên biệt cho các dòng xe điện thông minh VF3, VF5, VF6, VF7, VF8, VF9 với thủ tục thẩm định trực tuyến giải ngân trong ngày...</p>',
'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=800',
1, u.user_id, 'PUBLISHED', NOW()
FROM users u WHERE u.username = 'admin_super' LIMIT 1
ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO posts (title, slug, summary, content, thumbnail_url, category_id, author_id, status, published_at)
SELECT
'Cảnh báo an toàn bảo mật: Hướng dẫn kích hoạt xác thực sinh trắc học trên ứng dụng VCB Digibank',
'canh-bao-bao-mat-xac-thuc-sinh-trac-hoc-2026',
'Bảo vệ tài sản tài chính tối đa với công nghệ xác thực khuôn mặt khớp nối với cơ sở dữ liệu định danh quốc gia.',
'<p>Thực hiện Quyết định số 2345/QĐ-NHNN của Ngân hàng Nhà nước, Vietcombank khuyến nghị toàn bộ quý khách hàng nhanh chóng cập nhật thông tin sinh trắc học bằng cách quét chip CCCD trên ứng dụng VCB Digibank để đảm bảo giao dịch thông suốt và an toàn bảo mật cao nhất...</p>',
'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800',
3, u.user_id, 'PUBLISHED', NOW()
FROM users u WHERE u.username = 'admin_super' LIMIT 1
ON DUPLICATE KEY UPDATE title=VALUES(title);


-- ============================================================================
-- 10. HỘP THƯ LIÊN HỆ CỔNG THÔNG TIN (contact_messages)
-- ============================================================================
INSERT INTO contact_messages (full_name, phone_number, email, subject, message, status, response_note, created_at)
VALUES
('Nguyễn Văn Tuấn', '0981223344', 'tuan.nguyen@vinatex.com', 'Tìm hiểu gói vay ưu đãi cho doanh nghiệp dệt may xuất khẩu', 'Doanh nghiệp chúng tôi muốn tìm hiểu thủ tục mở L/C và vay vốn lưu động mùa vụ cuối năm với hạn mức 15 tỷ đồng.', 'NEW', NULL, NOW()),
('Trần Mai Hương', '0912445566', 'huong.tran@gmail.com', 'Hỏi về điều kiện phát hành thẻ tín dụng phụ cho người thân', 'Tôi hiện đang sở hữu thẻ Vietcombank Visa Signature, muốn phát hành thêm 01 thẻ phụ cho con gái du học tại Úc.', 'PROCESSING', 'Chuyên viên CSKH đã liên hệ gửi hướng dẫn hồ sơ qua email.', NOW()),
('Lê Quốc Doanh', '0903556677', 'doanh.lq@saigontech.vn', 'Đề nghị liên kết cổng thanh toán trực tuyến cho website thương mại điện tử', 'Công ty chúng tôi cần tích hợp cổng thanh toán Vietcombank Payment Gateway trên nền tảng bán lẻ công nghệ.', 'RESOLVED', 'Đã chuyển thông tin sang Trung tâm Chuyển đổi số & Thanh toán trực tuyến.', NOW()),
('Võ Thị Bích Ngọc', '0978991122', 'bichngoc@fpt.edu.vn', 'Góp ý về tính năng quét NFC căn cước CCCD trên VCB Digibank', 'Đề xuất ngân hàng tối ưu hóa luồng hướng dẫn vị trí đặt chip NFC trên các dòng điện thoại Android để quét nhanh hơn.', 'RESOLVED', 'Đã ghi nhận phản hồi và chuyển giao cho đội ngũ phát triển Mobile App.', NOW()),
('Đoàn Thanh Tùng', '0934778899', 'tung.doan@vietjetair.com', 'Hỏi về hạn mức rút tiền mặt ngoại tệ tại chi nhánh trước khi công tác', 'Tôi có nhu cầu rút 5,000 USD tiền mặt tại chi nhánh Hoàn Kiếm vào thứ Sáu tới, cần chuẩn bị thủ tục giấy tờ gì?', 'NEW', NULL, NOW());


-- ============================================================================
-- 11. BẢNG LỊCH HẸN GIAO DỊCH QUẦY (appointments)
-- ============================================================================
INSERT INTO appointments (appointment_code, full_name, phone_number, email, branch_id, branch_name, service_type, appointment_date, time_slot, note, status, created_at)
VALUES
('APT-2026-90001', 'Trần Văn Kiên', '0988223311', 'kien.tran@gmail.com', 1, 'Chi nhánh Vietcombank Hoàn Kiếm', 'Tư vấn tín dụng bất động sản', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00 - 10:00', 'Vay mua chung cư cao cấp Discovery Complex', 'PENDING', NOW()),
('APT-2026-90002', 'Lê Quỳnh Nga', '0912334488', 'nga.le@outlook.com', 2, 'Chi nhánh Vietcombank Ba Đình', 'Dịch vụ thẻ và Ngân hàng số', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:30 - 11:30', 'Đổi thẻ vật lý sang thẻ gắn chip không tiếp xúc EMV', 'CONFIRMED', NOW()),
('APT-2026-90003', 'Công ty CP Đầu tư Nam Long', '0243666555', 'tckt@namlong.com.vn', 3, 'Chi nhánh Vietcombank TP.HCM - Hội sở Bến Thành', 'Dịch vụ Doanh nghiệp & Vốn lưu động', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '14:00 - 15:00', 'Thẩm định hồ sơ bảo lãnh gói thầu xây dựng 5 tỷ', 'PENDING', NOW()),
('APT-2026-90004', 'Hoàng Minh Châu', '0903778811', 'chau.hoang@vinamilk.com', 4, 'Chi nhánh Vietcombank Bến Thành', 'Gửi tiết kiệm & Mở tài khoản số đẹp', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '15:30 - 16:30', 'Gửi tiết kiệm bậc thang 800 triệu kỳ hạn 18 tháng', 'CONFIRMED', NOW()),
('APT-2026-90005', 'Nguyễn Thị Tuyết Mai', '0977661122', 'mai.nguyen@danang.gov.vn', 5, 'Chi nhánh Vietcombank Đà Nẵng', 'Tra soát và hỗ trợ tài khoản', DATE_ADD(CURDATE(), INTERVAL -1 DAY), '08:30 - 09:30', 'Đăng ký dịch vụ ngân hàng điện tử doanh nghiệp', 'COMPLETED', NOW())
ON DUPLICATE KEY UPDATE note=VALUES(note);


-- ============================================================================
-- 12. LỊCH SỬ XUẤT BÁO CÁO HỆ THỐNG (report_exports)
-- ============================================================================
INSERT INTO report_exports (user_id, report_type, filter_params, file_format, file_path, exported_at)
VALUES
(103, 'Báo cáo Tổng hợp Thẩm định & Phê duyệt Tín dụng Quý 3/2026', '{\"branch\":\"HOAN_KIEM\",\"status\":\"APPROVED\",\"quarter\":\"Q3_2026\"}', 'EXCEL', '/exports/reports/Bao_cao_Tin_dung_Q3_2026.xlsx', NOW()),
(103, 'Báo cáo Thống kê Dòng tiền & Giao dịch Khách hàng Doanh nghiệp', '{\"customer_type\":\"ENTERPRISE\",\"date_range\":\"2026-07-01_to_2026-09-30\"}', 'PDF', '/exports/reports/Thong_ke_Dong_tien_DN_Q3.pdf', NOW()),
(101, 'Báo cáo Kiểm toán Hoạt động & Nhật ký Hệ thống (Security Audit)', '{\"severity\":\"ALL\",\"target_module\":\"RBAC_SECURITY\"}', 'CSV', '/exports/reports/Audit_Logs_Security_2026.csv', NOW()),
(104, 'Báo cáo Thống kê Năng suất Phục vụ Khách hàng tại Quầy', '{\"staff_id\":104,\"month\":\"09_2026\"}', 'EXCEL', '/exports/reports/Nang_suat_Quay_Thang_09.xlsx', NOW()),
(103, 'Báo cáo Tình hình Xử lý Khiếu nại Tra soát Giao dịch Toàn quốc', '{\"status\":\"RESOLVED\",\"quarter\":\"Q3\"}', 'PDF', '/exports/reports/Tra_soat_Khieu_nai_Q3.pdf', NOW());


-- ============================================================================
-- 13. MẠNG LƯỚI CHI NHÁNH MỚI (branches)
-- ============================================================================
INSERT INTO branches (branch_name, address, district, city, phone_number, working_hours)
VALUES
('Chi nhánh Vietcombank Hai Bà Trưng', 'Số 52 phố Lê Đại Hành, phường Lê Đại Hành', 'Quận Hai Bà Trưng', 'Hà Nội', '024.3974.6666', 'Thứ 2 - Thứ 6: 08:00 - 16:30'),
('Chi nhánh Vietcombank Tân Bình', 'Số 108 đường Cộng Hòa, Phường 4', 'Quận Tân Bình', 'TP. Hồ Chí Minh', '028.3811.8888', 'Thứ 2 - Thứ 6: 08:00 - 16:30'),
('Chi nhánh Vietcombank Hải Phòng', 'Số 11 đường Trần Phú, phường Lương Khánh Thiện', 'Quận Ngô Quyền', 'Hải Phòng', '0225.385.9999', 'Thứ 2 - Thứ 6: 08:00 - 16:30'),
('Chi nhánh Vietcombank Bình Dương', 'Số 314 Đại lộ Bình Dương, phường Phú Hòa', 'TP. Thủ Dầu Một', 'Bình Dương', '0274.382.5555', 'Thứ 2 - Thứ 6: 08:00 - 16:30'),
('Chi nhánh Vietcombank Nha Trang', 'Số 17 đường Quang Trung, phường Vạn Thạnh', 'TP. Nha Trang', 'Khánh Hòa', '0258.382.4444', 'Thứ 2 - Thứ 6: 08:00 - 16:30')
ON DUPLICATE KEY UPDATE phone_number=VALUES(phone_number);


-- ============================================================================
-- 14. KỊCH BẢN CHATBOT AI & FAQ (chatbot_faqs)
-- ============================================================================
INSERT INTO chatbot_faqs (category, keywords, question, answer, action_type, created_at)
VALUES
('USER_GUIDE', 'sinh trắc học, 2345, cccd gắn chip, nfc, quét khuôn mặt', 'Hướng dẫn kích hoạt xác thực sinh trắc học theo Quyết định 2345?', 'Quý khách vui lòng mở ứng dụng VCB Digibank -> Chọn Cài đặt -> Cập nhật sinh trắc học -> Đặt chip căn cước CCCD sát lưng điện thoại và thực hiện quét khuôn mặt theo hướng dẫn.', 'NAVIGATE_BIOMETRICS', NOW()),
('CARD_SERVICE', 'kích hoạt thẻ, mở thẻ, e-pin, đổi pin, quên pin', 'Làm thế nào để kích hoạt thẻ tín dụng và cấp lại mã PIN?', 'Quý khách có thể kích hoạt thẻ và tạo mã PIN điện tử (e-PIN) tức thì trên ứng dụng VCB Digibank tại mục Dịch vụ thẻ -> Quản lý dịch vụ thẻ -> Kích hoạt thẻ / Cấp mới PIN.', 'NAVIGATE_CARD_PIN', NOW()),
('LOAN_SERVICE', 'vay mua ô tô điện vinfast, vf8, vf9, lãi suất ưu đãi', 'Gói vay mua ô tô điện VinFast của Vietcombank có ưu đãi gì?', 'Vietcombank hỗ trợ vay tới 85% giá trị xe trong thời gian tối đa 8 năm, lãi suất ưu đãi cố định chỉ từ 5.8%/năm, miễn phí sạc pin tại trạm sạc công cộng trong 2 năm.', 'NAVIGATE_AUTO_LOAN', NOW()),
('RATES', 'lãi suất tiết kiệm cao nhất, gửi online, tích lũy', 'Lãi suất gửi tiết kiệm Online cao nhất tại Vietcombank là bao nhiêu?', 'Lãi suất tiết kiệm trực tuyến trên VCB Digibank hiện nay lên tới 7.2%/năm đối với kỳ hạn từ 24 tháng trở lên, cộng thêm ưu đãi lãi suất bậc thang cho số tiền gửi từ 100 triệu.', 'NAVIGATE_SAVINGS', NOW()),
('APPOINTMENT', 'đặt lịch hẹn quầy, tiếp đón ưu tiên, không chờ đợi', 'Làm sao để đặt lịch hẹn tiếp đón tại quầy giao dịch chi nhánh?', 'Quý khách có thể chọn trực tiếp Đặt lịch hẹn trên màn hình Chatbot AI này hoặc vào Cổng thông tin Vietcombank -> Chọn chi nhánh, khung giờ và dịch vụ để được phục vụ tại quầy ưu tiên.', 'OPEN_APPOINTMENT_MODAL', NOW());


-- ============================================================================
-- 15. BANNER CỔNG THÔNG TIN SỐ (portal_banners)
-- ============================================================================
INSERT INTO portal_banners (title, subtitle, image_url, target_url, display_order, is_active, created_at)
VALUES
('VCB Digibank thế hệ mới 2026', 'Tận hưởng tiện ích ngân hàng số vượt trội với trợ lý ảo AI thông minh', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=1200', '/#/customer/dashboard', 1, 1, NOW()),
('Gói vay mua ô tô điện Xanh', 'Lãi suất cố định 5.8%/năm cùng giải ngân siêu tốc trong 4 giờ', 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=1200', '/#/customer/loans/auto', 2, 1, NOW()),
('Thẻ Vietcombank Visa Signature', 'Đặc quyền phòng chờ thương gia quốc tế và hoàn tiền 15% ẩm thực', 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200', '/#/customer/cards', 3, 1, NOW()),
('Tiết kiệm tích lũy số linh hoạt', 'Sinh lời tối ưu theo ngày với lãi suất hấp dẫn lên tới 7.2%/năm', 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=1200', '/#/customer/savings', 4, 1, NOW()),
('Nền tảng Tài trợ thương mại số', 'Phát hành L/C online và cấp bảo lãnh thầu điện tử tức thì cho DN', 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200', '/#/customer/trade-finance', 5, 1, NOW());


-- ============================================================================
-- 16. TÀI LIỆU ĐÍNH KÈM BÀI VIẾT CMS (post_attachments)
-- ============================================================================
INSERT INTO post_attachments (post_id, file_name, file_url, file_type, file_size, created_at)
VALUES
(1, 'Dieu_khoan_goi_tin_dung_uu_dai_100k_ty.pdf', '/uploads/attachments/Dieu_khoan_tin_dung_100k_ty.pdf', 'PDF', 1048576, NOW()),
(2, 'Huong_dan_kich_hoat_sinh_trac_hoc_VCB_Digibank.pdf', '/uploads/attachments/HD_Sinh_trac_hoc_2345.pdf', 'PDF', 2097152, NOW()),
(3, 'Bieu_lai_suat_tiet_kiem_chuan_thang_09_2026.xlsx', '/uploads/attachments/Lai_suat_VCB_09_2026.xlsx', 'EXCEL', 524288, NOW()),
(4, 'The_le_chuong_trinh_hoan_tien_Visa_Signature.pdf', '/uploads/attachments/The_le_hoan_tien_Visa_Signature.pdf', 'PDF', 840000, NOW()),
(5, 'Chinh_sach_Zero_Fee_mien_phi_chuyen_tien_2026.pdf', '/uploads/attachments/Chinh_sach_Zero_Fee_2026.pdf', 'PDF', 612000, NOW());


-- ============================================================================
-- 17. LỊCH TRẢ NỢ GỐC VÀ LÃI (loan_schedules)
-- ============================================================================
INSERT INTO loan_schedules (loan_app_id, period_number, due_date, principal_amount, interest_amount, total_payment)
VALUES
(1, 1, DATE_ADD(CURDATE(), INTERVAL 1 MONTH), 10000000.00, 4250000.00, 14250000.00),
(1, 2, DATE_ADD(CURDATE(), INTERVAL 2 MONTH), 10000000.00, 4180000.00, 14180000.00),
(1, 3, DATE_ADD(CURDATE(), INTERVAL 3 MONTH), 10000000.00, 4110000.00, 14110000.00),
(1, 4, DATE_ADD(CURDATE(), INTERVAL 4 MONTH), 10000000.00, 4040000.00, 14040000.00),
(1, 5, DATE_ADD(CURDATE(), INTERVAL 5 MONTH), 10000000.00, 3970000.00, 13970000.00);


-- ============================================================================
-- 18. TÀI SẢN BẢO ĐẢM THẾ CHẤP (loan_collaterals)
-- ============================================================================
INSERT INTO loan_collaterals (loan_app_id, collateral_type, collateral_name, estimated_value, document_proof_url)
VALUES
(1, 'REAL_ESTATE', 'Giấy chứng nhận QSD đất & Nhà ở 85m2 tại KĐT Gamuda Gardens, Q. Hoàng Mai, Hà Nội', 5800000000.00, '/uploads/collaterals/so_do_gamuda.pdf'),
(2, 'SAVING_BOOK', 'Sổ tiết kiệm kỳ hạn 12 tháng tại Vietcombank Chi nhánh Hoàn Kiếm', 800000000.00, '/uploads/collaterals/so_tiet_kiem_800tr.pdf'),
(3, 'REAL_ESTATE', 'Căn hộ chung cư Masteri Centre Point số A12-08, TP. Thủ Đức, TP.HCM', 4200000000.00, '/uploads/collaterals/hop_dong_can_ho_masteri.pdf'),
(5, 'CAR', 'Xe ô tô VinFast VF8 Plus Dual Motor biển số 30K-888.99', 1270000000.00, '/uploads/collaterals/dang_ky_xe_vf8.pdf'),
(6, 'CAR', 'Xe ô tô Mercedes-Benz C300 AMG model 2026', 2099000000.00, '/uploads/collaterals/dang_ky_xe_mercedes.pdf');


-- ============================================================================
-- 19. HỒ SƠ CHỨNG TỪ ĐÍNH KÈM KHOẢN VAY (application_documents)
-- ============================================================================
INSERT INTO application_documents (application_id, document_name, file_url, uploaded_at)
VALUES
(1001, 'Hợp đồng lao động không xác định thời hạn & Giấy xác nhận thu nhập', '/uploads/docs/HDLD_Xac_nhan_thu_nhap.pdf', NOW()),
(1002, 'Sao kê tài khoản ngân hàng nhận lương 6 tháng gần nhất', '/uploads/docs/Sao_ke_luong_6_thang.pdf', NOW()),
(1003, 'Báo cáo kiểm toán tài chính và Tờ khai thuế doanh nghiệp năm 2025', '/uploads/docs/BCTC_Kiem_toan_2025.pdf', NOW()),
(1004, 'Hợp đồng mua bán căn hộ chung cư có công chứng', '/uploads/docs/HD_Mua_ban_can_ho_cong_chung.pdf', NOW()),
(1005, 'Giấy phép đăng ký kinh doanh và Điều lệ công ty', '/uploads/docs/GPKD_Dieu_le_doanh_nghiep.pdf', NOW());


-- ============================================================================
-- 20. NHẬT KÝ TRAO ĐỔI XỬ LÝ TICKET CSKH (support_ticket_logs)
-- ============================================================================
INSERT INTO support_ticket_logs (ticket_id, staff_id, action_note, created_at)
VALUES
(1, 104, 'Đã liên hệ khách hàng qua điện thoại, hướng dẫn quy trình xác thực CCCD gắn chip qua NFC thành công.', NOW()),
(2, 104, 'Đã kiểm tra hệ thống thẻ quốc tế, thẻ khách hàng hoạt động bình thường, không ghi nhận mã lỗi khóa.', NOW()),
(3, 104, 'Đã hỗ trợ điều chỉnh nâng hạn mức chuyển khoản tạm thời trong ngày lên 1 tỷ đồng theo giấy đề nghị của khách.', NOW()),
(4, 104, 'Đã phối hợp với phòng Kế toán quỹ hoàn tất hoàn trả khoản phí thường niên thẻ do đạt doanh số chi tiêu.', NOW()),
(5, 104, 'Đã hoàn tất cấp mã e-PIN trực tuyến mới cho khách hàng trên hệ thống ngân hàng số.', NOW());


-- ============================================================================
-- 21. NHẬT KÝ QUYẾT ĐỊNH PHÊ DUYỆT CỦA QUẢN LÝ (application_approvals)
-- ============================================================================
INSERT INTO application_approvals (application_id, manager_id, action, reason_note, processed_at)
VALUES
(1001, 103, 'APPROVED', 'Khách hàng có lịch sử tín dụng CIC nhóm 1 chuẩn, thu nhập chuyển khoản ổn định trên 35 triệu/tháng.', NOW()),
(1002, 103, 'APPROVED', 'Hồ sơ tài sản bảo đảm pháp lý minh bạch, thẩm định giá trị tài sản vượt 150% hạn mức vay đề xuất.', NOW()),
(1003, 103, 'REQUEST_DOCS', 'Yêu cầu doanh nghiệp bổ sung phụ lục hợp đồng thương mại xuất khẩu Quý 4/2026.', NOW()),
(1004, 103, 'APPROVED', 'Phê duyệt hạn mức cấp thẻ tín dụng đen Vietcombank Visa Signature 120 triệu đồng.', NOW()),
(1005, 103, 'APPROVED', 'Duyệt phương án tài trợ vốn lưu động ngắn hạn cho doanh nghiệp, lãi suất 7.2%/năm.', NOW());


-- ============================================================================
-- 22. NHẬT KÝ KIỂM TOÁN HỆ THỐNG (audit_logs)
-- ============================================================================
INSERT INTO audit_logs (user_id, action_type, module_name, ip_address, user_agent, status, description, created_at)
VALUES
(101, 'SECURITY_CONFIG_UPDATE', 'SYSTEM_SECURITY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'SUCCESS', 'Admin Super kích hoạt chính sách bắt buộc xác thực 2FA qua OTP cho toàn bộ cán bộ', NOW()),
(103, 'CREDIT_APPROVAL_DECISION', 'APPROVAL_MODULE', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'SUCCESS', 'Quản lý Minh Tuấn phê duyệt hồ sơ vay mua ô tô điện VinFast VF8 hạn mức 750 triệu', NOW()),
(104, 'CASH_DEPOSIT_TRANSACTION', 'STAFF_COUNTER', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'SUCCESS', 'Giao dịch viên Hoàng Nam thực hiện lệnh nộp tiền mặt 50.000.000 đ tại quầy số 02', NOW()),
(104, 'CUSTOMER_ADVISORY_CREATE', 'STAFF_CRM', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'SUCCESS', 'Ghi nhận phiếu tư vấn giải pháp bảo hiểm FWD liên kết đầu tư cho khách hàng VIP', NOW()),
(103, 'EXPORT_EXCEL_REPORT', 'REPORT_MODULE', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'SUCCESS', 'Quản lý xuất báo cáo tổng hợp thẩm định và chỉ số tăng trưởng tín dụng Quý 3/2026', NOW());

