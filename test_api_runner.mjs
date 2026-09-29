// Test Runner tự động cho Vietcombank Digital Banking API
const BASE_URL = 'http://localhost:8080/api/v1';

const tokens = {
  admin: '',
  manager: '',
  staff: '',
  customer: '',
};

const results = [];

function recordResult(testId, name, category, passed, status, detail = '') {
  results.push({ testId, name, category, passed, status, detail });
  const icon = passed ? '✅ PASS' : '❌ FAIL';
  console.log(`${icon} [${testId}] ${name} -> Status: ${status} ${detail ? '(' + detail + ')' : ''}`);
}

async function request(method, path, body = null, token = null) {
  const headers = { 'Content-Type': 'application/json' };
  if (token) headers['Authorization'] = `Bearer ${token}`;

  const options = { method, headers };
  if (body) options.body = JSON.stringify(body);

  const start = Date.now();
  try {
    const res = await fetch(`${BASE_URL}${path}`, options);
    const duration = Date.now() - start;
    let data = null;
    const contentType = res.headers.get('content-type') || '';
    if (contentType.includes('application/json')) {
      data = await res.json();
    } else {
      data = await res.text();
    }
    return { status: res.status, data, duration };
  } catch (err) {
    return { status: 0, error: err.message, duration: Date.now() - start };
  }
}

async function runAllTests() {
  console.log('='.repeat(70));
  console.log('🚀 KHỞI ĐỘNG BỘ TEST TỰ ĐỘNG VIETCOMBANK DIGITAL BANKING API');
  console.log(`📡 URL Máy chủ: ${BASE_URL}`);
  console.log('='.repeat(70) + '\n');

  // ================= 1. AUTH 2FA =================
  console.log('📌 1. KIỂM THỬ XÁC THỰC 2 LỚP (OTP 2FA)');

  // 1.1 Admin Step 1
  let res = await request('POST', '/auth/login', { username: 'admin_super', password: 'Admin@123' });
  let adminTemp = res.data?.data?.tempToken;
  let adminOtp = res.data?.data?.devOtp;
  recordResult('TC-AUTH-01', 'Admin Đăng nhập Bước 1 (Lấy OTP)', 'AUTH', res.status === 200 && !!adminTemp, res.status, `OTP: ${adminOtp}`);

  // 1.2 Admin Step 2
  res = await request('POST', '/auth/verify-otp', { username: 'admin_super', tempToken: adminTemp, otpCode: adminOtp });
  tokens.admin = res.data?.data?.accessToken || '';
  recordResult('TC-AUTH-02', 'Admin Xác thực OTP Bước 2 (Lấy JWT Token)', 'AUTH', res.status === 200 && !!tokens.admin, res.status);

  // 1.3 Manager Step 1 & 2
  res = await request('POST', '/auth/login', { username: 'ql_minhtuan', password: 'Manager@123' });
  let mngTemp = res.data?.data?.tempToken;
  let mngOtp = res.data?.data?.devOtp;
  res = await request('POST', '/auth/verify-otp', { username: 'ql_minhtuan', tempToken: mngTemp, otpCode: mngOtp });
  tokens.manager = res.data?.data?.accessToken || '';
  recordResult('TC-AUTH-03', 'Quản lý phê duyệt Đăng nhập 2FA (ql_minhtuan)', 'AUTH', res.status === 200 && !!tokens.manager, res.status);

  // 1.4 Staff Step 1 & 2
  res = await request('POST', '/auth/login', { username: 'nv_hoangnam', password: 'Staff@123' });
  let staffTemp = res.data?.data?.tempToken;
  let staffOtp = res.data?.data?.devOtp;
  res = await request('POST', '/auth/verify-otp', { username: 'nv_hoangnam', tempToken: staffTemp, otpCode: staffOtp });
  tokens.staff = res.data?.data?.accessToken || '';
  recordResult('TC-AUTH-04', 'Giao dịch viên Đăng nhập 2FA (nv_hoangnam)', 'AUTH', res.status === 200 && !!tokens.staff, res.status);

  // 1.5 Negative OTP
  res = await request('POST', '/auth/verify-otp', { username: 'admin_super', tempToken: adminTemp, otpCode: '000000' });
  recordResult('TC-AUTH-05', '[NEGATIVE] Nhập sai mã OTP -> Chặn 400 hoặc 401', 'AUTH', res.status === 400 || res.status === 401, res.status);

  console.log('');

  // ================= 2. RBAC SECURITY =================
  console.log('📌 2. KIỂM THỬ PHÂN QUYỀN RBAC & BẢO MẬT (CHẶN 403 FORBIDDEN)');

  // 2.1 Admin access users
  res = await request('GET', '/system/users', null, tokens.admin);
  recordResult('TC-RBAC-01', '[PASS] Admin Super truy cập Quản trị Người dùng', 'RBAC', res.status === 200, res.status);

  // 2.2 Manager -> Users (MUST BE 403)
  res = await request('GET', '/system/users', null, tokens.manager);
  recordResult('TC-RBAC-02', '[SECURITY] Quản lý gọi API Users -> Chặn 403 Forbidden', 'RBAC', res.status === 403, res.status);

  // 2.3 Manager -> Staff Transactions (MUST BE 403)
  res = await request('GET', '/staff/transactions', null, tokens.manager);
  recordResult('TC-RBAC-03', '[SECURITY] Quản lý gọi API Giao dịch tài chính -> Chặn 403 Forbidden', 'RBAC', res.status === 403, res.status);

  // 2.4 Manager -> Staff Appointments (MUST BE 403)
  res = await request('GET', '/staff/appointments', null, tokens.manager);
  recordResult('TC-RBAC-04', '[SECURITY] Quản lý gọi API Lịch hẹn Chatbot -> Chặn 403 Forbidden', 'RBAC', res.status === 403, res.status);

  // 2.5 Staff -> Loan Approvals (MUST BE 403)
  res = await request('GET', '/applications', null, tokens.staff);
  recordResult('TC-RBAC-05', '[SECURITY] Giao dịch viên gọi API Phê duyệt hồ sơ -> Chặn 403 Forbidden', 'RBAC', res.status === 403, res.status);

  // 2.6 Admin catalog permissions
  res = await request('GET', '/system/roles/permissions', null, tokens.admin);
  recordResult('TC-RBAC-06', '[PASS] Admin xem danh mục toàn bộ Quyền hạn (Permissions)', 'RBAC', res.status === 200, res.status);

  console.log('');

  // ================= 3. CUSTOMER PORTAL =================
  console.log('📌 3. KIỂM THỬ CỔNG KHÁCH HÀNG SỐ (CUSTOMER PORTAL)');

  // 3.1 Customer Login (2FA: Step 1 Password -> Step 2 OTP)
  res = await request('POST', '/customer/auth/login', { username: 'kh_thuha', password: 'Customer@123' });
  let custTemp = res.data?.data?.tempToken;
  let custOtp = res.data?.data?.devOtp;
  if (custTemp && custOtp) {
    res = await request('POST', '/customer/auth/verify-otp', { username: 'kh_thuha', tempToken: custTemp, otpCode: custOtp });
  }
  tokens.customer = res.data?.data?.accessToken || res.data?.data?.token || '';
  recordResult('TC-CUST-01', 'Khách hàng Đăng nhập 2FA OTP (kh_thuha)', 'CUSTOMER', res.status === 200 && !!tokens.customer, res.status);

  // 3.2 Customer Profile
  res = await request('GET', '/customer/profile', null, tokens.customer);
  recordResult('TC-CUST-02', 'Khách hàng xem Thông tin cá nhân Profile', 'CUSTOMER', res.status === 200, res.status, res.data?.data?.fullName);

  // 3.3 Customer Auto Loan
  res = await request('POST', '/customer/loans/auto', {
    requestedAmount: 650000000,
    termMonths: 60,
    carBrand: 'Hyundai',
    carModel: 'Tucson 2.0 Turbo 2026',
    manufactureYear: 2026,
    carPrice: 1050000000,
    isNewCar: true,
    estimatedCollateralValue: 1050000000,
    documentProofUrl: '/uploads/hop_dong_xe.pdf'
  }, tokens.customer);
  recordResult('TC-CUST-03', 'Khách hàng nộp hồ sơ Vay Mua Ô Tô (Auto Loan)', 'CUSTOMER', res.status === 200, res.status, res.data?.data?.applicationCode);

  // 3.4 Customer Consumer Loan
  res = await request('POST', '/customer/loans/consumer', {
    requestedAmount: 80000000,
    termMonths: 24,
    incomeProofDocUrl: '/uploads/sao_ke_luong.pdf'
  }, tokens.customer);
  recordResult('TC-CUST-04', 'Khách hàng nộp hồ sơ Vay Tiêu dùng (Consumer Loan)', 'CUSTOMER', res.status === 200, res.status);

  // 3.5 Customer Credit Card
  res = await request('POST', '/customer/cards', {
    cardType: 'VISA_PLATINUM',
    requestedLimit: 50000000,
    monthlyIncome: 30000000,
    salaryPaymentMethod: 'BANK_TRANSFER'
  }, tokens.customer);
  recordResult('TC-CUST-05', 'Khách hàng đăng ký Mở thẻ Tín dụng Quốc tế', 'CUSTOMER', res.status === 200, res.status);

  // 3.6 Customer Savings
  res = await request('POST', '/customer/savings', {
    productCode: 'SAVING_ONLINE_6M',
    depositAmount: 50000000,
    termMonths: 6,
    interestRate: 5.50
  }, tokens.customer);
  recordResult('TC-CUST-06', 'Khách hàng Mở sổ tiết kiệm Online', 'CUSTOMER', res.status === 200, res.status);

  // 3.7 Customer My Applications
  res = await request('GET', '/customer/my-applications', null, tokens.customer);
  const myApps = res.data?.data || [];
  recordResult('TC-CUST-07', 'Khách hàng tra cứu Hồ sơ của tôi', 'CUSTOMER', res.status === 200 && Array.isArray(myApps), res.status, `Tổng hồ sơ: ${myApps.length}`);

  console.log('');

  // ================= 4. LOAN APPROVAL =================
  console.log('📌 4. KIỂM THỬ THẨM ĐỊNH & PHÊ DUYỆT HỒ SƠ (MANAGER APPROVAL)');

  // 4.1 Applications list
  res = await request('GET', '/applications', null, tokens.manager);
  const appList = res.data?.data?.content || res.data?.data || [];
  recordResult('TC-APPR-01', 'Quản lý xem danh sách hồ sơ thẩm định', 'APPROVAL', res.status === 200, res.status, `Số hồ sơ: ${appList.length}`);

  let testAppId = appList[0]?.id;
  if (testAppId) {
    // 4.2 Application details
    res = await request('GET', `/applications/${testAppId}`, null, tokens.manager);
    recordResult('TC-APPR-02', `Xem chi tiết hồ sơ thẩm định ID #${testAppId}`, 'APPROVAL', res.status === 200, res.status, `Mã: ${res.data?.data?.applicationCode}`);

    // 4.3 Decision Approve
    res = await request('POST', `/applications/${testAppId}/decision`, {
      action: 'APPROVED',
      reasonNote: 'Hồ sơ đạt tiêu chuẩn tín dụng, nguồn thu nhập chứng minh minh bạch.'
    }, tokens.manager);
    recordResult('TC-APPR-03', `Quản lý ra quyết định Phê duyệt (APPROVED) hồ sơ #${testAppId}`, 'APPROVAL', res.status === 200, res.status);
  }

  console.log('');

  // ================= 5. STAFF OPERATIONS =================
  console.log('📌 5. KIỂM THỬ NGHIỆP VỤ GIAO DỊCH VIÊN & QUẦY (STAFF OPERATIONS)');

  // 5.1 Staff advisory
  res = await request('POST', '/staff/advisories', {
    customerId: 601,
    productType: 'Vay mua nhà ở dự án',
    notes: 'Khách hàng có nhu cầu vay mua căn hộ Vinhomes Smart City 1.2 tỷ',
    status: 'FOLLOW_UP'
  }, tokens.staff);
  recordResult('TC-STAFF-01', 'Ghi nhận phiếu Tư vấn KH tại quầy (CRM)', 'STAFF', res.status === 200, res.status);

  // 5.2 Staff ticket
  res = await request('POST', '/staff/tickets', {
    customerId: 601,
    priority: 'HIGH',
    title: 'Hỗ trợ cấp lại mã PIN thẻ tín dụng',
    content: 'Khách hàng quên mã PIN thẻ Visa Platinum tại cây ATM'
  }, tokens.staff);
  recordResult('TC-STAFF-02', 'Mở Ticket hỗ trợ CSKH', 'STAFF', res.status === 200, res.status);

  // 5.3 Staff Transaction
  res = await request('POST', '/staff/transactions', {
    senderCustomerId: 601,
    receiverAccountNumber: '0011001234567',
    receiverName: 'LE HOANG PHUC',
    bankName: 'VIETCOMBANK',
    amount: 15000000,
    fee: 0,
    description: 'Nop tien tai quay chi nhanh Ba Dinh'
  }, tokens.staff);
  recordResult('TC-STAFF-03', 'Lập lệnh nộp tiền/chuyển tiền tại quầy', 'STAFF', res.status === 200, res.status, res.data?.data?.transactionCode);

  // 5.4 Staff Appointments list
  res = await request('GET', '/staff/appointments', null, tokens.staff);
  const appts = res.data?.data?.content || res.data?.data || [];
  recordResult('TC-STAFF-04', 'Giao dịch viên xem danh sách Lịch hẹn Chatbot', 'STAFF', res.status === 200, res.status, `Lịch hẹn: ${appts.length}`);

  // 5.5 Staff Appointments stats
  res = await request('GET', '/staff/appointments/stats', null, tokens.staff);
  recordResult('TC-STAFF-05', 'Xem thống kê Lịch hẹn Chatbot chi nhánh', 'STAFF', res.status === 200, res.status);

  console.log('');

  // ================= 6. PUBLIC PORTAL & CHATBOT =================
  console.log('📌 6. KIỂM THỬ CỔNG THÔNG TIN & CHATBOT CÔNG KHAI (KHÔNG CẦN LOGIN)');

  // 6.1 Public exchange rates
  res = await request('GET', '/public/rates/exchange');
  recordResult('TC-PUB-01', 'Lấy Bảng Tỷ giá ngoại tệ hôm nay', 'PUBLIC', res.status === 200 && Array.isArray(res.data?.data), res.status, `Số ngoại tệ: ${res.data?.data?.length}`);

  // 6.2 Public gold rates
  res = await request('GET', '/public/rates/gold');
  recordResult('TC-PUB-02', 'Lấy Bảng Giá vàng SJC', 'PUBLIC', res.status === 200 && Array.isArray(res.data?.data), res.status);

  // 6.3 Public interest rates
  res = await request('GET', '/public/rates/interest');
  recordResult('TC-PUB-03', 'Lấy Bảng Lãi suất tiết kiệm', 'PUBLIC', res.status === 200 && Array.isArray(res.data?.data), res.status);

  // 6.4 Public posts
  res = await request('GET', '/public/posts');
  recordResult('TC-PUB-04', 'Lấy Danh sách Tin tức & Ưu đãi Vietcombank', 'PUBLIC', res.status === 200 && Array.isArray(res.data?.data), res.status);

  // 6.5 Public apply loan
  res = await request('POST', '/public/apply', {
    fullName: 'Đoàn Tiến Dũng',
    idCardNumber: '001099112233',
    phoneNumber: '0987654321',
    email: 'tiendung@gmail.com',
    applicationType: 'LOAN',
    requestedAmount: 200000000,
    note: 'Cần vay vốn sản xuất kinh doanh nông sản'
  });
  recordResult('TC-PUB-05', 'Khách vãng lai Nộp hồ sơ vay vốn trực tuyến (Public Apply)', 'PUBLIC', res.status === 201, res.status, res.data?.data?.applicationCode);

  // 6.6 Public appointment via Chatbot
  res = await request('POST', '/public/appointments', {
    fullName: 'Ngô Thanh Vân',
    phoneNumber: '0909123456',
    email: 'van.ngo@gmail.com',
    branchName: 'Chi nhánh Vietcombank Hoàn Kiếm',
    serviceType: 'Mở thẻ tín dụng & Tư vấn gói vay',
    appointmentDate: '2026-09-20',
    timeSlot: '14:00 - 15:00',
    note: 'Tư vấn mở thẻ Visa Platinum cao cấp'
  });
  recordResult('TC-PUB-06', 'Khách đặt lịch hẹn quầy qua Chatbot AI', 'PUBLIC', res.status === 201, res.status, `Mã hẹn: #${res.data?.data?.id || res.data?.data?.appointmentCode || 'OK'}`);

  console.log('');

  // ================= 7. REPORTS & AUDIT =================
  console.log('📌 7. KIỂM THỬ BÁO CÁO THỐNG KÊ & AUDIT LOGS');

  // 7.1 Report dashboard
  res = await request('GET', '/reports/dashboard', null, tokens.manager);
  recordResult('TC-REP-01', 'Quản lý xem Dashboard Báo cáo KPI', 'REPORT', res.status === 200, res.status);

  // 7.2 Report export history
  res = await request('GET', '/reports/history', null, tokens.manager);
  recordResult('TC-REP-02', 'Xem Lịch sử xuất báo cáo (/reports/history)', 'REPORT', res.status === 200, res.status);

  // 7.3 System Audit Logs
  res = await request('GET', '/system/audit-logs', null, tokens.admin);
  recordResult('TC-REP-03', 'Admin tra cứu Nhật ký kiểm toán hệ thống (Audit Logs)', 'REPORT', res.status === 200, res.status);

  // ================= TỔNG KẾT =================
  console.log('\n' + '='.repeat(70));
  const passedCount = results.filter(r => r.passed).length;
  const failedCount = results.filter(r => !r.passed).length;
  console.log(`📊 TỔNG KẾT KẾT QUẢ KIỂM THỬ:`);
  console.log(`   - Tổng số kịch bản đã test: ${results.length}`);
  console.log(`   - ✅ THÀNH CÔNG (PASS):    ${passedCount} / ${results.length} (${Math.round(passedCount/results.length*100)}%)`);
  console.log(`   - ❌ THẤT BẠI (FAIL):      ${failedCount} / ${results.length}`);
  console.log('='.repeat(70));
}

runAllTests();
