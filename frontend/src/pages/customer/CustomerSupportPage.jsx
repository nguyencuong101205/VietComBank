import { useEffect, useState } from 'react';
import {
  Alert,
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
  PlusOutlined,
  QuestionCircleOutlined,
  ReloadOutlined,
  SafetyCertificateOutlined,
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
      await unwrap(
        client.post('/customer/tickets', {
          title: values.title.trim(),
          description: values.description.trim(),
          priority: values.priority || 'MEDIUM',
        })
      );
      message.success('Đã tạo phiếu hỗ trợ khách hàng thành công!');
      setCreateTicketOpen(false);
      ticketForm.resetFields();
      loadTickets();
    } catch (e) {
      message.error(e.response?.data?.message || 'Không thể gửi phiếu hỗ trợ, vui lòng thử lại');
    } finally {
      setSubmittingTicket(false);
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
      case 'OPEN':
        return <Tag color="blue">Mới mở</Tag>;
      case 'IN_PROGRESS':
        return <Tag color="processing">Đang hỗ trợ</Tag>;
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
          style={{ color: '#005030' }}
          onClick={() => {
            setSelectedDispute(record);
            setDetailDisputeOpen(true);
          }}
        >
          Chi tiết
        </Button>
      ),
    },
  ];

  const ticketColumns = [
    {
      title: 'Mã Ticket',
      dataIndex: 'ticketCode',
      key: 'ticketCode',
      render: (code) => <Text strong style={{ color: '#005030' }}>{code}</Text>,
    },
    {
      title: 'Tiêu đề yêu cầu',
      dataIndex: 'title',
      key: 'title',
      render: (t) => <Text strong>{t}</Text>,
    },
    {
      title: 'Độ ưu tiên',
      dataIndex: 'priority',
      key: 'priority',
      render: (p) => priorityTag(p),
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
      render: (s) => ticketStatusTag(s),
    },
    {
      title: 'Thao tác',
      key: 'action',
      render: (_, record) => (
        <Button
          type="link"
          size="small"
          style={{ color: '#005030' }}
          onClick={() => {
            setSelectedTicket(record);
            setDetailTicketOpen(true);
          }}
        >
          Chi tiết
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
          Quản lý các yêu cầu tra soát khiếu nại giao dịch và phiếu hỗ trợ kỹ thuật trực tuyến 24/7 của Quý khách.
        </Text>
      </div>

      <Alert
        message="Cam kết chất lượng dịch vụ Vietcombank"
        description="Mọi thắc mắc, khiếu nại giao dịch thẻ, chuyển tiền hoặc lỗi hệ thống đều được cán bộ chuyên trách tiếp nhận và phản hồi xử lý trong vòng 24 - 72 giờ làm việc. Với các tình huống khẩn cấp, vui lòng gọi Hotline 1900 54 54 13."
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
                  <CustomerServiceOutlined /> Phiếu hỗ trợ CSKH ({tickets.length})
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
            <CustomerServiceOutlined /> Gửi phiếu hỗ trợ khách hàng
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
            name="description"
            label="Nội dung cần hỗ trợ chi tiết"
            rules={[{ required: true, message: 'Vui lòng nhập nội dung' }]}
          >
            <Input.TextArea
              rows={4}
              placeholder="Vui lòng cung cấp thêm thông tin thiết bị, số tài khoản, thông báo lỗi nếu có..."
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
                Gửi phiếu hỗ trợ
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

      {/* MODAL: CHI TIẾT TICKET */}
      <Modal
        title={
          <Space style={{ color: '#005030' }}>
            <CustomerServiceOutlined /> Chi tiết Phiếu Hỗ trợ #{selectedTicket?.ticketCode}
          </Space>
        }
        open={detailTicketOpen}
        onCancel={() => setDetailTicketOpen(false)}
        footer={[
          <Button key="close" type="primary" style={{ background: '#005030', borderColor: '#005030' }} onClick={() => setDetailTicketOpen(false)}>
            Đóng
          </Button>,
        ]}
        width={650}
      >
        {selectedTicket && (
          <Descriptions bordered column={1} size="middle" style={{ marginTop: 16 }}>
            <Descriptions.Item label="Mã Ticket">
              <Text copyable strong>{selectedTicket.ticketCode}</Text>
            </Descriptions.Item>
            <Descriptions.Item label="Tiêu đề">
              <Text strong>{selectedTicket.title}</Text>
            </Descriptions.Item>
            <Descriptions.Item label="Độ ưu tiên">
              {priorityTag(selectedTicket.priority)}
            </Descriptions.Item>
            <Descriptions.Item label="Trạng thái">
              {ticketStatusTag(selectedTicket.status)}
            </Descriptions.Item>
            <Descriptions.Item label="Thời gian gửi">
              {dayjs(selectedTicket.createdAt).format('DD/MM/YYYY HH:mm:ss')}
            </Descriptions.Item>
            <Descriptions.Item label="Nội dung yêu cầu">
              <Paragraph style={{ margin: 0, whiteSpace: 'pre-line' }}>{selectedTicket.description}</Paragraph>
            </Descriptions.Item>
            <Descriptions.Item label="Cán bộ phụ trách">
              {selectedTicket.assignedStaff ? selectedTicket.assignedStaff.fullName : 'Đang phân công cán bộ CSKH'}
            </Descriptions.Item>
          </Descriptions>
        )}
      </Modal>
    </div>
  );
}
