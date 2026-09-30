# -*- coding: utf-8 -*-
import os
import csv
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import parse_xml
from docx.oxml.ns import nsdecls

VCB_GREEN = "00843D"
VCB_LIGHT_ROW = "F4F9F5"
BORDER_COLOR = "D0D7DE"

def set_cell_background(cell, fill_hex):
    tcPr = cell._element.get_or_add_tcPr()
    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{fill_hex}"/>')
    tcPr.append(shd)

def save_formatted_csv_and_excel(headers, data_rows, csv_path, xlsx_path, sheet_name="DataSheet", col_types=None):
    """
    col_types: list chuỗi quy định kiểu dữ liệu của từng cột:
      'text', 'number', 'currency', 'rate', 'date', 'center'
    """
    all_rows = [headers] + data_rows

    # 1. Ghi file CSV với chuẩn UTF-8 with BOM (utf-8-sig) cho Excel mở không lỗi font
    os.makedirs(os.path.dirname(csv_path), exist_ok=True)
    with open(csv_path, 'w', newline='', encoding='utf-8-sig') as f:
        writer = csv.writer(f)
        writer.writerows(all_rows)

    # 2. Ghi file Excel (.xlsx) với định dạng bảng biểu Vietcombank tuyệt đẹp
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = sheet_name

    header_font = Font(name="Calibri", size=11, bold=True, color="FFFFFF")
    header_fill = PatternFill(start_color=VCB_GREEN, end_color=VCB_GREEN, fill_type="solid")
    
    data_font = Font(name="Calibri", size=10.5)
    data_font_bold = Font(name="Calibri", size=10.5, bold=True)
    alt_fill = PatternFill(start_color=VCB_LIGHT_ROW, end_color=VCB_LIGHT_ROW, fill_type="solid")

    thin_border = Border(
        left=Side(style='thin', color=BORDER_COLOR),
        right=Side(style='thin', color=BORDER_COLOR),
        top=Side(style='thin', color=BORDER_COLOR),
        bottom=Side(style='thin', color=BORDER_COLOR)
    )

    num_cols = len(headers)
    if not col_types:
        col_types = ['text'] * num_cols

    # Ghi dữ liệu vào sheet
    for r_idx, row in enumerate(all_rows, 1):
        is_header = (r_idx == 1)
        is_alt = (r_idx % 2 == 1 and not is_header) # zebra striping

        for c_idx, val in enumerate(row, 1):
            cell = ws.cell(row=r_idx, column=c_idx)
            val_str = str(val).strip()
            ctype = col_types[c_idx - 1] if c_idx - 1 < len(col_types) else 'text'

            cell.border = thin_border

            if is_header:
                cell.value = val_str
                cell.font = header_font
                cell.fill = header_fill
                cell.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
            else:
                if is_alt:
                    cell.fill = alt_fill
                cell.font = data_font

                # Căn lề và format số
                if ctype == 'currency':
                    try:
                        clean_num = float(val_str.replace(',', '').replace(' ', ''))
                        cell.value = clean_num
                        cell.number_format = '#,##0'
                        cell.alignment = Alignment(horizontal="right", vertical="center")
                    except ValueError:
                        cell.value = val_str
                        cell.alignment = Alignment(horizontal="right", vertical="center")

                elif ctype == 'rate':
                    try:
                        clean_num = float(val_str.replace('%', '').strip())
                        cell.value = clean_num
                        cell.number_format = '0.00"%"'
                        cell.alignment = Alignment(horizontal="right", vertical="center")
                    except ValueError:
                        cell.value = val_str
                        cell.alignment = Alignment(horizontal="right", vertical="center")

                elif ctype == 'number':
                    try:
                        if '.' in val_str:
                            cell.value = float(val_str)
                            cell.number_format = '#,##0.00'
                        else:
                            cell.value = int(val_str)
                            cell.number_format = '#,##0'
                        cell.alignment = Alignment(horizontal="right", vertical="center")
                    except ValueError:
                        cell.value = val_str
                        cell.alignment = Alignment(horizontal="right", vertical="center")

                elif ctype == 'center' or ctype == 'date':
                    cell.value = val_str
                    cell.alignment = Alignment(horizontal="center", vertical="center")

                else: # text
                    cell.value = val_str
                    cell.alignment = Alignment(horizontal="left", vertical="center")

        ws.row_dimensions[r_idx].height = 32 if is_header else 24

    # Căn độ rộng cột tự động và mở rộng để không bao giờ bị che khuất thông tin
    for col_idx in range(1, num_cols + 1):
        col_letter = get_column_letter(col_idx)
        max_len = 0
        for r_idx in range(1, len(all_rows) + 1):
            c_val = str(ws.cell(row=r_idx, column=col_idx).value or '')
            # Đếm ký tự ước tính (tiếng Việt có dấu nhân 1.25)
            length = sum(1.25 if ord(ch) > 127 else 1.0 for ch in c_val)
            if length > max_len:
                max_len = length

        # Đặt độ rộng thoải mái: max_len + 8 ký tự, tối thiểu 20
        ctype = col_types[col_idx - 1] if col_idx - 1 < len(col_types) else 'text'
        min_width = 28 if ctype == 'text' else 20
        ws.column_dimensions[col_letter].width = max(int(max_len + 8), min_width)

    # Đóng băng hàng tiêu đề (Freeze Panes)
    ws.freeze_panes = "A2"

    os.makedirs(os.path.dirname(xlsx_path), exist_ok=True)
    wb.save(xlsx_path)

def create_formatted_word_doc(docx_path, title, form_code, subtitle, sections, table_headers=None, table_data=None, col_widths=None):
    doc = Document()
    for section in doc.sections:
        section.top_margin = Inches(0.8)
        section.bottom_margin = Inches(0.8)
        section.left_margin = Inches(0.8)
        section.right_margin = Inches(0.8)

    # Header bảng chuẩn ngân hàng
    tbl_h = doc.add_table(rows=1, cols=2)
    tbl_h.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_h.columns[0].width = Inches(3.3)
    tbl_h.columns[1].width = Inches(3.6)

    c_left = tbl_h.cell(0, 0)
    p_l = c_left.paragraphs[0]
    p_l.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_bank = p_l.add_run("NGÂN HÀNG TMCP NGOẠI THƯƠNG VIỆT NAM\nVIETCOMBANK")
    r_bank.bold = True
    r_bank.font.size = Pt(10.5)
    r_bank.font.color.rgb = RGBColor(0, 132, 61)

    c_right = tbl_h.cell(0, 1)
    p_r = c_right.paragraphs[0]
    p_r.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_qh = p_r.add_run("CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM\nĐộc lập - Tự do - Hạnh phúc\n---------------")
    r_qh.bold = True
    r_qh.font.size = Pt(10)

    p_sp = doc.add_paragraph()
    p_sp.paragraph_format.space_after = Pt(6)

    # Tiêu đề
    p_title = doc.add_paragraph()
    p_title.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_t = p_title.add_run(title.upper())
    r_t.bold = True
    r_t.font.size = Pt(14)
    r_t.font.color.rgb = RGBColor(0, 100, 45)

    if form_code:
        p_c = doc.add_paragraph()
        p_c.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r_c = p_c.add_run(f"Mã văn bản / Biểu mẫu: {form_code}")
        r_c.italic = True
        r_c.font.size = Pt(9.5)
        r_c.font.color.rgb = RGBColor(100, 100, 100)

    if subtitle:
        p_sub = doc.add_paragraph()
        p_sub.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r_sub = p_sub.add_run(subtitle)
        r_sub.font.size = Pt(10.5)
        r_sub.bold = True

    # Nội dung các section
    for sec_title, fields in sections:
        p_sec = doc.add_paragraph()
        p_sec.paragraph_format.space_before = Pt(8)
        p_sec.paragraph_format.space_after = Pt(3)
        r_sec = p_sec.add_run(sec_title)
        r_sec.bold = True
        r_sec.font.size = Pt(11)
        r_sec.font.color.rgb = RGBColor(0, 110, 50)

        for label, val in fields:
            p_f = doc.add_paragraph()
            p_f.paragraph_format.space_before = Pt(1)
            p_f.paragraph_format.space_after = Pt(2)
            r_lbl = p_f.add_run(f"• {label}: ")
            r_lbl.bold = True
            r_lbl.font.size = Pt(10)
            r_val = p_f.add_run(f"{val}")
            r_val.font.size = Pt(10)

    # Bảng chi tiết
    if table_headers and table_data:
        p_tt = doc.add_paragraph()
        p_tt.paragraph_format.space_before = Pt(10)
        p_tt.paragraph_format.space_after = Pt(4)
        r_tt = p_tt.add_run("BẢNG KÊ QUY ĐỊNH CHI TIẾT:")
        r_tt.bold = True
        r_tt.font.size = Pt(10.5)
        r_tt.font.color.rgb = RGBColor(0, 110, 50)

        all_t_rows = [table_headers] + table_data
        table = doc.add_table(rows=len(all_t_rows), cols=len(table_headers))
        table.alignment = WD_TABLE_ALIGNMENT.CENTER
        table.autofit = True

        for r_idx, row_values in enumerate(all_t_rows):
            for c_idx, val in enumerate(row_values):
                cell = table.cell(r_idx, c_idx)
                cell.text = str(val)
                p = cell.paragraphs[0]
                p.paragraph_format.space_before = Pt(3)
                p.paragraph_format.space_after = Pt(3)
                run = p.runs[0] if p.runs else p.add_run()
                run.font.size = Pt(9.5)
                if r_idx == 0:
                    run.bold = True
                    run.font.color.rgb = RGBColor(255, 255, 255)
                    set_cell_background(cell, VCB_GREEN)
                    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
                else:
                    if r_idx % 2 == 1:
                        set_cell_background(cell, VCB_LIGHT_ROW)
                    if c_idx == 0:
                        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
                    else:
                        p.alignment = WD_ALIGN_PARAGRAPH.LEFT

    # Ký tên
    p_sig = doc.add_paragraph()
    p_sig.paragraph_format.space_before = Pt(16)

    tbl_sig = doc.add_table(rows=1, cols=2)
    tbl_sig.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_sig.columns[0].width = Inches(3.4)
    tbl_sig.columns[1].width = Inches(3.5)

    c_s1 = tbl_sig.cell(0, 0)
    p_s1 = c_s1.paragraphs[0]
    p_s1.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_s1 = p_s1.add_run("ĐẠI DIỆN KHÁCH HÀNG\n(Ký, ghi rõ họ tên & đóng dấu)\n\n\n\n...................................................")
    r_s1.font.size = Pt(10)
    r_s1.bold = True

    c_s2 = tbl_sig.cell(0, 1)
    p_s2 = c_s2.paragraphs[0]
    p_s2.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_s2 = p_s2.add_run("ĐẠI DIỆN VIETCOMBANK\n(Giao dịch viên / Kiểm soát viên ký)\n\n\n\n...................................................")
    r_s2.font.size = Pt(10)
    r_s2.bold = True

    os.makedirs(os.path.dirname(docx_path), exist_ok=True)
    doc.save(docx_path)

def main():
    target_main_dir = r"c:\Users\Admin\Documents\Đồ_Án\BTL\Du_Lieu_Mau_He_Thong"
    public_samples_dir = r"c:\Users\Admin\Documents\Đồ_Án\BTL\frontend\public\samples"
    samples_dir = r"c:\Users\Admin\Documents\Đồ_Án\BTL\samples"

    dirs_to_write = [
        target_main_dir,
        public_samples_dir,
        samples_dir
    ]

    excel_cat_dir = os.path.join(target_main_dir, "1_File_Excel_XLSX")
    csv_cat_dir = os.path.join(target_main_dir, "2_File_CSV")
    word_cat_dir = os.path.join(target_main_dir, "3_File_Word_DOCX")
    bieu_phi_cat_dir = os.path.join(target_main_dir, "Theo_Phan_He", "Bieu_Phi_Bieu_Mau")

    os.makedirs(excel_cat_dir, exist_ok=True)
    os.makedirs(csv_cat_dir, exist_ok=True)
    os.makedirs(word_cat_dir, exist_ok=True)
    os.makedirs(bieu_phi_cat_dir, exist_ok=True)

    # =========================================================================
    # 1. BỘ 5 BIỂU PHÍ & BIỂU MẪU CHUẨN MÀN HÌNH HỆ THỐNG
    # =========================================================================
    fee_form_items = [
        {
            "base_name": "Bieu_phi_dich_vu_The_quoc_te_Vietcombank_Visa_MasterCard_JCB_2026",
            "title": "Biểu phí dịch vụ Thẻ quốc tế Vietcombank Visa / MasterCard / JCB 2026",
            "form_code": "VCB-CARD-INT-2026",
            "subtitle": "Quy định mức thu phí phát hành, phí thường niên và các phí giao dịch thẻ quốc tế",
            "headers": ["Hạng thẻ quốc tế Vietcombank", "Phí phát hành thẻ (VND)", "Phí thường niên (VND/năm)", "Phí chuyển đổi ngoại tệ", "Phí rút tiền ATM ngoài nước"],
            "col_types": ["text", "currency", "currency", "rate", "text"],
            "rows": [
                ["Vietcombank Visa Signature", "0", "3000000", "1.50%", "4.0% (Tối thiểu 50,000 VND)"],
                ["Vietcombank Visa Platinum", "0", "800000", "2.00%", "4.0% (Tối thiểu 50,000 VND)"],
                ["Vietcombank Mastercard World", "0", "800000", "2.00%", "4.0% (Tối thiểu 50,000 VND)"],
                ["Vietcombank JCB Platinum", "0", "800000", "2.00%", "4.0% (Tối thiểu 50,000 VND)"],
                ["Vietcombank Visa Hạng Vàng", "50000", "200000", "2.50%", "4.0% (Tối thiểu 50,000 VND)"],
                ["Vietcombank Visa Hạng Chuẩn", "50000", "100000", "2.50%", "4.0% (Tối thiểu 50,000 VND)"],
                ["Vietcombank Mastercard Chuẩn", "50000", "100000", "2.50%", "4.0% (Tối thiểu 50,000 VND)"],
                ["Vietcombank JCB Chuẩn", "50000", "100000", "2.50%", "4.0% (Tối thiểu 50,000 VND)"]
            ],
            "sections": [
                ("I. QUY ĐỊNH CHUNG VỀ THẺ QUỐC TẾ", [
                    ("Đối tượng áp dụng", "Khách hàng cá nhân và doanh nghiệp phát hành thẻ quốc tế tại Vietcombank"),
                    ("Thời hạn hiệu lực biểu phí", "Áp dụng từ ngày 01/01/2026 cho đến khi có thông báo thay thế mới"),
                    ("Quy định miễn/giảm phí", "Khách hàng VIP Vietcombank Priority được miễn 100% phí thường niên")
                ]),
                ("II. ĐẶC QUYỀN VÀ BẢO HIỂM DU LỊCH ĐI KÈM", [
                    ("Bảo hiểm du lịch toàn cầu", "Áp dụng cho chủ thẻ Visa Signature và Platinum hạn mức bồi thường tới 11.65 tỷ VND"),
                    ("Phòng chờ sân bay", "Miễn phí sử dụng phòng chờ Lotus Lounge tại các sân bay quốc tế Việt Nam"),
                    ("VCB Rewards", "Tích lũy điểm thưởng không giới hạn cho mọi giao dịch thanh toán POS/Online")
                ])
            ]
        },
        {
            "base_name": "Bieu_mau_de_nghi_vay_von_va_phuong_an_tra_no_kiem_cam_ket_tai_san",
            "title": "Biểu mẫu đề nghị vay vốn & phương án trả nợ kiêm cam kết tài sản",
            "form_code": "VCB-LOAN-PROP-2026",
            "subtitle": "Hồ sơ đăng ký vay tiêu dùng, vay mua bất động sản hoặc sản xuất kinh doanh",
            "headers": ["Kỳ thanh toán", "Dư nợ đầu kỳ (VND)", "Tiền gốc trả hàng tháng (VND)", "Tiền lãi tạm tính 6.8%/năm (VND)", "Tổng số tiền trả kỳ (VND)"],
            "col_types": ["center", "currency", "currency", "currency", "currency"],
            "rows": [
                ["Kỳ 1", "1500000000", "12500000", "8500000", "21000000"],
                ["Kỳ 2", "1487500000", "12500000", "8429167", "20929167"],
                ["Kỳ 3", "1475000000", "12500000", "8358333", "20858333"],
                ["Kỳ 4", "1462500000", "12500000", "8287500", "20787500"],
                ["Kỳ 5", "1450000000", "12500000", "8216667", "20716667"],
                ["Kỳ 6", "1437500000", "12500000", "8145833", "20645833"],
                ["Kỳ 12", "1362500000", "12500000", "7720833", "20220833"],
                ["Kỳ 120", "12500000", "12500000", "70833", "12570833"]
            ],
            "sections": [
                ("I. THÔNG TIN KHÁCH HÀNG VÀ TÀI LIỆU PHÁP LÝ", [
                    ("Họ và tên khách hàng đề nghị vay", "NGUYỄN VĂN AN (Số CCCD: 001090012345)"),
                    ("Số điện thoại / Email", "0912345678 - an.nguyen@gmail.com"),
                    ("Địa chỉ thường trú / Nơi ở hiện tại", "Số 123 Phố Huế, Phường Hàng Bài, Quận Hoàn Kiếm, Hà Nội"),
                    ("Mục đích vay vốn", "Vay mua nhà ở dự án / căn hộ chung cư cao tầng")
                ]),
                ("II. THÔNG TIN KHOẢN VAY VÀ PHƯƠNG ÁN TRẢ NỢ", [
                    ("Số tiền đề nghị vay", "1,500,000,000 VND (Một tỷ năm trăm triệu đồng chẵn)"),
                    ("Thời hạn vay vốn", "120 tháng (10 năm)"),
                    ("Nguồn thu nhập trả nợ", "45,000,000 VND/tháng từ lương cố định sao kê Vietcombank"),
                    ("Tài sản bảo đảm thế chấp", "Căn hộ số 1204 Dự án Vinhomes Ocean Park (Giá trị thẩm định: 2.6 tỷ VND)")
                ])
            ]
        },
        {
            "base_name": "Bang_tong_hop_phi_chuyen_tien_quoc_te_qua_he_thong_SWIFT_va_Western_Union",
            "title": "Bảng tổng hợp phí chuyển tiền quốc tế qua hệ thống SWIFT & Western Union",
            "form_code": "VCB-REMIT-SWIFT-WU-2026",
            "subtitle": "Áp dụng cho dịch vụ chuyển tiền đi và nhận tiền từ nước ngoài qua SWIFT và Western Union",
            "headers": ["Kênh chuyển tiền quốc tế", "Mức phí tiêu chuẩn", "Mức thu tối thiểu", "Mức thu tối đa", "Ghi chú phí ngân hàng đại lý"],
            "col_types": ["text", "text", "text", "text", "text"],
            "rows": [
                ["SWIFT - Chuyển tiền đi quốc tế (Phí SHA)", "0.20% số tiền chuyển", "5.00 USD", "200.00 USD", "Bên nhận chịu phí ngân hàng trung gian"],
                ["SWIFT - Chuyển tiền đi quốc tế (Phí OUR)", "0.20% + 25 USD cước cố định", "30.00 USD", "250.00 USD", "Người gửi thanh toán toàn bộ chi phí"],
                ["SWIFT - Nhận tiền từ nước ngoài vào TK", "0.05% số tiền ghi có", "2.00 USD", "50.00 USD", "Miễn phí nếu nhận bằng VND"],
                ["Western Union - Nhận tiền quốc tế", "Miễn phí 100%", "0 USD", "0 USD", "Nhận tại quầy hoặc nhận qua VCB Digibank"],
                ["Western Union - Gửi tiền đi du học / trợ cấp", "Theo bậc tiền (0.3% - 0.5%)", "10.00 USD", "Theo biểu WU", "Nhanh chóng nhận ngay trong vài phút"]
            ],
            "sections": [
                ("I. QUY ĐỊNH HỒ SƠ CHUYỂN TIỀN QUỐC TẾ HỢP PHÁP", [
                    ("Mục đích du học / Khám chữa bệnh", "Hộ chiếu, Visa, Thông báo học phí/viện phí hợp lệ"),
                    ("Mục đích trợ cấp thân nhân / Định cư", "Giấy tờ chứng minh quan hệ nhân thân và quyết định định cư"),
                    ("Hạn mức chuyển ngoại tệ hàng năm", "Theo quy định hướng dẫn của Ngân hàng Nhà nước Việt Nam")
                ]),
                ("II. THỜI GIAN VÀ TIẾN ĐỘ XỬ LÝ LỆNH", [
                    ("Điện chuyển tiền SWIFT GPI", "Theo dõi trạng thái lệnh chuyển tiền xuyên biên giới theo thời gian thực"),
                    ("Thời gian nhận tiền", "Từ 1 đến 2 ngày làm việc (với SWIFT) hoặc tức thì (với Western Union)")
                ])
            ]
        },
        {
            "base_name": "Bang_bieu_phi_dich_vu_the_va_tai_khoan_2026",
            "title": "Bảng biểu phí dịch vụ thẻ & tài khoản 2026",
            "form_code": "VCB-ACC-CARD-FEE-2026",
            "subtitle": "Áp dụng đối với Khách hàng Cá nhân sử dụng tài khoản thanh toán và thẻ nội địa Vietcombank",
            "headers": ["Dịch vụ tài khoản & thẻ thanh toán", "Mức phí tiêu chuẩn (VND)", "Ưu đãi trên VCB Digibank", "Khách hàng Priority VIP", "Ghi chú quy định"],
            "col_types": ["text", "currency", "text", "text", "text"],
            "rows": [
                ["Mở tài khoản thanh toán VND", "0", "Miễn phí", "Miễn phí", "Mở tại quầy giao dịch hoặc eKYC trực tuyến"],
                ["Duy trì số dư tài khoản tối thiểu", "0", "0 VND", "0 VND", "Không yêu cầu duy trì số dư"],
                ["Phát hành thẻ ghi nợ Vietcombank Connect24", "50000", "Miễn phí khi mở online", "Miễn phí", "Thẻ chip không tiếp xúc Contactless"],
                ["Rút tiền tại cây ATM cùng hệ thống VCB", "1100", "1,100 VND / GD", "Miễn phí", "Đã bao gồm thuế GTGT (VAT)"],
                ["Rút tiền tại cây ATM ngoài hệ thống (Napas)", "3300", "3,300 VND / GD", "Miễn phí", "Đã bao gồm thuế GTGT (VAT)"],
                ["Chuyển tiền trong và ngoài hệ thống VCB", "0", "Miễn phí trọn đời", "Miễn phí", "Áp dụng cho mọi giao dịch trên Digibank"],
                ["Quản lý tài khoản không hoạt động (>12 tháng)", "30000", "30,000 VND / tháng", "Miễn phí", "Chỉ thu khi tài khoản còn số dư dương"]
            ],
            "sections": [
                ("I. QUYỀN LỢI TÀI KHOẢN THANH TOÁN VIETCOMBANK", [
                    ("Hạn mức giao dịch chuyển tiền trực tuyến", "Lên đến 3 tỷ VND / ngày đối với khách hàng thông thường"),
                    ("Tài khoản số đẹp / Theo ngày sinh / SĐT", "Miễn phí chọn số tài khoản trùng số điện thoại trên VCB Digibank"),
                    ("Liên kết ví điện tử & Cổng thanh toán", "Miễn phí kết nối ShopeePay, MoMo, ZaloPay, Apple Pay, Google Pay")
                ]),
                ("II. AN TOÀN VÀ BẢO MẬT TÀI KHOẢN", [
                    ("Phương thức xác thực sinh trắc học", "Bắt buộc xác thực khuôn mặt khớp với chip CCCD cho các giao dịch trên 10 triệu VND"),
                    ("Tổng đài khóa thẻ / tài khoản khẩn cấp", "Hotline 1900 54 54 13 hoặc thao tác tự động 24/7 trên VCB Digibank")
                ])
            ]
        },
        {
            "base_name": "Bieu_mau_dang_ky_dich_vu_ngan_hang_so_VCB_Digibank_va_Smart_OTP_2026",
            "title": "Biểu mẫu đăng ký dịch vụ ngân hàng số VCB Digibank & Smart OTP 2026",
            "form_code": "VCB-EBANK-DIGI-2026",
            "subtitle": "Đăng ký mới, cấp đổi mã PIN, nâng hạn mức giao dịch và kích hoạt Smart OTP xác thực cao cấp",
            "headers": ["Gói dịch vụ Ngân hàng số", "Hạn mức tối đa / giao dịch (VND)", "Hạn mức tối đa / ngày (VND)", "Phương thức xác thực an toàn", "Phí duy trì dịch vụ"],
            "col_types": ["text", "currency", "currency", "text", "text"],
            "rows": [
                ["Gói Cơ bản (Khởi đầu)", "100000000", "500000000", "SMS OTP", "Miễn phí trọn đời"],
                ["Gói Nâng cao (Tiêu chuẩn)", "1000000000", "3000000000", "VCB Smart OTP tích hợp App", "Miễn phí trọn đời"],
                ["Gói Priority VIP", "3000000000", "10000000000", "VCB Smart OTP + Sinh trắc học", "Miễn phí trọn đời"],
                ["Gói Doanh nghiệp & Chủ hộ KD", "5000000000", "20000000000", "Hard Token OTP / Chữ ký số CA", "Miễn phí trọn đời"]
            ],
            "sections": [
                ("I. THÔNG TIN KHÁCH HÀNG ĐĂNG KÝ", [
                    ("Họ và tên khách hàng", "LÊ HOÀNG MINH"),
                    ("Số CCCD gắn chip", "001201009876 (Ngày cấp: 15/09/2022)"),
                    ("Số điện thoại đăng ký Digibank", "0934567890"),
                    ("Địa chỉ hòm thư điện tử (Email)", "minh.lehoang@gmail.com")
                ]),
                ("II. DỊCH VỤ VÀ TÍNH NĂNG ĐĂNG KÝ MỚI", [
                    ("Loại yêu cầu", "[X] Đăng ký mới   [ ] Thay đổi thông tin SĐT   [ ] Mở khóa tài khoản"),
                    ("Gói hạn mức giao dịch đăng ký", "Gói Nâng cao (Hạn mức 3 tỷ VND / ngày)"),
                    ("Phương thức xác thực Smart OTP", "Kích hoạt Smart OTP trên thiết bị di động chính chủ"),
                    ("Dịch vụ nhận thông báo OTT", "Nhận thông báo biến động số dư miễn phí tức thì trên VCB Digibank")
                ]),
                ("III. CAM KẾT VÀ BẢO MẬT CỦA KHÁCH HÀNG", [
                    ("Bảo mật mật khẩu và mã OTP", "Tuyệt đối không cung cấp mật khẩu, mã OTP, mã PIN cho bất kỳ ai kể cả nhân viên ngân hàng"),
                    ("Cập nhật thông tin sinh trắc học", "Khách hàng đã hoàn thành quét chip CCCD thành công trên ứng dụng VCB Digibank")
                ])
            ]
        }
    ]

    for item in fee_form_items:
        base = item["base_name"]
        headers = item["headers"]
        rows = item["rows"]
        ctypes = item["col_types"]
        title = item["title"]
        code = item["form_code"]
        sub = item["subtitle"]
        secs = item["sections"]

        csv_file = f"{base}.csv"
        xlsx_file = f"{base}.xlsx"
        docx_file = f"{base}.docx"

        # Ghi vào thư mục gom theo định dạng
        save_formatted_csv_and_excel(headers, rows, os.path.join(csv_cat_dir, csv_file), os.path.join(excel_cat_dir, xlsx_file), sheet_name="DataSheet", col_types=ctypes)
        create_formatted_word_doc(os.path.join(word_cat_dir, docx_file), title, code, sub, secs, headers, rows)

        # Ghi vào thư mục theo phân hệ
        save_formatted_csv_and_excel(headers, rows, os.path.join(bieu_phi_cat_dir, csv_file), os.path.join(bieu_phi_cat_dir, xlsx_file), sheet_name="DataSheet", col_types=ctypes)
        create_formatted_word_doc(os.path.join(bieu_phi_cat_dir, docx_file), title, code, sub, secs, headers, rows)

        # Ghi vào thư mục tổng hợp và public
        for d in dirs_to_write:
            save_formatted_csv_and_excel(headers, rows, os.path.join(d, csv_file), os.path.join(d, xlsx_file), sheet_name="DataSheet", col_types=ctypes)
            create_formatted_word_doc(os.path.join(d, docx_file), title, code, sub, secs, headers, rows)

        print(f"-> Formatted: {base}")

    # =========================================================================
    # 2. BỘ TỶ GIÁ NGOẠI TỆ (CĂN CỘT VÀ TIÊU ĐỀ RÕ RÀNG)
    # =========================================================================
    exchange_headers = ["Mã ngoại tệ", "Giá mua tiền mặt (VND)", "Giá bán ra (VND)", "Giá chuyển khoản (VND)", "Ngày hiệu lực"]
    exchange_col_types = ["center", "currency", "currency", "currency", "date"]
    
    exchange_dates = ["26", "27", "28", "29", "30"]
    for day in exchange_dates:
        fname = f"ty_gia_ngoai_te_ngay_{day}_09_2026"
        dt = f"2026-09-{day}"
        add_val = int(day) - 26
        ex_rows = [
            ["USD", str(25120 + add_val * 10), str(25450 + add_val * 10), str(25170 + add_val * 10), dt],
            ["EUR", str(26800 + add_val * 20), str(28280 + add_val * 20), str(27080 + add_val * 20), dt],
            ["GBP", str(32100 + add_val * 20), str(33480 + add_val * 20), str(32420 + add_val * 20), dt],
            ["JPY", "162.50", "172.10", "164.20", dt],
            ["SGD", "18920", "19720", "19110", dt],
            ["AUD", "16450", "17150", "16620", dt],
            ["CAD", "18120", "18890", "18300", dt],
            ["CHF", "28750", "29970", "29040", dt],
            ["CNY", "3480", "3630", "3515", dt],
            ["KRW", "18.15", "20.18", "19.25", dt],
            ["THB", "715.0", "748.0", "729.0", dt]
        ]
        target_ex_dir = os.path.join(target_main_dir, "Theo_Phan_He", "Ty_Gia_Ngoai_Te")
        os.makedirs(target_ex_dir, exist_ok=True)
        save_formatted_csv_and_excel(exchange_headers, ex_rows, os.path.join(csv_cat_dir, f"{fname}.csv"), os.path.join(excel_cat_dir, f"{fname}.xlsx"), sheet_name="TyGiaNgoaiTe", col_types=exchange_col_types)
        save_formatted_csv_and_excel(exchange_headers, ex_rows, os.path.join(target_ex_dir, f"{fname}.csv"), os.path.join(target_ex_dir, f"{fname}.xlsx"), sheet_name="TyGiaNgoaiTe", col_types=exchange_col_types)
        for d in dirs_to_write:
            save_formatted_csv_and_excel(exchange_headers, ex_rows, os.path.join(d, f"{fname}.csv"), os.path.join(d, f"{fname}.xlsx"), sheet_name="TyGiaNgoaiTe", col_types=exchange_col_types)
        print(f"-> Formatted: {fname}")

    # =========================================================================
    # 3. BỘ GIÁ VÀNG (CĂN CỘT VÀ TIÊU ĐỀ RÕ RÀNG)
    # =========================================================================
    gold_headers = ["Loại vàng thị trường", "Giá mua vào (VND/lượng)", "Giá bán ra (VND/lượng)", "Ngày hiệu lực"]
    gold_col_types = ["text", "currency", "currency", "date"]
    for day in exchange_dates:
        fname = f"gia_vang_ngay_{day}_09_2026"
        dt = f"2026-09-{day}"
        add_v = (int(day) - 26) * 100000
        g_rows = [
            ["SJC 1L - 10L", str(87100000 + add_v), str(89100000 + add_v), dt],
            ["SJC 5c - 1c - 5 phân", str(87100000 + add_v), str(89130000 + add_v), dt],
            ["Vàng nhẫn SJC 99.99 1 chỉ - 5 chỉ", str(86400000 + add_v), str(87800000 + add_v), dt],
            ["Vàng Nữ Trang 99.99% (24K)", str(86200000 + add_v), str(87400000 + add_v), dt],
            ["Vàng Nữ Trang 75% (18K)", str(63900000 + add_v), str(65900000 + add_v), dt],
            ["Vàng Nữ Trang 58.3% (14K)", str(49200000 + add_v), str(51200000 + add_v), dt],
            ["Vàng Nữ Trang 41.7% (10K)", str(34500000 + add_v), str(36500000 + add_v), dt]
        ]
        target_g_dir = os.path.join(target_main_dir, "Theo_Phan_He", "Gia_Vang")
        os.makedirs(target_g_dir, exist_ok=True)
        save_formatted_csv_and_excel(gold_headers, g_rows, os.path.join(csv_cat_dir, f"{fname}.csv"), os.path.join(excel_cat_dir, f"{fname}.xlsx"), sheet_name="GiaVang", col_types=gold_col_types)
        save_formatted_csv_and_excel(gold_headers, g_rows, os.path.join(target_g_dir, f"{fname}.csv"), os.path.join(target_g_dir, f"{fname}.xlsx"), sheet_name="GiaVang", col_types=gold_col_types)
        for d in dirs_to_write:
            save_formatted_csv_and_excel(gold_headers, g_rows, os.path.join(d, f"{fname}.csv"), os.path.join(d, f"{fname}.xlsx"), sheet_name="GiaVang", col_types=gold_col_types)
        print(f"-> Formatted: {fname}")

    # =========================================================================
    # 4. BỘ LÃI SUẤT (CĂN CỘT VÀ TIÊU ĐỀ RÕ RÀNG)
    # =========================================================================
    interest_headers = ["Mã sản phẩm / Gói lãi suất", "Kỳ hạn áp dụng (tháng)", "Mức lãi suất (%/năm)", "Ngày hiệu lực"]
    interest_col_types = ["text", "center", "rate", "date"]

    interest_data = [
        ("lai_suat_tiet_kiem_ca_nhan_tai_quay", [
            ["SAVING_COUNTER_1M", "1", "2.00", "2026-09-30"],
            ["SAVING_COUNTER_3M", "3", "2.30", "2026-09-30"],
            ["SAVING_COUNTER_6M", "6", "3.30", "2026-09-30"],
            ["SAVING_COUNTER_9M", "9", "3.30", "2026-09-30"],
            ["SAVING_COUNTER_12M", "12", "4.80", "2026-09-30"],
            ["SAVING_COUNTER_24M", "24", "5.20", "2026-09-30"],
            ["SAVING_COUNTER_36M", "36", "5.20", "2026-09-30"],
            ["SAVING_COUNTER_60M", "60", "5.20", "2026-09-30"]
        ]),
        ("lai_suat_tiet_kiem_online_vcb_digibank", [
            ["SAVING_ONLINE_1M", "1", "2.20", "2026-09-30"],
            ["SAVING_ONLINE_3M", "3", "2.50", "2026-09-30"],
            ["SAVING_ONLINE_6M", "6", "3.50", "2026-09-30"],
            ["SAVING_ONLINE_9M", "9", "3.50", "2026-09-30"],
            ["SAVING_ONLINE_12M", "12", "5.00", "2026-09-30"],
            ["SAVING_ONLINE_24M", "24", "5.40", "2026-09-30"],
            ["SAVING_ONLINE_36M", "36", "5.40", "2026-09-30"]
        ]),
        ("lai_suat_tien_gui_doanh_nghiep", [
            ["CORP_DEPOSIT_1M", "1", "1.90", "2026-09-30"],
            ["CORP_DEPOSIT_3M", "3", "2.20", "2026-09-30"],
            ["CORP_DEPOSIT_6M", "6", "3.10", "2026-09-30"],
            ["CORP_DEPOSIT_9M", "9", "3.10", "2026-09-30"],
            ["CORP_DEPOSIT_12M", "12", "4.60", "2026-09-30"],
            ["CORP_DEPOSIT_24M", "24", "4.90", "2026-09-30"],
            ["CORP_DEPOSIT_36M", "36", "4.90", "2026-09-30"]
        ]),
        ("lai_suat_cho_vay_khach_hang_ca_nhan", [
            ["LOAN_MORTGAGE_HOME", "120", "6.50", "2026-09-30"],
            ["LOAN_AUTO_PURCHASE", "60", "6.90", "2026-09-30"],
            ["LOAN_CONSUMER_UNSECURED", "36", "8.20", "2026-09-30"],
            ["LOAN_STUDY_ABROAD", "48", "7.00", "2026-09-30"],
            ["LOAN_HOUSE_RENOVATION", "84", "6.80", "2026-09-30"]
        ]),
        ("lai_suat_cho_vay_doanh_nghiep_sme", [
            ["LOAN_SME_WORKING_CAPITAL", "12", "5.80", "2026-09-30"],
            ["LOAN_SME_MEDIUM_TERM", "36", "6.40", "2026-09-30"],
            ["LOAN_IMPORT_EXPORT", "6", "5.20", "2026-09-30"],
            ["LOAN_GREEN_PROJECT", "60", "6.00", "2026-09-30"],
            ["LOAN_SUPPLY_CHAIN", "12", "5.60", "2026-09-30"]
        ])
    ]

    for fname, i_rows in interest_data:
        target_i_dir = os.path.join(target_main_dir, "Theo_Phan_He", "Lai_Suat")
        os.makedirs(target_i_dir, exist_ok=True)
        save_formatted_csv_and_excel(interest_headers, i_rows, os.path.join(csv_cat_dir, f"{fname}.csv"), os.path.join(excel_cat_dir, f"{fname}.xlsx"), sheet_name="LaiSuat", col_types=interest_col_types)
        save_formatted_csv_and_excel(interest_headers, i_rows, os.path.join(target_i_dir, f"{fname}.csv"), os.path.join(target_i_dir, f"{fname}.xlsx"), sheet_name="LaiSuat", col_types=interest_col_types)
        for d in dirs_to_write:
            save_formatted_csv_and_excel(interest_headers, i_rows, os.path.join(d, f"{fname}.csv"), os.path.join(d, f"{fname}.xlsx"), sheet_name="LaiSuat", col_types=interest_col_types)
        print(f"-> Formatted: {fname}")

    print("\nALL_FILES_REFORMATTED_AND_EXPANDED_SUCCESSFULLY")

if __name__ == "__main__":
    main()
