import { useState, useRef, useEffect } from 'react';
import {
  Alert,
  Button,
  Card,
  Divider,
  Form,
  Input,
  Modal,
  Segmented,
  Space,
  Tag,
  Typography,
  message,
} from 'antd';
import {
  ArrowLeftOutlined,
  BankOutlined,
  CheckCircleFilled,
  KeyOutlined,
  LockOutlined,
  ReloadOutlined,
  SafetyCertificateFilled,
  SafetyOutlined,
  ShopOutlined,
  ThunderboltFilled,
  UserAddOutlined,
  UserOutlined,
} from '@ant-design/icons';
import client, { unwrap } from '../../api/client';
import { useCustomerAuth } from '../../store/CustomerAuthContext';
import { useLanguage } from '../../store/LanguageContext';
import LanguageSwitcher from '../../components/LanguageSwitcher';
import VisualCaptcha from '../../components/VisualCaptcha';

const { Title, Text, Paragraph } = Typography;

export default function CustomerLoginPage() {
  const [loading, setLoading] = useState(false);
  const [customerType, setCustomerType] = useState('INDIVIDUAL');
  const [step, setStep] = useState(1);
  const [step1Data, setStep1Data] = useState(null);
  const [otpCountdown, setOtpCountdown] = useState(60);
  const [resending, setResending] = useState(false);
  const { loginCustomer } = useCustomerAuth();
  const { t, lang } = useLanguage();
  const [form] = Form.useForm();
  const [otpForm] = Form.useForm();
  const captchaRef = useRef(null);

  // Đếm ngược gửi lại OTP
  useEffect(() => {
    let timer = null;
    if (step === 2 && otpCountdown > 0) {
      timer = setInterval(() => {
        setOtpCountdown((prev) => (prev > 0 ? prev - 1 : 0));
      }, 1000);
    }
    return () => {
      if (timer) clearInterval(timer);
    };
  }, [step, otpCountdown]);

  // Modal Quên mật khẩu
  const [forgotModalOpen, setForgotModalOpen] = useState(false);
  const [forgotStep, setForgotStep] = useState(1);
  const [forgotLoading, setForgotLoading] = useState(false);
  const [forgotInfo, setForgotInfo] = useState(null);
  const [forgotForm] = Form.useForm();
  const [resetForm] = Form.useForm();

  // BƯỚC 1: Kiểm tra mật khẩu + Captcha
  const handleLogin = async (values) => {
    // Kiểm tra mã captcha
    const expected = captchaRef.current?.getCode()?.toUpperCase();
    if (!expected || values.captcha?.trim().toUpperCase() !== expected) {
      message.error(
        lang === 'vi'
          ? 'Mã xác thực chống bot không chính xác! Vui lòng nhập lại.'
          : 'Security captcha is incorrect. Please try again!'
      );
      captchaRef.current?.refresh();
      return;
    }

    setLoading(true);
    try {
      const res = await unwrap(
        client.post('/customer/auth/login', {
          username: values.username,
          password: values.password,
        })
      );

      // Nếu backend yêu cầu xác thực OTP 2FA (có tempToken)
      if (res.tempToken) {
        setStep1Data(res);
        setStep(2);
        setOtpCountdown(60);
        otpForm.resetFields();
        if (res.devOtp) {
          message.info(
            lang === 'vi'
              ? `[MÔI TRƯỜNG DEV] Mã OTP xác thực: ${res.devOtp}. Vui lòng nhập mã để hoàn tất!`
              : `[DEV ENVIRONMENT] Security OTP: ${res.devOtp}. Please enter to verify!`
          );
        }
      } else {
        // Trực tiếp (nếu có access token ngay)
        loginCustomer(res);
        message.success(
          lang === 'vi'
            ? `Chào mừng ${res.fullName} đến với Vietcombank Digital Portal!`
            : `Welcome ${res.fullName} to Vietcombank Digital Portal!`
        );
        window.location.hash = '#/portal';
      }
    } catch (err) {
      captchaRef.current?.refresh();
      message.error(
        err.response?.data?.message ||
          (lang === 'vi'
            ? 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin!'
            : 'Login failed. Please verify your credentials!')
      );
    } finally {
      setLoading(false);
    }
  };

  // BƯỚC 2: Xác thực mã Smart OTP
  const handleVerifyOtp = async (values) => {
    setLoading(true);
    try {
      const res = await unwrap(
        client.post('/customer/auth/verify-otp', {
          username: step1Data.username,
          tempToken: step1Data.tempToken,
          otpCode: values.otpCode,
        })
      );

      loginCustomer(res);
      message.success(
        lang === 'vi'
          ? `Đăng nhập thành công! Chào mừng ${res.fullName}`
          : `Login successful! Welcome ${res.fullName}`
      );
      window.location.hash = '#/portal';
    } catch (err) {
      message.error(
        err.response?.data?.message ||
          (lang === 'vi'
            ? 'Mã OTP không chính xác hoặc đã hết hạn!'
            : 'OTP is incorrect or expired!')
      );
    } finally {
      setLoading(false);
    }
  };

  // Gửi lại mã OTP
  const handleResendOtp = async () => {
    if (otpCountdown > 0) return;
    setResending(true);
    try {
      const res = await unwrap(
        client.post('/customer/auth/resend-otp', {
          username: step1Data.username,
          tempToken: step1Data.tempToken,
        })
      );
      setStep1Data((prev) => ({ ...prev, ...res }));
      setOtpCountdown(60);
      otpForm.resetFields();
      message.success(
        lang === 'vi'
          ? `Đã gửi lại mã OTP tới ${res.maskedPhone || 'số điện thoại của Quý khách'}`
          : `New OTP sent to ${res.maskedPhone}`
      );
      if (res.devOtp) {
        message.info(
          lang === 'vi'
            ? `[MÔI TRƯỜNG DEV] Mã OTP mới: ${res.devOtp}`
            : `[DEV ENVIRONMENT] New OTP: ${res.devOtp}`
        );
      }
    } catch (err) {
      message.error(err.response?.data?.message || 'Không thể gửi lại mã OTP');
    } finally {
      setResending(false);
    }
  };

  const fillQuickAccount = (username, pass, type) => {
    setStep(1);
    setCustomerType(type);
    const code = captchaRef.current?.getCode() || '';
    form.setFieldsValue({
      username,
      password: pass,
      captcha: code,
    });
    message.success(
      lang === 'vi'
        ? `Đã điền tài khoản: ${username}. Bấm "Tiếp tục xác thực OTP" để nhận mã OTP!`
        : `Filled: ${username}. Click "Continue with OTP" to get your code!`
    );
  };

  const handleForgotStep1 = async (values) => {
    setForgotLoading(true);
    try {
      const res = await unwrap(client.post('/customer/auth/forgot-password', { username: values.username }));
      setForgotInfo(res);
      setForgotStep(2);
      resetForm.resetFields();
      if (res.devOtp) {
        resetForm.setFieldsValue({ otpCode: res.devOtp });
        message.info(
          lang === 'vi'
            ? `[MÔI TRƯỜNG DEV] Mã OTP xác thực: ${res.devOtp}`
            : `[DEV ENVIRONMENT] Security OTP: ${res.devOtp}`
        );
      }
    } catch (err) {
      message.error(err.response?.data?.message || 'Không tìm thấy tài khoản tương ứng');
    } finally {
      setForgotLoading(false);
    }
  };

  const handleForgotStep2 = async (values) => {
    if (values.newPassword !== values.confirmPassword) {
      message.error(lang === 'vi' ? 'Mật khẩu xác nhận không khớp!' : 'Passwords do not match!');
      return;
    }
    setForgotLoading(true);
    try {
      await unwrap(
        client.post('/customer/auth/reset-password', {
          username: forgotInfo.username,
          otpCode: values.otpCode,
          newPassword: values.newPassword,
        })
      );
      message.success(
        lang === 'vi'
          ? 'Đặt lại mật khẩu thành công! Quý khách có thể đăng nhập ngay với mật khẩu mới.'
          : 'Password reset successful! You can now log in.'
      );
      setForgotModalOpen(false);
      setForgotStep(1);
      form.setFieldsValue({ username: forgotInfo.username });
    } catch (err) {
      message.error(err.response?.data?.message || 'Không thể đặt lại mật khẩu');
    } finally {
      setForgotLoading(false);
    }
  };

  return (
    <div
      style={{
        minHeight: '100vh',
        background: 'linear-gradient(135deg, #002B18 0%, #00482B 50%, #0B3D25 100%)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '32px 20px',
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      {/* Background Decorative Glow Orbs */}
      <div
        style={{
          position: 'absolute',
          top: '-15%',
          right: '-10%',
          width: '520px',
          height: '520px',
          borderRadius: '50%',
          background: 'radial-gradient(circle, rgba(115,184,40,0.18) 0%, rgba(0,72,43,0) 70%)',
          pointerEvents: 'none',
        }}
      />
      <div
        style={{
          position: 'absolute',
          bottom: '-20%',
          left: '-10%',
          width: '600px',
          height: '600px',
          borderRadius: '50%',
          background: 'radial-gradient(circle, rgba(0,72,43,0.4) 0%, rgba(0,40,20,0) 70%)',
          pointerEvents: 'none',
        }}
      />

      <div
        style={{
          maxWidth: 960,
          width: '100%',
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(340px, 1fr))',
          background: 'rgba(255, 255, 255, 0.98)',
          borderRadius: 20,
          boxShadow: '0 24px 64px rgba(0, 20, 10, 0.45)',
          overflow: 'hidden',
          border: '1px solid rgba(255, 255, 255, 0.2)',
          zIndex: 1,
        }}
      >
        {/* LEFT COLUMN: BRANDING & HIGHLIGHTS */}
        <div
          style={{
            background: 'linear-gradient(145deg, #003820 0%, #00482B 65%, #005A36 100%)',
            padding: '40px 36px',
            color: '#fff',
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'space-between',
            position: 'relative',
          }}
        >
          <div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 28 }}>
              <div
                style={{
                  background: '#73B828',
                  borderRadius: 10,
                  width: 44,
                  height: 44,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: '#00482B',
                  fontWeight: 900,
                  fontSize: 20,
                  boxShadow: '0 4px 12px rgba(115,184,40,0.35)',
                }}
              >
                VCB
              </div>
              <div>
                <Text strong style={{ color: '#fff', fontSize: 16, display: 'block', letterSpacing: 0.5, lineHeight: 1.2 }}>
                  VIETCOMBANK
                </Text>
                <Text style={{ color: '#A2DEB1', fontSize: 11, fontWeight: 600, letterSpacing: 1 }}>
                  DIGITAL BANKING PORTAL
                </Text>
              </div>
            </div>

            <Title level={3} style={{ color: '#FFFFFF', fontWeight: 700, margin: '0 0 12px 0', lineHeight: 1.3 }}>
              {lang === 'vi' ? 'Hệ sinh thái Ngân hàng số Đột phá' : 'Next-Gen Digital Banking Experience'}
            </Title>
            <Paragraph style={{ color: '#D1E7DD', fontSize: 13.5, lineHeight: 1.6, marginBottom: 28 }}>
              {lang === 'vi'
                ? 'Giải pháp tài chính thông minh, bảo mật đa tầng, phục vụ tức thì mọi nhu cầu vay vốn, thẻ tín dụng, tiết kiệm và quản lý dòng tiền doanh nghiệp.'
                : 'Intelligent financial solutions with multi-layer security, instant credit financing, international cards, and automated cash management.'}
            </Paragraph>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
                <CheckCircleFilled style={{ color: '#73B828', fontSize: 18, marginTop: 2 }} />
                <div>
                  <Text strong style={{ color: '#FFFFFF', fontSize: 13, display: 'block' }}>
                    {lang === 'vi' ? 'Phê duyệt hồ sơ trực tuyến 24/7' : '24/7 Instant Online Approval'}
                  </Text>
                  <Text style={{ color: '#A2DEB1', fontSize: 12 }}>
                    {lang === 'vi' ? 'Tiếp cận nguồn vốn tiêu dùng & SXKD nhanh chóng' : 'Quick access to personal and business credit lines'}
                  </Text>
                </div>
              </div>

              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
                <SafetyCertificateFilled style={{ color: '#73B828', fontSize: 18, marginTop: 2 }} />
                <div>
                  <Text strong style={{ color: '#FFFFFF', fontSize: 13, display: 'block' }}>
                    {lang === 'vi' ? 'Bảo mật tiêu chuẩn Quốc tế' : 'Bank-Grade Global Security'}
                  </Text>
                  <Text style={{ color: '#A2DEB1', fontSize: 12 }}>
                    {lang === 'vi' ? 'Mã hóa dữ liệu cấp ngân hàng, xác thực đa yếu tố' : 'End-to-end encryption with advanced MFA'}
                  </Text>
                </div>
              </div>

              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
                <ThunderboltFilled style={{ color: '#73B828', fontSize: 18, marginTop: 2 }} />
                <div>
                  <Text strong style={{ color: '#FFFFFF', fontSize: 13, display: 'block' }}>
                    {lang === 'vi' ? 'Lãi suất tiết kiệm cạnh tranh' : 'High-Yield Savings & Smart Rates'}
                  </Text>
                  <Text style={{ color: '#A2DEB1', fontSize: 12 }}>
                    {lang === 'vi' ? 'Tối ưu lợi nhuận cho nguồn vốn nhàn rỗi' : 'Maximize returns on individual and enterprise deposits'}
                  </Text>
                </div>
              </div>
            </div>
          </div>

          <div
            style={{
              paddingTop: 24,
              borderTop: '1px solid rgba(255,255,255,0.12)',
              marginTop: 28,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <BankOutlined style={{ color: '#73B828', fontSize: 16 }} />
              <Text style={{ color: '#A2DEB1', fontSize: 12 }}>Hotline 24/7: <strong>1900 54 54 13</strong></Text>
            </div>
            <Tag color="#73B828" style={{ color: '#00482B', fontWeight: 700, margin: 0, border: 'none' }}>
              PROD 2026
            </Tag>
          </div>
        </div>

        {/* RIGHT COLUMN: LOGIN FORM */}
        <div style={{ padding: '36px 36px 28px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
          <div>
            {/* Top Bar: Language & Public Portal Link */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 20 }}>
              <a
                href="#/portal"
                style={{
                  color: '#637381',
                  fontSize: 12.5,
                  display: 'flex',
                  alignItems: 'center',
                  gap: 5,
                  fontWeight: 500,
                  transition: 'color 0.2s',
                }}
              >
                <ArrowLeftOutlined style={{ fontSize: 11 }} /> {lang === 'vi' ? 'Cổng thông tin' : 'Public Web'}
              </a>
              <LanguageSwitcher size="small" />
            </div>

            <div style={{ marginBottom: 20 }}>
              <Title level={3} style={{ margin: 0, color: '#00482B', fontWeight: 700, fontSize: 22 }}>
                {step === 1
                  ? (lang === 'vi' ? 'Đăng nhập Khách hàng' : 'Customer Sign In')
                  : (lang === 'vi' ? 'Xác thực Smart OTP (Bước 2/2)' : 'Smart OTP Verification (Step 2/2)')}
              </Title>
              <Text type="secondary" style={{ fontSize: 13 }}>
                {step === 1
                  ? (lang === 'vi'
                    ? 'Vui lòng chọn loại tài khoản và nhập thông tin đăng nhập'
                    : 'Select your account type and enter your credentials')
                  : (lang === 'vi'
                    ? 'Nhập mã OTP 6 số được gửi tới số điện thoại/email của Quý khách'
                    : 'Enter the 6-digit OTP sent to your phone or email')}
              </Text>
            </div>

            {step === 1 && (
              <>
                {/* Account Type Segmented Tab */}
                <div style={{ marginBottom: 20 }}>
                  <Segmented
                    block
                    size="large"
                    value={customerType}
                    onChange={(val) => setCustomerType(val)}
                    options={[
                      {
                        label: (
                          <div style={{ padding: '4px 0', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8, fontWeight: 600 }}>
                            <UserOutlined />
                            <span>{t('customer.individual')}</span>
                          </div>
                        ),
                        value: 'INDIVIDUAL',
                      },
                      {
                        label: (
                          <div style={{ padding: '4px 0', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8, fontWeight: 600 }}>
                            <ShopOutlined />
                            <span>{t('customer.enterprise')}</span>
                          </div>
                        ),
                        value: 'ENTERPRISE',
                      },
                    ]}
                    style={{
                      background: '#F1F5F9',
                      padding: 3,
                      borderRadius: 10,
                    }}
                  />
                </div>

                {/* Login Form Step 1 */}
                <Form form={form} layout="vertical" onFinish={handleLogin} requiredMark={false}>
                  <Form.Item
                    name="username"
                    label={
                      <span style={{ fontWeight: 600, fontSize: 13, color: '#1C252E' }}>
                        {customerType === 'INDIVIDUAL'
                          ? (lang === 'vi' ? 'Tên đăng nhập / Số CCCD' : 'Username / National ID')
                          : (lang === 'vi' ? 'Mã Doanh nghiệp / Tên đăng nhập' : 'Business Tax ID / Username')}
                      </span>
                    }
                    rules={[
                      {
                        required: true,
                        message:
                          lang === 'vi'
                            ? 'Vui lòng nhập tên đăng nhập / mã khách hàng'
                            : 'Please enter your username or ID',
                      },
                    ]}
                  >
                    <Input
                      prefix={<UserOutlined style={{ color: '#00482B', marginRight: 4 }} />}
                      placeholder={
                        customerType === 'INDIVIDUAL'
                          ? (lang === 'vi' ? 'VD: kh_thuha hoặc 001198000123' : 'e.g. kh_thuha or ID number')
                          : (lang === 'vi' ? 'VD: dn_abctech hoặc 0101234567' : 'e.g. dn_abctech or Tax ID')
                      }
                      size="large"
                      style={{ borderRadius: 8 }}
                    />
                  </Form.Item>

                  <Form.Item
                    name="password"
                    label={
                      <div style={{ display: 'flex', justifyContent: 'space-between', width: '100%' }}>
                        <span style={{ fontWeight: 600, fontSize: 13, color: '#1C252E' }}>
                          {lang === 'vi' ? 'Mật khẩu bảo mật' : 'Password'}
                        </span>
                        <a
                          href="#/portal"
                          onClick={(e) => {
                            e.preventDefault();
                            setForgotModalOpen(true);
                            setForgotStep(1);
                            forgotForm.resetFields();
                          }}
                          style={{ fontSize: 12, color: '#005030', fontWeight: 600 }}
                        >
                          {lang === 'vi' ? 'Quên mật khẩu?' : 'Forgot password?'}
                        </a>
                      </div>
                    }
                    rules={[
                      {
                        required: true,
                        message:
                          lang === 'vi' ? 'Vui lòng nhập mật khẩu tài khoản' : 'Please enter your password',
                      },
                    ]}
                  >
                    <Input.Password
                      prefix={<LockOutlined style={{ color: '#00482B', marginRight: 4 }} />}
                      placeholder={lang === 'vi' ? 'Nhập mật khẩu' : 'Enter password'}
                      size="large"
                      style={{ borderRadius: 8 }}
                    />
                  </Form.Item>

                  {/* Visual Captcha */}
                  <Form.Item
                    name="captcha"
                    label={
                      <span style={{ fontWeight: 600, fontSize: 13, color: '#1C252E' }}>
                        {lang === 'vi' ? 'Mã kiểm tra chống bot' : 'Security Captcha'}
                      </span>
                    }
                    rules={[
                      {
                        required: true,
                        message: lang === 'vi' ? 'Vui lòng nhập mã kiểm tra' : 'Please enter security code',
                      },
                    ]}
                  >
                    <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
                      <Input
                        prefix={<SafetyOutlined style={{ color: '#00482B', marginRight: 4 }} />}
                        placeholder={lang === 'vi' ? 'Nhập mã bên cạnh' : 'Enter code'}
                        size="large"
                        maxLength={6}
                        style={{ borderRadius: 8, textTransform: 'uppercase', letterSpacing: 2, fontWeight: 700 }}
                      />
                      <VisualCaptcha ref={captchaRef} width={120} height={40} />
                    </div>
                  </Form.Item>

                  <Button
                    type="primary"
                    htmlType="submit"
                    size="large"
                    block
                    loading={loading}
                    style={{
                      background: 'linear-gradient(135deg, #00482B 0%, #005A36 100%)',
                      borderColor: '#00482B',
                      height: 46,
                      fontSize: 15,
                      fontWeight: 700,
                      letterSpacing: 0.3,
                      marginTop: 6,
                      boxShadow: '0 4px 12px rgba(0,72,43,0.25)',
                    }}
                  >
                    {lang === 'vi' ? 'Tiếp tục xác thực OTP →' : 'Continue with OTP →'}
                  </Button>
                </Form>
              </>
            )}

            {/* Step 2: OTP Form */}
            {step === 2 && (
              <div>
                <Alert
                  type="success"
                  showIcon
                  icon={<SafetyCertificateFilled style={{ color: '#005030' }} />}
                  style={{ marginBottom: 18, borderRadius: 10, background: '#F0F9EB', border: '1px solid #B7EB8F' }}
                  message={
                    <span style={{ fontWeight: 700, color: '#005030', fontSize: 14 }}>
                      {lang === 'vi' ? 'Xác thực tài khoản an toàn 2 lớp' : '2-Factor Authentication'}
                    </span>
                  }
                  description={
                    <div style={{ fontSize: 13, color: '#274C37', marginTop: 4 }}>
                      <div>
                        {lang === 'vi' ? 'Khách hàng: ' : 'Customer: '}
                        <strong>{step1Data?.fullName}</strong> ({step1Data?.username})
                      </div>
                      <div>
                        {lang === 'vi' ? 'Mã OTP gửi tới: ' : 'OTP sent to: '}
                        <strong>{step1Data?.maskedPhone || step1Data?.maskedEmail || 'SĐT đăng ký'}</strong>
                      </div>
                      {step1Data?.devOtp && (
                        <div style={{ marginTop: 8, padding: '6px 10px', background: '#E8F5E9', borderRadius: 6, border: '1px dashed #4CAF50' }}>
                          <span style={{ color: '#2E7D32', fontWeight: 600 }}>
                            {lang === 'vi' ? '🔑 [DEV MODE] Mã OTP: ' : '🔑 [DEV MODE] OTP: '}
                          </span>
                          <strong style={{ fontSize: 18, color: '#D32F2F', letterSpacing: 3 }}>
                            {step1Data.devOtp}
                          </strong>
                        </div>
                      )}
                    </div>
                  }
                />

                <Form form={otpForm} layout="vertical" onFinish={handleVerifyOtp} requiredMark={false}>
                  <Form.Item
                    name="otpCode"
                    label={
                      <span style={{ fontWeight: 600, fontSize: 13, color: '#1C252E' }}>
                        {lang === 'vi' ? 'Nhập mã Smart OTP 6 số' : 'Enter 6-digit OTP code'}
                      </span>
                    }
                    rules={[
                      { required: true, message: lang === 'vi' ? 'Vui lòng nhập mã OTP' : 'Please enter OTP' },
                      { len: 6, message: lang === 'vi' ? 'Mã OTP gồm đúng 6 chữ số' : 'OTP must be 6 digits' },
                    ]}
                  >
                    <Input
                      prefix={<KeyOutlined style={{ color: '#005030', marginRight: 4 }} />}
                      placeholder="123456"
                      size="large"
                      maxLength={6}
                      autoFocus
                      style={{
                        borderRadius: 8,
                        textAlign: 'center',
                        fontSize: 24,
                        letterSpacing: 8,
                        fontWeight: 700,
                        color: '#005030',
                        height: 50,
                      }}
                    />
                  </Form.Item>

                  <Button
                    type="primary"
                    htmlType="submit"
                    size="large"
                    block
                    loading={loading}
                    style={{
                      background: 'linear-gradient(135deg, #00482B 0%, #005A36 100%)',
                      borderColor: '#00482B',
                      height: 46,
                      fontSize: 15,
                      fontWeight: 700,
                      boxShadow: '0 4px 12px rgba(0,72,43,0.25)',
                    }}
                  >
                    {lang === 'vi' ? 'Xác nhận & Đăng nhập' : 'Verify & Sign In'}
                  </Button>

                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 16 }}>
                    <Button
                      type="link"
                      onClick={() => setStep(1)}
                      style={{ padding: 0, color: '#637381', fontSize: 13 }}
                    >
                      ← {lang === 'vi' ? 'Quay lại bước 1' : 'Back to Step 1'}
                    </Button>
                    <Button
                      type="link"
                      onClick={handleResendOtp}
                      loading={resending}
                      disabled={otpCountdown > 0}
                      style={{
                        padding: 0,
                        color: otpCountdown > 0 ? '#919EAB' : '#005030',
                        fontWeight: 600,
                        fontSize: 13,
                      }}
                    >
                      {otpCountdown > 0
                        ? (lang === 'vi' ? `Gửi lại mã sau (${otpCountdown}s)` : `Resend in (${otpCountdown}s)`)
                        : (lang === 'vi' ? 'Gửi lại mã OTP' : 'Resend OTP')}
                    </Button>
                  </div>
                </Form>
              </div>
            )}

            {/* Registration Banner */}
            <div
              style={{
                marginTop: 18,
                padding: '10px 14px',
                background: '#EBF7E3',
                borderRadius: 8,
                border: '1px solid rgba(115,184,40,0.4)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
              }}
            >
              <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                <UserAddOutlined style={{ color: '#00482B', fontSize: 15 }} />
                <Text style={{ fontSize: 12.5, color: '#003820', fontWeight: 500 }}>
                  {lang === 'vi' ? 'Chưa có tài khoản e-Banking?' : 'Need a digital banking account?'}
                </Text>
              </div>
              <a
                href="#/customer/register"
                style={{
                  color: '#00482B',
                  fontWeight: 700,
                  fontSize: 12.5,
                  textDecoration: 'underline',
                  whiteSpace: 'nowrap',
                }}
              >
                {lang === 'vi' ? 'Đăng ký ngay' : 'Register now'}
              </a>
            </div>

            {/* Quick Demo Accounts */}
            <Divider orientation="center" style={{ fontSize: 11, color: '#919EAB', margin: '20px 0 10px' }}>
              {lang === 'vi' ? 'TÀI KHOẢN TRẢI NGHIỆM ĐIỀN NHANH (DEMO)' : 'CUSTOMER QUICK LOGIN ACCOUNTS'}
            </Divider>

            <div
              style={{
                background: '#F8FAFC',
                padding: '8px 12px',
                borderRadius: 8,
                border: '1px dashed #CBD5E1',
                display: 'flex',
                flexDirection: 'column',
                gap: 6,
              }}
            >
              {/* Account 1: kh_thuha */}
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ fontSize: 12 }}>
                  <Tag color="green" style={{ fontSize: 10, padding: '0 4px', margin: '0 6px 0 0' }}>CÁ NHÂN</Tag>
                  <code style={{ color: '#00482B', fontWeight: 600 }}>kh_thuha</code>
                </div>
                <Button
                  size="small"
                  type="link"
                  onClick={() => fillQuickAccount('kh_thuha', 'Customer@123', 'INDIVIDUAL')}
                  style={{ color: '#00482B', fontWeight: 600, fontSize: 12, padding: 0 }}
                >
                  {lang === 'vi' ? 'Điền nhanh →' : 'Quick Fill →'}
                </Button>
              </div>

              {/* Account 2: kh_namle */}
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ fontSize: 12 }}>
                  <Tag color="cyan" style={{ fontSize: 10, padding: '0 4px', margin: '0 6px 0 0' }}>VAY VỐN</Tag>
                  <code style={{ color: '#00482B', fontWeight: 600 }}>kh_namle</code>
                </div>
                <Button
                  size="small"
                  type="link"
                  onClick={() => fillQuickAccount('kh_namle', 'Customer@123', 'INDIVIDUAL')}
                  style={{ color: '#0891B2', fontWeight: 600, fontSize: 12, padding: 0 }}
                >
                  {lang === 'vi' ? 'Điền nhanh →' : 'Quick Fill →'}
                </Button>
              </div>

              {/* Account 3: dn_abctech */}
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ fontSize: 12 }}>
                  <Tag color="geekblue" style={{ fontSize: 10, padding: '0 4px', margin: '0 6px 0 0' }}>DOANH NGHIỆP</Tag>
                  <code style={{ color: '#00482B', fontWeight: 600 }}>dn_abctech</code>
                </div>
                <Button
                  size="small"
                  type="link"
                  onClick={() => fillQuickAccount('dn_abctech', 'Customer@123', 'ENTERPRISE')}
                  style={{ color: '#2563EB', fontWeight: 600, fontSize: 12, padding: 0 }}
                >
                  {lang === 'vi' ? 'Điền nhanh →' : 'Quick Fill →'}
                </Button>
              </div>
            </div>
          </div>

          <div style={{ textAlign: 'center', marginTop: 16 }}>
            <a href="#/login" style={{ color: '#637381', fontSize: 12 }}>
              {lang === 'vi' ? '🔒 Cán bộ & Quản trị viên VCB? Đăng nhập tại đây' : '🔒 Internal Staff Login Portal'}
            </a>
          </div>
        </div>
      </div>

      {/* MODAL: QUÊN MẬT KHẨU & ĐẶT LẠI MẬT KHẨU */}
      <Modal
        title={
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, color: '#00482B' }}>
            <KeyOutlined style={{ color: '#73B828' }} />
            <span>{lang === 'vi' ? 'Khôi phục Mật khẩu Khách hàng' : 'Customer Password Recovery'}</span>
          </div>
        }
        open={forgotModalOpen}
        onCancel={() => {
          setForgotModalOpen(false);
          setForgotStep(1);
        }}
        footer={null}
        destroyOnClose
        width={480}
      >
        {forgotStep === 1 ? (
          <Form form={forgotForm} layout="vertical" onFinish={handleForgotStep1} style={{ marginTop: 16 }}>
            <Alert
              type="info"
              showIcon
              message={lang === 'vi' ? 'Xác minh danh tính khách hàng' : 'Customer Verification'}
              description={
                lang === 'vi'
                  ? 'Vui lòng nhập Tên đăng nhập, Email hoặc Số CMND/CCCD/Mã số thuế đã đăng ký với Vietcombank. Hệ thống sẽ gửi mã xác thực OTP về số điện thoại của bạn.'
                  : 'Enter your registered Username, Email, or National ID. An OTP code will be sent to your verified phone number.'
              }
              style={{ marginBottom: 20 }}
            />
            <Form.Item
              name="username"
              label={<span style={{ fontWeight: 600 }}>{lang === 'vi' ? 'Tên đăng nhập / CCCD / Email' : 'Username / ID / Email'}</span>}
              rules={[{ required: true, message: lang === 'vi' ? 'Vui lòng nhập thông tin xác thực' : 'Please enter your username/ID' }]}
            >
              <Input
                prefix={<UserOutlined style={{ color: '#00482B' }} />}
                placeholder={lang === 'vi' ? 'VD: kh_thuha, kh_namle hoặc dn_abctech' : 'e.g. kh_thuha or ID'}
                size="large"
              />
            </Form.Item>
            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10, marginTop: 24 }}>
              <Button onClick={() => setForgotModalOpen(false)}>
                {lang === 'vi' ? 'Hủy bỏ' : 'Cancel'}
              </Button>
              <Button
                type="primary"
                htmlType="submit"
                loading={forgotLoading}
                style={{ background: '#00482B', borderColor: '#00482B' }}
              >
                {lang === 'vi' ? 'Tiếp tục nhận OTP →' : 'Continue to OTP →'}
              </Button>
            </div>
          </Form>
        ) : (
          <Form form={resetForm} layout="vertical" onFinish={handleForgotStep2} style={{ marginTop: 16 }}>
            <Alert
              type="success"
              showIcon
              message={lang === 'vi' ? 'Đã gửi mã xác thực OTP' : 'OTP Code Sent'}
              description={
                <div>
                  <p style={{ margin: '0 0 6px 0' }}>
                    {lang === 'vi'
                      ? `Mã OTP đã được gửi tới số điện thoại đăng ký: ${forgotInfo?.maskedPhone || 'của quý khách'}`
                      : `OTP has been sent to: ${forgotInfo?.maskedPhone}`}
                  </p>
                  {forgotInfo?.devOtp && (
                    <Tag color="green" style={{ fontSize: 13, padding: '2px 8px' }}>
                      [DEV] Mã OTP: <strong>{forgotInfo.devOtp}</strong>
                    </Tag>
                  )}
                </div>
              }
              style={{ marginBottom: 20 }}
            />

            <Form.Item
              name="otpCode"
              label={<span style={{ fontWeight: 600 }}>{lang === 'vi' ? 'Mã xác thực OTP (6 chữ số)' : 'OTP Verification Code'}</span>}
              rules={[
                { required: true, message: lang === 'vi' ? 'Vui lòng nhập mã OTP' : 'Please enter OTP' },
                { len: 6, message: lang === 'vi' ? 'Mã OTP gồm 6 chữ số' : 'OTP must be 6 digits' }
              ]}
            >
              <Input
                size="large"
                maxLength={6}
                placeholder="123456"
                style={{ letterSpacing: 4, fontWeight: 700, textAlign: 'center' }}
              />
            </Form.Item>

            <Form.Item
              name="newPassword"
              label={<span style={{ fontWeight: 600 }}>{lang === 'vi' ? 'Mật khẩu mới' : 'New Password'}</span>}
              rules={[
                { required: true, message: lang === 'vi' ? 'Vui lòng nhập mật khẩu mới' : 'Please enter new password' },
                { min: 6, message: lang === 'vi' ? 'Mật khẩu tối thiểu 6 ký tự' : 'At least 6 characters' }
              ]}
            >
              <Input.Password
                prefix={<LockOutlined style={{ color: '#00482B' }} />}
                size="large"
                placeholder={lang === 'vi' ? 'Nhập mật khẩu mới' : 'Enter new password'}
              />
            </Form.Item>

            <Form.Item
              name="confirmPassword"
              label={<span style={{ fontWeight: 600 }}>{lang === 'vi' ? 'Xác nhận mật khẩu mới' : 'Confirm New Password'}</span>}
              rules={[{ required: true, message: lang === 'vi' ? 'Vui lòng xác nhận mật khẩu' : 'Please confirm password' }]}
            >
              <Input.Password
                prefix={<LockOutlined style={{ color: '#00482B' }} />}
                size="large"
                placeholder={lang === 'vi' ? 'Nhập lại mật khẩu mới' : 'Confirm new password'}
              />
            </Form.Item>

            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 24 }}>
              <Button type="link" onClick={() => setForgotStep(1)} style={{ padding: 0 }}>
                ← {lang === 'vi' ? 'Quay lại bước 1' : 'Back to Step 1'}
              </Button>
              <Space>
                <Button onClick={() => setForgotModalOpen(false)}>
                  {lang === 'vi' ? 'Đóng' : 'Close'}
                </Button>
                <Button
                  type="primary"
                  htmlType="submit"
                  loading={forgotLoading}
                  style={{ background: '#00482B', borderColor: '#00482B' }}
                >
                  {lang === 'vi' ? 'Xác nhận đổi mật khẩu' : 'Confirm Reset Password'}
                </Button>
              </Space>
            </div>
          </Form>
        )}
      </Modal>
    </div>
  );
}
