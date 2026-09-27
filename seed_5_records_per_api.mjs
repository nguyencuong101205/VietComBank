// Script nạp thêm 5 bản ghi cho mỗi API/giao diện hệ thống Vietcombank Digital Banking
const BASE_URL = 'http://localhost:8080/api/v1';

async function request(method, path, body = null, token = null) {
  const headers = { 'Content-Type': 'application/json' };
  if (token) headers['Authorization'] = `Bearer ${token}`;
  const options = { method, headers };
  if (body) options.body = JSON.stringify(body);

  try {
    const res = await fetch(`${BASE_URL}${path}`, options);
    const data = await res.json();
    return { status: res.status, data };
  } catch (err) {
    return { status: 0, error: err.message };
  }
}

async function login(username, password, isStaff = false) {
  if (isStaff) {
    const l1 = await request('POST', '/auth/login', { username, password });
    const temp = l1.data?.data?.tempToken;
    const otp = l1.data?.data?.devOtp;
    const l2 = await request('POST', '/auth/verify-otp', { username, tempToken: temp, otpCode: otp });
    return l2.data?.data?.accessToken;
  } else {
    const res = await request('POST', '/customer/auth/login', { username, password });
    return res.data?.data?.accessToken || res.data?.data?.token;
  }
}

async function seed() {
  console.log('🚀 Bắt đầu thêm 5 bản ghi cho mỗi API/Giao diện...');

  // Đăng nhập các vai trò
  const adminToken = await login('admin_super', 'Admin@123', true);
  const staffToken = await login('nv_hoangnam', 'Staff@123', true);
  const custThuhaToken = await login('kh_thuha', 'Customer@123', false);
  const custNamleToken = await login('kh_namle', 'Customer@123', false);
  const custEnterpriseToken = await login('dn_abctech', 'Customer@123', false);

  console.log('✅ Đã xác thực thành công các tài khoản: Admin, Staff, Khách hàng cá nhân, Khách hàng DN');

  // =========================================================================
  // 1. TIẾT KIỆM ONLINE (/customer/savings) - 5 SỔ MỚI
  // =========================================================================
  console.log('\n--- 1. Thêm 5 sổ Tiết kiệm Online (/customer/savings) ---');
  const savingsData = [
    { productCode: 'TIET_KIEM_ONLINE_1M', depositAmount: 20000000, termMonths: 1, interestRate: 3.5 },
    { productCode: 'TIET_KIEM_ONLINE_3M', depositAmount: 50000000, termMonths: 3, interestRate: 4.5 },
    { productCode: 'TIET_KIEM_ONLINE_6M', depositAmount: 120000000, termMonths: 6, interestRate: 5.5 },
    { productCode: 'TIET_KIEM_ONLINE_12M', depositAmount: 300000000, termMonths: 12, interestRate: 6.8 },
    { productCode: 'TIET_KIEM_ONLINE_24M', depositAmount: 500000000, termMonths: 24, interestRate: 7.2 }
  ];

  for (const s of savingsData) {
    const r = await request('POST', '/customer/savings', s, custThuhaToken);
    console.log(`  + Sổ tiết kiệm ${s.termMonths} tháng (${(s.depositAmount).toLocaleString('vi-VN')} đ):`, r.status === 200 ? '✅ Thành công ' + r.data?.data?.savingCode : '❌ ' + r.data?.message);
  }

  // =========================================================================
  // 2. HỒ SƠ VAY & MỞ THẺ CÁ NHÂN (/customer/loans, /customer/cards) - 5 HỒ SƠ
  // =========================================================================
  console.log('\n--- 2. Thêm 5 hồ sơ Vay & Thẻ tín dụng cá nhân (/customer/my-applications) ---');

  // 2.1 Vay mua ô tô VinFast VF8
  let r = await request('POST', '/customer/loans/auto', {
    requestedAmount: 750000000,
    termMonths: 60,
    carBrand: 'VinFast',
    carModel: 'VF8 Plus Dual Motor 2026',
    manufactureYear: 2026,
    carPrice: 1270000000,
    isNewCar: true,
    estimatedCollateralValue: 1270000000,
    documentProofUrl: '/uploads/docs/hop_dong_vinfast_vf8.pdf'
  }, custThuhaToken);
  console.log('  + Vay mua xe VinFast VF8:', r.status === 200 ? '✅ ' + r.data?.data?.applicationCode : '❌ ' + r.data?.message);

  // 2.2 Vay mua ô tô Mercedes C300
  r = await request('POST', '/customer/loans/auto', {
    requestedAmount: 900000000,
    termMonths: 72,
    carBrand: 'Mercedes-Benz',
    carModel: 'C300 AMG 2026',
    manufactureYear: 2026,
    carPrice: 2099000000,
    isNewCar: true,
    estimatedCollateralValue: 2099000000,
    documentProofUrl: '/uploads/docs/hop_dong_mercedes_c300.pdf'
  }, custThuhaToken);
  console.log('  + Vay mua xe Mercedes C300:', r.status === 200 ? '✅ ' + r.data?.data?.applicationCode : '❌ ' + r.data?.message);

  // 2.3 Vay tiêu dùng sửa chữa nhà
  r = await request('POST', '/customer/loans/consumer', {
    requestedAmount: 180000000,
    termMonths: 36,
    incomeProofDocUrl: '/uploads/docs/sao_ke_luong_vcb.pdf'
  }, custThuhaToken);
  console.log('  + Vay tiêu dùng sửa nhà 180 triệu:', r.status === 200 ? '✅ ' + r.data?.data?.applicationCode : '❌ ' + r.data?.message);

  // 2.4 Thẻ Vietcombank Visa Signature
  r = await request('POST', '/customer/cards', {
    cardType: 'VISA_SIGNATURE',
    requestedLimit: 120000000,
    monthlyIncome: 45000000,
    salaryPaymentMethod: 'BANK_TRANSFER'
  }, custThuhaToken);
  console.log('  + Mở thẻ Visa Signature 120 triệu:', r.status === 200 ? '✅ ' + r.data?.data?.applicationCode : '❌ ' + r.data?.message);

  // 2.5 Thẻ Vietcombank JCB Platinum
  r = await request('POST', '/customer/cards', {
    cardType: 'JCB_PLATINUM',
    requestedLimit: 60000000,
    monthlyIncome: 25000000,
    salaryPaymentMethod: 'BANK_TRANSFER'
  }, custThuhaToken);
  console.log('  + Mở thẻ JCB Platinum 60 triệu:', r.status === 200 ? '✅ ' + r.data?.data?.applicationCode : '❌ ' + r.data?.message);

  // =========================================================================
  // 3. TÀI TRỢ THƯƠNG MẠI DOANH NGHIỆP (/customer/trade-finance) - 5 HỒ SƠ
  // =========================================================================
  console.log('\n--- 3. Thêm 5 yêu cầu Tài trợ thương mại DN (/customer/trade-finance) ---');
  const tradeData = [
    {
      serviceType: 'LETTER_OF_CREDIT',
      amount: 2850000000,
      currency: 'VND',
      beneficiaryName: 'Samsung Electronics Vietnam Co., Ltd',
      purpose: 'Phát hành L/C không hủy ngang nhập khẩu linh kiện điện tử bán dẫn lô hàng Quý 4/2026',
      documentUrl: '/uploads/docs/hop_dong_ngoai_thuong_samsung.pdf'
    },
    {
      serviceType: 'BANK_GUARANTEE',
      amount: 850000000,
      currency: 'VND',
      beneficiaryName: 'Ban Quản lý Dự án Giao thông Đô thị Hà Nội',
      purpose: 'Thư bảo lãnh dự thầu và thực hiện hợp đồng gói thầu số 06 hệ thống giám sát thông minh',
      documentUrl: '/uploads/docs/ho_so_moi_thau_06.pdf'
    },
    {
      serviceType: 'BANK_GUARANTEE',
      amount: 450000000,
      currency: 'VND',
      beneficiaryName: 'Tập đoàn Điện lực Việt Nam (EVN)',
      purpose: 'Bảo lãnh tiền tạm ứng thi công trạm biến áp số 2 khu công nghệ cao',
      documentUrl: '/uploads/docs/hop_dong_evn_tam_ung.pdf'
    },
    {
      serviceType: 'IMPORT_EXPORT_FINANCE',
      amount: 1500000000,
      currency: 'VND',
      beneficiaryName: 'Công ty Cổ phần Nông sản Xuất khẩu An Giang',
      purpose: 'Tài trợ chiết khấu bộ chứng từ xuất khẩu gạo thơm sang thị trường EU theo hạn ngạch EVFTA',
      documentUrl: '/uploads/docs/bo_chung_tu_xuat_khau_gao.pdf'
    },
    {
      serviceType: 'LETTER_OF_CREDIT',
      amount: 1950000000,
      currency: 'VND',
      beneficiaryName: 'Tokyo Technology & Machinery Corp (Japan)',
      purpose: 'Phát hành Thư tín dụng Standby L/C nhập khẩu dây chuyền tự động hóa công nghiệp',
      documentUrl: '/uploads/docs/hop_dong_may_moc_japan.pdf'
    }
  ];

  for (const t of tradeData) {
    const res = await request('POST', '/customer/trade-finance', t, custEnterpriseToken);
    console.log(`  + Tài trợ thương mại: ${t.beneficiaryName}:`, res.status === 200 ? '✅ ' + res.data?.data?.requestCode : '❌ ' + res.data?.message);
  }

  // =========================================================================
  // 4. GIAO DỊCH TÀI CHÍNH TẠI QUẦY (/staff/transactions) - 5 GIAO DỊCH
  // =========================================================================
  console.log('\n--- 4. Thêm 5 giao dịch tài chính quầy & luân chuyển dòng tiền (/staff/transactions) ---');
  const txData = [
    { senderCustomerId: 601, receiverAccountNumber: '0071009988112', receiverName: 'NGUYEN THI KIM NGAN', bankName: 'VIETCOMBANK', amount: 35000000, fee: 0, description: 'Nop tien mat tai quay thanh toan tien hang' },
    { senderCustomerId: 601, receiverAccountNumber: '1903666888999', receiverName: 'CONG TY CP DIEN MAY XANH', bankName: 'Techcombank', amount: 18500000, fee: 11000, description: 'Thanh toan tien mua may giat va tu lanh' },
    { senderCustomerId: 601, receiverAccountNumber: '0911222333', receiverName: 'TRAN THI THU HA', bankName: 'VIETCOMBANK', amount: 50000000, fee: 0, description: 'Nop tien vao tai khoan thanh toan dinh ky' },
    { senderCustomerId: 601, receiverAccountNumber: '1028777999', receiverName: 'LE HOANG ANH', bankName: 'VietinBank', amount: 12000000, fee: 9900, description: 'Chuyen tien thanh toan tien thue nha thang 9' },
    { senderCustomerId: 601, receiverAccountNumber: '0011005544332', receiverName: 'VIETCOMBANK LOAN RECOVERY', bankName: 'VIETCOMBANK', amount: 6850000, fee: 0, description: 'Trich nop tien lai va goc vay tieu dung dinh ky' }
  ];

  for (const tx of txData) {
    const res = await request('POST', '/staff/transactions', tx, staffToken);
    console.log(`  + Giao dịch ${tx.amount.toLocaleString('vi-VN')} đ tới ${tx.receiverName}:`, res.status === 200 ? '✅ ' + res.data?.data?.transactionCode : '❌ ' + res.data?.message);
  }

  // =========================================================================
  // 5. TƯ VẤN KHÁCH HÀNG CRM (/staff/advisories) - 5 PHIẾU
  // =========================================================================
  console.log('\n--- 5. Thêm 5 phiếu Tư vấn Khách hàng CRM (/staff/advisories) ---');
  const advData = [
    { customerId: 601, productType: 'Vay mua xe ô tô điện VinFast VF8', notes: 'Khách hàng có nhu cầu vay 750 triệu trong 5 năm, hưởng ưu đãi miễn phí trạm sạc 2 năm và lãi suất 6.5%.', status: 'FOLLOW_UP' },
    { customerId: 601, productType: 'Thẻ tín dụng Vietcombank Visa Signature', notes: 'Tư vấn mở thẻ đen đặc quyền phòng chờ sân bay và bảo hiểm du lịch 10.5 tỷ VND. Khách hàng quan tâm và đã nộp hồ sơ.', status: 'COMPLETED' },
    { customerId: 601, productType: 'Tiết kiệm bậc thang phát lộc', notes: 'Khách hàng có 500 triệu nhàn rỗi, tư vấn gửi kỳ hạn 12 tháng lãi suất 6.8% kèm quay số trúng thưởng sổ tiết kiệm.', status: 'FOLLOW_UP' },
    { customerId: 601, productType: 'Bảo hiểm nhân thọ liên kết đầu tư FWD', notes: 'Tư vấn giải pháp bảo vệ tài chính kết hợp gia tăng tài sản, mức phí bảo hiểm 30 triệu/năm.', status: 'CONSULTED' },
    { customerId: 601, productType: 'Tài khoản số đẹp Như ý Phong thủy', notes: 'Khách hàng đăng ký mở tài khoản đuôi lộc phát 686868 để phục vụ kinh doanh online.', status: 'COMPLETED' }
  ];

  for (const a of advData) {
    const res = await request('POST', '/staff/advisories', a, staffToken);
    console.log(`  + Phiếu tư vấn CRM: ${a.productType}:`, res.status === 200 ? '✅ Thành công (ID: ' + res.data?.data?.id + ')' : '❌ ' + res.data?.message);
  }

  // =========================================================================
  // 6. TICKET HỖ TRỢ CSKH (/staff/tickets) - 5 TICKET
  // =========================================================================
  console.log('\n--- 6. Thêm 5 Ticket hỗ trợ CSKH (/staff/tickets) ---');
  const ticketData = [
    { customerId: 601, priority: 'HIGH', title: 'Hỗ trợ kích hoạt sinh trắc học khuôn mặt theo Quyết định 2345', content: 'Khách hàng đổi sang điện thoại iPhone mới, quét NFC căn cước CCCD gắn chip bị lỗi không nhận diện.' },
    { customerId: 601, priority: 'URGENT', title: 'Cần nâng hạn mức chuyển tiền trực tuyến trong ngày lên 1 tỷ', content: 'Khách hàng cần thanh toán tiền đặt cọc mua căn hộ chung cư trong chiều nay, hạn mức hiện tại 500 triệu/ngày không đủ.' },
    { customerId: 601, priority: 'MEDIUM', title: 'Thẻ tín dụng Visa Platinum bị trừ phí thường niên', content: 'Khách hàng hỏi điều kiện hoàn phí thường niên năm đầu khi chi tiêu đạt mốc 20 triệu đồng theo thể lệ chương trình.' },
    { customerId: 601, priority: 'HIGH', title: 'Cấp lại mã PIN thẻ ghi nợ quốc tế Vietcombank Connect24', content: 'Khách hàng quên mã PIN thẻ vật lý khi đi du lịch nước ngoài, cần cấp lại mã e-PIN trực tuyến trên app VCB Digibank.' },
    { customerId: 601, priority: 'LOW', title: 'Đăng ký dịch vụ nhận biến động số dư qua tin nhắn OTT miễn phí', content: 'Khách hàng muốn hủy nhận tin nhắn SMS để chuyển sang nhận thông báo biến động số dư hoàn toàn miễn phí trên app.' }
  ];

  for (const tk of ticketData) {
    const res = await request('POST', '/staff/tickets', tk, staffToken);
    console.log(`  + Ticket CSKH: ${tk.title}:`, res.status === 200 ? '✅ ' + res.data?.data?.ticketCode : '❌ ' + res.data?.message);
  }

  // =========================================================================
  // 7. TRA SOÁT KHIẾU NẠI GIAO DỊCH (/staff/disputes) - 5 TRA SOÁT
  // =========================================================================
  console.log('\n--- 7. Thêm 5 Tra soát khiếu nại giao dịch (/staff/disputes) ---');
  const disputeData = [
    { customerId: 601, transactionCode: 'TXN-2026-889901', reason: 'Rút tiền tại cây ATM Vietcombank Ba Đình tài khoản bị trừ 3.000.000 VNĐ nhưng máy chỉ nhả 2.000.000 VNĐ.' },
    { customerId: 601, transactionCode: 'TXN-2026-889902', reason: 'Quẹt thẻ Visa tại máy POS nhà hàng King BBQ báo lỗi giao dịch nhưng ứng dụng ngân hàng vẫn trừ 1.450.000 VNĐ.' },
    { customerId: 601, transactionCode: 'TXN-2026-889903', reason: 'Chuyển tiền nhanh 24/7 sang Techcombank người nhận chưa nhận được tiền dù tài khoản Vietcombank đã bị trừ 25.000.000 VNĐ.' },
    { customerId: 601, transactionCode: 'TXN-2026-889904', reason: 'Thanh toán đơn hàng Shopee qua cổng Napas bị trừ 2 lần cùng một mã giao dịch 890.000 VNĐ.' },
    { customerId: 601, transactionCode: 'TXN-2026-889905', reason: 'Giao dịch lạ trừ tiền 45 USD từ trang thương mại điện tử quốc tế do nghi ngờ bị lộ thông tin thẻ.' }
  ];

  for (const d of disputeData) {
    const res = await request('POST', '/staff/disputes', d, staffToken);
    console.log(`  + Tra soát: ${d.transactionCode}:`, res.status === 200 ? '✅ ' + res.data?.data?.disputeCode : '❌ ' + res.data?.message);
  }

  // =========================================================================
  // 8. LỊCH HẸN CHATBOT CHI NHÁNH (/public/appointments) - 5 LỊCH HẸN
  // =========================================================================
  console.log('\n--- 8. Thêm 5 Lịch hẹn đặt từ Chatbot AI (/staff/appointments) ---');
  const aptData = [
    {
      fullName: 'Trần Đình Phong',
      phoneNumber: '0988112244',
      email: 'phong.tran@gmail.com',
      branchName: 'Chi nhánh Vietcombank Hoàn Kiếm - Hà Nội',
      serviceType: 'Tư vấn hồ sơ vay vốn (Mua nhà/Mua xe/Kinh doanh)',
      appointmentDate: '2026-09-18',
      timeSlot: '09:00 - 10:00',
      note: 'Tư vấn gói vay sản xuất kinh doanh hạn mức 1.5 tỷ cho cơ sở chế biến thực phẩm'
    },
    {
      fullName: 'Lê Mỹ Duyên',
      phoneNumber: '0912334455',
      email: 'duyen.le@outlook.com',
      branchName: 'Chi nhánh Vietcombank Ba Đình - Hà Nội',
      serviceType: 'Phát hành thẻ tín dụng quốc tế',
      appointmentDate: '2026-09-18',
      timeSlot: '10:30 - 11:30',
      note: 'Nhận thẻ vật lý Vietcombank Visa Signature và kích hoạt thanh toán không tiếp xúc'
    },
    {
      fullName: 'Công ty TNHH Đầu tư Minh Long',
      phoneNumber: '0243888777',
      email: 'contact@minhlong.vn',
      branchName: 'Chi nhánh Vietcombank Cầu Giấy',
      serviceType: 'Dịch vụ Doanh nghiệp & Tài trợ thương mại',
      appointmentDate: '2026-09-19',
      timeSlot: '14:00 - 15:00',
      note: 'Mở tài khoản thanh toán số đẹp doanh nghiệp và ký hợp đồng bảo lãnh tạm ứng thầu'
    },
    {
      fullName: 'Nguyễn Hải Đăng',
      phoneNumber: '0903889911',
      email: 'haidang@vinamilk.com.vn',
      branchName: 'Chi nhánh Vietcombank Bến Thành - TP.HCM',
      serviceType: 'Gửi tiền tiết kiệm & Mở tài khoản',
      appointmentDate: '2026-09-19',
      timeSlot: '15:30 - 16:30',
      note: 'Gửi tiết kiệm bậc thang 1.2 tỷ VND, cần được tiếp đón tại quầy Priority VIP'
    },
    {
      fullName: 'Phạm Ngọc Mai',
      phoneNumber: '0977665544',
      email: 'mai.pham@vietjetair.com',
      branchName: 'Chi nhánh Vietcombank Đà Nẵng',
      serviceType: 'Tra soát giao dịch & Hỗ trợ ngân hàng số',
      appointmentDate: '2026-09-20',
      timeSlot: '08:30 - 09:30',
      note: 'Hỗ trợ quét chip căn cước CCCD và cập nhật dữ liệu sinh trắc học trực tiếp tại quầy'
    }
  ];

  for (const a of aptData) {
    const res = await request('POST', '/public/appointments', a);
    console.log(`  + Lịch hẹn Chatbot của ${a.fullName}:`, res.status === 201 ? '✅ ' + (res.data?.data?.appointmentCode || res.data?.data?.id) : '❌ ' + res.data?.message);
  }

  // =========================================================================
  // 9. TIN TỨC / CMS BÀI VIẾT (/cms/posts) - 5 BÀI VIẾT MỚI
  // =========================================================================
  console.log('\n--- 9. Thêm 5 Bài viết Tin tức CMS & Cổng thông tin (/cms/posts) ---');
  const postsData = [
    {
      title: 'Vietcombank ra mắt tính năng Mở sổ tiết kiệm tích lũy số linh hoạt trên VCB Digibank',
      summary: 'Khách hàng có thể gửi tích lũy định kỳ hàng ngày, hàng tuần hoặc hàng tháng chỉ từ 100.000 VNĐ với mức sinh lời tối ưu.',
      content: '<p>Vietcombank chính thức giới thiệu sản phẩm Tiết kiệm tích lũy số trên ứng dụng VCB Digibank. Với tính năng này, việc tích lũy tài chính trở nên dễ dàng và thông minh hơn bao giờ hết, cho phép cài đặt trích tiền tự động và hưởng lãi suất sinh lời hấp dẫn theo ngày...</p>',
      thumbnailUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=800',
      categoryId: 1,
      status: 'PUBLISHED'
    },
    {
      title: 'Giải pháp Tài trợ thương mại số toàn diện cho doanh nghiệp xuất nhập khẩu 2026',
      summary: 'Gói hỗ trợ hạn mức tín dụng 30.000 tỷ đồng với cơ chế phát hành L/C online và bảo lãnh điện tử siêu tốc trong 2 giờ.',
      content: '<p>Đồng hành cùng cộng đồng doanh nghiệp trong xu hướng hội nhập kinh tế toàn cầu, Vietcombank triển khai nền tảng Tài trợ thương mại số (Trade Finance Digital Platform). Nền tảng giúp tối ưu hóa thời gian xử lý phát hành thư tín dụng L/C và bảo lãnh ngân hàng...</p>',
      thumbnailUrl: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      categoryId: 1,
      status: 'PUBLISHED'
    },
    {
      title: 'Ưu đãi hoàn tiền 15% khi chi tiêu qua thẻ Vietcombank JCB Platinum tại các nhà hàng Nhật Bản',
      summary: 'Trải nghiệm ẩm thực tinh hoa xứ sở hoa anh đào với chương trình hoàn tiền hấp dẫn lên tới 1.500.000 VNĐ mỗi tháng.',
      content: '<p>Từ nay đến hết tháng 12/2026, toàn bộ chủ thẻ tín dụng quốc tế Vietcombank JCB Platinum khi thanh toán tại chuỗi nhà hàng ẩm thực Nhật Bản cao cấp trên toàn quốc sẽ được tận hưởng ưu đãi hoàn tiền 15% trực tiếp vào sao kê thẻ tín dụng...</p>',
      thumbnailUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
      categoryId: 2,
      status: 'PUBLISHED'
    },
    {
      title: 'Gói vay mua ô tô điện VinFast: Lãi suất siêu ưu đãi 5.8%/năm đồng hành cùng kỷ nguyên xanh',
      summary: 'Vietcombank liên kết độc quyền hỗ trợ khách hàng vay tới 85% giá trị xe với thời hạn vay linh hoạt đến 8 năm.',
      content: '<p>Nhằm khuyến khích lối sống xanh và phương tiện giao thông thân thiện với môi trường, Vietcombank cùng VinFast triển khai gói tài chính chuyên biệt cho các dòng xe điện thông minh VF3, VF5, VF6, VF7, VF8, VF9 với thủ tục thẩm định trực tuyến giải ngân trong ngày...</p>',
      thumbnailUrl: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=800',
      categoryId: 1,
      status: 'PUBLISHED'
    },
    {
      title: 'Cảnh báo an toàn bảo mật: Hướng dẫn kích hoạt xác thực sinh trắc học trên ứng dụng VCB Digibank',
      summary: 'Bảo vệ tài sản tài chính tối đa với công nghệ xác thực khuôn mặt khớp nối với cơ sở dữ liệu định danh quốc gia.',
      content: '<p>Thực hiện Quyết định số 2345/QĐ-NHNN của Ngân hàng Nhà nước, Vietcombank khuyến nghị toàn bộ quý khách hàng nhanh chóng cập nhật thông tin sinh trắc học bằng cách quét chip CCCD trên ứng dụng VCB Digibank để đảm bảo giao dịch thông suốt và an toàn bảo mật cao nhất...</p>',
      thumbnailUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=800',
      categoryId: 3,
      status: 'PUBLISHED'
    }
  ];

  for (const p of postsData) {
    const res = await request('POST', '/cms/posts', p, adminToken);
    console.log(`  + Bài viết CMS: ${p.title.slice(0, 45)}...:`, res.status === 200 || res.status === 201 ? '✅ Thành công' : '❌ ' + res.data?.message);
  }

  console.log('\n================================================================');
  console.log('🎉 ĐÃ HOÀN TẤT NẠP THÊM 5 BẢN GHI CHO TẤT CẢ CÁC API & GIAO DIỆN!');
  console.log('================================================================');
}

seed();
