import { useEffect, useRef, useState, useImperativeHandle, forwardRef } from 'react';
import { Button, Tooltip } from 'antd';
import { ReloadOutlined } from '@ant-design/icons';

const CHARS = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';

const VisualCaptcha = forwardRef(function VisualCaptcha({ onCodeChange, width = 120, height = 40 }, ref) {
  const canvasRef = useRef(null);
  const [code, setCode] = useState('');

  const generateCode = () => {
    let result = '';
    for (let i = 0; i < 5; i++) {
      result += CHARS.charAt(Math.floor(Math.random() * CHARS.length));
    }
    return result;
  };

  const drawCaptcha = (text) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    // Clear background with soft gradient
    const gradient = ctx.createLinearGradient(0, 0, width, height);
    gradient.addColorStop(0, '#E8F5E9');
    gradient.addColorStop(1, '#C8E6C9');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, width, height);

    // Draw random interference lines
    for (let i = 0; i < 4; i++) {
      ctx.strokeStyle = `rgba(${Math.floor(Math.random() * 100)}, ${Math.floor(Math.random() * 100 + 80)}, ${Math.floor(Math.random() * 50)}, 0.4)`;
      ctx.lineWidth = 1.5;
      ctx.beginPath();
      ctx.moveTo(Math.random() * width, Math.random() * height);
      ctx.lineTo(Math.random() * width, Math.random() * height);
      ctx.stroke();
    }

    // Draw noise dots
    for (let i = 0; i < 30; i++) {
      ctx.fillStyle = `rgba(0, ${Math.floor(Math.random() * 100 + 50)}, 0, 0.3)`;
      ctx.beginPath();
      ctx.arc(Math.random() * width, Math.random() * height, 1, 0, 2 * Math.PI);
      ctx.fill();
    }

    // Draw characters with random rotation and colors
    const charWidth = width / (text.length + 1);
    ctx.font = 'bold 20px "Courier New", monospace';
    ctx.textBaseline = 'middle';

    const colors = ['#00482B', '#006837', '#1B5E20', '#2E7D32', '#005030'];

    for (let i = 0; i < text.length; i++) {
      const char = text[i];
      const x = (i + 0.6) * charWidth;
      const y = height / 2 + (Math.random() * 4 - 2);
      const angle = (Math.random() * 30 - 15) * (Math.PI / 180);

      ctx.save();
      ctx.translate(x, y);
      ctx.rotate(angle);
      ctx.fillStyle = colors[i % colors.length];
      ctx.shadowColor = 'rgba(0,0,0,0.15)';
      ctx.shadowBlur = 2;
      ctx.shadowOffsetX = 1;
      ctx.shadowOffsetY = 1;
      ctx.fillText(char, -7, 0);
      ctx.restore();
    }
  };

  const refresh = () => {
    const newCode = generateCode();
    setCode(newCode);
    if (onCodeChange) onCodeChange(newCode);
    setTimeout(() => drawCaptcha(newCode), 20);
  };

  useImperativeHandle(ref, () => ({
    getCode: () => code,
    refresh,
  }));

  useEffect(() => {
    refresh();
  }, []);

  return (
    <div style={{ display: 'inline-flex', alignItems: 'center', gap: 8 }}>
      <canvas
        ref={canvasRef}
        width={width}
        height={height}
        style={{
          borderRadius: 6,
          border: '1px solid #A5D6A7',
          cursor: 'pointer',
          boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.08)',
        }}
        onClick={refresh}
        title="Nhấp để đổi mã xác thực khác"
      />
      <Tooltip title="Làm mới mã xác thực">
        <Button
          type="text"
          size="small"
          icon={<ReloadOutlined style={{ color: '#00482B' }} />}
          onClick={refresh}
          style={{ width: 28, height: 28 }}
        />
      </Tooltip>
    </div>
  );
});

export default VisualCaptcha;
