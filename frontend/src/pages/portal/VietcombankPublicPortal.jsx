import { useEffect, useRef, useState } from 'react';
import {
  Alert,
  Avatar,
  Badge,
  Button,
  Card,
  Col,
  Divider,
  Drawer,
  Dropdown,
  Form,
  Input,
  InputNumber,
  Layout,
  Modal,
  Radio,
  Row,
  Select,
  Space,
  Statistic,
  Table,
  Tabs,
  Tag,
  Typography,
  message,
} from 'antd';
import {
  BankOutlined,
  CalculatorOutlined,
  CalendarOutlined,
  CheckCircleOutlined,
  CheckOutlined,
  ClockCircleOutlined,
  CloseOutlined,
  CompassOutlined,
  CustomerServiceOutlined,
  DashboardOutlined,
  DollarOutlined,
  DownOutlined,
  EnvironmentOutlined,
  FileDoneOutlined,
  GoldOutlined,
  LeftOutlined,
  LoginOutlined,
  LogoutOutlined,
  MessageOutlined,
  PercentageOutlined,
  PhoneOutlined,
  QuestionCircleOutlined,
  ReadOutlined,
  RightOutlined,
  RobotOutlined,
  SafetyCertificateOutlined,
  SafetyOutlined,
  SearchOutlined,
  SecurityScanOutlined,
  SendOutlined,
  TableOutlined,
  UserOutlined,
  WarningOutlined,
  FileTextOutlined,
  DownloadOutlined,
} from '@ant-design/icons';
import dayjs from 'dayjs';
import client from '../../api/client';
import { useLanguage } from '../../store/LanguageContext';
import { useCustomerAuth } from '../../store/CustomerAuthContext';
import LanguageSwitcher from '../../components/LanguageSwitcher';

const { Header, Content, Footer } = Layout;
const { Title, Text, Paragraph } = Typography;
const { Option } = Select;

export default function VietcombankPublicPortal() {
  const { t, lang } = useLanguage();
  const { isCustomerLoggedIn, customer, logoutCustomer } = useCustomerAuth();

  const customerMenuItems = [
    {
      key: 'dashboard',
      icon: <DashboardOutlined />,
      label: t('customer.menuDashboard') || 'Bảng điều khiển',
      onClick: () => {
        window.location.hash = '#/customer/dashboard';
      },
    },
    {
      key: 'my_apps',
      icon: <FileDoneOutlined />,
      label: t('customer.menuMyApplications') || 'Hồ sơ của tôi',
      onClick: () => {
        window.location.hash = '#/customer/my-applications';
      },
    },
    { type: 'divider' },
    {
      key: 'logout',
      icon: <LogoutOutlined />,
      label: t('common.logout') || 'Đăng xuất',
      danger: true,
      onClick: () => {
        logoutCustomer();
        message.success(lang === 'vi' ? 'Đã đăng xuất tài khoản khách hàng' : 'Customer logged out successfully');
      },
    },
  ];

  const [exchangeRates, setExchangeRates] = useState([]);
  const [goldRates, setGoldRates] = useState([]);
  const [interestRates, setInterestRates] = useState([]);
  const [posts, setPosts] = useState([]);
  const [feeTemplates, setFeeTemplates] = useState([]);
  const [chatbotFaqs, setChatbotFaqs] = useState([]);
  const [branches, setBranches] = useState([]);
  const [loadingRates, setLoadingRates] = useState(false);

  // Tra cứu nhanh tiến độ (Tracking Widget)
  const [trackCode, setTrackCode] = useState('');
  const [trackingLoading, setTrackingLoading] = useState(false);
  const [trackResultModal, setTrackResultModal] = useState(false);
  const [trackResult, setTrackResult] = useState(null);

  // Modal Bảng phân bổ lịch trả nợ chi tiết (Amortization Schedule)
  const [amortizationModalVisible, setAmortizationModalVisible] = useState(false);

  // Modal Đăng ký trực tuyến
  const [applyModalVisible, setApplyModalVisible] = useState(false);
  const [applyForm] = Form.useForm();
  const [submittingApply, setSubmittingApply] = useState(false);
  const [applySuccessData, setApplySuccessData] = useState(null);

  // State công cụ tính lãi vay / tiết kiệm
  const [calcType, setCalcType] = useState('LOAN'); // LOAN | SAVING
  const [calcAmount, setCalcAmount] = useState(100000000); // 100 triệu
  const [calcTerm, setCalcTerm] = useState(12); // 12 tháng
  const [calcRate, setCalcRate] = useState(7.5); // % / năm

  // Nút chạy ngang tin tức (Horizontal News Carousel)
  const newsScrollRef = useRef(null);
  const scrollNews = (direction) => {
    if (newsScrollRef.current) {
      const scrollOffset = direction === 'left' ? -380 : 380;
      newsScrollRef.current.scrollBy({ left: scrollOffset, behavior: 'smooth' });
    }
  };

  // Chatbot state
  const [chatDrawerVisible, setChatDrawerVisible] = useState(false);
  const [chatTab, setChatTab] = useState('chat'); // 'chat' | 'appointment' | 'contact' | 'guide'
  const [chatInput, setChatInput] = useState('');
  const [chatMessages, setChatMessages] = useState([
    {
      id: 1,
      sender: 'bot',
      text: 'Xin chào quý khách! Tôi là VCB AI Assistant của Ngân hàng Vietcombank 🇻🇳. Tôi có thể hỗ trợ quý khách:\n• 📅 Đặt lịch hẹn giao dịch tại quầy chi nhánh\n• 📞 Hotline liên hệ & Hỗ trợ CSKH 24/7\n• 📖 Hướng dẫn sử dụng VCB Digibank, mở tài khoản & vay vốn\nQuý khách muốn tra cứu thông tin gì hôm nay?',
      time: 'Vừa xong',
    },
  ]);
  const [appointmentForm] = Form.useForm();
  const [contactForm] = Form.useForm();
  const [submittingAppointment, setSubmittingAppointment] = useState(false);
  const [submittingContact, setSubmittingContact] = useState(false);

  // Danh sách tin tức mẫu chất lượng cao kèm ảnh thực tế nếu DB chưa có bài
  const DEFAULT_NEWS = [
    {
      id: 101,
      title: 'Vietcombank triển khai gói tín dụng ưu đãi 100.000 tỷ đồng với lãi suất từ 6.0%/năm',
      categoryName: 'Ưu đãi tín dụng',
      summary: 'Gói vay quy mô lớn hỗ trợ khách hàng cá nhân và doanh nghiệp tiếp cận nguồn vốn giá rẻ để phục hồi sản xuất, kinh doanh và mua nhà an cư.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=600&auto=format&fit=crop&q=80',
      createdAt: '2026-09-08T08:30:00Z',
    },
    {
      id: 102,
      title: 'VCB Digibank thế hệ mới: Nâng tầm trải nghiệm với Trợ lý AI và Sinh trắc học',
      categoryName: 'Ngân hàng số',
      summary: 'Vietcombank chính thức cập nhật nền tảng VCB Digibank với giao diện tùy biến, công nghệ nhận diện khuôn mặt sinh trắc học chuẩn Quyết định 2345/QĐ-NHNN.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600&auto=format&fit=crop&q=80',
      createdAt: '2026-09-05T09:00:00Z',
    },
    {
      id: 103,
      title: 'Biểu lãi suất tiền gửi tiết kiệm Vietcombank mới nhất tháng 09/2026',
      categoryName: 'Lãi suất & Biểu phí',
      summary: 'Cập nhật bảng lãi suất huy động vốn tiền gửi VND và ngoại tệ tại quầy và trực tuyến trên ứng dụng VCB Digibank kỳ hạn từ 1 đến 60 tháng.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=600&auto=format&fit=crop&q=80',
      createdAt: '2026-09-01T10:15:00Z',
    },
    {
      id: 104,
      title: 'Chương trình thẻ Vietcombank Visa Signature: Hoàn tiền 15% ẩm thực và du lịch toàn cầu',
      categoryName: 'Khuyến mại Thẻ',
      summary: 'Đặc quyền thượng lưu dành riêng cho chủ thẻ tín dụng cao cấp Vietcombank: miễn phí phòng chờ sân bay quốc tế hạng thương gia và tích điểm đổi quà.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1556742049-0a67c5574f73?w=600&auto=format&fit=crop&q=80',
      createdAt: '2026-08-28T14:20:00Z',
    },
    {
      id: 105,
      title: 'Vietcombank đồng hành hỗ trợ doanh nghiệp xuất nhập khẩu với gói bảo lãnh & L/C',
      categoryName: 'Khách hàng Doanh nghiệp',
      summary: 'Giải pháp tài trợ thương mại toàn diện, giảm đến 50% phí phát hành thư tín dụng L/C và tỷ giá chuyển đổi ngoại tệ cạnh tranh nhất thị trường.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=600&auto=format&fit=crop&q=80',
      createdAt: '2026-08-25T11:00:00Z',
    },
    {
      id: 106,
      title: 'Cảnh báo an toàn thông tin: Nhận diện thủ đoạn lừa đảo giả mạo SMS Brandname ngân hàng',
      categoryName: 'An toàn bảo mật',
      summary: 'Khuyến cáo khách hàng tuyệt đối không cung cấp mã OTP, mật khẩu đăng nhập, không bấm vào đường link lạ giả mạo website Vietcombank.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?w=600&auto=format&fit=crop&q=80',
      createdAt: '2026-08-20T16:45:00Z',
    },
  ];

  const displayNews = posts && posts.length >= 4 ? posts : [...(posts || []), ...DEFAULT_NEWS];

  useEffect(() => {
    loadPublicData();
  }, []);

  const loadPublicData = async () => {
    setLoadingRates(true);
    try {
      const [exRes, goldRes, intRes, postRes, feeRes, faqRes, branchRes] = await Promise.allSettled([
        client.get('/public/rates/exchange'),
        client.get('/public/rates/gold'),
        client.get('/public/rates/interest'),
        client.get('/public/posts'),
        client.get('/public/fees'),
        client.get('/public/faqs'),
        client.get('/public/branches'),
      ]);

      if (exRes.status === 'fulfilled') setExchangeRates(exRes.value.data?.data || []);
      if (goldRes.status === 'fulfilled') setGoldRates(goldRes.value.data?.data || []);
      if (intRes.status === 'fulfilled') setInterestRates(intRes.value.data?.data || []);
      if (postRes.status === 'fulfilled') setPosts(postRes.value.data?.data || []);
      if (feeRes.status === 'fulfilled') setFeeTemplates(feeRes.value.data?.data || []);
      if (faqRes.status === 'fulfilled') setChatbotFaqs(faqRes.value.data?.data || []);
      if (branchRes.status === 'fulfilled') setBranches(branchRes.value.data?.data || []);
    } catch (e) {
      console.error('Lỗi tải dữ liệu cổng Vietcombank', e);
    } finally {
      setLoadingRates(false);
    }
  };

  const handleQuickTrack = async () => {
    if (!trackCode || !trackCode.trim()) {
      message.warning('Vui lòng nhập mã hồ sơ, mã tra soát hoặc mã hỗ trợ để tra cứu');
      return;
    }
    setTrackingLoading(true);
    try {
      const res = await client.get('/public/track', { params: { code: trackCode.trim() } });
      if (res.data?.data) {
        setTrackResult(res.data.data);
        setTrackResultModal(true);
      } else {
        message.info(res.data?.message || `Không tìm thấy thông tin tương ứng với mã: ${trackCode.trim()}`);
      }
    } catch (e) {
      message.error(e.response?.data?.message || 'Lỗi tra cứu tiến độ, vui lòng thử lại');
    } finally {
      setTrackingLoading(false);
    }
  };

  const handleApplySubmit = async (values) => {
    setSubmittingApply(true);
    try {
      const res = await client.post('/public/apply', values);
      setApplySuccessData(res.data?.data);
      applyForm.resetFields();
      message.success('Đã gửi hồ sơ đăng ký thành công!');
    } catch (err) {
      message.error(err.response?.data?.message || 'Không thể gửi hồ sơ, vui lòng kiểm tra lại thông tin');
    } finally {
      setSubmittingApply(false);
    }
  };

  const handleSendMessage = (customText) => {
    const text = customText || chatInput;
    if (!text?.trim()) return;

    const userMsg = {
      id: Date.now(),
      sender: 'user',
      text: text.trim(),
      time: dayjs().format('HH:mm'),
    };
    setChatMessages((prev) => [...prev, userMsg]);
    if (!customText) setChatInput('');

    // Phân tích ý định người dùng (Intent AI matching kết hợp FAQ Database)
    setTimeout(() => {
      const lower = text.toLowerCase();
      let reply = '';

      // 1. Đối chiếu ngân hàng câu hỏi thường gặp FAQ lấy từ CSDL Vietcombank
      if (chatbotFaqs && chatbotFaqs.length > 0) {
        const matchedFaq = chatbotFaqs.find((f) => {
          if (f.question && lower.includes(f.question.toLowerCase())) return true;
          if (f.keywords) {
            const kwList = f.keywords.toLowerCase().split(',').map((k) => k.trim());
            return kwList.some((kw) => kw && lower.includes(kw));
          }
          return false;
        });
        if (matchedFaq) {
          reply = `💡 ${matchedFaq.answer}\n\n(Câu hỏi liên quan: "${matchedFaq.question}")`;
        }
      }

      // 2. Phân loại theo bộ quy tắc nghiệp vụ mặc định
      if (!reply) {
        if (lower.includes('đặt lịch') || lower.includes('hẹn') || lower.includes('quầy') || lower.includes('chi nhánh')) {
          reply = 'Dạ, để đặt lịch hẹn giao dịch tại quầy Vietcombank mà không phải chờ đợi, quý khách có thể bấm chuyển sang tab "📅 Đặt lịch hẹn" ngay bên trên hoặc điền thông tin chi nhánh, thời gian để hệ thống giữ chỗ ưu tiên cho quý khách!';
        } else if (lower.includes('hotline') || lower.includes('liên hệ') || lower.includes('tổng đài') || lower.includes('số điện thoại') || lower.includes('cskh')) {
          reply = 'Trung tâm Hỗ trợ Khách hàng Vietcombank phục vụ 24/7:\n📞 Hotline trong nước: 1900 54 54 13\n📞 Hotline quốc tế: (+84) 243 8243524\n✉️ Email: contact@vietcombank.com.vn\nQuý khách cũng có thể gửi phản ánh qua tab "📞 Liên hệ & Phản ánh" bên trên!';
        } else if (lower.includes('lãi suất') || lower.includes('tiết kiệm') || lower.includes('gửi tiền')) {
          reply = 'Hiện tại Vietcombank đang áp dụng mức lãi suất tiết kiệm trực tuyến hấp dẫn lên tới 6.8%/năm cho kỳ hạn 12 - 24 tháng. Quý khách có thể xem bảng lãi suất trực quan tại mục "Biểu lãi suất & Tỷ giá" hoặc sử dụng công cụ tính tiền lãi trên trang chủ!';
        } else if (lower.includes('tỷ giá') || lower.includes('ngoại tệ') || lower.includes('usd') || lower.includes('eur')) {
          reply = 'Tỷ giá ngoại tệ Vietcombank hôm nay: USD bán ra 25,820 VND, EUR chuyển khoản 27,300 VND. Bảng tỷ giá được cập nhật liên tục từ Hội sở chính tại đầu trang web!';
        } else if (lower.includes('vay') || lower.includes('mua nhà') || lower.includes('mua xe') || lower.includes('hồ sơ')) {
          reply = 'Vietcombank đang có chương trình cho vay ưu đãi với lãi suất chỉ từ 6.0%/năm, hạn mức vay tới 85% giá trị tài sản đảm bảo, thời hạn tối đa 35 năm. Quý khách có thể bấm "Nộp hồ sơ vay online" ngay góc trên để được duyệt trong 24h!';
        } else if (lower.includes('hướng dẫn') || lower.includes('quên mật khẩu') || lower.includes('digibank') || lower.includes('mở tài khoản')) {
          reply = 'Dạ, để xem hướng dẫn chi tiết về cách mở tài khoản eKYC, kích hoạt Smart OTP, hoặc xử lý quên mật khẩu, quý khách vui lòng chọn tab "📖 Hướng dẫn sử dụng" để xem các bước minh họa cụ thể nhé!';
        } else {
          reply = `Cảm ơn quý khách đã nhắn tin! Tôi đã ghi nhận yêu cầu về "${text}". Để được hỗ trợ chuyên sâu nhất, quý khách có thể liên hệ Tổng đài 1900 54 54 13 hoặc đặt lịch hẹn đến chi nhánh gần nhất để cán bộ tín dụng Vietcombank phục vụ trực tiếp!`;
        }
      }

      setChatMessages((prev) => [
        ...prev,
        {
          id: Date.now() + 1,
          sender: 'bot',
          text: reply,
          time: dayjs().format('HH:mm'),
        },
      ]);
    }, 350);
  };

  const handleAppointmentSubmit = async (values) => {
    setSubmittingAppointment(true);
    try {
      const payload = {
        fullName: values.fullName,
        phoneNumber: values.phoneNumber,
        email: values.email || null,
        branchName: values.branchName,
        serviceType: values.serviceType,
        appointmentDate: values.appointmentDate,
        timeSlot: values.timeSlot,
        note: values.note || null,
      };
      const res = await client.post('/public/appointments', payload);
      const appt = res.data?.data;
      const appointmentCode = appt?.appointmentCode || ('VCB-APT-' + Math.floor(100000 + Math.random() * 900000));

      message.success(`Đặt lịch hẹn thành công! Mã cuộc hẹn của quý khách: ${appointmentCode}`);
      appointmentForm.resetFields();
      setChatMessages((prev) => [
        ...prev,
        {
          id: Date.now(),
          sender: 'bot',
          text: `🎉 Quý khách đã đặt lịch hẹn thành công!\n• Mã lịch hẹn: ${appointmentCode}\n• Khách hàng: ${values.fullName} (${values.phoneNumber})\n• Chi nhánh: ${values.branchName}\n• Dịch vụ: ${values.serviceType}\n• Ngày hẹn: ${values.appointmentDate} | Khung giờ: ${values.timeSlot}\nVietcombank sẽ gửi tin nhắn SMS xác nhận và đón tiếp quý khách tại quầy ưu tiên!`,
          time: dayjs().format('HH:mm'),
        },
      ]);
      setChatTab('chat');
    } catch (e) {
      console.error(e);
      message.error(e.response?.data?.message || 'Không thể đặt lịch hẹn, vui lòng thử lại');
    } finally {
      setSubmittingAppointment(false);
    }
  };

  const handleContactSubmit = async (values) => {
    setSubmittingContact(true);
    try {
      const res = await client.post('/public/contacts', {
        fullName: values.fullName,
        phoneNumber: values.phoneNumber,
        email: values.email || null,
        subject: values.subject,
        message: values.message,
      });
      const msgId = res.data?.data?.messageId || 'VCB';
      message.success('Đã gửi thông tin liên hệ thành công! Vietcombank sẽ phản hồi trong 24h.');
      contactForm.resetFields();
      setChatMessages((prev) => [
        ...prev,
        {
          id: Date.now(),
          sender: 'bot',
          text: `✅ Cảm ơn quý khách ${values.fullName}! Tin nhắn với chủ đề "${values.subject}" đã được ghi nhận trên hệ thống (Mã tiếp nhận #${msgId}). Chuyên viên CSKH Vietcombank sẽ liên hệ lại qua SĐT ${values.phoneNumber} hoặc Email trong vòng 24 giờ.`,
          time: dayjs().format('HH:mm'),
        },
      ]);
      setChatTab('chat');
    } catch (e) {
      message.error(e.response?.data?.message || 'Không thể gửi liên hệ, vui lòng thử lại');
    } finally {
      setSubmittingContact(false);
    }
  };

  // Tạo bảng phân bổ lịch trả nợ chi tiết (Amortization Schedule)
  const generateAmortizationSchedule = () => {
    const p = Number(calcAmount) || 0;
    const n = Number(calcTerm) || 12;
    const annualRate = (Number(calcRate) || 0) / 100;
    const monthlyRate = annualRate / 12;
    const monthlyPrincipal = p / n;

    const schedule = [];
    let currentBalance = p;
    for (let i = 1; i <= n; i++) {
      const interest = currentBalance * monthlyRate;
      const totalPay = monthlyPrincipal + interest;
      const endBalance = Math.max(0, currentBalance - monthlyPrincipal);
      schedule.push({
        period: i,
        startBalance: Math.round(currentBalance),
        principal: Math.round(monthlyPrincipal),
        interest: Math.round(interest),
        totalPay: Math.round(totalPay),
        endBalance: Math.round(endBalance),
      });
      currentBalance = endBalance;
    }
    return schedule;
  };

  // Tính toán tiền lãi
  const calcResult = () => {
    const p = Number(calcAmount) || 0;
    const r = (Number(calcRate) || 0) / 100 / 12; // lãi tháng
    const n = Number(calcTerm) || 1;

    if (calcType === 'SAVING') {
      // Tiết kiệm lãi đơn: Tiền lãi = Gốc * Lãi năm * Tháng / 12
      const totalInterest = p * ((Number(calcRate) || 0) / 100) * (n / 12);
      return {
        monthlyInterest: totalInterest / n,
        totalInterest: totalInterest,
        totalPayout: p + totalInterest,
      };
    } else {
      // Vay trả góp theo dư nợ giảm dần: Gốc đều hàng tháng = P / n, Lãi tháng đầu = P * r
      const principalMonthly = p / n;
      const firstMonthInterest = p * r;
      const totalInterest = (n * (p * r + (p / n) * r)) / 2;
      return {
        monthlyPayment: principalMonthly + firstMonthInterest,
        totalInterest: totalInterest,
        totalPayout: p + totalInterest,
      };
    }
  };

  const exchangeColumns = [
    {
      title: 'Mã NT',
      dataIndex: 'currencyCode',
      key: 'currencyCode',
      render: (code) => <Tag color="#005030" style={{ fontWeight: 'bold' }}>{code}</Tag>,
    },
    {
      title: 'Mua tiền mặt',
      dataIndex: 'buyRate',
      key: 'buyRate',
      align: 'right',
      render: (val) => (val ? Number(val).toLocaleString('vi-VN') : '-'),
    },
    {
      title: 'Mua chuyển khoản',
      dataIndex: 'transferRate',
      key: 'transferRate',
      align: 'right',
      render: (val) => (val ? Number(val).toLocaleString('vi-VN') : '-'),
    },
    {
      title: 'Bán ra',
      dataIndex: 'sellRate',
      key: 'sellRate',
      align: 'right',
      render: (val) => (val ? <Text strong style={{ color: '#005030' }}>{Number(val).toLocaleString('vi-VN')}</Text> : '-'),
    },
  ];

  const goldColumns = [
    {
      title: 'Loại vàng',
      dataIndex: 'goldType',
      key: 'goldType',
      render: (t) => <Text strong>{t}</Text>,
    },
    {
      title: 'Giá mua (VND/lượng)',
      dataIndex: 'buyPrice',
      key: 'buyPrice',
      align: 'right',
      render: (val) => (val ? Number(val).toLocaleString('vi-VN') : '-'),
    },
    {
      title: 'Giá bán (VND/lượng)',
      dataIndex: 'sellPrice',
      key: 'sellPrice',
      align: 'right',
      render: (val) => (val ? <Text strong style={{ color: '#005030' }}>{Number(val).toLocaleString('vi-VN')}</Text> : '-'),
    },
  ];

  const interestColumns = [
    {
      title: 'Sản phẩm',
      dataIndex: 'productCode',
      key: 'productCode',
      render: (p) => <Tag color="green">{p}</Tag>,
    },
    {
      title: 'Kỳ hạn',
      dataIndex: 'termMonths',
      key: 'termMonths',
      render: (t) => (t ? `${t} Tháng` : 'Không kỳ hạn'),
    },
    {
      title: 'Lãi suất (% / năm)',
      dataIndex: 'ratePercentage',
      key: 'ratePercentage',
      align: 'right',
      render: (r) => <Text strong style={{ color: '#d46b08', fontSize: 14 }}>{r}%</Text>,
    },
  ];

  const feeColumns = [
    {
      title: 'Tên biểu phí / Biểu mẫu dịch vụ',
      dataIndex: 'title',
      key: 'title',
      render: (t) => (
        <Text strong style={{ color: '#005030' }}>
          <FileTextOutlined style={{ marginRight: 6 }} />
          {t}
        </Text>
      ),
    },
    {
      title: 'Định dạng',
      dataIndex: 'fileType',
      key: 'fileType',
      width: 110,
      render: (ft) => {
        const upper = (ft || 'PDF').toUpperCase();
        const color = upper.includes('PDF') ? 'red' : upper.includes('DOC') ? 'blue' : 'green';
        return <Tag color={color}>{upper}</Tag>;
      },
    },
    {
      title: 'Ngày ban hành',
      dataIndex: 'createdAt',
      key: 'createdAt',
      width: 140,
      render: (d) => (d ? dayjs(d).format('DD/MM/YYYY') : 'Hiện hành'),
    },
    {
      title: 'Thao tác',
      key: 'action',
      width: 140,
      align: 'center',
      render: (_, record) => (
        <Button
          type="primary"
          size="small"
          icon={<DownloadOutlined />}
          style={{ background: '#005030', borderColor: '#005030' }}
          onClick={() => {
            message.success(`Đang tải xuống biểu mẫu: "${record.title}". Mẫu biểu chuẩn có hiệu lực của Vietcombank.`);
          }}
        >
          Tải biểu mẫu
        </Button>
      ),
    },
  ];

  return (
    <Layout style={{ minHeight: '100vh', background: '#f8faf9' }}>
      {/* 1. TOPBAR & HEADER VIETCOMBANK */}
      <div style={{
        background: '#003820',
        color: '#e8f5e9',
        padding: '7px 48px',
        fontSize: 12.5,
        position: 'relative',
        zIndex: 11,
      }}>
        <Row justify="space-between" align="middle">
          <Col>
            <Space size="middle">
              <span style={{ color: '#e8f5e9' }}>
                <PhoneOutlined style={{ color: '#73B828', marginRight: 4 }} />
                {t('common.hotline')}: <b style={{ color: '#fff' }}>1900 54 54 13</b>
              </span>
              <span style={{ color: 'rgba(255,255,255,0.3)' }}>|</span>
              <span style={{ color: '#e8f5e9' }}>
                <EnvironmentOutlined style={{ color: '#73B828', marginRight: 4 }} />
                {t('common.network')}: <b style={{ color: '#fff' }}>{t('common.branches')}</b>
              </span>
            </Space>
          </Col>
          <Col>
            <Space size="middle">
              <LanguageSwitcher size="small" style={{ background: 'rgba(255,255,255,0.15)', color: '#fff', border: '1px solid rgba(115,184,40,0.5)' }} />
              <a href="#/customer/login" style={{ color: '#fff', fontWeight: 600, display: 'flex', alignItems: 'center', gap: 4 }}>
                <UserOutlined /> {t('portal.customerPortalLink')}
              </a>
              <Divider type="vertical" style={{ borderColor: '#73B828' }} />
              <a href="#/login" style={{ color: '#73B828', fontWeight: 600, display: 'flex', alignItems: 'center', gap: 4 }}>
                <LoginOutlined /> {t('portal.adminPortalLink')}
              </a>
            </Space>
          </Col>
        </Row>
      </div>

      <Header style={{
        background: '#fff',
        padding: '0 48px',
        height: 76,
        lineHeight: 'normal',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        boxShadow: '0 2px 8px rgba(0,56,32,0.08)',
        borderBottom: '3px solid #73B828',
        position: 'relative',
        zIndex: 10,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14, lineHeight: 'normal' }}>
          <div style={{
            background: '#005030',
            color: '#73B828',
            fontWeight: '900',
            fontSize: 22,
            padding: '6px 14px',
            borderRadius: 8,
            letterSpacing: 1.5,
            border: '2px solid #73B828',
            lineHeight: 1,
            display: 'inline-flex',
            alignItems: 'center',
            justifyContent: 'center',
            boxShadow: '0 2px 6px rgba(0,80,48,0.2)',
          }}>
            VIETCOMBANK
          </div>
          <div style={{ lineHeight: 1.25 }}>
            <div style={{
              color: '#005030',
              fontSize: 15,
              fontWeight: 800,
              lineHeight: 1.25,
              whiteSpace: 'nowrap',
              letterSpacing: -0.2,
            }}>
              {t('common.bankFullName')}
            </div>
            <div style={{
              fontSize: 11,
              color: '#667085',
              lineHeight: 1.3,
              marginTop: 2,
              whiteSpace: 'nowrap',
            }}>
              {t('common.slogan')}
            </div>
          </div>
        </div>

        <Space size="large">
          <Button type="text" style={{ fontWeight: 600, color: '#005030' }} onClick={() => document.getElementById('rates-section')?.scrollIntoView({ behavior: 'smooth' })}>
            {t('portal.navRates')}
          </Button>
          <Button type="text" style={{ fontWeight: 600, color: '#005030' }} onClick={() => document.getElementById('calc-section')?.scrollIntoView({ behavior: 'smooth' })}>
            {t('portal.navCalc')}
          </Button>
          <Button type="text" style={{ fontWeight: 600, color: '#005030' }} onClick={() => document.getElementById('news-section')?.scrollIntoView({ behavior: 'smooth' })}>
            {t('portal.navNews')}
          </Button>

          {isCustomerLoggedIn ? (
            <Space size="middle">
              {/* Nút vào Bảng điều khiển của khách hàng */}
              <Button
                type="primary"
                size="large"
                icon={<DashboardOutlined />}
                style={{
                  background: '#005030',
                  borderColor: '#005030',
                  color: '#fff',
                  fontWeight: 700,
                  boxShadow: '0 4px 12px rgba(0,80,48,0.3)',
                }}
                onClick={() => {
                  window.location.hash = '#/customer/dashboard';
                }}
              >
                {t('customer.menuDashboard') || 'Bảng điều khiển'}
              </Button>

              {/* Tên người dùng thay thế cho button đăng ký vay & mở thẻ */}
              <Dropdown menu={{ items: customerMenuItems }} placement="bottomRight">
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: 8,
                    cursor: 'pointer',
                    padding: '6px 14px',
                    borderRadius: 24,
                    background: '#F0FDF4',
                    border: '1.5px solid #73B828',
                    transition: 'all 0.2s ease',
                  }}
                >
                  <Avatar
                    style={{ backgroundColor: '#005030', color: '#73B828', fontWeight: 'bold' }}
                    icon={<UserOutlined />}
                  />
                  <div style={{ textAlign: 'left', lineHeight: 1.2 }}>
                    <Text strong style={{ color: '#005030', display: 'block', fontSize: 13, maxWidth: 160, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                      {customer?.fullName || customer?.username}
                    </Text>
                    <Text type="secondary" style={{ fontSize: 11, color: '#00482B' }}>
                      {customer?.customerType === 'ENTERPRISE' ? 'Doanh nghiệp' : 'Khách hàng cá nhân'}
                    </Text>
                  </div>
                  <DownOutlined style={{ fontSize: 10, color: '#005030', marginLeft: 4 }} />
                </div>
              </Dropdown>
            </Space>
          ) : (
            <>
              <Button
                type="default"
                size="large"
                icon={<UserOutlined />}
                style={{
                  borderColor: '#005030',
                  color: '#005030',
                  fontWeight: 600,
                }}
                href="#/customer/login"
              >
                {t('portal.btnLoginCustomer')}
              </Button>
              <Button
                type="dashed"
                size="large"
                style={{
                  borderColor: '#00482B',
                  color: '#00482B',
                  fontWeight: 600,
                }}
                href="#/customer/register"
              >
                {t('customer.btnRegister')}
              </Button>
              <Button
                type="primary"
                size="large"
                className="btn-vcb-accent"
                icon={<SendOutlined />}
                style={{
                  background: '#73B828',
                  borderColor: '#73B828',
                  color: '#003820',
                  fontWeight: 700,
                  boxShadow: '0 4px 12px rgba(115,184,40,0.4)',
                }}
                onClick={() => {
                  setApplySuccessData(null);
                  setApplyModalVisible(true);
                }}
              >
                {t('portal.btnApplyOnline')}
              </Button>
            </>
          )}
        </Space>
      </Header>

      <Content style={{ padding: '0 48px', maxWidth: 1300, margin: '24px auto', width: '100%' }}>
        {/* 2. HERO BANNER VCB */}
        <Card
          style={{
            background: 'linear-gradient(135deg, #00482B 0%, #006837 60%, #008744 100%)',
            color: '#fff',
            borderRadius: 12,
            marginBottom: 24,
            border: 'none',
            boxShadow: '0 8px 24px rgba(0,56,32,0.15)',
          }}
          bodyStyle={{ padding: '40px 48px' }}
        >
          <Row gutter={[24, 24]} align="middle">
            <Col xs={24} md={15}>
              <Tag color="#73B828" style={{ color: '#00482B', fontWeight: 'bold', fontSize: 13, padding: '4px 10px' }}>
                {t('portal.heroTag')}
              </Tag>
              <Title level={1} style={{ color: '#fff', margin: '16px 0 12px', fontSize: 36, fontWeight: 800 }}>
                {t('portal.heroTitle')}
              </Title>
              <Paragraph style={{ color: '#e8f5e9', fontSize: 16, lineHeight: 1.6, maxWidth: 650 }}>
                {t('portal.heroDesc')}
              </Paragraph>
              <Space size="middle" style={{ marginTop: 12 }}>
                <Button
                  type="primary"
                  size="large"
                  className="btn-vcb-accent"
                  style={{
                    background: '#73B828',
                    borderColor: '#73B828',
                    color: '#003820',
                    fontWeight: 700,
                    height: 46,
                    padding: '0 28px',
                    fontSize: 15,
                  }}
                  onClick={() => setApplyModalVisible(true)}
                >
                  {t('portal.btnApplyNow')}
                </Button>
                <Button
                  size="large"
                  className="btn-vcb-outline-light"
                  style={{
                    background: 'rgba(255,255,255,0.08)',
                    color: '#fff',
                    borderColor: '#73B828',
                    fontWeight: 600,
                    height: 46,
                    fontSize: 15,
                  }}
                  href="#/login"
                >
                  {t('portal.btnLoginStaff')}
                </Button>
              </Space>
            </Col>
            <Col xs={24} md={9} style={{ textAlign: 'center' }}>
              <div style={{
                background: 'rgba(255,255,255,0.08)',
                padding: '24px',
                borderRadius: 12,
                border: '1px solid rgba(115,184,40,0.3)',
                backdropFilter: 'blur(4px)',
              }}>
                <Statistic
                  title={<span style={{ color: '#a5d6a7' }}>{t('portal.maxInterestRate')}</span>}
                  value={6.8}
                  precision={1}
                  suffix={<span style={{ color: '#73B828', fontSize: 20 }}>% / {t('portal.calcTerm').toLowerCase()}</span>}
                  valueStyle={{ color: '#fff', fontSize: 44, fontWeight: 'bold' }}
                />
                <Divider style={{ borderColor: 'rgba(255,255,255,0.15)', margin: '12px 0' }} />
                <Row gutter={8}>
                  <Col span={12}>
                    <Statistic
                      title={<span style={{ color: '#c8e6c9', fontSize: 12 }}>{t('portal.usdSellRate')}</span>}
                      value={25820}
                      valueStyle={{ color: '#73B828', fontSize: 18, fontWeight: 'bold' }}
                      suffix={<span style={{ fontSize: 11, color: '#e8f5e9' }}>VND</span>}
                    />
                  </Col>
                  <Col span={12}>
                    <Statistic
                      title={<span style={{ color: '#c8e6c9', fontSize: 12 }}>{t('portal.goldSjcSell')}</span>}
                      value={88.5}
                      valueStyle={{ color: '#ffd54f', fontSize: 18, fontWeight: 'bold' }}
                      suffix={<span style={{ fontSize: 11, color: '#e8f5e9' }}>Tr.đ</span>}
                    />
                  </Col>
                </Row>
              </div>
            </Col>
          </Row>
        </Card>

        {/* 2b. THANH TRA CỨU NHANH TIẾN ĐỘ HỒ SƠ / TRA SOÁT / PHIẾU HỖ TRỢ */}
        <Card
          style={{
            background: '#ffffff',
            borderRadius: 12,
            marginBottom: 28,
            boxShadow: '0 4px 16px rgba(0,80,48,0.08)',
            border: '1.5px solid #d9f7be',
          }}
          bodyStyle={{ padding: '20px 28px' }}
        >
          <Row gutter={[16, 16]} align="middle">
            <Col xs={24} md={8}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <Avatar
                  size={44}
                  style={{ backgroundColor: '#E8F5E9', color: '#005030' }}
                  icon={<SearchOutlined style={{ fontSize: 22 }} />}
                />
                <div>
                  <Text strong style={{ color: '#005030', fontSize: 16, display: 'block' }}>
                    Tra cứu tiến độ hồ sơ &amp; Khiếu nại
                  </Text>
                  <Text type="secondary" style={{ fontSize: 12 }}>
                    Tra cứu nhanh theo mã hồ sơ (APP-...), mã tra soát (DSP-...) hoặc ticket (TK-...)
                  </Text>
                </div>
              </div>
            </Col>
            <Col xs={24} md={16}>
              <Space.Compact style={{ width: '100%' }}>
                <Input
                  size="large"
                  placeholder="Nhập mã định danh (Ví dụ: APP-2026-001, DSP-2026-001, TK-2026-001...)"
                  prefix={<SearchOutlined style={{ color: '#005030' }} />}
                  value={trackCode}
                  onChange={(e) => setTrackCode(e.target.value)}
                  onPressEnter={handleQuickTrack}
                  style={{ borderRadius: '8px 0 0 8px' }}
                  allowClear
                />
                <Button
                  type="primary"
                  size="large"
                  loading={trackingLoading}
                  onClick={handleQuickTrack}
                  style={{
                    background: '#005030',
                    borderColor: '#005030',
                    fontWeight: 700,
                    padding: '0 28px',
                    borderRadius: '0 8px 8px 0',
                  }}
                >
                  Tra cứu ngay
                </Button>
              </Space.Compact>
            </Col>
          </Row>
        </Card>

        {/* 3. BẢNG DỮ LIỆU BIẾN ĐỘNG TRỰC TUYẾN (TỶ GIÁ / GIÁ VÀNG / LÃI SUẤT / BIỂU PHÍ) */}
        <div id="rates-section" style={{ marginBottom: 32 }}>
          <Title level={3} style={{ color: '#005030', marginBottom: 4 }}>
            <DollarOutlined /> {t('portal.marketRatesTitle')}
          </Title>
          <Text type="secondary" style={{ display: 'block', marginBottom: 16 }}>
            {t('portal.marketRatesSubtitle')}
          </Text>

          <Card style={{ borderRadius: 8, boxShadow: '0 2px 8px rgba(0,0,0,0.05)' }}>
            <Tabs
              defaultActiveKey="exchange"
              items={[
                {
                  key: 'exchange',
                  label: <span style={{ fontWeight: 600, fontSize: 14 }}><DollarOutlined /> {t('portal.tabExchange')}</span>,
                  children: (
                    <Table
                      rowKey="currencyCode"
                      columns={exchangeColumns}
                      dataSource={exchangeRates}
                      loading={loadingRates}
                      pagination={false}
                      size="middle"
                    />
                  ),
                },
                {
                  key: 'gold',
                  label: <span style={{ fontWeight: 600, fontSize: 14 }}><GoldOutlined /> {t('portal.tabGold')}</span>,
                  children: (
                    <Table
                      rowKey="goldType"
                      columns={goldColumns}
                      dataSource={goldRates}
                      loading={loadingRates}
                      pagination={false}
                      size="middle"
                    />
                  ),
                },
                {
                  key: 'interest',
                  label: <span style={{ fontWeight: 600, fontSize: 14 }}><PercentageOutlined /> {t('portal.tabInterest')}</span>,
                  children: (
                    <Table
                      rowKey={(r) => `${r.productCode}-${r.termMonths}`}
                      columns={interestColumns}
                      dataSource={interestRates}
                      loading={loadingRates}
                      pagination={false}
                      size="middle"
                    />
                  ),
                },
                {
                  key: 'fees',
                  label: (
                    <span style={{ fontWeight: 600, fontSize: 14 }}>
                      <FileTextOutlined /> Biểu phí &amp; Biểu mẫu trực tuyến ({feeTemplates.length})
                    </span>
                  ),
                  children: (
                    <Table
                      rowKey="templateId"
                      columns={feeColumns}
                      dataSource={feeTemplates}
                      loading={loadingRates}
                      pagination={{ pageSize: 6 }}
                      size="middle"
                    />
                  ),
                },
              ]}
            />
          </Card>
        </div>

        {/* 4. CÔNG CỤ TÍNH TOÁN TIỀN VAY & GỬI TIẾT KIỆM */}
        <div id="calc-section" style={{ marginBottom: 32 }}>
          <Card
            style={{
              background: '#fff',
              borderRadius: 12,
              borderLeft: '5px solid #005030',
              boxShadow: '0 4px 12px rgba(0,0,0,0.06)',
            }}
          >
            <Title level={3} style={{ color: '#005030', marginTop: 0 }}>
              <CalculatorOutlined /> {t('portal.calcTitle')}
            </Title>
            <Row gutter={[24, 24]}>
              <Col xs={24} md={12}>
                <Form layout="vertical">
                  <Form.Item label={t('portal.calcType')}>
                    <Radio.Group
                      value={calcType}
                      onChange={(e) => {
                        setCalcType(e.target.value);
                        setCalcRate(e.target.value === 'SAVING' ? 5.5 : 8.5);
                      }}
                      buttonStyle="solid"
                    >
                      <Radio.Button value="LOAN">{t('portal.calcLoan')}</Radio.Button>
                      <Radio.Button value="SAVING">{t('portal.calcSaving')}</Radio.Button>
                    </Radio.Group>
                  </Form.Item>

                  <Form.Item label={calcType === 'LOAN' ? t('portal.calcAmountLoan') : t('portal.calcAmountSaving')}>
                    <InputNumber
                      style={{ width: '100%' }}
                      size="large"
                      min={10000000}
                      max={10000000000}
                      step={10000000}
                      value={calcAmount}
                      formatter={(value) => `${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
                      parser={(value) => value.replace(/\$\s?|(,*)/g, '')}
                      onChange={(v) => setCalcAmount(v || 0)}
                    />
                  </Form.Item>

                  <Row gutter={16}>
                    <Col span={12}>
                      <Form.Item label={t('portal.calcTerm')}>
                        <Select size="large" value={calcTerm} onChange={setCalcTerm}>
                          <Option value={6}>6 Tháng</Option>
                          <Option value={12}>12 Tháng (1 năm)</Option>
                          <Option value={24}>24 Tháng (2 năm)</Option>
                          <Option value={36}>36 Tháng (3 năm)</Option>
                          <Option value={60}>60 Tháng (5 năm)</Option>
                          <Option value={120}>120 Tháng (10 năm)</Option>
                        </Select>
                      </Form.Item>
                    </Col>
                    <Col span={12}>
                      <Form.Item label={t('portal.calcRate')}>
                        <InputNumber
                          style={{ width: '100%' }}
                          size="large"
                          min={1}
                          max={25}
                          step={0.1}
                          value={calcRate}
                          onChange={(v) => setCalcRate(v || 0)}
                        />
                      </Form.Item>
                    </Col>
                  </Row>
                </Form>
              </Col>

              <Col xs={24} md={12}>
                <div style={{
                  background: '#f4fbf6',
                  padding: 24,
                  borderRadius: 10,
                  border: '1px solid #b7eb8f',
                  height: '100%',
                  display: 'flex',
                  flexDirection: 'column',
                  justifyContent: 'center',
                }}>
                  <Text strong style={{ color: '#005030', fontSize: 16 }}>
                    {t('portal.calcResultHeader')}
                  </Text>
                  <Divider style={{ margin: '12px 0' }} />

                  {calcType === 'LOAN' ? (
                    <Space direction="vertical" size="small" style={{ width: '100%' }}>
                      <Row justify="space-between">
                        <Text type="secondary">{t('portal.firstMonthPay')}</Text>
                        <Text strong style={{ color: '#d4380d', fontSize: 18 }}>
                          {Number(Math.round(calcResult().monthlyPayment)).toLocaleString('vi-VN')} đ
                        </Text>
                      </Row>
                      <Row justify="space-between">
                        <Text type="secondary">{t('portal.totalInterestLoan')}</Text>
                        <Text strong>{Number(Math.round(calcResult().totalInterest)).toLocaleString('vi-VN')} đ</Text>
                      </Row>
                      <Row justify="space-between">
                        <Text type="secondary">{t('portal.totalPayoutLoan')}</Text>
                        <Text strong style={{ color: '#005030', fontSize: 16 }}>
                          {Number(Math.round(calcResult().totalPayout)).toLocaleString('vi-VN')} đ
                        </Text>
                      </Row>
                    </Space>
                  ) : (
                    <Space direction="vertical" size="small" style={{ width: '100%' }}>
                      <Row justify="space-between">
                        <Text type="secondary">{t('portal.monthlyInterestSaving')}</Text>
                        <Text strong style={{ color: '#389e0d', fontSize: 18 }}>
                          {Number(Math.round(calcResult().monthlyInterest)).toLocaleString('vi-VN')} đ
                        </Text>
                      </Row>
                      <Row justify="space-between">
                        <Text type="secondary">{t('portal.totalInterestSaving')}</Text>
                        <Text strong>{Number(Math.round(calcResult().totalInterest)).toLocaleString('vi-VN')} đ</Text>
                      </Row>
                      <Row justify="space-between">
                        <Text type="secondary">{t('portal.totalPayoutSaving')}</Text>
                        <Text strong style={{ color: '#005030', fontSize: 16 }}>
                          {Number(Math.round(calcResult().totalPayout)).toLocaleString('vi-VN')} đ
                        </Text>
                      </Row>
                    </Space>
                  )}

                  {calcType === 'LOAN' && (
                    <Button
                      block
                      size="large"
                      icon={<TableOutlined />}
                      style={{
                        marginTop: 16,
                        borderColor: '#005030',
                        color: '#005030',
                        fontWeight: 600,
                        background: '#fff',
                      }}
                      onClick={() => setAmortizationModalVisible(true)}
                    >
                      Xem lịch trả nợ chi tiết (Dư nợ giảm dần)
                    </Button>
                  )}

                  <Button
                    type="primary"
                    block
                    size="large"
                    style={{
                      marginTop: calcType === 'LOAN' ? 12 : 20,
                      background: '#005030',
                      borderColor: '#005030',
                      fontWeight: 600,
                    }}
                    onClick={() => {
                      applyForm.setFieldsValue({ requestedAmount: calcAmount });
                      setApplySuccessData(null);
                      setApplyModalVisible(true);
                    }}
                  >
                    {t('portal.btnApplyThis')}
                  </Button>
                </div>
              </Col>
            </Row>
          </Card>
        </div>

        {/* 5. TIN TỨC & CỔNG THÔNG TIN ĐIỆN TỬ - NÚT CHẠY NGANG SANG 2 BÊN */}
        <div id="news-section" style={{ marginBottom: 40, position: 'relative' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginBottom: 16 }}>
            <div>
              <Tag color="#005030" style={{ fontWeight: 'bold', marginBottom: 6 }}>BẢN TIN VIETCOMBANK 24/7</Tag>
              <Title level={3} style={{ color: '#005030', margin: 0 }}>
                <ReadOutlined /> {t('portal.newsTitle')}
              </Title>
              <Text type="secondary" style={{ display: 'block', marginTop: 4 }}>
                {t('portal.newsSubtitle')} • Bấm nút điều hướng để xem các tin tức khác
              </Text>
            </div>
            {/* Nút bấm chạy ngang sang 2 bên */}
            <Space size="middle">
              <Button
                shape="circle"
                size="large"
                icon={<LeftOutlined />}
                onClick={() => scrollNews('left')}
                style={{
                  background: '#fff',
                  borderColor: '#005030',
                  color: '#005030',
                  boxShadow: '0 2px 8px rgba(0,80,48,0.15)',
                }}
                title="Xem tin trước"
              />
              <Button
                shape="circle"
                size="large"
                type="primary"
                icon={<RightOutlined />}
                onClick={() => scrollNews('right')}
                style={{
                  background: '#005030',
                  borderColor: '#005030',
                  boxShadow: '0 2px 8px rgba(0,80,48,0.25)',
                }}
                title="Xem tin tiếp theo"
              />
            </Space>
          </div>

          {/* Dải tin tức cuộn ngang */}
          <div
            ref={newsScrollRef}
            style={{
              display: 'flex',
              gap: 20,
              overflowX: 'auto',
              scrollBehavior: 'smooth',
              paddingBottom: 16,
              paddingTop: 4,
              scrollbarWidth: 'none',
              msOverflowStyle: 'none',
            }}
          >
            {displayNews.map((p) => (
              <div
                key={p.id}
                style={{
                  flex: '0 0 360px',
                  maxWidth: 360,
                }}
              >
                <Card
                  hoverable
                  style={{
                    borderRadius: 12,
                    overflow: 'hidden',
                    height: '100%',
                    display: 'flex',
                    flexDirection: 'column',
                    border: '1px solid #e0e0e0',
                    boxShadow: '0 4px 12px rgba(0,0,0,0.05)',
                  }}
                  bodyStyle={{ flex: 1, display: 'flex', flexDirection: 'column' }}
                  cover={
                    <div style={{ height: 190, overflow: 'hidden', position: 'relative' }}>
                      <img
                        alt={p.title}
                        src={p.thumbnailUrl || 'https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=600&auto=format&fit=crop&q=80'}
                        style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                      />
                      <Tag
                        color="#005030"
                        style={{
                          position: 'absolute',
                          top: 12,
                          left: 12,
                          fontWeight: 'bold',
                          borderRadius: 4,
                          boxShadow: '0 2px 6px rgba(0,0,0,0.2)',
                        }}
                      >
                        {p.categoryName || 'Tin tức'}
                      </Tag>
                    </div>
                  }
                >
                  <Title
                    level={5}
                    ellipsis={{ rows: 2 }}
                    style={{ color: '#005030', marginBottom: 8, fontSize: 16, lineHeight: 1.4, fontWeight: 700 }}
                  >
                    {p.title}
                  </Title>
                  <Paragraph
                    ellipsis={{ rows: 3 }}
                    type="secondary"
                    style={{ fontSize: 13, lineHeight: 1.6, flex: 1, marginBottom: 12 }}
                  >
                    {p.summary || 'Thông tin chính thức từ Cổng thông tin điện tử Ngân hàng Ngoại thương Việt Nam Vietcombank.'}
                  </Paragraph>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', paddingTop: 10, borderTop: '1px solid #f0f0f0' }}>
                    <Text type="secondary" style={{ fontSize: 12 }}>
                      <ClockCircleOutlined /> {dayjs(p.createdAt || new Date()).format('DD/MM/YYYY')}
                    </Text>
                    <a
                      href="#news-section"
                      onClick={(e) => {
                        e.preventDefault();
                        Modal.info({
                          title: p.title,
                          width: 700,
                          content: (
                            <div style={{ marginTop: 16 }}>
                              <img
                                src={p.thumbnailUrl}
                                alt={p.title}
                                style={{ width: '100%', maxHeight: 300, objectFit: 'cover', borderRadius: 8, marginBottom: 16 }}
                              />
                              <Tag color="#005030">{p.categoryName || 'Tin tức'}</Tag>
                              <Text type="secondary" style={{ marginLeft: 8 }}>
                                Ngày đăng: {dayjs(p.createdAt).format('DD/MM/YYYY HH:mm')}
                              </Text>
                              <Divider style={{ margin: '12px 0' }} />
                              <Paragraph style={{ fontSize: 15, lineHeight: 1.7 }}>
                                {p.summary}
                              </Paragraph>
                              <Paragraph style={{ fontSize: 14, color: '#555', lineHeight: 1.7 }}>
                                Để biết thêm thông tin chi tiết về các chương trình ưu đãi, sản phẩm dịch vụ ngân hàng số, kính mời Quý khách hàng liên hệ các điểm giao dịch Vietcombank trên toàn quốc hoặc gọi Tổng đài 1900 54 54 13 để được tư vấn tận tình.
                              </Paragraph>
                            </div>
                          ),
                          okText: 'Đóng',
                        });
                      }}
                      style={{ color: '#73B828', fontWeight: 600, fontSize: 13 }}
                    >
                      Chi tiết →
                    </a>
                  </div>
                </Card>
              </div>
            ))}
          </div>
        </div>

        {/* 5b. CẨM NANG GIAO DỊCH AN TOÀN & CẢNH BÁO AN NINH MẠNG */}
        <div id="security-section" style={{ marginBottom: 40 }}>
          <Card
            style={{
              borderRadius: 12,
              border: '2px solid #ffccc7',
              background: 'linear-gradient(180deg, #fffbfb 0%, #ffffff 100%)',
              boxShadow: '0 4px 16px rgba(207,19,34,0.06)',
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 20, flexWrap: 'wrap', gap: 12 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <Avatar
                  size={46}
                  style={{ backgroundColor: '#fff1f0', color: '#cf1322' }}
                  icon={<SecurityScanOutlined style={{ fontSize: 24 }} />}
                />
                <div>
                  <Title level={3} style={{ color: '#005030', margin: 0 }}>
                    Cẩm nang Giao dịch An toàn &amp; Cảnh báo An ninh mạng
                  </Title>
                  <Text type="secondary">
                    Chủ động phòng ngừa rủi ro lừa đảo công nghệ cao và bảo vệ tài sản tài khoản ngân hàng của Quý khách
                  </Text>
                </div>
              </div>
              <Tag color="error" style={{ fontSize: 13, padding: '4px 12px', fontWeight: 'bold' }}>
                <WarningOutlined /> CẢNH BÁO KHẨN CẤP
              </Tag>
            </div>

            <Row gutter={[20, 20]}>
              <Col xs={24} sm={12} lg={6}>
                <Card
                  size="small"
                  style={{
                    height: '100%',
                    background: '#fff',
                    borderRadius: 8,
                    borderTop: '4px solid #cf1322',
                    boxShadow: '0 2px 8px rgba(0,0,0,0.04)',
                  }}
                >
                  <Text strong style={{ color: '#cf1322', display: 'block', fontSize: 15, marginBottom: 8 }}>
                    1. Tuyệt đối KHÔNG chia sẻ OTP
                  </Text>
                  <Paragraph type="secondary" style={{ fontSize: 13, lineHeight: 1.6, margin: 0 }}>
                    Vietcombank <strong>KHÔNG BAO GIỜ</strong> yêu cầu cung cấp Mật khẩu hoặc Smart OTP qua điện thoại hay tin nhắn. Mọi yêu cầu OTP đều là lừa đảo.
                  </Paragraph>
                </Card>
              </Col>

              <Col xs={24} sm={12} lg={6}>
                <Card
                  size="small"
                  style={{
                    height: '100%',
                    background: '#fff',
                    borderRadius: 8,
                    borderTop: '4px solid #fa8c16',
                    boxShadow: '0 2px 8px rgba(0,0,0,0.04)',
                  }}
                >
                  <Text strong style={{ color: '#d46b08', display: 'block', fontSize: 15, marginBottom: 8 }}>
                    2. Cảnh giác đường link giả mạo
                  </Text>
                  <Paragraph type="secondary" style={{ fontSize: 13, lineHeight: 1.6, margin: 0 }}>
                    Chỉ đăng nhập tại địa chỉ chính thức có ổ khóa bảo mật <code>vietcombank.com.vn</code>. Không click vào link lạ từ SMS Brandname giả mạo.
                  </Paragraph>
                </Card>
              </Col>

              <Col xs={24} sm={12} lg={6}>
                <Card
                  size="small"
                  style={{
                    height: '100%',
                    background: '#fff',
                    borderRadius: 8,
                    borderTop: '4px solid #52c41a',
                    boxShadow: '0 2px 8px rgba(0,0,0,0.04)',
                  }}
                >
                  <Text strong style={{ color: '#389e0d', display: 'block', fontSize: 15, marginBottom: 8 }}>
                    3. Bật Sinh trắc học QĐ 2345
                  </Text>
                  <Paragraph type="secondary" style={{ fontSize: 13, lineHeight: 1.6, margin: 0 }}>
                    Cập nhật khuôn mặt khớp với dữ liệu trên thẻ CCCD gắn chip để bảo vệ giao dịch chuyển tiền trên 10 triệu đồng hoặc vượt 20 triệu đồng/ngày.
                  </Paragraph>
                </Card>
              </Col>

              <Col xs={24} sm={12} lg={6}>
                <Card
                  size="small"
                  style={{
                    height: '100%',
                    background: '#fff',
                    borderRadius: 8,
                    borderTop: '4px solid #1890ff',
                    boxShadow: '0 2px 8px rgba(0,0,0,0.04)',
                  }}
                >
                  <Text strong style={{ color: '#096dd9', display: 'block', fontSize: 15, marginBottom: 8 }}>
                    4. Khóa dịch vụ khẩn cấp 24/7
                  </Text>
                  <Paragraph type="secondary" style={{ fontSize: 13, lineHeight: 1.6, margin: 0 }}>
                    Khi phát hiện giao dịch bất thường hoặc mất điện thoại, chủ động bấm <strong>Khóa thẻ khẩn cấp</strong> trên VCB Digibank hoặc gọi ngay <strong>1900 54 54 13</strong>.
                  </Paragraph>
                </Card>
              </Col>
            </Row>

            <Divider style={{ margin: '20px 0 16px' }} />
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 12 }}>
              <Space>
                <SafetyOutlined style={{ color: '#52c41a', fontSize: 18 }} />
                <Text style={{ fontSize: 13, color: '#333' }}>
                  Hệ thống bảo mật Vietcombank đạt chứng nhận tiêu chuẩn an ninh quốc tế PCI-DSS Level 1 cao nhất.
                </Text>
              </Space>
              <Button
                type="primary"
                danger
                icon={<PhoneOutlined />}
                style={{ fontWeight: 600 }}
                onClick={() => {
                  Modal.warning({
                    title: 'Đường dây nóng Khẩn cấp Vietcombank',
                    content: 'Quý khách vui lòng gọi ngay Hotline 1900 54 54 13 (hoạt động 24/7) hoặc đến chi nhánh Vietcombank gần nhất để được khóa thẻ và phong tỏa tài khoản tức thì.',
                    okText: 'Đã hiểu',
                  });
                }}
              >
                Hotline Khẩn cấp: 1900 54 54 13
              </Button>
            </div>
          </Card>
        </div>
      </Content>

      {/* 6. FOOTER CHUẨN VIETCOMBANK */}
      <Footer style={{ background: '#003820', color: '#c8e6c9', padding: '40px 48px 24px' }}>
        <Row gutter={[32, 24]} style={{ maxWidth: 1300, margin: '0 auto' }}>
          <Col xs={24} md={8}>
            <Title level={4} style={{ color: '#73B828', marginTop: 0 }}>
              {t('common.bankFullName')} ({t('common.bankName')})
            </Title>
            <Paragraph style={{ color: '#a5d6a7', fontSize: 13 }}>
              Trụ sở chính: 198 Trần Quang Khải, Hoàn Kiếm, Hà Nội.<br />
              Giấy phép hoạt động số 138/GP-NHNN do Ngân hàng Nhà nước Việt Nam cấp.
            </Paragraph>
          </Col>
          <Col xs={12} md={5}>
            <Text strong style={{ color: '#fff', display: 'block', marginBottom: 12 }}>{t('portal.footerPersonalServices')}</Text>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 13 }}>
              <a href="#rates-section" style={{ color: '#c8e6c9' }}>Tài khoản &amp; Tiết kiệm</a>
              <a href="#rates-section" style={{ color: '#c8e6c9' }}>Thẻ tín dụng VCB</a>
              <a href="#calc-section" style={{ color: '#c8e6c9' }}>Vay mua nhà, mua xe</a>
              <a href="#calc-section" style={{ color: '#c8e6c9' }}>Ngân hàng số VCB Digibank</a>
            </div>
          </Col>
          <Col xs={12} md={5}>
            <Text strong style={{ color: '#fff', display: 'block', marginBottom: 12 }}>{t('portal.footerStaffServices')}</Text>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 6, fontSize: 13 }}>
              <a href="#/login" style={{ color: '#73B828', fontWeight: 'bold' }}>{t('portal.adminPortalLink')}</a>
              <a href="#/login" style={{ color: '#c8e6c9' }}>Phê duyệt hồ sơ nghiệp vụ</a>
              <a href="#/login" style={{ color: '#c8e6c9' }}>Cập nhật tỷ giá &amp; lãi suất</a>
              <a href="#/login" style={{ color: '#c8e6c9' }}>Báo cáo điều hành</a>
            </div>
          </Col>
          <Col xs={24} md={6}>
            <Text strong style={{ color: '#fff', display: 'block', marginBottom: 12 }}>{t('portal.footerSupport')}</Text>
            <Text style={{ color: '#73B828', fontSize: 20, fontWeight: 'bold', display: 'block' }}>
              1900 54 54 13
            </Text>
            <Text style={{ color: '#a5d6a7', fontSize: 12 }}>
              {t('portal.footerSupportDesc')}
            </Text>
          </Col>
        </Row>
        <Divider style={{ borderColor: 'rgba(255,255,255,0.15)', margin: '24px 0 16px' }} />
        <div style={{ textAlign: 'center', fontSize: 12, color: '#81c784' }}>
          {t('portal.footerCopyright')}
        </div>
      </Footer>

      {/* 7. MODAL NỘP HỒ SƠ VAY / MỞ THẺ TRỰC TUYẾN */}
      <Modal
        title={
          <Space>
            <SafetyCertificateOutlined style={{ color: '#005030', fontSize: 20 }} />
            <span style={{ color: '#005030', fontWeight: 'bold' }}>
              ĐĂNG KÝ SẢN PHẨM TRỰC TUYẾN VIETCOMBANK
            </span>
          </Space>
        }
        open={applyModalVisible}
        onCancel={() => setApplyModalVisible(false)}
        footer={null}
        width={600}
        destroyOnClose
      >
        {applySuccessData ? (
          <div style={{ textAlign: 'center', padding: '24px 12px' }}>
            <CheckCircleOutlined style={{ fontSize: 56, color: '#52c41a', marginBottom: 16 }} />
            <Title level={4} style={{ color: '#005030', marginBottom: 8 }}>
              Nộp hồ sơ thành công!
            </Title>
            <Alert
              type="success"
              message={<Text strong>Mã hồ sơ tiếp nhận: {applySuccessData.applicationCode}</Text>}
              description={applySuccessData.message}
              showIcon
              style={{ textAlign: 'left', marginBottom: 20 }}
            />
            <Button
              type="primary"
              style={{ background: '#005030', borderColor: '#005030' }}
              onClick={() => {
                setApplySuccessData(null);
                setApplyModalVisible(false);
              }}
            >
              Đóng cửa sổ
            </Button>
          </div>
        ) : (
          <Form form={applyForm} layout="vertical" onFinish={handleApplySubmit} initialValues={{ applicationType: 'LOAN', requestedAmount: 50000000 }}>
            <Alert
              type="info"
              message="Hồ sơ sau khi gửi sẽ được chuyển trực tiếp vào Cổng điều hành Admin Portal để cán bộ tín dụng thẩm định và liên hệ quý khách."
              showIcon
              style={{ marginBottom: 16 }}
            />
            <Row gutter={16}>
              <Col span={12}>
                <Form.Item name="fullName" label="Họ và tên khách hàng" rules={[{ required: true, message: 'Nhập họ tên' }]}>
                  <Input prefix={<UserOutlined />} placeholder="Nguyễn Văn A" size="large" />
                </Form.Item>
              </Col>
              <Col span={12}>
                <Form.Item name="idCardNumber" label="Số CCCD / CMND" rules={[{ required: true, message: 'Nhập số CCCD' }]}>
                  <Input placeholder="12 chữ số CCCD" size="large" maxLength={12} />
                </Form.Item>
              </Col>
            </Row>

            <Row gutter={16}>
              <Col span={12}>
                <Form.Item name="phoneNumber" label="Số điện thoại liên hệ" rules={[{ required: true, message: 'Nhập số điện thoại' }]}>
                  <Input prefix={<PhoneOutlined />} placeholder="09xxxxxxx" size="large" />
                </Form.Item>
              </Col>
              <Col span={12}>
                <Form.Item name="email" label="Email">
                  <Input placeholder="email@domain.com" size="large" />
                </Form.Item>
              </Col>
            </Row>

            <Row gutter={16}>
              <Col span={12}>
                <Form.Item name="applicationType" label="Loại hình sản phẩm" rules={[{ required: true }]}>
                  <Select size="large">
                    <Option value="LOAN">Vay vốn tiêu dùng / Mua nhà</Option>
                    <Option value="CARD_ISSUANCE">Mở thẻ tín dụng quốc tế</Option>
                    <Option value="LIMIT_APPROVAL">Đề xuất nâng hạn mức</Option>
                  </Select>
                </Form.Item>
              </Col>
              <Col span={12}>
                <Form.Item name="requestedAmount" label="Số tiền đề xuất (VND)" rules={[{ required: true, message: 'Nhập số tiền' }]}>
                  <InputNumber
                    style={{ width: '100%' }}
                    size="large"
                    min={1000000}
                    step={5000000}
                    formatter={(val) => `${val}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
                    parser={(val) => val.replace(/\$\s?|(,*)/g, '')}
                  />
                </Form.Item>
              </Col>
            </Row>

            <Form.Item name="note" label="Ghi chú thêm">
              <Input.TextArea rows={2} placeholder="Nhu cầu chi tiết, thời gian có thể nghe điện thoại..." />
            </Form.Item>

            <Form.Item style={{ marginBottom: 0, textAlign: 'right' }}>
              <Space>
                <Button onClick={() => setApplyModalVisible(false)}>Hủy</Button>
                <Button
                  type="primary"
                  htmlType="submit"
                  loading={submittingApply}
                  style={{ background: '#005030', borderColor: '#005030', fontWeight: 600 }}
                >
                  Xác nhận gửi hồ sơ
                </Button>
              </Space>
            </Form.Item>
          </Form>
        )}
      </Modal>

      {/* MODAL KẾT QUẢ TRA CỨU TIẾN ĐỘ */}
      <Modal
        title={
          <Space style={{ color: '#005030', fontSize: 16 }}>
            <SearchOutlined /> Kết quả tra cứu trực tuyến
          </Space>
        }
        open={trackResultModal}
        onCancel={() => setTrackResultModal(false)}
        footer={[
          <Button
            key="close"
            type="primary"
            style={{ background: '#005030', borderColor: '#005030' }}
            onClick={() => setTrackResultModal(false)}
          >
            Đóng
          </Button>,
        ]}
        width={650}
      >
        {trackResult && (
          <div style={{ marginTop: 12 }}>
            <Alert
              type="success"
              message={
                <Text strong style={{ color: '#005030', fontSize: 15 }}>
                  {trackResult.type === 'APPLICATION'
                    ? 'HỒ SƠ VAY VỐN / MỞ THẺ TÍN DỤNG'
                    : trackResult.type === 'DISPUTE'
                    ? 'YÊU CẦU TRA SOÁT KHIẾU NẠI GIAO DỊCH'
                    : 'PHIẾU HỖ TRỢ CHĂM SÓC KHÁCH HÀNG'}
                </Text>
              }
              description={trackResult.description}
              showIcon
              style={{ marginBottom: 16 }}
            />

            <Descriptions bordered column={1} size="middle">
              <Descriptions.Item label="Mã định danh">
                <Text copyable strong style={{ color: '#005030', fontSize: 15 }}>
                  {trackResult.code}
                </Text>
              </Descriptions.Item>
              <Descriptions.Item label="Khách hàng">
                <Text strong>{trackResult.customerName || 'Khách hàng'}</Text>
              </Descriptions.Item>

              {trackResult.itemType && (
                <Descriptions.Item label="Phân loại hồ sơ">
                  <Tag color="blue">{trackResult.itemType}</Tag>
                </Descriptions.Item>
              )}

              {trackResult.requestedAmount && (
                <Descriptions.Item label="Số tiền đề xuất">
                  <Text strong style={{ color: '#d4380d' }}>
                    {Number(trackResult.requestedAmount).toLocaleString('vi-VN')} VND
                  </Text>
                </Descriptions.Item>
              )}

              {trackResult.transactionCode && (
                <Descriptions.Item label="Mã giao dịch liên quan">
                  <Text copyable>{trackResult.transactionCode}</Text>
                </Descriptions.Item>
              )}

              {trackResult.reason && (
                <Descriptions.Item label="Lý do tra soát">
                  <Paragraph style={{ margin: 0 }}>{trackResult.reason}</Paragraph>
                </Descriptions.Item>
              )}

              {trackResult.resolutionNote && (
                <Descriptions.Item label="Kết quả xử lý từ Cán bộ">
                  <div style={{ background: '#f6ffed', padding: '8px 12px', borderRadius: 6, border: '1px solid #b7eb8f', color: '#135200' }}>
                    {trackResult.resolutionNote}
                  </div>
                </Descriptions.Item>
              )}

              {trackResult.title && (
                <Descriptions.Item label="Tiêu đề yêu cầu">
                  <Text strong>{trackResult.title}</Text>
                </Descriptions.Item>
              )}

              <Descriptions.Item label="Trạng thái hiện tại">
                <Tag
                  color={
                    ['APPROVED', 'RESOLVED', 'CLOSED'].includes(trackResult.status)
                      ? 'success'
                      : ['PROCESSING', 'IN_PROGRESS'].includes(trackResult.status)
                      ? 'processing'
                      : trackResult.status === 'REJECTED'
                      ? 'error'
                      : 'gold'
                  }
                  style={{ fontWeight: 'bold' }}
                >
                  {trackResult.status}
                </Tag>
              </Descriptions.Item>

              <Descriptions.Item label="Thời gian tiếp nhận">
                {trackResult.createdAt ? dayjs(trackResult.createdAt).format('DD/MM/YYYY HH:mm:ss') : '-'}
              </Descriptions.Item>
            </Descriptions>
          </div>
        )}
      </Modal>

      {/* MODAL BẢNG PHÂN BỔ LỊCH TRẢ NỢ CHI TIẾT (AMORTIZATION SCHEDULE) */}
      <Modal
        title={
          <Space style={{ color: '#005030', fontSize: 16 }}>
            <TableOutlined /> Bảng phân bổ lịch trả nợ chi tiết (Theo dư nợ giảm dần)
          </Space>
        }
        open={amortizationModalVisible}
        onCancel={() => setAmortizationModalVisible(false)}
        footer={[
          <Button
            key="apply"
            type="primary"
            style={{ background: '#005030', borderColor: '#005030' }}
            onClick={() => {
              setAmortizationModalVisible(false);
              applyForm.setFieldsValue({ requestedAmount: calcAmount });
              setApplySuccessData(null);
              setApplyModalVisible(true);
            }}
          >
            Nộp hồ sơ theo gói này
          </Button>,
          <Button key="close" onClick={() => setAmortizationModalVisible(false)}>
            Đóng
          </Button>,
        ]}
        width={850}
      >
        <div style={{ marginTop: 12 }}>
          {/* Tóm tắt gói vay */}
          <Card size="small" style={{ background: '#f4fbf6', borderColor: '#b7eb8f', marginBottom: 16 }}>
            <Row gutter={[16, 8]}>
              <Col span={8}>
                <Text type="secondary">Số tiền vay:</Text>{' '}
                <Text strong style={{ color: '#005030' }}>
                  {Number(calcAmount).toLocaleString('vi-VN')} đ
                </Text>
              </Col>
              <Col span={8}>
                <Text type="secondary">Thời hạn:</Text>{' '}
                <Text strong>{calcTerm} tháng ({calcTerm / 12} năm)</Text>
              </Col>
              <Col span={8}>
                <Text type="secondary">Lãi suất:</Text>{' '}
                <Text strong style={{ color: '#d46b08' }}>{calcRate}% / năm</Text>
              </Col>
              <Col span={8}>
                <Text type="secondary">Tiền gốc hàng tháng:</Text>{' '}
                <Text strong>
                  {Number(Math.round(calcAmount / calcTerm)).toLocaleString('vi-VN')} đ
                </Text>
              </Col>
              <Col span={8}>
                <Text type="secondary">Tổng tiền lãi cả kỳ:</Text>{' '}
                <Text strong style={{ color: '#d4380d' }}>
                  {Number(Math.round(calcResult().totalInterest)).toLocaleString('vi-VN')} đ
                </Text>
              </Col>
              <Col span={8}>
                <Text type="secondary">Tổng số tiền trả:</Text>{' '}
                <Text strong style={{ color: '#005030' }}>
                  {Number(Math.round(calcResult().totalPayout)).toLocaleString('vi-VN')} đ
                </Text>
              </Col>
            </Row>
          </Card>

          {/* Bảng phân kỳ */}
          <Table
            dataSource={generateAmortizationSchedule()}
            rowKey="period"
            size="small"
            pagination={{ pageSize: 12 }}
            columns={[
              {
                title: 'Kỳ (Tháng)',
                dataIndex: 'period',
                key: 'period',
                width: 90,
                align: 'center',
                render: (p) => <Tag color="#005030">Tháng {p}</Tag>,
              },
              {
                title: 'Dư nợ đầu kỳ (VND)',
                dataIndex: 'startBalance',
                key: 'startBalance',
                align: 'right',
                render: (val) => Number(val).toLocaleString('vi-VN'),
              },
              {
                title: 'Tiền gốc (VND)',
                dataIndex: 'principal',
                key: 'principal',
                align: 'right',
                render: (val) => Number(val).toLocaleString('vi-VN'),
              },
              {
                title: 'Tiền lãi (VND)',
                dataIndex: 'interest',
                key: 'interest',
                align: 'right',
                render: (val) => (
                  <Text style={{ color: '#d46b08' }}>{Number(val).toLocaleString('vi-VN')}</Text>
                ),
              },
              {
                title: 'Tổng trả kỳ này (VND)',
                dataIndex: 'totalPay',
                key: 'totalPay',
                align: 'right',
                render: (val) => (
                  <Text strong style={{ color: '#005030' }}>
                    {Number(val).toLocaleString('vi-VN')}
                  </Text>
                ),
              },
              {
                title: 'Dư nợ cuối kỳ (VND)',
                dataIndex: 'endBalance',
                key: 'endBalance',
                align: 'right',
                render: (val) => Number(val).toLocaleString('vi-VN'),
              },
            ]}
          />
        </div>
      </Modal>

      {/* 8. NÚT NỔI CHATBOT AI ASSISTANT VIETCOMBANK */}
      <div
        style={{
          position: 'fixed',
          bottom: 28,
          right: 28,
          zIndex: 999,
        }}
      >
        <Badge count="AI" style={{ backgroundColor: '#73B828', color: '#00482B', fontWeight: 'bold' }}>
          <Button
            type="primary"
            shape="round"
            size="large"
            icon={<RobotOutlined style={{ fontSize: 20 }} />}
            onClick={() => setChatDrawerVisible(true)}
            style={{
              background: 'linear-gradient(135deg, #005030 0%, #00703c 100%)',
              borderColor: '#73B828',
              height: 50,
              padding: '0 20px',
              fontSize: 14,
              fontWeight: 700,
              boxShadow: '0 6px 20px rgba(0,80,48,0.4)',
              display: 'flex',
              alignItems: 'center',
              gap: 8,
            }}
          >
            Trợ lý AI Vietcombank
          </Button>
        </Badge>
      </div>

      {/* DRAWER CHATBOT TƯƠNG TÁC ĐA NĂNG */}
      <Drawer
        title={
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <Avatar style={{ backgroundColor: '#73B828', color: '#00482B' }} icon={<RobotOutlined />} size={36} />
            <div>
              <Text strong style={{ color: '#005030', fontSize: 16, display: 'block', lineHeight: 1.2 }}>
                VCB Digital AI Assistant
              </Text>
              <Text type="secondary" style={{ fontSize: 11 }}>Trực tuyến • Hỗ trợ đặt lịch & hướng dẫn 24/7</Text>
            </div>
          </div>
        }
        placement="right"
        width={480}
        onClose={() => setChatDrawerVisible(false)}
        open={chatDrawerVisible}
        bodyStyle={{ padding: 0, display: 'flex', flexDirection: 'column', background: '#f8faf9' }}
      >
        {/* Navigation Tabs */}
        <div style={{ background: '#fff', borderBottom: '1px solid #e0e0e0', padding: '4px 12px 0' }}>
          <Tabs
            activeKey={chatTab}
            onChange={setChatTab}
            centered
            items={[
              { key: 'chat', label: <span><MessageOutlined /> Trò chuyện</span> },
              { key: 'appointment', label: <span><CalendarOutlined /> Đặt lịch hẹn</span> },
              { key: 'contact', label: <span><PhoneOutlined /> Liên hệ CSKH</span> },
              { key: 'guide', label: <span><QuestionCircleOutlined /> Hướng dẫn</span> },
            ]}
          />
        </div>

        {/* TAB 1: TRÒ CHUYỆN AI */}
        {chatTab === 'chat' && (
          <div style={{ display: 'flex', flexDirection: 'column', flex: 1, height: 'calc(100vh - 120px)' }}>
            {/* Vùng tin nhắn */}
            <div style={{ flex: 1, overflowY: 'auto', padding: '16px 20px' }}>
              {chatMessages.map((m) => (
                <div
                  key={m.id}
                  style={{
                    display: 'flex',
                    justifyContent: m.sender === 'user' ? 'flex-end' : 'flex-start',
                    marginBottom: 16,
                  }}
                >
                  {m.sender === 'bot' && (
                    <Avatar
                      style={{ backgroundColor: '#005030', color: '#73B828', marginRight: 10, flexShrink: 0 }}
                      icon={<RobotOutlined />}
                      size={32}
                    />
                  )}
                  <div style={{ maxWidth: '80%' }}>
                    <div
                      style={{
                        padding: '10px 14px',
                        borderRadius: m.sender === 'user' ? '16px 16px 2px 16px' : '16px 16px 16px 2px',
                        background: m.sender === 'user' ? '#005030' : '#fff',
                        color: m.sender === 'user' ? '#fff' : '#222',
                        boxShadow: '0 2px 8px rgba(0,0,0,0.06)',
                        fontSize: 13,
                        lineHeight: 1.6,
                        whiteSpace: 'pre-line',
                        border: m.sender === 'bot' ? '1px solid #e8e8e8' : 'none',
                      }}
                    >
                      {m.text}
                    </div>
                    <div
                      style={{
                        fontSize: 10,
                        color: '#999',
                        marginTop: 4,
                        textAlign: m.sender === 'user' ? 'right' : 'left',
                      }}
                    >
                      {m.time}
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* Gợi ý câu hỏi nhanh (Quick Prompts) */}
            <div style={{ padding: '8px 16px', background: '#f0f5f2', borderTop: '1px solid #e0e0e0' }}>
              <Text type="secondary" style={{ fontSize: 11, display: 'block', marginBottom: 6 }}>
                Gợi ý câu hỏi nhanh:
              </Text>
              <Space wrap size={[6, 6]}>
                <Button
                  size="small"
                  shape="round"
                  style={{ fontSize: 12, borderColor: '#73B828', color: '#005030' }}
                  onClick={() => setChatTab('appointment')}
                >
                  📅 Đặt lịch hẹn tại quầy
                </Button>
                <Button
                  size="small"
                  shape="round"
                  style={{ fontSize: 12, borderColor: '#73B828', color: '#005030' }}
                  onClick={() => handleSendMessage('Cho tôi biết hotline liên hệ Vietcombank')}
                >
                  📞 Hotline liên hệ
                </Button>
                <Button
                  size="small"
                  shape="round"
                  style={{ fontSize: 12, borderColor: '#73B828', color: '#005030' }}
                  onClick={() => handleSendMessage('Lãi suất tiền gửi tiết kiệm hôm nay bao nhiêu?')}
                >
                  💰 Lãi suất tiết kiệm
                </Button>
                <Button
                  size="small"
                  shape="round"
                  style={{ fontSize: 12, borderColor: '#73B828', color: '#005030' }}
                  onClick={() => handleSendMessage('Điều kiện và hồ sơ vay mua nhà Vietcombank')}
                >
                  🏠 Gói vay mua nhà
                </Button>
                <Button
                  size="small"
                  shape="round"
                  style={{ fontSize: 12, borderColor: '#73B828', color: '#005030' }}
                  onClick={() => setChatTab('guide')}
                >
                  📖 Hướng dẫn sử dụng
                </Button>
              </Space>
            </div>

            {/* Khung nhập tin nhắn */}
            <div style={{ padding: '12px 16px', background: '#fff', borderTop: '1px solid #e0e0e0' }}>
              <Space orientation="horizontal" style={{ width: '100%' }}>
                <Input
                  placeholder="Nhập câu hỏi cần hỗ trợ..."
                  value={chatInput}
                  onChange={(e) => setChatInput(e.target.value)}
                  onPressEnter={() => handleSendMessage()}
                  style={{ borderRadius: 20, padding: '8px 16px' }}
                />
                <Button
                  type="primary"
                  shape="circle"
                  icon={<SendOutlined />}
                  onClick={() => handleSendMessage()}
                  style={{ background: '#005030', borderColor: '#005030' }}
                />
              </Space>
            </div>
          </div>
        )}

        {/* TAB 2: ĐẶT LỊCH HẸN TẠI QUẦY (APPOINTMENT) */}
        {chatTab === 'appointment' && (
          <div style={{ padding: '20px', overflowY: 'auto', flex: 1, background: '#fff' }}>
            <Alert
              type="success"
              message="Đặt lịch trước để được phục vụ ưu tiên tại Quầy giao dịch Vietcombank mà không cần bốc số chờ đợi!"
              showIcon
              style={{ marginBottom: 16 }}
            />
            <Form form={appointmentForm} layout="vertical" onFinish={handleAppointmentSubmit}>
              <Form.Item
                name="branchName"
                label="Chi nhánh / Phòng giao dịch"
                rules={[{ required: true, message: 'Vui lòng chọn chi nhánh' }]}
                initialValue="Chi nhánh Hoàn Kiếm - Hà Nội"
              >
                <Select size="large" showSearch optionFilterProp="children">
                  {branches && branches.length > 0 ? (
                    branches.map((b) => (
                      <Option key={b.id} value={`${b.branchName} - ${b.city}`}>
                        {b.branchName} - {b.address} ({b.city})
                      </Option>
                    ))
                  ) : (
                    <>
                      <Option value="Chi nhánh Hoàn Kiếm - Hà Nội">VCB Hoàn Kiếm - 198 Trần Quang Khải, Hà Nội</Option>
                      <Option value="Chi nhánh Ba Đình - Hà Nội">VCB Ba Đình - 521 Kim Mã, Ba Đình, Hà Nội</Option>
                      <Option value="Chi nhánh Bến Thành - TP.HCM">VCB Bến Thành - 69 Bùi Thị Xuân, Q.1, TP.HCM</Option>
                      <Option value="Chi nhánh TP.HCM - Q.1">VCB TP.HCM - Tòa nhà Vietcombank Tower, Công trường Mê Linh, Q.1</Option>
                      <Option value="Chi nhánh Đà Nẵng">VCB Đà Nẵng - 140-142 Lê Lợi, Hải Châu, Đà Nẵng</Option>
                      <Option value="Chi nhánh Cần Thơ">VCB Cần Thơ - 3-5-7 Hòa Bình, Ninh Kiều, Cần Thơ</Option>
                    </>
                  )}
                </Select>
              </Form.Item>

              <Form.Item
                name="serviceType"
                label="Dịch vụ cần giao dịch"
                rules={[{ required: true, message: 'Vui lòng chọn dịch vụ' }]}
                initialValue="Gửi tiền tiết kiệm & Mở tài khoản"
              >
                <Select size="large">
                  <Option value="Gửi tiền tiết kiệm & Mở tài khoản">Gửi tiền tiết kiệm & Mở tài khoản</Option>
                  <Option value="Tư vấn hồ sơ vay vốn (Mua nhà/Mua xe/Kinh doanh)">Tư vấn hồ sơ vay vốn (Mua nhà/Mua xe)</Option>
                  <Option value="Phát hành thẻ tín dụng quốc tế">Phát hành thẻ tín dụng quốc tế</Option>
                  <Option value="Giao dịch nộp / rút tiền mặt số lượng lớn">Nộp / Rút tiền mặt số lượng lớn</Option>
                  <Option value="Tra soát giao dịch & Hỗ trợ ngân hàng số">Tra soát giao dịch & Hỗ trợ VCB Digibank</Option>
                </Select>
              </Form.Item>

              <Row gutter={12}>
                <Col span={12}>
                  <Form.Item
                    name="appointmentDate"
                    label="Ngày hẹn"
                    rules={[{ required: true, message: 'Chọn ngày hẹn' }]}
                    initialValue="2026-09-10"
                  >
                    <Select size="large">
                      <Option value="2026-09-10">Ngày mai (10/09/2026)</Option>
                      <Option value="2026-09-11">Thứ Sáu (11/09/2026)</Option>
                      <Option value="2026-09-14">Thứ Hai tuần tới (14/09/2026)</Option>
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    name="timeSlot"
                    label="Khung giờ"
                    rules={[{ required: true, message: 'Chọn khung giờ' }]}
                    initialValue="09:00 - 10:00"
                  >
                    <Select size="large">
                      <Option value="08:30 - 09:30">08:30 - 09:30 (Sáng)</Option>
                      <Option value="09:30 - 10:30">09:30 - 10:30 (Sáng)</Option>
                      <Option value="10:30 - 11:30">10:30 - 11:30 (Sáng)</Option>
                      <Option value="13:30 - 14:30">13:30 - 14:30 (Chiều)</Option>
                      <Option value="14:30 - 15:30">14:30 - 15:30 (Chiều)</Option>
                      <Option value="15:30 - 16:30">15:30 - 16:30 (Chiều)</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                name="fullName"
                label="Họ và tên của quý khách"
                rules={[{ required: true, message: 'Vui lòng nhập họ tên' }]}
              >
                <Input prefix={<UserOutlined />} placeholder="Nguyễn Văn A" size="large" />
              </Form.Item>

              <Form.Item
                name="phoneNumber"
                label="Số điện thoại nhận tin nhắn xác nhận"
                rules={[{ required: true, message: 'Vui lòng nhập số điện thoại' }]}
              >
                <Input prefix={<PhoneOutlined />} placeholder="09xxxxxxxx" size="large" />
              </Form.Item>

              <Form.Item name="note" label="Ghi chú thêm nhu cầu">
                <Input.TextArea rows={2} placeholder="Ví dụ: Cần tư vấn gói vay 1 tỷ, chuẩn bị tài liệu gì..." />
              </Form.Item>

              <Button
                type="primary"
                htmlType="submit"
                block
                size="large"
                loading={submittingAppointment}
                style={{ background: '#005030', borderColor: '#005030', fontWeight: 'bold' }}
              >
                Xác nhận đặt lịch hẹn ưu tiên
              </Button>
            </Form>
          </div>
        )}

        {/* TAB 3: LIÊN HỆ & PHẢN HỒI (CONTACT) */}
        {chatTab === 'contact' && (
          <div style={{ padding: '20px', overflowY: 'auto', flex: 1, background: '#fff' }}>
            <Card style={{ background: '#f4fbf6', borderColor: '#b7eb8f', marginBottom: 20 }}>
              <Space direction="vertical" size="small" style={{ width: '100%' }}>
                <Text strong style={{ color: '#005030', fontSize: 15 }}>
                  📞 Tổng đài Chăm sóc Khách hàng 24/7
                </Text>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <Text type="secondary">Hotline trong nước:</Text>
                  <Text strong style={{ color: '#d4380d', fontSize: 16 }}>1900 54 54 13</Text>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <Text type="secondary">Hotline quốc tế:</Text>
                  <Text strong>(+84) 243 8243524</Text>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <Text type="secondary">Email tiếp nhận:</Text>
                  <Text copyable style={{ color: '#005030' }}>contact@vietcombank.com.vn</Text>
                </div>
              </Space>
            </Card>

            <Title level={5} style={{ color: '#005030', marginBottom: 12 }}>
              Gửi thư yêu cầu tư vấn / phản ánh dịch vụ
            </Title>
            <Form form={contactForm} layout="vertical" onFinish={handleContactSubmit}>
              <Form.Item
                name="subject"
                label="Chủ đề liên hệ"
                rules={[{ required: true, message: 'Vui lòng chọn chủ đề' }]}
                initialValue="Tư vấn sản phẩm dịch vụ ngân hàng"
              >
                <Select size="large">
                  <Option value="Tư vấn sản phẩm dịch vụ ngân hàng">Tư vấn sản phẩm dịch vụ ngân hàng</Option>
                  <Option value="Hỗ trợ ứng dụng VCB Digibank">Hỗ trợ ứng dụng VCB Digibank</Option>
                  <Option value="Yêu cầu tra soát khiếu nại giao dịch">Yêu cầu tra soát khiếu nại giao dịch</Option>
                  <Option value="Phản ánh chất lượng dịch vụ">Phản ánh chất lượng dịch vụ</Option>
                  <Option value="Góp ý phát triển sản phẩm">Góp ý phát triển sản phẩm</Option>
                </Select>
              </Form.Item>

              <Form.Item
                name="fullName"
                label="Họ và tên"
                rules={[{ required: true, message: 'Nhập họ tên' }]}
              >
                <Input placeholder="Nguyễn Văn A" size="large" />
              </Form.Item>

              <Row gutter={12}>
                <Col span={12}>
                  <Form.Item
                    name="phoneNumber"
                    label="Số điện thoại"
                    rules={[{ required: true, message: 'Nhập số điện thoại' }]}
                  >
                    <Input placeholder="09xxxxxxxx" size="large" />
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item name="email" label="Email liên hệ">
                    <Input placeholder="email@domain.com" size="large" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                name="message"
                label="Nội dung cần liên hệ"
                rules={[{ required: true, message: 'Vui lòng nhập nội dung' }]}
              >
                <Input.TextArea rows={3} placeholder="Mô tả chi tiết nội dung quý khách cần hỗ trợ..." />
              </Form.Item>

              <Button
                type="primary"
                htmlType="submit"
                block
                size="large"
                loading={submittingContact}
                style={{ background: '#005030', borderColor: '#005030', fontWeight: 'bold' }}
              >
                Gửi thông tin liên hệ
              </Button>
            </Form>
          </div>
        )}

        {/* TAB 4: HƯỚNG DẪN SỬ DỤNG (USER GUIDE & FAQ) */}
        {chatTab === 'guide' && (
          <div style={{ padding: '20px', overflowY: 'auto', flex: 1, background: '#fff' }}>
            <Title level={5} style={{ color: '#005030', marginBottom: 16 }}>
              📖 Cẩm nang Hướng dẫn & Câu hỏi thường gặp
            </Title>
            <Space orientation="vertical" size="middle" style={{ width: '100%' }}>
              <Card size="small" style={{ borderRadius: 8, borderColor: '#e0e0e0' }}>
                <Text strong style={{ color: '#005030', display: 'block', marginBottom: 6 }}>
                  1. Hướng dẫn mở tài khoản trực tuyến eKYC
                </Text>
                <Paragraph style={{ fontSize: 13, color: '#555', margin: 0 }}>
                  Tải ứng dụng <b>VCB Digibank</b> trên App Store hoặc Google Play. Chọn &quot;Mở tài khoản mới cho khách hàng chưa có dịch vụ&quot; → Chụp ảnh 2 mặt CCCD gắn chip → Quét khuôn mặt sinh trắc học NFC → Kích hoạt và nhận số tài khoản ngay sau 1 phút.
                </Paragraph>
              </Card>

              <Card size="small" style={{ borderRadius: 8, borderColor: '#e0e0e0' }}>
                <Text strong style={{ color: '#005030', display: 'block', marginBottom: 6 }}>
                  2. Quên mật khẩu đăng nhập VCB Digibank
                </Text>
                <Paragraph style={{ fontSize: 13, color: '#555', margin: 0 }}>
                  Tại màn hình đăng nhập VCB Digibank, bấm &quot;Quên mật khẩu&quot; → Nhập Tên đăng nhập, số CCCD và Email đã đăng ký → Hệ thống xác thực bằng khuôn mặt và gửi mật khẩu tạm thời về SMS/Email của quý khách.
                </Paragraph>
              </Card>

              <Card size="small" style={{ borderRadius: 8, borderColor: '#e0e0e0' }}>
                <Text strong style={{ color: '#005030', display: 'block', marginBottom: 6 }}>
                  3. Kích hoạt &amp; Cài đặt Smart OTP xác thực giao dịch
                </Text>
                <Paragraph style={{ fontSize: 13, color: '#555', margin: 0 }}>
                  Đăng nhập VCB Digibank → Vào Cài đặt → Quản lý phương thức xác thực → Kích hoạt <b>VCB Smart OTP</b>. Thiết lập mã PIN gồm 6 số để xác thực nhanh chóng và bảo mật tối đa cho các giao dịch trên 10 triệu đồng.
                </Paragraph>
              </Card>

              <Card size="small" style={{ borderRadius: 8, borderColor: '#e0e0e0' }}>
                <Text strong style={{ color: '#005030', display: 'block', marginBottom: 6 }}>
                  4. Quy trình nộp hồ sơ vay vốn trực tuyến
                </Text>
                <Paragraph style={{ fontSize: 13, color: '#555', margin: 0 }}>
                  Bấm nút <b>&quot;Đăng ký hồ sơ trực tuyến&quot;</b> tại góc trên trang chủ hoặc mục Công cụ tính lãi → Điền họ tên, số CCCD, loại vay (tiêu dùng, mua nhà, mua ô tô) và số tiền đề xuất. Cán bộ tín dụng sẽ liên hệ quý khách trong vòng 24 giờ để thẩm định.
                </Paragraph>
              </Card>

              <Card size="small" style={{ borderRadius: 8, borderColor: '#e0e0e0' }}>
                <Text strong style={{ color: '#005030', display: 'block', marginBottom: 6 }}>
                  5. Biểu phí dịch vụ ngân hàng điện tử Vietcombank
                </Text>
                <Paragraph style={{ fontSize: 13, color: '#555', margin: 0 }}>
                  Vietcombank <b>MIỄN PHÍ HOÀN TOÀN</b>: Phí duy trì tài khoản, phí chuyển tiền trong hệ thống và liên ngân hàng 24/7, phí phát hành thẻ phi vật lý trên VCB Digibank.
                </Paragraph>
              </Card>
            </Space>
          </div>
        )}
      </Drawer>
    </Layout>
  );
}
