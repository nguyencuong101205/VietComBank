import { useEffect, useState, useRef } from 'react';
import {
  Alert,
  Avatar,
  Badge,
  Button,
  Card,
  Col,
  Descriptions,
  Divider,
  Empty,
  Form,
  Input,
  Modal,
  Row,
  Select,
  Space,
  Spin,
  Table,
  Tabs,
  Tag,
  Typography,
  message,
} from 'antd';
import {
  AuditOutlined,
  CustomerServiceOutlined,
  ExclamationCircleOutlined,
  FileSearchOutlined,
  MessageOutlined,
  PlusOutlined,
  QuestionCircleOutlined,
  ReloadOutlined,
  SafetyCertificateOutlined,
  SendOutlined,
  UserOutlined,
} from '@ant-design/icons';
import dayjs from 'dayjs';
import client, { unwrap } from '../../api/client';
import { useCustomerAuth } from '../../store/CustomerAuthContext';

const { Title, Text, Paragraph } = Typography;
const { Option } = Select;

export default function CustomerSupportPage() {
  const { customer } = useCustomerAuth();

  // Active tab: 'disputes' | 'tickets'
  const [activeTab, setActiveTab] = useState('disputes');

  // Tra soát giao dịch (Disputes)
  const [disputes, setDisputes] = useState([]);
  const [loadingDisputes, setLoadingDisputes] = useState(false);
  const [createDisputeOpen, setCreateDisputeOpen] = useState(false);
  const [submittingDispute, setSubmittingDispute] = useState(false);
  const [disputeForm] = Form.useForm();
  const [selectedDispute, setSelectedDispute] = useState(null);
  const [detailDisputeOpen, setDetailDisputeOpen] = useState(false);

  // Phiếu hỗ trợ CSKH (Support Tickets)
  const [tickets, setTickets] = useState([]);
  const [loadingTickets, setLoadingTickets] = useState(false);
  const [createTicketOpen, setCreateTicketOpen] = useState(false);
  const [submittingTicket, setSubmittingTicket] = useState(false);
  const [ticketForm] = Form.useForm();
  const [selectedTicket, setSelectedTicket] = useState(null);
  const [detailTicketOpen, setDetailTicketOpen] = useState(false);

  // Trò chuyện / Nhắn tin hai chiều CSKH (Two-Way Messaging)
  const [ticketMessages, setTicketMessages] = useState([]);
  const [loadingMessages, setLoadingMessages] = useState(false);
  const [sendingMessage, setSendingMessage] = useState(false);
  const [replyText, setReplyText] = useState('');
  const messagesEndRef = useRef(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    if (detailTicketOpen) {
      scrollToBottom();
    }
  }, [ticketMessages, detailTicketOpen]);

  useEffect(() => {
    loadDisputes();
    loadTickets();
  }, []);

  const loadDisputes = async () => {
    setLoadingDisputes(true);
    try {
      const data = await unwrap(client.get('/customer/disputes'));
      setDisputes(Array.isArray(data) ? data : []);
    } catch (e) {
      console.error('Lỗi tải danh sách tra soát', e);
      message.error(e.response?.data?.message || 'Không thể tải danh sách yêu cầu tra soát');
    } finally {
      setLoadingDisputes(false);
    }
  };

  const loadTickets = async () => {
    setLoadingTickets(true);
    try {
      const data = await unwrap(client.get('/customer/tickets'));
      setTickets(Array.isArray(data) ? data : []);
    } catch (e) {
      console.error('Lỗi tải danh sách ticket', e);
      message.error(e.response?.data?.message || 'Không thể tải danh sách phiếu hỗ trợ');
    } finally {
      setLoadingTickets(false);
    }
  };

  const handleCreateDispute = async (values) => {
    setSubmittingDispute(true);
    try {
      await unwrap(
        client.post('/customer/disputes', {
          transactionCode: values.transactionCode.trim(),
          reason: values.reason.trim(),
        })
      );
      message.success('Đã gửi yêu cầu tra soát giao dịch thành công! Vietcombank sẽ xử lý trong tối đa 03 ngày làm việc.');
      setCreateDisputeOpen(false);
      disputeForm.resetFields();
      loadDisputes();
    } catch (e) {
      message.error(e.response?.data?.message || 'Không thể gửi yêu cầu tra soát, vui lòng kiểm tra lại mã giao dịch');
    } finally {
      setSubmittingDispute(false);
    }
  };

  const handleCreateTicket = async (values) => {
    setSubmittingTicket(true);
    try {
      const content = (values.content || values.description || '').trim();
      const res = await unwrap(
        client.post('/customer/tickets', {
          title: values.title.trim(),
          content: content,
          priority: values.priority || 'MEDIUM',
        })
      );
      message.success('Đã tạo phiếu hỗ trợ khách hàng thành công! Cán bộ CSKH đã tiếp nhận.');
      setCreateTicketOpen(false);
      ticketForm.resetFields();
      await loadTickets();
      // Mở ngay cửa sổ trò chuyện với ticket vừa tạo
      if (res && res.id) {
        openTicketChat(res);
      }
    } catch (e) {
      message.error(e.response?.data?.message || 'Không thể gửi phiếu hỗ trợ, vui lòng thử lại');
    } finally {
      setSubmittingTicket(false);
    }
  };

  const openTicketChat = async (ticket) => {
    setSelectedTicket(ticket);
    setDetailTicketOpen(true);
    setLoadingMessages(true);
    setReplyText('');
    try {
      const res = await unwrap(client.get(`/customer/tickets/${ticket.id}`));
      if (res) {
        setSelectedTicket(res);
        setTicketMessages(res.messages || []);
      }
    } catch (err) {
      // Fallback lấy tin nhắn trực tiếp
      try {
        const msgs = await unwrap(client.get(`/customer/tickets/${ticket.id}/messages`));
        setTicketMessages(Array.isArray(msgs) ? msgs : []);
      } catch (e) {
        setTicketMessages([]);
      }
    } finally {
      setLoadingMessages(false);
    }
  };

  const handleSendMessage = async () => {
    if (!replyText || !replyText.trim() || !selectedTicket) return;
    const msg = replyText.trim();
    setSendingMessage(true);
    try {
      const newMsg = await unwrap(
        client.post(`/customer/tickets/${selectedTicket.id}/messages`, {
          messageText: msg,
        })
      );
      setTicketMessages((prev) => [...prev, newMsg]);
      setReplyText('');
      message.success('Đã gửi phản hồi tới cán bộ CSKH');
      // Nếu ticket trước đó là RESOLVED hoặc CLOSED, cập nhật trạng thái hiển thị
      if (selectedTicket.status === 'RESOLVED' || selectedTicket.status === 'CLOSED') {
        setSelectedTicket((prev) => ({ ...prev, status: 'IN_PROGRESS' }));
        loadTickets();
      }
    } catch (err) {
      message.error(err.response?.data?.message || 'Không thể gửi tin nhắn, vui lòng thử lại');
    } finally {
      setSendingMessage(false);
    }
  };

  const disputeStatusTag = (status) => {
    switch (status) {
      case 'PENDING':
        return <Tag color="gold">Chờ tiếp nhận</Tag>;
      case 'PROCESSING':
        return <Tag color="processing">Đang xử lý</Tag>;
      case 'RESOLVED':
        return <Tag color="success">Đã giải quyết</Tag>;
      case 'REJECTED':
        return <Tag color="error">Từ chối</Tag>;
      default:
        return <Tag>{status}</Tag>;
    }
  };

  const ticketStatusTag = (status) => {
    switch (status) {
      case 'NEW':
      case 'OPEN':
        return <Tag color="gold">Chờ CSKH tiếp nhận</Tag>;
      case 'IN_PROGRESS':
        return <Tag color="processing">Đang trao đổi hỗ trợ</Tag>;
      case 'TRANSFERRED':
        return <Tag color="purple">Chuyển tiếp kỹ thuật</Tag>;
      case 'RESOLVED':
        return <Tag color="success">Đã giải quyết</Tag>;
      case 'CLOSED':
        return <Tag color="default">Đã đóng</Tag>;
      default:
        return <Tag>{status}</Tag>;
    }
  };

  const priorityTag = (p) => {
    switch (p) {
      case 'LOW':
        return <Tag color="default">Thấp</Tag>;
      case 'MEDIUM':
        return <Tag color="blue">Bình thường</Tag>;
      case 'HIGH':
        return <Tag color="orange">Cao</Tag>;
      case 'URGENT':
        return <Tag color="red">Khẩn cấp</Tag>;
      default:
        return <Tag>{p}</Tag>;
    }
  };

  const disputeColumns = [
    {
      title: 'Mã tra soát',
      dataIndex: 'disputeCode',
      key: 'disputeCode',
      render: (code) => <Text strong style={{ color: '#005030' }}>{code}</Text>,
    },
    {
      title: 'Mã GD liên quan',
      dataIndex: 'transactionCode',
      key: 'transactionCode',
      render: (tx) => <Text copyable={{ text: tx }}>{tx || 'N/A'}</Text>,
    },
    {
      title: 'Lý do khiếu nại / tra soát',
      dataIndex: 'reason',
      key: 'reason',
      ellipsis: true,
    },
    {
      title: 'Thời gian gửi',
      dataIndex: 'createdAt',
      key: 'createdAt',
      render: (d) => (d ? dayjs(d).format('DD/MM/YYYY HH:mm') : '-'),
    },
    {
      title: 'Trạng thái',
      dataIndex: 'status',
      key: 'status',
      render: (s) => disputeStatusTag(s),
    },
    {
      title: 'Thao tác',
      key: 'action',
      render: (_, record) => (
        <Button
          type="link"
          size="small"
          style={{ color: '#005030', fontWeight: 600 }}
          onClick={() => {
            setSelectedDispute(record);
            setDetailDisputeOpen(true);
          }}
        >
          Chi tiết tra soát
        </Button>
      ),
    },
  ];

  const ticketColumns = [
    {
      title: 'Mã Ticket',
      dataIndex: 'ticketCode',
      key: 'ticketCode',
      width: 140,
      render: (code) => <Text strong style={{ color: '#005030' }}>{code}</Text>,
    },
    {
      title: 'Tiêu đề yêu cầu hỗ trợ',
      dataIndex: 'title',
      key: 'title',
      render: (t) => <Text strong>{t}</Text>,
    },
    {
      title: 'Độ ưu tiên',
      dataIndex: 'priority',
      key: 'priority',
      width: 110,
      render: (p) => priorityTag(p),
    },
    {
      title: 'Thời gian gửi',
      dataIndex: 'createdAt',
      key: 'createdAt',
      width: 150,
      render: (d) => (d ? dayjs(d).format('DD/MM/YYYY HH:mm') : '-'),
    },
    {
      title: 'Trạng thái',
      dataIndex: 'status',
      key: 'status',
      width: 170,
      render: (s) => ticketStatusTag(s),
    },
    {
      title: 'Thao tác',
      key: 'action',
      width: 160,
      render: (_, record) => (
        <Button
          type="primary"
          size="small"
          icon={<MessageOutlined />}
          style={{ background: '#005030', borderColor: '#005030', fontWeight: 500 }}
          onClick={() => openTicketChat(record)}
        >
          Trò chuyện CSKH
        </Button>
      ),
    },
  ];

  return (
    <div style={{ maxWidth: 1200, margin: '0 auto', paddingBottom: 24 }}>
      {/* Tiêu đề trang */}
      <div style={{ marginBottom: 20 }}>
        <Title level={2} style={{ color: '#005030', margin: 0, display: 'flex', alignItems: 'center', gap: 10 }}>
          <CustomerServiceOutlined /> Trung tâm Hỗ trợ &amp; Tra soát Giao dịch
        </Title>
        <Text type="secondary">
          Kênh nhắn tin tương tác trực tiếp hai chiều với Cán bộ Chăm sóc Khách hàng Vietcombank 24/7 và gửi tra soát giao dịch trực tuyến.
        </Text>
      </div>

      <Alert
        message="Cam kết dịch vụ Chăm sóc Khách hàng Vietcombank"
        description="Quý khách có thể trao đổi nhắn tin phản hồi liên tục với nhân viên CSKH tại từng phiếu hỗ trợ. Mọi thắc mắc về thẻ, tài khoản, lỗi chuyển tiền đều được giải quyết tận tâm, minh bạch và bảo mật."
        type="info"
        showIcon
        style={{ marginBottom: 20, borderRadius: 8, borderColor: '#b7eb8f', background: '#f6ffed' }}
      />

      <Card style={{ borderRadius: 12, boxShadow: '0 2px 10px rgba(0,0,0,0.04)' }}>
        <Tabs
          activeKey={activeTab}
          onChange={setActiveTab}
          tabBarExtraContent={
            <Space>
              {activeTab === 'disputes' ? (
                <>
                  <Button icon={<ReloadOutlined />} onClick={loadDisputes} loading={loadingDisputes}>
                    Làm mới
                  </Button>
                  <Button
                    type="primary"
                    icon={<PlusOutlined />}
                    style={{ background: '#005030', borderColor: '#005030', fontWeight: 600 }}
                    onClick={() => setCreateDisputeOpen(true)}
                  >
                    Tạo yêu cầu tra soát
                  </Button>
                </>
              ) : (
                <>
                  <Button icon={<ReloadOutlined />} onClick={loadTickets} loading={loadingTickets}>
                    Làm mới
                  </Button>
                  <Button
                    type="primary"
                    icon={<PlusOutlined />}
                    style={{ background: '#005030', borderColor: '#005030', fontWeight: 600 }}
                    onClick={() => setCreateTicketOpen(true)}
                  >
                    Gửi phiếu hỗ trợ mới
                  </Button>
                </>
              )}
            </Space>
          }
          items={[
            {
              key: 'disputes',
              label: (
                <span style={{ fontSize: 15, fontWeight: 600 }}>
                  <AuditOutlined /> Tra soát Giao dịch ({disputes.length})
                </span>
              ),
              children: (
                <div>
                  <Table
                    columns={disputeColumns}
                    dataSource={disputes}
                    rowKey="id"
                    loading={loadingDisputes}
                    pagination={{ pageSize: 8 }}
                    locale={{
                      emptyText: (
                        <Empty
                          description="Quý khách chưa có yêu cầu tra soát nào"
                          image={Empty.PRESENTED_IMAGE_SIMPLE}
                        >
                          <Button
                            type="primary"
                            style={{ background: '#005030', borderColor: '#005030' }}
                            onClick={() => setCreateDisputeOpen(true)}
                          >
                            Tạo yêu cầu tra soát đầu tiên
                          </Button>
                        </Empty>
                      ),
                    }}
                  />
                </div>
              ),
            },
            {
              key: 'tickets',
              label: (
                <span style={{ fontSize: 15, fontWeight: 600 }}>
                  <CustomerServiceOutlined /> Phiếu hỗ trợ &amp; Nhắn tin CSKH ({tickets.length})
                </span>
              ),
              children: (
                <div>
                  <Table
                    columns={ticketColumns}
                    dataSource={tickets}
                    rowKey="id"
                    loading={loadingTickets}
                    pagination={{ pageSize: 8 }}
                    locale={{
                      emptyText: (
                        <Empty
                          description="Quý khách chưa gửi phiếu hỗ trợ nào"
                          image={Empty.PRESENTED_IMAGE_SIMPLE}
                        >
                          <Button
                            type="primary"
                            style={{ background: '#005030', borderColor: '#005030' }}
                            onClick={() => setCreateTicketOpen(true)}
                          >
                            Gửi phiếu hỗ trợ đầu tiên
                          </Button>
                        </Empty>
                      ),
                    }}
                  />
                </div>
              ),
            },
          ]}
        />
      </Card>

      {/* MODAL: TẠO YÊU CẦU TRA SOÁT */}
      <Modal
        title={
          <Space style={{ color: '#005030', fontSize: 16 }}>
            <AuditOutlined /> Tạo yêu cầu tra soát giao dịch
          </Space>
        }
        open={createDisputeOpen}
        onCancel={() => setCreateDisputeOpen(false)}
        footer={null}
        destroyOnClose
      >
        <Paragraph type="secondary" style={{ fontSize: 13 }}>
          Áp dụng cho các giao dịch chuyển tiền bị trừ tiền nhưng người nhận chưa nhận được, giao dịch quẹt thẻ bị tính trùng, hoặc nghi ngờ giao dịch gian lận.
        </Paragraph>
        <Form form={disputeForm} layout="vertical" onFinish={handleCreateDispute}>
          <Form.Item
            name="transactionCode"
            label="Mã giao dịch cần tra soát (FT... hoặc mã trong sao kê)"
            rules={[{ required: true, message: 'Vui lòng nhập mã giao dịch' }]}
          >
            <Input placeholder="Ví dụ: FT26090184928" size="large" />
          </Form.Item>

          <Form.Item
            name="reason"
            label="Lý do chi tiết yêu cầu tra soát"
            rules={[{ required: true, message: 'Vui lòng nhập lý do' }]}
          >
            <Input.TextArea
              rows={4}
              placeholder="Mô tả cụ thể sự việc: Thời gian giao dịch, số tiền bị trừ, hiện tượng xảy ra..."
            />
          </Form.Item>

          <Form.Item style={{ marginBottom: 0, textAlign: 'right' }}>
            <Space>
              <Button onClick={() => setCreateDisputeOpen(false)}>Hủy</Button>
              <Button
                type="primary"
                htmlType="submit"
                loading={submittingDispute}
                style={{ background: '#005030', borderColor: '#005030', fontWeight: 600 }}
              >
                Gửi yêu cầu tra soát
              </Button>
            </Space>
          </Form.Item>
        </Form>
      </Modal>

      {/* MODAL: TẠO PHIẾU HỖ TRỢ TICKETS */}
      <Modal
        title={
          <Space style={{ color: '#005030', fontSize: 16 }}>
            <CustomerServiceOutlined /> Gửi phiếu hỗ trợ khách hàng mới
          </Space>
        }
        open={createTicketOpen}
        onCancel={() => setCreateTicketOpen(false)}
        footer={null}
        destroyOnClose
      >
        <Form form={ticketForm} layout="vertical" onFinish={handleCreateTicket}>
          <Form.Item
            name="title"
            label="Tiêu đề yêu cầu hỗ trợ"
            rules={[{ required: true, message: 'Vui lòng nhập tiêu đề' }]}
          >
            <Input placeholder="Ví dụ: Cần hỗ trợ nâng hạn mức chuyển tiền trực tuyến" size="large" />
          </Form.Item>

          <Form.Item
            name="priority"
            label="Mức độ ưu tiên"
            initialValue="MEDIUM"
            rules={[{ required: true }]}
          >
            <Select size="large">
              <Option value="LOW">Thấp - Thắc mắc biểu phí, thông tin chung</Option>
              <Option value="MEDIUM">Bình thường - Đăng ký dịch vụ, hỗ trợ tính năng</Option>
              <Option value="HIGH">Cao - Lỗi không đăng nhập được, lỗi OTP</Option>
              <Option value="URGENT">Khẩn cấp - Nghi ngờ lộ thông tin, khóa tài khoản</Option>
            </Select>
          </Form.Item>

          <Form.Item
            name="content"
            label="Nội dung cần hỗ trợ chi tiết"
            rules={[{ required: true, message: 'Vui lòng nhập nội dung' }]}
          >
            <Input.TextArea
              rows={4}
              placeholder="Vui lòng cung cấp chi tiết sự cố: Thiết bị đang dùng, số tài khoản, thông báo lỗi nếu có..."
            />
          </Form.Item>

          <Form.Item style={{ marginBottom: 0, textAlign: 'right' }}>
            <Space>
              <Button onClick={() => setCreateTicketOpen(false)}>Hủy</Button>
              <Button
                type="primary"
                htmlType="submit"
                loading={submittingTicket}
                style={{ background: '#005030', borderColor: '#005030', fontWeight: 600 }}
              >
                Gửi phiếu & Bắt đầu trao đổi
              </Button>
            </Space>
          </Form.Item>
        </Form>
      </Modal>

      {/* MODAL: CHI TIẾT TRA SOÁT */}
      <Modal
        title={
          <Space style={{ color: '#005030' }}>
            <AuditOutlined /> Chi tiết Yêu cầu Tra soát #{selectedDispute?.disputeCode}
          </Space>
        }
        open={detailDisputeOpen}
        onCancel={() => setDetailDisputeOpen(false)}
        footer={[
          <Button key="close" type="primary" style={{ background: '#005030', borderColor: '#005030' }} onClick={() => setDetailDisputeOpen(false)}>
            Đóng
          </Button>,
        ]}
        width={650}
      >
        {selectedDispute && (
          <Descriptions bordered column={1} size="middle" style={{ marginTop: 16 }}>
            <Descriptions.Item label="Mã tra soát">
              <Text copyable strong>{selectedDispute.disputeCode}</Text>
            </Descriptions.Item>
            <Descriptions.Item label="Mã giao dịch">
              <Text copyable>{selectedDispute.transactionCode || 'N/A'}</Text>
            </Descriptions.Item>
            <Descriptions.Item label="Trạng thái">
              {disputeStatusTag(selectedDispute.status)}
            </Descriptions.Item>
            <Descriptions.Item label="Thời gian tạo">
              {dayjs(selectedDispute.createdAt).format('DD/MM/YYYY HH:mm:ss')}
            </Descriptions.Item>
            <Descriptions.Item label="Lý do tra soát">
              <Paragraph style={{ margin: 0, whiteSpace: 'pre-line' }}>{selectedDispute.reason}</Paragraph>
            </Descriptions.Item>
            <Descriptions.Item label="Kết quả xử lý từ Cán bộ Ngân hàng">
              {selectedDispute.resolutionNote ? (
                <div style={{ background: '#f6ffed', padding: '8px 12px', borderRadius: 6, border: '1px solid #b7eb8f', color: '#135200' }}>
                  {selectedDispute.resolutionNote}
                </div>
              ) : (
                <Text type="secondary">Chuyên viên đang tiếp nhận kiểm tra hồ sơ giao dịch, vui lòng chờ cập nhật.</Text>
              )}
            </Descriptions.Item>
          </Descriptions>
        )}
      </Modal>

      {/* MODAL: HỘI THOẠI NHẮN TIN TRAO ĐỔI HAI CHIỀU GIỮA KHÁCH HÀNG & NHÂN VIÊN CSKH */}
      <Modal
        title={
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', paddingRight: 24 }}>
            <Space>
              <CustomerServiceOutlined style={{ color: '#005030', fontSize: 20 }} />
              <div>
                <span style={{ color: '#005030', fontWeight: 600, fontSize: 16 }}>
                  Hỗ trợ trực tuyến: #{selectedTicket?.ticketCode}
                </span>
                <div style={{ fontSize: 12, fontWeight: 'normal', color: '#666' }}>
                  {selectedTicket?.title}
                </div>
              </div>
            </Space>
            <Space>
              {selectedTicket && priorityTag(selectedTicket.priority)}
              {selectedTicket && ticketStatusTag(selectedTicket.status)}
            </Space>
          </div>
        }
        open={detailTicketOpen}
        onCancel={() => setDetailTicketOpen(false)}
        footer={null}
        width={780}
        destroyOnClose
      >
        {selectedTicket && (
          <div style={{ display: 'flex', flexDirection: 'column', height: '650px', maxHeight: '75vh' }}>
            {/* Thanh thông tin tóm tắt phiếu hỗ trợ */}
            <div style={{ background: '#f8fafc', padding: '10px 14px', borderRadius: 8, marginBottom: 12, border: '1px solid #e2e8f0', fontSize: 13 }}>
              <Row gutter={[12, 4]} align="middle">
                <Col span={14}>
                  <Text type="secondary">Yêu cầu ban đầu: </Text>
                  <Text strong>{selectedTicket.content || selectedTicket.title}</Text>
                </Col>
                <Col span={10} style={{ textAlign: 'right' }}>
                  <Text type="secondary">Gửi lúc: </Text>
                  <Text>{dayjs(selectedTicket.createdAt).format('DD/MM/YYYY HH:mm')}</Text>
                </Col>
              </Row>
            </div>

            {/* Khung tin nhắn hội thoại hai chiều */}
            <div
              style={{
                flex: 1,
                overflowY: 'auto',
                padding: '16px',
                background: '#f4f6f8',
                borderRadius: 8,
                border: '1px solid #e5e7eb',
                display: 'flex',
                flexDirection: 'column',
                gap: 12,
              }}
            >
              {loadingMessages ? (
                <div style={{ textAlign: 'center', padding: '50px 0' }}>
                  <Spin tip="Đang tải lịch sử trao đổi..." />
                </div>
              ) : ticketMessages.length === 0 ? (
                <Empty description="Chưa có tin nhắn nào trong hội thoại này" />
              ) : (
                ticketMessages.map((msg, idx) => {
                  const isCustomer = msg.senderType === 'CUSTOMER';
                  return (
                    <div
                      key={msg.id || idx}
                      style={{
                        display: 'flex',
                        flexDirection: isCustomer ? 'row-reverse' : 'row',
                        alignItems: 'flex-start',
                        gap: 10,
                      }}
                    >
                      <Avatar
                        style={{
                          backgroundColor: isCustomer ? '#005030' : '#1890ff',
                          flexShrink: 0,
                        }}
                        icon={isCustomer ? <UserOutlined /> : <CustomerServiceOutlined />}
                      />
                      <div
                        style={{
                          maxWidth: '75%',
                          display: 'flex',
                          flexDirection: 'column',
                          alignItems: isCustomer ? 'flex-end' : 'flex-start',
                        }}
                      >
                        <div style={{ fontSize: 12, color: '#6b7280', marginBottom: 2 }}>
                          <span style={{ fontWeight: 600, color: isCustomer ? '#005030' : '#1e3a8a' }}>
                            {isCustomer ? 'Quý khách (Bạn)' : msg.senderName}
                          </span>
                          {!isCustomer && (
                            <Tag color="cyan" style={{ fontSize: 10, marginLeft: 6, lineHeight: '16px', padding: '0 4px' }}>
                              Cán bộ CSKH
                            </Tag>
                          )}
                          <span style={{ marginLeft: 8 }}>
                            {msg.createdAt ? dayjs(msg.createdAt).format('HH:mm DD/MM') : ''}
                          </span>
                        </div>
                        <div
                          style={{
                            padding: '10px 14px',
                            borderRadius: isCustomer ? '14px 2px 14px 14px' : '2px 14px 14px 14px',
                            background: isCustomer ? '#005030' : '#ffffff',
                            color: isCustomer ? '#ffffff' : '#1f2937',
                            boxShadow: '0 1px 3px rgba(0,0,0,0.08)',
                            fontSize: 14,
                            lineHeight: 1.5,
                            whiteSpace: 'pre-wrap',
                            wordBreak: 'break-word',
                          }}
                        >
                          {msg.messageText}
                        </div>
                      </div>
                    </div>
                  );
                })
              )}
              <div ref={messagesEndRef} />
            </div>

            {/* Khung soạn thảo và gửi tin nhắn phản hồi */}
            <div style={{ marginTop: 12, paddingTop: 8, borderTop: '1px solid #f0f0f0' }}>
              <div style={{ display: 'flex', gap: 10 }}>
                <Input.TextArea
                  rows={2}
                  placeholder="Nhập nội dung phản hồi, trao đổi trực tiếp với nhân viên CSKH (Nhấn Gửi hoặc Ctrl+Enter)..."
                  value={replyText}
                  onChange={(e) => setReplyText(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter' && (e.ctrlKey || e.metaKey)) {
                      e.preventDefault();
                      handleSendMessage();
                    }
                  }}
                  style={{ borderRadius: 8, resize: 'none' }}
                />
                <Button
                  type="primary"
                  icon={<SendOutlined />}
                  loading={sendingMessage}
                  disabled={!replyText.trim()}
                  onClick={handleSendMessage}
                  style={{
                    height: 'auto',
                    padding: '0 20px',
                    background: '#005030',
                    borderColor: '#005030',
                    fontWeight: 600,
                    borderRadius: 8,
                  }}
                >
                  Gửi
                </Button>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 6 }}>
                <Text type="secondary" style={{ fontSize: 12 }}>
                  💡 Gợi ý: Gõ tin nhắn và nhấn <b>Ctrl+Enter</b> để gửi nhanh.
                </Text>
                <Button
                  type="link"
                  size="small"
                  icon={<ReloadOutlined />}
                  onClick={() => openTicketChat(selectedTicket)}
                  style={{ color: '#005030' }}
                >
                  Tải lại tin nhắn
                </Button>
              </div>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}

