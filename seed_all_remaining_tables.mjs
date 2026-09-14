import mysql from 'mysql2/promise';

async function seedAllRemaining() {
  console.log('🚀 Bắt đầu nạp 5 bản ghi cho toàn bộ các bảng còn lại trong database admin_portal_db...');

  const conn = await mysql.createConnection({
    host: '100.86.222.38',
    port: 3306,
    user: 'root',
    password: '1',
    database: 'admin_portal_db'
  });

  try {
    // -------------------------------------------------------------------------
    // 1. contact_messages (5 bản ghi - Hộp thư liên hệ của Cổng thông tin)
    // -------------------------------------------------------------------------
    console.log('\n--- 1. Bảng contact_messages (Hộp thư liên hệ khách hàng) ---');
    const contactSql = `
      INSERT INTO contact_messages (full_name, phone_number, email, subject, message, status, response_note, created_at)
      VALUES
      ('Nguyễn Văn Tuấn', '0981223344', 'tuan.nguyen@vinatex.com', 'Tìm hiểu gói vay ưu đãi cho doanh nghiệp dệt may xuất khẩu', 'Doanh nghiệp chúng tôi muốn tìm hiểu thủ tục mở L/C và vay vốn lưu động mùa vụ cuối năm với hạn mức 15 tỷ đồng.', 'NEW', NULL, NOW()),
      ('Trần Mai Hương', '0912445566', 'huong.tran@gmail.com', 'Hỏi về điều kiện phát hành thẻ tín dụng phụ cho người thân', 'Tôi hiện đang sở hữu thẻ Vietcombank Visa Signature, muốn phát hành thêm 01 thẻ phụ cho con gái du học tại Úc.', 'PROCESSING', 'Chuyên viên CSKH đã liên hệ gửi hướng dẫn hồ sơ qua email.', NOW()),
      ('Lê Quốc Doanh', '0903556677', 'doanh.lq@saigontech.vn', 'Đề nghị liên kết cổng thanh toán trực tuyến cho website thương mại điện tử', 'Công ty chúng tôi cần tích hợp cổng thanh toán Vietcombank Payment Gateway trên nền tảng bán lẻ công nghệ.', 'RESOLVED', 'Đã chuyển thông tin sang Trung tâm Chuyển đổi số & Thanh toán trực tuyến.', NOW()),
      ('Võ Thị Bích Ngọc', '0978991122', 'bichngoc@fpt.edu.vn', 'Góp ý về tính năng quét NFC căn cước CCCD trên VCB Digibank', 'Đề xuất ngân hàng tối ưu hóa luồng hướng dẫn vị trí đặt chip NFC trên các dòng điện thoại Android để quét nhanh hơn.', 'RESOLVED', 'Đã ghi nhận phản hồi và chuyển giao cho đội ngũ phát triển Mobile App.', NOW()),
      ('Đoàn Thanh Tùng', '0934778899', 'tung.doan@vietjetair.com', 'Hỏi về hạn mức rút tiền mặt ngoại tệ tại chi nhánh trước khi công tác', 'Tôi có nhu cầu rút 5,000 USD tiền mặt tại chi nhánh Hoàn Kiếm vào thứ Sáu tới, cần chuẩn bị thủ tục giấy tờ gì?', 'NEW', NULL, NOW());
    `;
    await conn.query(contactSql);
    console.log('  ✅ Đã thêm 5 liên hệ vào contact_messages');

    // -------------------------------------------------------------------------
    // 2. appointments (5 bản ghi - Bảng lịch hẹn giao dịch)
    // -------------------------------------------------------------------------
    console.log('\n--- 2. Bảng appointments (Lịch hẹn giao dịch tại quầy) ---');
    const apptSql = `
      INSERT INTO appointments (appointment_code, full_name, phone_number, email, branch_id, branch_name, service_type, appointment_date, time_slot, note, status, created_at)
      VALUES
      ('APT-2026-90001', 'Trần Văn Kiên', '0988223311', 'kien.tran@gmail.com', 1, 'Chi nhánh Vietcombank Hoàn Kiếm', 'Tư vấn tín dụng bất động sản', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00 - 10:00', 'Vay mua chung cư cao cấp Discovery Complex', 'PENDING', NOW()),
      ('APT-2026-90002', 'Lê Quỳnh Nga', '0912334488', 'nga.le@outlook.com', 2, 'Chi nhánh Vietcombank Ba Đình', 'Dịch vụ thẻ và Ngân hàng số', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:30 - 11:30', 'Đổi thẻ vật lý sang thẻ gắn chip không tiếp xúc EMV', 'CONFIRMED', NOW()),
      ('APT-2026-90003', 'Công ty CP Đầu tư Nam Long', '0243666555', 'tckt@namlong.com.vn', 3, 'Chi nhánh Vietcombank TP.HCM - Hội sở Bến Thành', 'Dịch vụ Doanh nghiệp & Vốn lưu động', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '14:00 - 15:00', 'Thẩm định hồ sơ bảo lãnh gói thầu xây dựng 5 tỷ', 'PENDING', NOW()),
      ('APT-2026-90004', 'Hoàng Minh Châu', '0903778811', 'chau.hoang@vinamilk.com', 4, 'Chi nhánh Vietcombank Bến Thành', 'Gửi tiết kiệm & Mở tài khoản số đẹp', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '15:30 - 16:30', 'Gửi tiết kiệm bậc thang 800 triệu kỳ hạn 18 tháng', 'CONFIRMED', NOW()),
      ('APT-2026-90005', 'Nguyễn Thị Tuyết Mai', '0977661122', 'mai.nguyen@danang.gov.vn', 5, 'Chi nhánh Vietcombank Đà Nẵng', 'Tra soát và hỗ trợ tài khoản', DATE_ADD(CURDATE(), INTERVAL -1 DAY), '08:30 - 09:30', 'Đăng ký dịch vụ ngân hàng điện tử doanh nghiệp', 'COMPLETED', NOW())
      ON DUPLICATE KEY UPDATE note=VALUES(note);
    `;
    await conn.query(apptSql);
    console.log('  ✅ Đã thêm 5 lịch hẹn vào appointments');

    // -------------------------------------------------------------------------
    // 3. report_exports (5 bản ghi - Lịch sử xuất báo cáo KPI / Excel / PDF)
    // -------------------------------------------------------------------------
    console.log('\n--- 3. Bảng report_exports (Lịch sử xuất báo cáo hệ thống) ---');
    const reportSql = `
      INSERT INTO report_exports (user_id, report_type, filter_params, file_format, file_path, exported_at)
      VALUES
      (103, 'Báo cáo Tổng hợp Thẩm định & Phê duyệt Tín dụng Quý 3/2026', '{\"branch\":\"HOAN_KIEM\",\"status\":\"APPROVED\",\"quarter\":\"Q3_2026\"}', 'EXCEL', '/exports/reports/Bao_cao_Tin_dung_Q3_2026.xlsx', NOW()),
      (103, 'Báo cáo Thống kê Dòng tiền & Giao dịch Khách hàng Doanh nghiệp', '{\"customer_type\":\"ENTERPRISE\",\"date_range\":\"2026-07-01_to_2026-09-30\"}', 'PDF', '/exports/reports/Thong_ke_Dong_tien_DN_Q3.pdf', NOW()),
      (101, 'Báo cáo Kiểm toán Hoạt động & Nhật ký Hệ thống (Security Audit)', '{\"severity\":\"ALL\",\"target_module\":\"RBAC_SECURITY\"}', 'CSV', '/exports/reports/Audit_Logs_Security_2026.csv', NOW()),
      (104, 'Báo cáo Thống kê Năng suất Phục vụ Khách hàng tại Quầy', '{\"staff_id\":104,\"month\":\"09_2026\"}', 'EXCEL', '/exports/reports/Nang_suat_Quay_Thang_09.xlsx', NOW()),
      (103, 'Báo cáo Tình hình Xử lý Khiếu nại Tra soát Giao dịch Toàn quốc', '{\"status\":\"RESOLVED\",\"quarter\":\"Q3\"}', 'PDF', '/exports/reports/Tra_soat_Khieu_nai_Q3.pdf', NOW());
    `;
    await conn.query(reportSql);
    console.log('  ✅ Đã thêm 5 báo cáo vào report_exports');

    // -------------------------------------------------------------------------
    // 4. branches (5 chi nhánh ngân hàng mới)
    // -------------------------------------------------------------------------
    console.log('\n--- 4. Bảng branches (Mạng lưới chi nhánh Vietcombank) ---');
    const branchSql = `
      INSERT INTO branches (branch_name, address, district, city, phone_number, working_hours)
      VALUES
      ('Chi nhánh Vietcombank Hai Bà Trưng', 'Số 52 phố Lê Đại Hành, phường Lê Đại Hành', 'Quận Hai Bà Trưng', 'Hà Nội', '024.3974.6666', 'Thứ 2 - Thứ 6: 08:00 - 16:30'),
      ('Chi nhánh Vietcombank Tân Bình', 'Số 108 đường Cộng Hòa, Phường 4', 'Quận Tân Bình', 'TP. Hồ Chí Minh', '028.3811.8888', 'Thứ 2 - Thứ 6: 08:00 - 16:30'),
      ('Chi nhánh Vietcombank Hải Phòng', 'Số 11 đường Trần Phú, phường Lương Khánh Thiện', 'Quận Ngô Quyền', 'Hải Phòng', '0225.385.9999', 'Thứ 2 - Thứ 6: 08:00 - 16:30'),
      ('Chi nhánh Vietcombank Bình Dương', 'Số 314 Đại lộ Bình Dương, phường Phú Hòa', 'TP. Thủ Dầu Một', 'Bình Dương', '0274.382.5555', 'Thứ 2 - Thứ 6: 08:00 - 16:30'),
      ('Chi nhánh Vietcombank Nha Trang', 'Số 17 đường Quang Trung, phường Vạn Thạnh', 'TP. Nha Trang', 'Khánh Hòa', '0258.382.4444', 'Thứ 2 - Thứ 6: 08:00 - 16:30')
      ON DUPLICATE KEY UPDATE phone_number=VALUES(phone_number);
    `;
    await conn.query(branchSql);
    console.log('  ✅ Đã thêm 5 chi nhánh vào branches');

    // -------------------------------------------------------------------------
    // 5. chatbot_faqs (5 câu hỏi & kịch bản Chatbot AI mới)
    // -------------------------------------------------------------------------
    console.log('\n--- 5. Bảng chatbot_faqs (Kịch bản Chatbot AI ngân hàng) ---');
    const faqSql = `
      INSERT INTO chatbot_faqs (category, keywords, question, answer, action_type, created_at)
      VALUES
      ('USER_GUIDE', 'sinh trắc học, 2345, cccd gắn chip, nfc, quét khuôn mặt', 'Hướng dẫn kích hoạt xác thực sinh trắc học theo Quyết định 2345?', 'Quý khách vui lòng mở ứng dụng VCB Digibank -> Chọn Cài đặt -> Cập nhật sinh trắc học -> Đặt chip căn cước CCCD sát lưng điện thoại và thực hiện quét khuôn mặt theo hướng dẫn.', 'NAVIGATE_BIOMETRICS', NOW()),
      ('CARD_SERVICE', 'kích hoạt thẻ, mở thẻ, e-pin, đổi pin, quên pin', 'Làm thế nào để kích hoạt thẻ tín dụng và cấp lại mã PIN?', 'Quý khách có thể kích hoạt thẻ và tạo mã PIN điện tử (e-PIN) tức thì trên ứng dụng VCB Digibank tại mục Dịch vụ thẻ -> Quản lý dịch vụ thẻ -> Kích hoạt thẻ / Cấp mới PIN.', 'NAVIGATE_CARD_PIN', NOW()),
      ('LOAN_SERVICE', 'vay mua ô tô điện vinfast, vf8, vf9, lãi suất ưu đãi', 'Gói vay mua ô tô điện VinFast của Vietcombank có ưu đãi gì?', 'Vietcombank hỗ trợ vay tới 85% giá trị xe trong thời gian tối đa 8 năm, lãi suất ưu đãi cố định chỉ từ 5.8%/năm, miễn phí sạc pin tại trạm sạc công cộng trong 2 năm.', 'NAVIGATE_AUTO_LOAN', NOW()),
      ('RATES', 'lãi suất tiết kiệm cao nhất, gửi online, tích lũy', 'Lãi suất gửi tiết kiệm Online cao nhất tại Vietcombank là bao nhiêu?', 'Lãi suất tiết kiệm trực tuyến trên VCB Digibank hiện nay lên tới 7.2%/năm đối với kỳ hạn từ 24 tháng trở lên, cộng thêm ưu đãi lãi suất bậc thang cho số tiền gửi từ 100 triệu.', 'NAVIGATE_SAVINGS', NOW()),
      ('APPOINTMENT', 'đặt lịch hẹn quầy, tiếp đón ưu tiên, không chờ đợi', 'Làm sao để đặt lịch hẹn tiếp đón tại quầy giao dịch chi nhánh?', 'Quý khách có thể chọn trực tiếp Đặt lịch hẹn trên màn hình Chatbot AI này hoặc vào Cổng thông tin Vietcombank -> Chọn chi nhánh, khung giờ và dịch vụ để được phục vụ tại quầy ưu tiên.', 'OPEN_APPOINTMENT_MODAL', NOW());
    `;
    await conn.query(faqSql);
    console.log('  ✅ Đã thêm 5 câu hỏi vào chatbot_faqs');

    // -------------------------------------------------------------------------
    // 6. portal_banners (5 banner truyền thông Cổng thông tin số)
    // -------------------------------------------------------------------------
    console.log('\n--- 6. Bảng portal_banners (Banner Cổng thông tin khách hàng) ---');
    const bannerSql = `
      INSERT INTO portal_banners (title, subtitle, image_url, target_url, display_order, is_active, created_at)
      VALUES
      ('VCB Digibank thế hệ mới 2026', 'Tận hưởng tiện ích ngân hàng số vượt trội với trợ lý ảo AI thông minh', 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=1200', '/#/customer/dashboard', 1, 1, NOW()),
      ('Gói vay mua ô tô điện Xanh', 'Lãi suất cố định 5.8%/năm cùng giải ngân siêu tốc trong 4 giờ', 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=1200', '/#/customer/loans/auto', 2, 1, NOW()),
      ('Thẻ Vietcombank Visa Signature', 'Đặc quyền phòng chờ thương gia quốc tế và hoàn tiền 15% ẩm thực', 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200', '/#/customer/cards', 3, 1, NOW()),
      ('Tiết kiệm tích lũy số linh hoạt', 'Sinh lời tối ưu theo ngày với lãi suất hấp dẫn lên tới 7.2%/năm', 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=1200', '/#/customer/savings', 4, 1, NOW()),
      ('Nền tảng Tài trợ thương mại số', 'Phát hành L/C online và cấp bảo lãnh thầu điện tử tức thì cho DN', 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200', '/#/customer/trade-finance', 5, 1, NOW());
    `;
    await conn.query(bannerSql);
    console.log('  ✅ Đã thêm 5 banner vào portal_banners');

    // -------------------------------------------------------------------------
    // 7. post_attachments (5 tài liệu đính kèm bài viết tin tức)
    // -------------------------------------------------------------------------
    console.log('\n--- 7. Bảng post_attachments (Tài liệu đính kèm bài viết CMS) ---');
    const attachSql = `
      INSERT INTO post_attachments (post_id, file_name, file_url, file_type, file_size, created_at)
      VALUES
      (1, 'Dieu_khoan_goi_tin_dung_uu_dai_100k_ty.pdf', '/uploads/attachments/Dieu_khoan_tin_dung_100k_ty.pdf', 'PDF', 1048576, NOW()),
      (2, 'Huong_dan_kich_hoat_sinh_trac_hoc_VCB_Digibank.pdf', '/uploads/attachments/HD_Sinh_trac_hoc_2345.pdf', 'PDF', 2097152, NOW()),
      (3, 'Bieu_lai_suat_tiet_kiem_chuan_thang_09_2026.xlsx', '/uploads/attachments/Lai_suat_VCB_09_2026.xlsx', 'EXCEL', 524288, NOW()),
      (4, 'The_le_chuong_trinh_hoan_tien_Visa_Signature.pdf', '/uploads/attachments/The_le_hoan_tien_Visa_Signature.pdf', 'PDF', 840000, NOW()),
      (5, 'Chinh_sach_Zero_Fee_mien_phi_chuyen_tien_2026.pdf', '/uploads/attachments/Chinh_sach_Zero_Fee_2026.pdf', 'PDF', 612000, NOW());
    `;
    await conn.query(attachSql);
    console.log('  ✅ Đã thêm 5 tệp đính kèm vào post_attachments');

    // -------------------------------------------------------------------------
    // 8. loan_schedules (5 kỳ trả nợ cho khoản vay cá nhân)
    // -------------------------------------------------------------------------
    console.log('\n--- 8. Bảng loan_schedules (Lịch trả nợ gốc và lãi chi tiết) ---');
    const scheduleSql = `
      INSERT INTO loan_schedules (loan_app_id, period_number, due_date, principal_amount, interest_amount, total_payment)
      VALUES
      (1, 1, DATE_ADD(CURDATE(), INTERVAL 1 MONTH), 10000000.00, 4250000.00, 14250000.00),
      (1, 2, DATE_ADD(CURDATE(), INTERVAL 2 MONTH), 10000000.00, 4180000.00, 14180000.00),
      (1, 3, DATE_ADD(CURDATE(), INTERVAL 3 MONTH), 10000000.00, 4110000.00, 14110000.00),
      (1, 4, DATE_ADD(CURDATE(), INTERVAL 4 MONTH), 10000000.00, 4040000.00, 14040000.00),
      (1, 5, DATE_ADD(CURDATE(), INTERVAL 5 MONTH), 10000000.00, 3970000.00, 13970000.00);
    `;
    await conn.query(scheduleSql);
    console.log('  ✅ Đã thêm 5 kỳ trả nợ vào loan_schedules');

    // -------------------------------------------------------------------------
    // 9. loan_collaterals (5 tài sản bảo đảm thế chấp hợp chuẩn)
    // -------------------------------------------------------------------------
    console.log('\n--- 9. Bảng loan_collaterals (Tài sản bảo đảm thế chấp) ---');
    const colSql = `
      INSERT INTO loan_collaterals (loan_app_id, collateral_type, collateral_name, estimated_value, document_proof_url)
      VALUES
      (1, 'REAL_ESTATE', 'Giấy chứng nhận QSD đất & Nhà ở 85m2 tại KĐT Gamuda Gardens, Q. Hoàng Mai, Hà Nội', 5800000000.00, '/uploads/collaterals/so_do_gamuda.pdf'),
      (2, 'SAVING_BOOK', 'Sổ tiết kiệm kỳ hạn 12 tháng tại Vietcombank Chi nhánh Hoàn Kiếm', 800000000.00, '/uploads/collaterals/so_tiet_kiem_800tr.pdf'),
      (3, 'REAL_ESTATE', 'Căn hộ chung cư Masteri Centre Point số A12-08, TP. Thủ Đức, TP.HCM', 4200000000.00, '/uploads/collaterals/hop_dong_can_ho_masteri.pdf'),
      (5, 'CAR', 'Xe ô tô VinFast VF8 Plus Dual Motor biển số 30K-888.99', 1270000000.00, '/uploads/collaterals/dang_ky_xe_vf8.pdf'),
      (6, 'CAR', 'Xe ô tô Mercedes-Benz C300 AMG model 2026', 2099000000.00, '/uploads/collaterals/dang_ky_xe_mercedes.pdf');
    `;
    await conn.query(colSql);
    console.log('  ✅ Đã thêm 5 tài sản bảo đảm vào loan_collaterals');

    // -------------------------------------------------------------------------
    // 10. application_documents (5 hồ sơ chứng từ pháp lý & tài chính)
    // -------------------------------------------------------------------------
    console.log('\n--- 10. Bảng application_documents (Hồ sơ chứng từ đính kèm) ---');
    const docSql = `
      INSERT INTO application_documents (application_id, document_name, file_url, uploaded_at)
      VALUES
      (1001, 'Hợp đồng lao động không xác định thời hạn & Giấy xác nhận thu nhập', '/uploads/docs/HDLD_Xac_nhan_thu_nhap.pdf', NOW()),
      (1002, 'Sao kê tài khoản ngân hàng nhận lương 6 tháng gần nhất', '/uploads/docs/Sao_ke_luong_6_thang.pdf', NOW()),
      (1003, 'Báo cáo kiểm toán tài chính và Tờ khai thuế doanh nghiệp năm 2025', '/uploads/docs/BCTC_Kiem_toan_2025.pdf', NOW()),
      (1004, 'Hợp đồng mua bán căn hộ chung cư có công chứng', '/uploads/docs/HD_Mua_ban_can_ho_cong_chung.pdf', NOW()),
      (1005, 'Giấy phép đăng ký kinh doanh và Điều lệ công ty', '/uploads/docs/GPKD_Dieu_le_doanh_nghiep.pdf', NOW());
    `;
    await conn.query(docSql);
    console.log('  ✅ Đã thêm 5 chứng từ vào application_documents');

    // -------------------------------------------------------------------------
    // 11. support_ticket_logs (5 nhật ký trao đổi hỗ trợ CSKH)
    // -------------------------------------------------------------------------
    console.log('\n--- 11. Bảng support_ticket_logs (Nhật ký xử lý Ticket CSKH) ---');
    const ticketLogSql = `
      INSERT INTO support_ticket_logs (ticket_id, staff_id, action_note, created_at)
      VALUES
      (1, 104, 'Đã liên hệ khách hàng qua điện thoại, hướng dẫn quy trình xác thực CCCD gắn chip qua NFC thành công.', NOW()),
      (2, 104, 'Đã kiểm tra hệ thống thẻ quốc tế, thẻ khách hàng hoạt động bình thường, không ghi nhận mã lỗi khóa.', NOW()),
      (3, 104, 'Đã hỗ trợ điều chỉnh nâng hạn mức chuyển khoản tạm thời trong ngày lên 1 tỷ đồng theo giấy đề nghị của khách.', NOW()),
      (4, 104, 'Đã phối hợp với phòng Kế toán quỹ hoàn tất hoàn trả khoản phí thường niên thẻ do đạt doanh số chi tiêu.', NOW()),
      (5, 104, 'Đã hoàn tất cấp mã e-PIN trực tuyến mới cho khách hàng trên hệ thống ngân hàng số.', NOW());
    `;
    await conn.query(ticketLogSql);
    console.log('  ✅ Đã thêm 5 nhật ký vào support_ticket_logs');

    // -------------------------------------------------------------------------
    // 12. application_approvals (5 quyết định phê duyệt của Quản lý)
    // -------------------------------------------------------------------------
    console.log('\n--- 12. Bảng application_approvals (Nhật ký phê duyệt tín dụng của Quản lý) ---');
    const appApprSql = `
      INSERT INTO application_approvals (application_id, manager_id, action, reason_note, processed_at)
      VALUES
      (1001, 103, 'APPROVED', 'Khách hàng có lịch sử tín dụng CIC nhóm 1 chuẩn, thu nhập chuyển khoản ổn định trên 35 triệu/tháng.', NOW()),
      (1002, 103, 'APPROVED', 'Hồ sơ tài sản bảo đảm pháp lý minh bạch, thẩm định giá trị tài sản vượt 150% hạn mức vay đề xuất.', NOW()),
      (1003, 103, 'REQUEST_DOCS', 'Yêu cầu doanh nghiệp bổ sung phụ lục hợp đồng thương mại xuất khẩu Quý 4/2026.', NOW()),
      (1004, 103, 'APPROVED', 'Phê duyệt hạn mức cấp thẻ tín dụng đen Vietcombank Visa Signature 120 triệu đồng.', NOW()),
      (1005, 103, 'APPROVED', 'Duyệt phương án tài trợ vốn lưu động ngắn hạn cho doanh nghiệp, lãi suất 7.2%/năm.', NOW());
    `;
    await conn.query(appApprSql);
    console.log('  ✅ Đã thêm 5 phê duyệt vào application_approvals');

    // -------------------------------------------------------------------------
    // 13. financial_transactions cho Doanh nghiệp dn_abctech (id: 602, sđt: 0243999888)
    // Phục vụ màn hình Dòng tiền Doanh nghiệp: http://localhost:5173/#/customer/cash-flow
    // và Lịch sử giao dịch: http://localhost:5173/#/customer/transactions
    // -------------------------------------------------------------------------
    console.log('\n--- 13. Bảng financial_transactions (Dòng tiền Inflow & Outflow cho Doanh nghiệp) ---');
    const entTxSql = `
      INSERT INTO financial_transactions
      (transaction_code, sender_customer_id, receiver_account_number, receiver_name, bank_name, amount, fee, description, processed_by_staff_id, status, created_at)
      VALUES
      -- INFLOW 1: Nhận tiền thanh toán hợp đồng phần mềm từ đối tác
      ('TXN-DN-2026-001', NULL, '0243999888', 'CÔNG TY TNHH GIẢI PHÁP CÔNG NGHỆ ABC', 'Vietcombank', 350000000.00, 0.00, 'Khach hang Vingroup thanh toan hop dong phan mem ERP dot 1', 104, 'SUCCESS', NOW()),
      -- INFLOW 2: Nhận tiền thanh toán xuất khẩu phần mềm từ Nhật Bản
      ('TXN-DN-2026-002', NULL, '0243999888', 'CÔNG TY TNHH GIẢI PHÁP CÔNG NGHỆ ABC', 'Vietcombank', 480000000.00, 0.00, 'Thanh toan hop dong gia cong xuat khau phan mem Tokyo IT', 104, 'SUCCESS', NOW()),
      -- OUTFLOW 1: Chi trả lương cán bộ nhân viên tháng 9
      ('TXN-DN-2026-003', 602, '0071009988776', 'TONG CONG TY TRA LUONG NHAN VIEN ABC', 'Vietcombank', 185000000.00, 0.00, 'Chi tra luong va phu cap ky 1 thang 09/2026 cho 45 nhan vien', 104, 'SUCCESS', NOW()),
      -- OUTFLOW 2: Thanh toán tiền thuê văn phòng trụ sở
      ('TXN-DN-2026-004', 602, '1903888222111', 'CONG TY CP DAU TU TOA NHA KEANGNAM', 'Techcombank', 65000000.00, 11000.00, 'Thanh toan tien thue van phong tang 18 Keangnam thang 9', 104, 'SUCCESS', NOW()),
      -- OUTFLOW 3: Thanh toán tiền điện toán đám mây Amazon AWS
      ('TXN-DN-2026-005', 602, '0451000888999', 'AMAZON WEB SERVICES VIETNAM', 'Vietcombank', 42500000.00, 0.00, 'Thanh toan phi dich vu Cloud ha tang thang 8/2026', 104, 'SUCCESS', NOW())
      ON DUPLICATE KEY UPDATE amount=VALUES(amount);
    `;
    await conn.query(entTxSql);
    console.log('  ✅ Đã thêm 5 giao dịch dòng tiền (2 Inflow, 3 Outflow) cho Doanh nghiệp dn_abctech');

    // -------------------------------------------------------------------------
    // 14. audit_logs (5 nhật ký kiểm toán hệ thống nghiệp vụ)
    // -------------------------------------------------------------------------
    console.log('\n--- 14. Bảng audit_logs (Nhật ký kiểm toán hệ thống) ---');
    const auditSql = `
      INSERT INTO audit_logs (user_id, action_type, module_name, ip_address, user_agent, status, description, created_at)
      VALUES
      (101, 'SECURITY_CONFIG_UPDATE', 'SYSTEM_SECURITY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'SUCCESS', 'Admin Super kích hoạt chính sách bắt buộc xác thực 2FA qua OTP cho toàn bộ cán bộ', NOW()),
      (103, 'CREDIT_APPROVAL_DECISION', 'APPROVAL_MODULE', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'SUCCESS', 'Quản lý Minh Tuấn phê duyệt hồ sơ vay mua ô tô điện VinFast VF8 hạn mức 750 triệu', NOW()),
      (104, 'CASH_DEPOSIT_TRANSACTION', 'STAFF_COUNTER', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'SUCCESS', 'Giao dịch viên Hoàng Nam thực hiện lệnh nộp tiền mặt 50.000.000 đ tại quầy số 02', NOW()),
      (104, 'CUSTOMER_ADVISORY_CREATE', 'STAFF_CRM', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'SUCCESS', 'Ghi nhận phiếu tư vấn giải pháp bảo hiểm FWD liên kết đầu tư cho khách hàng VIP', NOW()),
      (103, 'EXPORT_EXCEL_REPORT', 'REPORT_MODULE', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'SUCCESS', 'Quản lý xuất báo cáo tổng hợp thẩm định và chỉ số tăng trưởng tín dụng Quý 3/2026', NOW());
    `;
    await conn.query(auditSql);
    console.log('  ✅ Đã thêm 5 nhật ký kiểm toán vào audit_logs');

    console.log('\n================================================================');
    console.log('🎉 TOÀN BỘ CÁC BẢNG TRONG DATABASE ĐÃ ĐƯỢC NẠP DỮ LIỆU ĐẦY ĐỦ 100%!');
    console.log('================================================================');
  } catch (err) {
    console.error('❌ Lỗi khi nạp dữ liệu:', err);
  } finally {
    await conn.end();
  }
}

seedAllRemaining();
