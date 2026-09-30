import { useEffect, useState } from 'react';
import {
  Badge,
  Button,
  Card,
  Col,
  Descriptions,
  Empty,
  Form,
  Input,
  Modal,
  Row,
  Select,
  Space,
  Table,
  Tag,
  Typography,
  message,
} from 'antd';
import {
  CheckCircleOutlined,
  ClockCircleOutlined,
  EyeOutlined,
  MailOutlined,
  PhoneOutlined,
  ReloadOutlined,
  SearchOutlined,
  SyncOutlined,
  UserOutlined,
} from '@ant-design/icons';
import dayjs from 'dayjs';
import client, { unwrap } from '../../api/client';

const { Title, Text, Paragraph } = Typography;
const { Option } = Select;

export default function ContactsManagementPage() {
  const [contacts, setContacts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(0);
  const [pageSize, setPageSize] = useState(10);

  const [searchKeyword, setSearchKeyword] = useState('');
  const [statusFilter, setStatusFilter] = useState('');

  // Modal xử lý trạng thái
  const [updateModalOpen, setUpdateModalOpen] = useState(false);
  const [selectedContact, setSelectedContact] = useState(null);
  const [updating, setUpdating] = useState(false);
  const [updateForm] = Form.useForm();

  // Modal xem chi tiết
  const [detailModalOpen, setDetailModalOpen] = useState(false);

  useEffect(() => {
    loadContacts(0, pageSize);
  }, []);

  const loadContacts = async (p = page, s = pageSize) => {
    setLoading(true);
    try {
      const res = await unwrap(
        client.get('/staff/contacts', {
          params: {
            keyword: searchKeyword ? searchKeyword.trim() : undefined,
            status: statusFilter || undefined,
            page: p,
            size: s,
          },
        })
      );
      setContacts(res.content || []);
      setTotal(res.totalElements || 0);
      setPage(p);
      setPageSize(s);
    } catch (e) {
      console.error(e);
      message.error('Không thể tải danh sách tin nhắn liên hệ');
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = () => {
    loadContacts(0, pageSize);
  };

  const handleReset = () => {
    setSearchKeyword('');
    setStatusFilter('');
    setPage(0);
    loadContacts(0, pageSize);
  };

  const openUpdateModal = (record) => {
    setSelectedContact(record);
    updateForm.setFieldsValue({
      status: record.status || 'PROCESSING',
      responseNote: record.responseNote || '',
    });
    setUpdateModalOpen(true);
  };

  const handleUpdateStatus = async (values) => {
    if (!selectedContact) return;
    setUpdating(true);
    try {
      await unwrap(
        client.put(`/staff/contacts/${selectedContact.id}/status`, {
          status: values.status,
          responseNote: values.responseNote ? values.responseNote.trim() : null,
        })
      );
      message.success('Cập nhật trạng thái liên hệ thành công!');
      setUpdateModalOpen(false);
      loadContacts();
    } catch (e) {
      message.error(e.response?.data?.message || 'Không thể cập nhật trạng thái');
    } finally {
      setUpdating(false);
    }
  };

  const statusTag = (s) => {
    switch (s) {
      case 'NEW':
        return <Tag color="blue">MỚI TIẾP NHẬN</Tag>;
      case 'PROCESSING':
        return <Tag color="orange">ĐANG XỬ LÝ</Tag>;
      case 'RESOLVED':
        return <Tag color="green">ĐÃ GIẢI QUYẾT</Tag>;
      default:
        return <Tag>{s}</Tag>;
    }
  };

  const columns = [
    {
      title: 'Mã',
      dataIndex: 'id',
      key: 'id',
      width: 65,
      render: (id) => <Text strong style={{ color: '#005030' }}>#{id}</Text>,
    },
    {
      title: 'Họ và tên khách',
      dataIndex: 'fullName',
      key: 'fullName',
      render: (name, r) => (
        <div>
          <Text strong>{name}</Text>
          <div style={{ fontSize: 12, color: '#888' }}>
            <PhoneOutlined /> {r.phoneNumber}
          </div>
        </div>
      ),
    },
    {
      title: 'Email',
      dataIndex: 'email',
      key: 'email',
      ellipsis: true,
      render: (em) => em || <Text type="secondary">-</Text>,
    },
    {
      title: 'Tiêu đề liên hệ',
      dataIndex: 'subject',
      key: 'subject',
      ellipsis: true,
      render: (sub) => <Text strong>{sub}</Text>,
    },
    {
      title: 'Nội dung',
      dataIndex: 'message',
      key: 'message',
      ellipsis: true,
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
      width: 130,
      render: (s) => statusTag(s),
    },
    {
      title: 'Thao tác',
      key: 'action',
      width: 150,
      render: (_, record) => (
        <Space size="small">
          <Button
            type="link"
            size="small"
            icon={<EyeOutlined />}
            onClick={() => {
              setSelectedContact(record);
              setDetailModalOpen(true);
            }}
          >
            Xem
          </Button>
          <Button
            type="link"
            size="small"
            icon={<SyncOutlined />}
            style={{ color: '#005030', fontWeight: 600 }}
            onClick={() => openUpdateModal(record)}
          >
            Xử lý
          </Button>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: '0 0 24px' }}>
      <div style={{ marginBottom: 16 }}>
        <Title level={2} style={{ color: '#005030', margin: 0, display: 'flex', alignItems: 'center', gap: 10 }}>
          <MailOutlined /> Quản lý Thư liên hệ &amp; Ý kiến Khách hàng
        </Title>
        <Text type="secondary">
          Tiếp nhận, xử lý và phản hồi các yêu cầu liên hệ, phản ánh dịch vụ từ Cổng thông tin công cộng Vietcombank.
        </Text>
      </div>

      {/* Bộ lọc tìm kiếm */}
      <Card style={{ borderRadius: 8, marginBottom: 16, boxShadow: '0 2px 6px rgba(0,0,0,0.04)' }}>
        <Row gutter={[16, 16]} align="middle">
          <Col xs={24} sm={10} md={8}>
            <Input
              placeholder="Tìm theo tên khách hàng, SĐT, email, tiêu đề..."
              prefix={<SearchOutlined />}
              value={searchKeyword}
              onChange={(e) => setSearchKeyword(e.target.value)}
              onPressEnter={handleSearch}
              allowClear
            />
          </Col>
          <Col xs={24} sm={7} md={5}>
            <Select
              style={{ width: '100%' }}
              placeholder="Tất cả trạng thái"
              value={statusFilter}
              onChange={setStatusFilter}
              allowClear
            >
              <Option value="">Tất cả trạng thái</Option>
              <Option value="NEW">Mới tiếp nhận</Option>
              <Option value="PROCESSING">Đang xử lý</Option>
              <Option value="RESOLVED">Đã giải quyết</Option>
            </Select>
          </Col>
          <Col xs={24} sm={7} md={6}>
            <Space>
              <Button type="primary" icon={<SearchOutlined />} onClick={handleSearch} style={{ background: '#005030', borderColor: '#005030' }}>
                Tìm kiếm
              </Button>
              <Button icon={<ReloadOutlined />} onClick={handleReset}>
                Đặt lại
              </Button>
            </Space>
          </Col>
        </Row>
      </Card>

      {/* Bảng dữ liệu */}
      <Card style={{ borderRadius: 8, boxShadow: '0 2px 8px rgba(0,0,0,0.04)' }}>
        <Table
          columns={columns}
          dataSource={contacts}
          rowKey="id"
          loading={loading}
          pagination={{
            current: page + 1,
            pageSize: pageSize,
            total: total,
            showSizeChanger: true,
            onChange: (p, s) => loadContacts(p - 1, s),
          }}
          locale={{
            emptyText: <Empty description="Chưa có tin nhắn liên hệ nào" image={Empty.PRESENTED_IMAGE_SIMPLE} />,
          }}
        />
      </Card>

      {/* MODAL CẬP NHẬT TIẾN ĐỘ XỬ LÝ */}
      <Modal
        title={
          <Space style={{ color: '#005030' }}>
            <SyncOutlined /> Xử lý liên hệ #{selectedContact?.id} - {selectedContact?.fullName}
          </Space>
        }
        open={updateModalOpen}
        onCancel={() => setUpdateModalOpen(false)}
        footer={null}
        destroyOnClose
      >
        {selectedContact && (
          <Form form={updateForm} layout="vertical" onFinish={handleUpdateStatus}>
            <div style={{ background: '#f5f5f5', padding: '10px 14px', borderRadius: 6, marginBottom: 16 }}>
              <Text strong style={{ display: 'block' }}>Tiêu đề: {selectedContact.subject}</Text>
              <Text type="secondary" style={{ fontSize: 13, display: 'block', marginTop: 4 }}>
                Nội dung: {selectedContact.message}
              </Text>
            </div>

            <Form.Item
              name="status"
              label="Cập nhật trạng thái xử lý"
              rules={[{ required: true, message: 'Chọn trạng thái' }]}
            >
              <Select size="large">
                <Option value="NEW">MỚI TIẾP NHẬN (Chưa xử lý)</Option>
                <Option value="PROCESSING">ĐANG XỬ LÝ (Đã chuyển bộ phận liên quan / gọi điện)</Option>
                <Option value="RESOLVED">ĐÃ GIẢI QUYẾT (Đã phản hồi hoàn tất cho khách)</Option>
              </Select>
            </Form.Item>

            <Form.Item
              name="responseNote"
              label="Ghi chú nội bộ / Kết quả phản hồi"
            >
              <Input.TextArea
                rows={4}
                placeholder="Ví dụ: Đã gọi điện qua SĐT 09xxxxxxxx lúc 10:15 hướng dẫn khách hàng mở lại thẻ tín dụng..."
              />
            </Form.Item>

            <Form.Item style={{ marginBottom: 0, textAlign: 'right' }}>
              <Space>
                <Button onClick={() => setUpdateModalOpen(false)}>Hủy</Button>
                <Button
                  type="primary"
                  htmlType="submit"
                  loading={updating}
                  style={{ background: '#005030', borderColor: '#005030', fontWeight: 600 }}
                >
                  Lưu thay đổi
                </Button>
              </Space>
            </Form.Item>
          </Form>
        )}
      </Modal>

      {/* MODAL XEM CHI TIẾT */}
      <Modal
        title={
          <Space style={{ color: '#005030' }}>
            <MailOutlined /> Chi tiết Tin nhắn liên hệ #{selectedContact?.id}
          </Space>
        }
        open={detailModalOpen}
        onCancel={() => setDetailModalOpen(false)}
        footer={[
          <Button key="close" type="primary" style={{ background: '#005030', borderColor: '#005030' }} onClick={() => setDetailModalOpen(false)}>
            Đóng
          </Button>,
        ]}
        width={650}
      >
        {selectedContact && (
          <Descriptions bordered column={1} size="middle" style={{ marginTop: 16 }}>
            <Descriptions.Item label="Họ tên người gửi">
              <Text strong>{selectedContact.fullName}</Text>
            </Descriptions.Item>
            <Descriptions.Item label="Số điện thoại">
              <Text copyable>{selectedContact.phoneNumber}</Text>
            </Descriptions.Item>
            <Descriptions.Item label="Địa chỉ Email">
              <Text copyable>{selectedContact.email || 'Không cung cấp'}</Text>
            </Descriptions.Item>
            <Descriptions.Item label="Tiêu đề thư">
              <Text strong>{selectedContact.subject}</Text>
            </Descriptions.Item>
            <Descriptions.Item label="Nội dung phản ánh / yêu cầu">
              <Paragraph style={{ margin: 0, whiteSpace: 'pre-line' }}>{selectedContact.message}</Paragraph>
            </Descriptions.Item>
            <Descriptions.Item label="Thời gian tiếp nhận">
              {dayjs(selectedContact.createdAt).format('DD/MM/YYYY HH:mm:ss')}
            </Descriptions.Item>
            <Descriptions.Item label="Trạng thái hiện tại">
              {statusTag(selectedContact.status)}
            </Descriptions.Item>
            <Descriptions.Item label="Ghi chú phản hồi của Cán bộ">
              {selectedContact.responseNote ? (
                <div style={{ background: '#f6ffed', padding: '8px 12px', borderRadius: 6, border: '1px solid #b7eb8f', color: '#135200' }}>
                  {selectedContact.responseNote}
                </div>
              ) : (
                <Text type="secondary">Chưa có ghi chú xử lý.</Text>
              )}
            </Descriptions.Item>
          </Descriptions>
        )}
      </Modal>
    </div>
  );
}
