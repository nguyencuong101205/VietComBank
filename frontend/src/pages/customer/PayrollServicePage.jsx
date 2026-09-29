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
  InputNumber,
  Modal,
  Popconfirm,
  Row,
  Space,
  Statistic,
  Table,
  Tag,
  Typography,
  message,
} from 'antd';
import {
  BankOutlined,
  CheckCircleOutlined,
  DeleteOutlined,
  DollarOutlined,
  DownloadOutlined,
  HistoryOutlined,
  PlusOutlined,
  ReloadOutlined,
  SafetyCertificateOutlined,
  SendOutlined,
  TeamOutlined,
  ThunderboltOutlined,
  UploadOutlined,
} from '@ant-design/icons';
import dayjs from 'dayjs';
import client, { unwrap } from '../../api/client';
import { useCustomerAuth } from '../../store/CustomerAuthContext';

const { Title, Text, Paragraph } = Typography;

const DEFAULT_EMPLOYEES = [
  {
    key: '1',
    employeeName: 'Nguyễn Văn An',
    accountNumber: '0011004567890',
    amount: 18500000,
    note: 'Lương tháng 09/2026 - NV An',
  },
  {
    key: '2',
    employeeName: 'Trần Thị Bích Ngọc',
    accountNumber: '0011009876543',
    amount: 22000000,
    note: 'Lương tháng 09/2026 - NV Ngọc',
  },
  {
    key: '3',
    employeeName: 'Lê Hoàng Minh',
    accountNumber: '0011002345678',
    amount: 16000000,
    note: 'Lương tháng 09/2026 - NV Minh',
  },
  {
    key: '4',
    employeeName: 'Phạm Thu Trang',
    accountNumber: '0011008765432',
    amount: 25000000,
    note: 'Lương tháng 09/2026 - NV Trang',
  },
  {
    key: '5',
    employeeName: 'Đỗ Hữu Nghĩa',
    accountNumber: '0011003456789',
    amount: 19500000,
    note: 'Lương tháng 09/2026 - NV Nghĩa',
  },
];

export default function PayrollServicePage() {
  const { customer } = useCustomerAuth();

  const [employees, setEmployees] = useState(DEFAULT_EMPLOYEES);
  const [profile, setProfile] = useState(null);
  const [history, setHistory] = useState([]);
  const [loadingHistory, setLoadingHistory] = useState(false);

  // Form thêm nhân viên
  const [addModalOpen, setAddModalOpen] = useState(false);
  const [addForm] = Form.useForm();

  // Xác nhận chi trả
  const [confirmModalOpen, setConfirmModalOpen] = useState(false);
  const [submittingPayroll, setSubmittingPayroll] = useState(false);
  const [confirmForm] = Form.useForm();

  // Kết quả chi trả
  const [resultModalOpen, setResultModalOpen] = useState(false);
  const [payrollResult, setPayrollResult] = useState(null);

  useEffect(() => {
    loadProfile();
    loadHistory();
  }, []);

  const loadProfile = async () => {
    try {
      const data = await unwrap(client.get('/customer/profile'));
      setProfile(data);
    } catch (e) {
      console.error(e);
    }
  };

  const loadHistory = async () => {
    setLoadingHistory(true);
    try {
      const data = await unwrap(client.get('/customer/payroll/history'));
      setHistory(Array.isArray(data) ? data : []);
    } catch (e) {
      console.error(e);
    } finally {
      setLoadingHistory(false);
    }
  };

  const totalAmount = employees.reduce((sum, item) => sum + (Number(item.amount) || 0), 0);
  const currentBalance = profile?.accountBalance || 500000000;

  const handleAddEmployee = (values) => {
    const newEmp = {
      key: Date.now().toString(),
      employeeName: values.employeeName.trim(),
      accountNumber: values.accountNumber.trim(),
      amount: Number(values.amount),
      note: values.note ? values.note.trim() : `Lương tháng ${dayjs().format('MM/YYYY')}`,
    };
    setEmployees([...employees, newEmp]);
    addForm.resetFields();
    setAddModalOpen(false);
    message.success('Đã thêm nhân viên vào danh sách chi trả');
  };

  const handleDeleteEmployee = (key) => {
    setEmployees(employees.filter((e) => e.key !== key));
    message.info('Đã xóa dòng khỏi danh sách');
  };

  const handleExecutePayroll = async (values) => {
    if (employees.length === 0) {
      message.error('Danh sách chi trả lương đang trống!');
      return;
    }
    if (totalAmount > currentBalance) {
      message.error('Số dư tài khoản thanh toán không đủ để thực hiện lô chi trả lương!');
      return;
    }

    setSubmittingPayroll(true);
    try {
      const batchTitle = values.description || `Chi trả lương tháng ${values.payrollMonth || dayjs().format('MM/YYYY')}`;
      const payload = {
        batchName: batchTitle,
        description: batchTitle,
        payrollMonth: values.payrollMonth || dayjs().format('MM/YYYY'),
        items: employees.map((e) => ({
          employeeName: e.employeeName,
          accountNumber: e.accountNumber,
          receiverAccountNumber: e.accountNumber,
          bankName: 'Vietcombank',
          amount: e.amount,
          note: e.note,
        })),
      };

      const res = await unwrap(client.post('/customer/payroll/execute', payload));
      setPayrollResult(res);
      setConfirmModalOpen(false);
      setResultModalOpen(true);
      message.success('Thực hiện chi trả lương theo lô thành công!');
      loadProfile();
      loadHistory();
    } catch (e) {
      message.error(e.response?.data?.message || 'Lỗi khi thực hiện chi trả lương theo lô');
    } finally {
      setSubmittingPayroll(false);
    }
  };

  const employeeColumns = [
    {
      title: 'STT',
      width: 60,
      render: (_, __, index) => index + 1,
    },
    {
      title: 'Họ tên nhân viên',
      dataIndex: 'employeeName',
      key: 'employeeName',
      render: (name) => <Text strong>{name}</Text>,
    },
    {
      title: 'Số TK Vietcombank',
      dataIndex: 'accountNumber',
      key: 'accountNumber',
      render: (acc) => <Text copyable style={{ color: '#005030', fontFamily: 'monospace' }}>{acc}</Text>,
    },
    {
      title: 'Số tiền chi trả (VND)',
      dataIndex: 'amount',
      key: 'amount',
      align: 'right',
      render: (val) => (
        <Text strong style={{ color: '#005030', fontSize: 14 }}>
          {Number(val).toLocaleString('vi-VN')} đ
        </Text>
      ),
    },
    {
      title: 'Nội dung giao dịch',
      dataIndex: 'note',
      key: 'note',
      ellipsis: true,
    },
    {
      title: 'Thao tác',
      key: 'action',
      width: 80,
      align: 'center',
      render: (_, record) => (
        <Popconfirm
          title="Xác nhận xóa nhân viên này khỏi bảng lương?"
          onConfirm={() => handleDeleteEmployee(record.key)}
          okText="Xóa"
          cancelText="Hủy"
        >
          <Button type="text" danger icon={<DeleteOutlined />} size="small" />
        </Popconfirm>
      ),
    },
  ];

  const historyColumns = [
    {
      title: 'Mã lô Payroll',
      dataIndex: 'batchCode',
      key: 'batchCode',
      render: (code) => <Text strong style={{ color: '#005030' }}>{code}</Text>,
    },
    {
      title: 'Kỳ lương',
      dataIndex: 'payrollMonth',
      key: 'payrollMonth',
      render: (m) => <Tag color="green">{m || '09/2026'}</Tag>,
    },
    {
      title: 'Số lượng nhân sự',
      dataIndex: 'employeeCount',
      key: 'employeeCount',
      render: (cnt) => <Text>{cnt} nhân sự</Text>,
    },
    {
      title: 'Tổng số tiền đã chi',
      dataIndex: 'totalAmount',
      key: 'totalAmount',
      align: 'right',
      render: (val) => (
        <Text strong style={{ color: '#d4380d' }}>
          -{Number(val).toLocaleString('vi-VN')} đ
        </Text>
      ),
    },
    {
      title: 'Thời gian thực hiện',
      dataIndex: 'createdAt',
      key: 'createdAt',
      render: (d) => (d ? dayjs(d).format('DD/MM/YYYY HH:mm') : '-'),
    },
    {
      title: 'Trạng thái',
      dataIndex: 'status',
      key: 'status',
      render: () => <Tag color="success">THÀNH CÔNG (100%)</Tag>,
    },
  ];

  return (
    <div style={{ maxWidth: 1200, margin: '0 auto', paddingBottom: 24 }}>
      {/* Tiêu đề trang */}
      <div style={{ marginBottom: 20 }}>
        <Title level={2} style={{ color: '#005030', margin: 0, display: 'flex', alignItems: 'center', gap: 10 }}>
          <ThunderboltOutlined /> Dịch vụ Chi trả Lương theo Lô (Batch Payroll)
        </Title>
        <Text type="secondary">
          Giải pháp ngân hàng số chuyên biệt dành cho Doanh nghiệp: Chuyển tiền lương tự động hàng loạt tới cán bộ nhân viên trong tích tắc.
        </Text>
      </div>

      {/* Thông tin tài khoản nguồn và số dư */}
      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        <Col xs={24} md={14}>
          <Card style={{ borderRadius: 12, height: '100%', borderLeft: '4px solid #005030', boxShadow: '0 2px 8px rgba(0,0,0,0.05)' }}>
            <Descriptions title="Tài khoản Doanh nghiệp trích nợ" size="small" column={1}>
              <Descriptions.Item label="Đơn vị thụ hưởng">
                <Text strong style={{ fontSize: 15, color: '#005030' }}>
                  {profile?.fullName || customer?.fullName || 'CÔNG TY TNHH CÔNG NGHỆ ABC'}
                </Text>
              </Descriptions.Item>
              <Descriptions.Item label="Mã định danh / MST">
                <Text copyable>{profile?.idCardNumber || '0109988776'}</Text>
              </Descriptions.Item>
              <Descriptions.Item label="Số tài khoản thanh toán">
                <Text copyable strong style={{ color: '#005030', fontSize: 16 }}>
                  {profile?.accountNumber || '0011009998888'}
                </Text>
                <Tag color="#73B828" style={{ marginLeft: 8, color: '#00482B', fontWeight: 'bold' }}>
                  VND - Thanh toán DN
                </Tag>
              </Descriptions.Item>
            </Descriptions>
          </Card>
        </Col>

        <Col xs={24} md={10}>
          <Card style={{ borderRadius: 12, height: '100%', background: 'linear-gradient(135deg, #005030 0%, #00703c 100%)', color: '#fff' }}>
            <Statistic
              title={<span style={{ color: '#a5d6a7', fontSize: 13 }}>SỐ DƯ KHẢ DỤNG HIỆN TẠI</span>}
              value={currentBalance}
              precision={0}
              suffix={<span style={{ color: '#fff', fontSize: 16 }}>VND</span>}
              valueStyle={{ color: '#fff', fontSize: 30, fontWeight: 'bold' }}
            />
            <Divider style={{ borderColor: 'rgba(255,255,255,0.2)', margin: '12px 0' }} />
            <Row justify="space-between" align="middle">
              <Text style={{ color: '#c8e6c9' }}>Tổng tiền lương lô này:</Text>
              <Text strong style={{ color: '#ffd54f', fontSize: 18 }}>
                {totalAmount.toLocaleString('vi-VN')} VND
              </Text>
            </Row>
          </Card>
        </Col>
      </Row>

      {/* Bảng danh sách nhân viên cần chi trả */}
      <Card
        title={
          <Space>
            <TeamOutlined style={{ color: '#005030' }} />
            <span>Danh sách cán bộ nhân viên nhận lương ({employees.length} người)</span>
          </Space>
        }
        extra={
          <Space>
            <Button
              icon={<PlusOutlined />}
              onClick={() => setAddModalOpen(true)}
            >
              Thêm nhân viên
            </Button>
            <Button
              type="primary"
              icon={<SendOutlined />}
              style={{ background: '#73B828', borderColor: '#73B828', color: '#003820', fontWeight: 700 }}
              onClick={() => {
                confirmForm.setFieldsValue({
                  payrollMonth: `Tháng ${dayjs().format('MM/YYYY')}`,
                  description: `Thanh toán lương tháng ${dayjs().format('MM/YYYY')} - ${profile?.fullName || 'DN'}`,
                });
                setConfirmModalOpen(true);
              }}
              disabled={employees.length === 0}
            >
              Chi trả lương ({Number(totalAmount).toLocaleString('vi-VN')} đ)
            </Button>
          </Space>
        }
        style={{ borderRadius: 12, marginBottom: 24, boxShadow: '0 2px 10px rgba(0,0,0,0.04)' }}
      >
        <Table
          columns={employeeColumns}
          dataSource={employees}
          pagination={false}
          summary={() => (
            <Table.Summary fixed>
              <Table.Summary.Row style={{ background: '#f6ffed' }}>
                <Table.Summary.Cell index={0} colSpan={3}>
                  <Text strong style={{ color: '#005030' }}>TỔNG CỘNG QUỸ LƯƠNG TRÍCH NỢ ({employees.length} NHÂN SỰ):</Text>
                </Table.Summary.Cell>
                <Table.Summary.Cell index={1} align="right">
                  <Text strong style={{ color: '#d4380d', fontSize: 16 }}>
                    {totalAmount.toLocaleString('vi-VN')} VND
                  </Text>
                </Table.Summary.Cell>
                <Table.Summary.Cell index={2} colSpan={2} />
              </Table.Summary.Row>
            </Table.Summary>
          )}
        />
      </Card>

      {/* Lịch sử các đợt chi trả lương */}
      <Card
        title={
          <Space>
            <HistoryOutlined style={{ color: '#005030' }} />
            <span>Lịch sử các đợt chi trả lương theo lô gần đây</span>
          </Space>
        }
        extra={
          <Button icon={<ReloadOutlined />} onClick={loadHistory} loading={loadingHistory}>
            Làm mới
          </Button>
        }
        style={{ borderRadius: 12, boxShadow: '0 2px 10px rgba(0,0,0,0.04)' }}
      >
        <Table
          columns={historyColumns}
          dataSource={history}
          rowKey="id"
          loading={loadingHistory}
          pagination={{ pageSize: 5 }}
          locale={{
            emptyText: <Empty description="Chưa có lịch sử chi trả lương theo lô" image={Empty.PRESENTED_IMAGE_SIMPLE} />,
          }}
        />
      </Card>

      {/* MODAL THÊM NHÂN VIÊN */}
      <Modal
        title={
          <Space style={{ color: '#005030' }}>
            <PlusOutlined /> Thêm nhân sự vào bảng thanh toán lương
          </Space>
        }
        open={addModalOpen}
        onCancel={() => setAddModalOpen(false)}
        footer={null}
        destroyOnClose
      >
        <Form form={addForm} layout="vertical" onFinish={handleAddEmployee}>
          <Form.Item
            name="employeeName"
            label="Họ và tên nhân sự"
            rules={[{ required: true, message: 'Vui lòng nhập họ tên' }]}
          >
            <Input placeholder="Ví dụ: Hoàng Văn Tuấn" size="large" />
          </Form.Item>

          <Form.Item
            name="accountNumber"
            label="Số tài khoản thụ hưởng (Vietcombank)"
            rules={[{ required: true, message: 'Vui lòng nhập số tài khoản' }]}
          >
            <Input placeholder="001100..." size="large" />
          </Form.Item>

          <Form.Item
            name="amount"
            label="Số tiền lương chi trả (VND)"
            rules={[{ required: true, message: 'Vui lòng nhập số tiền' }]}
          >
            <InputNumber
              style={{ width: '100%' }}
              size="large"
              min={100000}
              step={500000}
              formatter={(val) => `${val}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
              parser={(val) => val.replace(/\$\s?|(,*)/g, '')}
            />
          </Form.Item>

          <Form.Item name="note" label="Nội dung giao dịch">
            <Input placeholder="Chi tra luong thang..." size="large" />
          </Form.Item>

          <Form.Item style={{ marginBottom: 0, textAlign: 'right' }}>
            <Space>
              <Button onClick={() => setAddModalOpen(false)}>Hủy</Button>
              <Button type="primary" htmlType="submit" style={{ background: '#005030', borderColor: '#005030' }}>
                Thêm vào bảng lương
              </Button>
            </Space>
          </Form.Item>
        </Form>
      </Modal>

      {/* MODAL XÁC NHẬN CHI TRẢ LƯƠNG HÀNG LOẠT */}
      <Modal
        title={
          <Space style={{ color: '#005030', fontSize: 16 }}>
            <SafetyCertificateOutlined /> Xác thực lệnh chi trả lương hàng loạt
          </Space>
        }
        open={confirmModalOpen}
        onCancel={() => setConfirmModalOpen(false)}
        footer={null}
        destroyOnClose
      >
        <Alert
          type="warning"
          message="Lưu ý quan trọng"
          description={`Lệnh này sẽ tự động trích nợ ${totalAmount.toLocaleString('vi-VN')} VND từ tài khoản doanh nghiệp và ghi có tức thì cho ${employees.length} nhân viên trong danh sách.`}
          showIcon
          style={{ marginBottom: 16 }}
        />

        <Form form={confirmForm} layout="vertical" onFinish={handleExecutePayroll}>
          <Form.Item name="payrollMonth" label="Kỳ lương thanh toán">
            <Input size="large" />
          </Form.Item>

          <Form.Item name="description" label="Nội dung giao dịch tổng quát">
            <Input size="large" />
          </Form.Item>

          <Form.Item
            name="otpCode"
            label="Mã Smart OTP Doanh nghiệp"
            initialValue="123456"
            rules={[{ required: true, message: 'Nhập mã Smart OTP' }]}
            extra="Mã Smart OTP xác thực 6 số trên ứng dụng VCB Digibank (Mặc định demo: 123456)"
          >
            <Input size="large" maxLength={6} style={{ letterSpacing: 4, fontWeight: 'bold', fontSize: 18 }} />
          </Form.Item>

          <Form.Item style={{ marginBottom: 0, textAlign: 'right' }}>
            <Space>
              <Button onClick={() => setConfirmModalOpen(false)}>Hủy bỏ</Button>
              <Button
                type="primary"
                htmlType="submit"
                loading={submittingPayroll}
                style={{ background: '#005030', borderColor: '#005030', fontWeight: 700 }}
              >
                Xác nhận chi trả ngay
              </Button>
            </Space>
          </Form.Item>
        </Form>
      </Modal>

      {/* MODAL KẾT QUẢ CHI TRẢ */}
      <Modal
        title={
          <Space style={{ color: '#389e0d', fontSize: 16 }}>
            <CheckCircleOutlined /> Lệnh chi trả lương theo lô hoàn tất
          </Space>
        }
        open={resultModalOpen}
        onCancel={() => setResultModalOpen(false)}
        footer={[
          <Button key="ok" type="primary" style={{ background: '#005030', borderColor: '#005030' }} onClick={() => setResultModalOpen(false)}>
            Hoàn tất
          </Button>,
        ]}
      >
        <div style={{ textAlign: 'center', padding: '16px 0' }}>
          <CheckCircleOutlined style={{ fontSize: 56, color: '#52c41a', marginBottom: 16 }} />
          <Title level={4} style={{ color: '#005030', marginBottom: 8 }}>
            Đã chuyển khoản thành công {employees.length} món lương!
          </Title>
          <Text type="secondary" style={{ display: 'block', marginBottom: 16 }}>
            Mã lô giao dịch: <Text strong copyable>{payrollResult?.batchCode || 'VCB-PAY-2026'}</Text>
          </Text>

          <Card size="small" style={{ background: '#f6ffed', borderColor: '#b7eb8f', textAlign: 'left' }}>
            <Descriptions size="small" column={1}>
              <Descriptions.Item label="Tổng số tiền trích nợ">
                <Text strong style={{ color: '#d4380d', fontSize: 15 }}>
                  {Number(payrollResult?.totalAmount || totalAmount).toLocaleString('vi-VN')} VND
                </Text>
              </Descriptions.Item>
              <Descriptions.Item label="Số giao dịch thành công">
                <Tag color="success">{payrollResult?.successCount || employees.length} / {employees.length} giao dịch</Tag>
              </Descriptions.Item>
              <Descriptions.Item label="Thời gian thực hiện">
                {dayjs().format('DD/MM/YYYY HH:mm:ss')}
              </Descriptions.Item>
            </Descriptions>
          </Card>
        </div>
      </Modal>
    </div>
  );
}
