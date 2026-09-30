# -*- coding: utf-8 -*-
import os
import csv
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn

VCB_GREEN_HEX = "00843D"
VCB_LIGHT_GREEN_HEX = "E8F5E9"
BORDER_COLOR = "D0D7DE"

def set_cell_background(cell, fill_hex):
    tcPr = cell._element.get_or_add_tcPr()
    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{fill_hex}"/>')
    tcPr.append(shd)

def save_csv_and_excel(rows, csv_path, xlsx_path, sheet_name="Data"):
    # 1. Ghi CSV
    os.makedirs(os.path.dirname(csv_path), exist_ok=True)
    with open(csv_path, 'w', newline='', encoding='utf-8-sig') as f:
        writer = csv.writer(f)
        writer.writerows(rows)

    # 2. Ghi Excel với style Vietcombank
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = sheet_name

    header_font = Font(name="Calibri", size=11, bold=True, color="FFFFFF")
    header_fill = PatternFill(start_color=VCB_GREEN_HEX, end_color=VCB_GREEN_HEX, fill_type="solid")
    data_font = Font(name="Calibri", size=10)
    thin_border = Border(
        left=Side(style='thin', color=BORDER_COLOR),
        right=Side(style='thin', color=BORDER_COLOR),
        top=Side(style='thin', color=BORDER_COLOR),
        bottom=Side(style='thin', color=BORDER_COLOR)
    )

    for row_idx, row in enumerate(rows, 1):
        for col_idx, val in enumerate(row, 1):
            cell = ws.cell(row=row_idx, column=col_idx)
            val_clean = str(val).strip()
            # Thử parse số
            try:
                if '.' in val_clean:
                    cell.value = float(val_clean)
                else:
                    cell.value = int(val_clean)
            except ValueError:
                cell.value = val_clean

            cell.border = thin_border
            if row_idx == 1:
                cell.font = header_font
                cell.fill = header_fill
                cell.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
            else:
                cell.font = data_font
                if isinstance(cell.value, (int, float)):
                    cell.alignment = Alignment(horizontal="right", vertical="center")
                else:
                    cell.alignment = Alignment(horizontal="left", vertical="center")

    for col in ws.columns:
        max_len = 0
        col_letter = get_column_letter(col[0].column)
        for cell in col:
            v = str(cell.value or '')
            if len(v) > max_len:
                max_len = len(v)
        ws.column_dimensions[col_letter].width = max(max_len + 4, 12)

    ws.row_dimensions[1].height = 26
    os.makedirs(os.path.dirname(xlsx_path), exist_ok=True)
    wb.save(xlsx_path)
    print(f"Generated: {os.path.basename(xlsx_path)}")

def create_word_document(docx_path, title, form_code, subtitle, sections, table_data=None):
    doc = Document()
    
    # Thiết lập lề 2 cm chuẩn hành chính
    for section in doc.sections:
        section.top_margin = Inches(0.8)
        section.bottom_margin = Inches(0.8)
        section.left_margin = Inches(0.9)
        section.right_margin = Inches(0.9)

    # Header chuẩn biểu mẫu ngân hàng
    table_head = doc.add_table(rows=1, cols=2)
    table_head.alignment = WD_TABLE_ALIGNMENT.CENTER
    table_head.autofit = False
    table_head.columns[0].width = Inches(3.2)
    table_head.columns[1].width = Inches(3.5)

    cell_left = table_head.cell(0, 0)
    p_left = cell_left.paragraphs[0]
    p_left.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run_bank = p_left.add_run("NGÂN HÀNG TMCP NGOẠI THƯƠNG VIỆT NAM\nVIETCOMBANK")
    run_bank.bold = True
    run_bank.font.size = Pt(10)
    run_bank.font.color.rgb = RGBColor(0, 132, 61) # VCB Green

    cell_right = table_head.cell(0, 1)
    p_right = cell_right.paragraphs[0]
    p_right.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run_qh = p_right.add_run("CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM\nĐộc lập - Tự do - Hạnh phúc\n---------------")
    run_qh.bold = True
    run_qh.font.size = Pt(10)

    p_space = doc.add_paragraph()
    p_space.paragraph_format.space_after = Pt(4)

    # Tiêu đề biểu mẫu
    p_title = doc.add_paragraph()
    p_title.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run_t = p_title.add_run(title.upper())
    run_t.bold = True
    run_t.font.size = Pt(15)
    run_t.font.color.rgb = RGBColor(0, 100, 45)

    if form_code:
        p_code = doc.add_paragraph()
        p_code.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run_c = p_code.add_run(f"Mã biểu mẫu: {form_code}")
        run_c.italic = True
        run_c.font.size = Pt(9.5)
        run_c.font.color.rgb = RGBColor(100, 100, 100)

    if subtitle:
        p_sub = doc.add_paragraph()
        p_sub.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run_s = p_sub.add_run(subtitle)
        run_s.font.size = Pt(11)
        run_s.bold = True

    # Các phần mục (Sections)
    for sec_title, fields in sections:
        p_sec = doc.add_paragraph()
        p_sec.paragraph_format.space_before = Pt(8)
        p_sec.paragraph_format.space_after = Pt(3)
        run_st = p_sec.add_run(sec_title)
        run_st.bold = True
        run_st.font.size = Pt(11)
        run_st.font.color.rgb = RGBColor(0, 110, 50)

        for label, default_val in fields:
            p_field = doc.add_paragraph()
            p_field.paragraph_format.space_before = Pt(1)
            p_field.paragraph_format.space_after = Pt(2)
            run_lbl = p_field.add_run(f"• {label}: ")
            run_lbl.bold = True
            run_lbl.font.size = Pt(10.5)
            run_val = p_field.add_run(f"{default_val}")
            run_val.font.size = Pt(10.5)

    # Bảng số liệu chi tiết nếu có
    if table_data:
        p_tbl_title = doc.add_paragraph()
        p_tbl_title.paragraph_format.space_before = Pt(8)
        run_tt = p_tbl_title.add_run("BẢNG KÊ CHI TIẾT ĐÍNH KÈM:")
        run_tt.bold = True
        run_tt.font.size = Pt(10.5)

        table = doc.add_table(rows=len(table_data), cols=len(table_data[0]))
        table.alignment = WD_TABLE_ALIGNMENT.CENTER
        table.autofit = True

        for r_idx, row_values in enumerate(table_data):
            for c_idx, val in enumerate(row_values):
                cell = table.cell(r_idx, c_idx)
                cell.text = str(val)
                p = cell.paragraphs[0]
                p.paragraph_format.space_before = Pt(2)
                p.paragraph_format.space_after = Pt(2)
                run = p.runs[0] if p.runs else p.add_run()
                run.font.size = Pt(9.5)
                if r_idx == 0:
                    run.bold = True
                    set_cell_background(cell, VCB_LIGHT_GREEN_HEX)
                    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
                else:
                    if c_idx == 0:
                        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
                    else:
                        p.alignment = WD_ALIGN_PARAGRAPH.LEFT

    # Phần chữ ký
    p_sig_space = doc.add_paragraph()
    p_sig_space.paragraph_format.space_before = Pt(12)

    table_sig = doc.add_table(rows=1, cols=2)
    table_sig.alignment = WD_TABLE_ALIGNMENT.CENTER
    table_sig.columns[0].width = Inches(3.3)
    table_sig.columns[1].width = Inches(3.4)

    c_sig_l = table_sig.cell(0, 0)
    p_sl = c_sig_l.paragraphs[0]
    p_sl.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_sl = p_sl.add_run("ĐẠI DIỆN KHÁCH HÀNG\n(Ký, ghi rõ họ tên & đóng dấu nếu có)\n\n\n\n...................................................")
    r_sl.font.size = Pt(10)
    r_sl.bold = True

    c_sig_r = table_sig.cell(0, 1)
    p_sr = c_sig_r.paragraphs[0]
    p_sr.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_sr = p_sr.add_run("ĐẠI DIỆN VIETCOMBANK\n(Giao dịch viên / Kiểm soát viên ký duyệt)\n\n\n\n...................................................")
    r_sr.font.size = Pt(10)
    r_sr.bold = True

    os.makedirs(os.path.dirname(docx_path), exist_ok=True)
    doc.save(docx_path)
    print(f"Generated DOCX: {os.path.basename(docx_path)}")

def main():
    dest_dirs = [
        "samples",
        "frontend/public/samples"
    ]

    # =========================================================================
    # 1. 5 FILE TỶ GIÁ NGOẠI TỆ (EXCHANGE RATES)
    # Schema: currencyCode,buyRate,sellRate,transferRate,effectiveDate
    # =========================================================================
    exchange_files = [
        ("ty_gia_ngoai_te_ngay_26_09_2026", [
            ["currencyCode", "buyRate", "sellRate", "transferRate", "effectiveDate"],
            ["USD", "25120.0000", "25450.0000", "25170.0000", "2026-09-26"],
            ["EUR", "26800.0000", "28280.0000", "27080.0000", "2026-09-26"],
            ["GBP", "32100.0000", "33480.0000", "32420.0000", "2026-09-26"],
            ["JPY", "162.1000", "171.8000", "163.9000", "2026-09-26"],
            ["SGD", "18880.0000", "19680.0000", "19070.0000", "2026-09-26"],
            ["AUD", "16410.0000", "17110.0000", "16580.0000", "2026-09-26"],
            ["CAD", "18090.0000", "18850.0000", "18260.0000", "2026-09-26"],
            ["CHF", "28710.0000", "29920.0000", "29000.0000", "2026-09-26"],
            ["CNY", "3470.0000", "3620.0000", "3505.0000", "2026-09-26"],
            ["KRW", "18.1000", "20.1200", "19.2000", "2026-09-26"],
            ["THB", "712.0000", "745.0000", "726.0000", "2026-09-26"]
        ]),
        ("ty_gia_ngoai_te_ngay_27_09_2026", [
            ["currencyCode", "buyRate", "sellRate", "transferRate", "effectiveDate"],
            ["USD", "25135.0000", "25465.0000", "25185.0000", "2026-09-27"],
            ["EUR", "26820.0000", "28300.0000", "27100.0000", "2026-09-27"],
            ["GBP", "32120.0000", "33500.0000", "32440.0000", "2026-09-27"],
            ["JPY", "162.3000", "172.0000", "164.0500", "2026-09-27"],
            ["SGD", "18900.0000", "19700.0000", "19090.0000", "2026-09-27"],
            ["AUD", "16430.0000", "17130.0000", "16600.0000", "2026-09-27"],
            ["CAD", "18105.0000", "18870.0000", "18285.0000", "2026-09-27"],
            ["CHF", "28730.0000", "29950.0000", "29020.0000", "2026-09-27"],
            ["CNY", "3475.0000", "3625.0000", "3510.0000", "2026-09-27"],
            ["KRW", "18.1200", "20.1500", "19.2200", "2026-09-27"],
            ["THB", "714.0000", "747.0000", "728.0000", "2026-09-27"]
        ]),
        ("ty_gia_ngoai_te_ngay_28_09_2026", [
            ["currencyCode", "buyRate", "sellRate", "transferRate", "effectiveDate"],
            ["USD", "25140.0000", "25470.0000", "25190.0000", "2026-09-28"],
            ["EUR", "26830.0000", "28310.0000", "27110.0000", "2026-09-28"],
            ["GBP", "32130.0000", "33510.0000", "32450.0000", "2026-09-28"],
            ["JPY", "162.4000", "172.0500", "164.1500", "2026-09-28"],
            ["SGD", "18910.0000", "19710.0000", "19100.0000", "2026-09-28"],
            ["AUD", "16440.0000", "17140.0000", "16610.0000", "2026-09-28"],
            ["CAD", "18115.0000", "18880.0000", "18295.0000", "2026-09-28"],
            ["CHF", "28740.0000", "29960.0000", "29030.0000", "2026-09-28"],
            ["CNY", "3478.0000", "3628.0000", "3512.0000", "2026-09-28"],
            ["KRW", "18.1400", "20.1700", "19.2400", "2026-09-28"],
            ["THB", "714.5000", "747.5000", "728.5000", "2026-09-28"]
        ]),
        ("ty_gia_ngoai_te_ngay_29_09_2026", [
            ["currencyCode", "buyRate", "sellRate", "transferRate", "effectiveDate"],
            ["USD", "25150.0000", "25480.0000", "25200.0000", "2026-09-29"],
            ["EUR", "26850.0000", "28320.0000", "27120.0000", "2026-09-29"],
            ["GBP", "32150.0000", "33520.0000", "32470.0000", "2026-09-29"],
            ["JPY", "162.5000", "172.1000", "164.2000", "2026-09-29"],
            ["SGD", "18920.0000", "19720.0000", "19110.0000", "2026-09-29"],
            ["AUD", "16450.0000", "17150.0000", "16620.0000", "2026-09-29"],
            ["CAD", "18120.0000", "18890.0000", "18300.0000", "2026-09-29"],
            ["CHF", "28750.0000", "29970.0000", "29040.0000", "2026-09-29"],
            ["CNY", "3480.0000", "3630.0000", "3515.0000", "2026-09-29"],
            ["KRW", "18.1500", "20.1800", "19.2500", "2026-09-29"],
            ["THB", "715.0000", "748.0000", "729.0000", "2026-09-29"]
        ]),
        ("ty_gia_ngoai_te_ngay_30_09_2026", [
            ["currencyCode", "buyRate", "sellRate", "transferRate", "effectiveDate"],
            ["USD", "25160.0000", "25490.0000", "25210.0000", "2026-09-30"],
            ["EUR", "26880.0000", "28350.0000", "27150.0000", "2026-09-30"],
            ["GBP", "32180.0000", "33560.0000", "32500.0000", "2026-09-30"],
            ["JPY", "162.7000", "172.3000", "164.4000", "2026-09-30"],
            ["SGD", "18940.0000", "19750.0000", "19130.0000", "2026-09-30"],
            ["AUD", "16470.0000", "17170.0000", "16640.0000", "2026-09-30"],
            ["CAD", "18140.0000", "18910.0000", "18320.0000", "2026-09-30"],
            ["CHF", "28770.0000", "29990.0000", "29060.0000", "2026-09-30"],
            ["CNY", "3485.0000", "3635.0000", "3520.0000", "2026-09-30"],
            ["KRW", "18.1800", "20.2000", "19.2800", "2026-09-30"],
            ["THB", "716.0000", "749.5000", "730.0000", "2026-09-30"]
        ])
    ]

    for fname, data in exchange_files:
        for d in dest_dirs:
            save_csv_and_excel(data, f"{d}/{fname}.csv", f"{d}/{fname}.xlsx", sheet_name="ExchangeRates")

    # =========================================================================
    # 2. 5 FILE GIÁ VÀNG (GOLD RATES)
    # Schema: goldType,buyPrice,sellPrice,effectiveDate
    # =========================================================================
    gold_files = [
        ("gia_vang_ngay_26_09_2026", [
            ["goldType", "buyPrice", "sellPrice", "effectiveDate"],
            ["SJC 1L - 10L", "87100000.00", "89100000.00", "2026-09-26"],
            ["SJC 5c - 1c - 5 phân", "87100000.00", "89130000.00", "2026-09-26"],
            ["Vàng nhẫn SJC 99.99 1 chỉ - 5 chỉ", "86400000.00", "87800000.00", "2026-09-26"],
            ["Vàng Nữ Trang 99.99% (24K)", "86200000.00", "87400000.00", "2026-09-26"],
            ["Vàng Nữ Trang 75% (18K)", "63900000.00", "65900000.00", "2026-09-26"],
            ["Vàng Nữ Trang 58.3% (14K)", "49200000.00", "51200000.00", "2026-09-26"],
            ["Vàng Nữ Trang 41.7% (10K)", "34500000.00", "36500000.00", "2026-09-26"]
        ]),
        ("gia_vang_ngay_27_09_2026", [
            ["goldType", "buyPrice", "sellPrice", "effectiveDate"],
            ["SJC 1L - 10L", "87200000.00", "89200000.00", "2026-09-27"],
            ["SJC 5c - 1c - 5 phân", "87200000.00", "89230000.00", "2026-09-27"],
            ["Vàng nhẫn SJC 99.99 1 chỉ - 5 chỉ", "86500000.00", "87900000.00", "2026-09-27"],
            ["Vàng Nữ Trang 99.99% (24K)", "86300000.00", "87500000.00", "2026-09-27"],
            ["Vàng Nữ Trang 75% (18K)", "64000000.00", "66000000.00", "2026-09-27"],
            ["Vàng Nữ Trang 58.3% (14K)", "49300000.00", "51300000.00", "2026-09-27"],
            ["Vàng Nữ Trang 41.7% (10K)", "34600000.00", "36600000.00", "2026-09-27"]
        ]),
        ("gia_vang_ngay_28_09_2026", [
            ["goldType", "buyPrice", "sellPrice", "effectiveDate"],
            ["SJC 1L - 10L", "87350000.00", "89350000.00", "2026-09-28"],
            ["SJC 5c - 1c - 5 phân", "87350000.00", "89380000.00", "2026-09-28"],
            ["Vàng nhẫn SJC 99.99 1 chỉ - 5 chỉ", "86650000.00", "88050000.00", "2026-09-28"],
            ["Vàng Nữ Trang 99.99% (24K)", "86450000.00", "87650000.00", "2026-09-28"],
            ["Vàng Nữ Trang 75% (18K)", "64100000.00", "66100000.00", "2026-09-28"],
            ["Vàng Nữ Trang 58.3% (14K)", "49400000.00", "51400000.00", "2026-09-28"],
            ["Vàng Nữ Trang 41.7% (10K)", "34700000.00", "36700000.00", "2026-09-28"]
        ]),
        ("gia_vang_ngay_29_09_2026", [
            ["goldType", "buyPrice", "sellPrice", "effectiveDate"],
            ["SJC 1L - 10L", "87500000.00", "89500000.00", "2026-09-29"],
            ["SJC 5c - 1c - 5 phân", "87500000.00", "89530000.00", "2026-09-29"],
            ["Vàng nhẫn SJC 99.99 1 chỉ - 5 chỉ", "86800000.00", "88200000.00", "2026-09-29"],
            ["Vàng Nữ Trang 99.99% (24K)", "86600000.00", "87800000.00", "2026-09-29"],
            ["Vàng Nữ Trang 75% (18K)", "64200000.00", "66200000.00", "2026-09-29"],
            ["Vàng Nữ Trang 58.3% (14K)", "49500000.00", "51500000.00", "2026-09-29"],
            ["Vàng Nữ Trang 41.7% (10K)", "34800000.00", "36800000.00", "2026-09-29"]
        ]),
        ("gia_vang_ngay_30_09_2026", [
            ["goldType", "buyPrice", "sellPrice", "effectiveDate"],
            ["SJC 1L - 10L", "87650000.00", "89650000.00", "2026-09-30"],
            ["SJC 5c - 1c - 5 phân", "87650000.00", "89680000.00", "2026-09-30"],
            ["Vàng nhẫn SJC 99.99 1 chỉ - 5 chỉ", "86950000.00", "88350000.00", "2026-09-30"],
            ["Vàng Nữ Trang 99.99% (24K)", "86750000.00", "87950000.00", "2026-09-30"],
            ["Vàng Nữ Trang 75% (18K)", "64350000.00", "66350000.00", "2026-09-30"],
            ["Vàng Nữ Trang 58.3% (14K)", "49650000.00", "51650000.00", "2026-09-30"],
            ["Vàng Nữ Trang 41.7% (10K)", "34950000.00", "36950000.00", "2026-09-30"]
        ])
    ]

    for fname, data in gold_files:
        for d in dest_dirs:
            save_csv_and_excel(data, f"{d}/{fname}.csv", f"{d}/{fname}.xlsx", sheet_name="GoldRates")

    # =========================================================================
    # 3. 5 FILE LÃI SUẤT (INTEREST RATES)
    # Schema: productCode,termMonths,ratePercentage,effectiveDate
    # =========================================================================
    interest_files = [
        ("lai_suat_tiet_kiem_ca_nhan_tai_quay", [
            ["productCode", "termMonths", "ratePercentage", "effectiveDate"],
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
            ["productCode", "termMonths", "ratePercentage", "effectiveDate"],
            ["SAVING_ONLINE_1M", "1", "2.20", "2026-09-30"],
            ["SAVING_ONLINE_3M", "3", "2.50", "2026-09-30"],
            ["SAVING_ONLINE_6M", "6", "3.50", "2026-09-30"],
            ["SAVING_ONLINE_9M", "9", "3.50", "2026-09-30"],
            ["SAVING_ONLINE_12M", "12", "5.00", "2026-09-30"],
            ["SAVING_ONLINE_24M", "24", "5.40", "2026-09-30"],
            ["SAVING_ONLINE_36M", "36", "5.40", "2026-09-30"]
        ]),
        ("lai_suat_tien_gui_doanh_nghiep", [
            ["productCode", "termMonths", "ratePercentage", "effectiveDate"],
            ["CORP_DEPOSIT_1M", "1", "1.90", "2026-09-30"],
            ["CORP_DEPOSIT_3M", "3", "2.20", "2026-09-30"],
            ["CORP_DEPOSIT_6M", "6", "3.10", "2026-09-30"],
            ["CORP_DEPOSIT_9M", "9", "3.10", "2026-09-30"],
            ["CORP_DEPOSIT_12M", "12", "4.60", "2026-09-30"],
            ["CORP_DEPOSIT_24M", "24", "4.90", "2026-09-30"],
            ["CORP_DEPOSIT_36M", "36", "4.90", "2026-09-30"]
        ]),
        ("lai_suat_cho_vay_khach_hang_ca_nhan", [
            ["productCode", "termMonths", "ratePercentage", "effectiveDate"],
            ["LOAN_MORTGAGE_HOME", "120", "6.50", "2026-09-30"],
            ["LOAN_AUTO_PURCHASE", "60", "6.90", "2026-09-30"],
            ["LOAN_CONSUMER_UNSECURED", "36", "8.20", "2026-09-30"],
            ["LOAN_STUDY_ABROAD", "48", "7.00", "2026-09-30"],
            ["LOAN_HOUSE_RENOVATION", "84", "6.80", "2026-09-30"]
        ]),
        ("lai_suat_cho_vay_doanh_nghiep_sme", [
            ["productCode", "termMonths", "ratePercentage", "effectiveDate"],
            ["LOAN_SME_WORKING_CAPITAL", "12", "5.80", "2026-09-30"],
            ["LOAN_SME_MEDIUM_TERM", "36", "6.40", "2026-09-30"],
            ["LOAN_IMPORT_EXPORT", "6", "5.20", "2026-09-30"],
            ["LOAN_GREEN_PROJECT", "60", "6.00", "2026-09-30"],
            ["LOAN_SUPPLY_CHAIN", "12", "5.60", "2026-09-30"]
        ])
    ]

    for fname, data in interest_files:
        for d in dest_dirs:
            save_csv_and_excel(data, f"{d}/{fname}.csv", f"{d}/{fname}.xlsx", sheet_name="InterestRates")

    # =========================================================================
    # 4. 5 FILE BIỂU PHÍ DỊCH VỤ NGÂN HÀNG (EXCEL & CSV)
    # Phục vụ quản lý biểu phí và công khai trên cổng khách hàng
    # =========================================================================
    fee_files = [
        ("bieu_phi_dich_vu_the_vcb", [
            ["category", "serviceName", "feeStandardVND", "feeVipVND", "note"],
            ["THẺ GHI NỢ", "Phát hành thẻ ghi nợ nội địa chuẩn", "50000", "0", "Miễn phí khi mở online"],
            ["THẺ GHI NỢ", "Phát hành thẻ ghi nợ quốc tế Visa/Mastercard", "100000", "0", "Hạng Chuẩn/Vàng"],
            ["THẺ TÍN DỤNG", "Phí thường niên thẻ Vietcombank Visa Signature", "3000000", "1500000", "Hoàn phí khi đạt doanh số chi tiêu"],
            ["THẺ TÍN DỤNG", "Phí thường niên thẻ Vietcombank Visa Platinum", "800000", "0", "Ưu đãi khách hàng VIP"],
            ["GIAO DỊCH ATM", "Rút tiền tại ATM trong hệ thống Vietcombank", "1100", "0", "Đã bao gồm VAT"],
            ["GIAO DỊCH ATM", "Rút tiền tại ATM ngoài hệ thống Napas", "3300", "0", "Đã bao gồm VAT"]
        ]),
        ("bieu_phi_chuyen_tien_va_tai_khoan", [
            ["category", "serviceName", "feeStandardVND", "feeVipVND", "note"],
            ["TÀI KHOẢN", "Phí quản lý tài khoản thanh toán VND", "0", "0", "Miễn phí trọn đời"],
            ["TÀI KHOẢN", "Phí duy trì số dư tối thiểu tài khoản", "0", "0", "Không yêu cầu số dư tối thiểu"],
            ["CHUYỂN TIỀN", "Chuyển tiền nội bộ Vietcombank trên Digibank", "0", "0", "Miễn phí toàn bộ"],
            ["CHUYỂN TIỀN", "Chuyển tiền nhanh 24/7 Napas ngoài hệ thống", "0", "0", "Miễn phí trên VCB Digibank"],
            ["CHUYỂN TIỀN", "Chuyển tiền tại quầy cùng hệ thống", "11000", "0", "Giao dịch dưới 500 triệu VND"],
            ["CHUYỂN TIỀN", "Chuyển tiền liên ngân hàng tại quầy", "22000", "0", "Tối thiểu 22.000 VND / giao dịch"]
        ]),
        ("bieu_phi_ngan_hang_so_digibank", [
            ["category", "serviceName", "feeStandardVND", "feeVipVND", "note"],
            ["VCB DIGIBANK", "Phí đăng ký và kích hoạt ứng dụng", "0", "0", "Miễn phí"],
            ["VCB DIGIBANK", "Phí duy trì dịch vụ VCB Digibank hàng tháng", "0", "0", "Miễn phí"],
            ["SMS CHỦ ĐỘNG", "Gói thông báo biến động số dư qua SMS (1-20 SMS)", "11000", "0", "11.000 VND / tháng / số"],
            ["SMS CHỦ ĐỘNG", "Gói thông báo SMS không giới hạn", "55000", "0", "55.000 VND / tháng / số"],
            ["XÁC THỰC", "Phương thức xác thực VCB Smart OTP", "0", "0", "Miễn phí tích hợp trên App"]
        ]),
        ("bieu_phi_dich_vu_tin_dung_bao_lanh", [
            ["category", "serviceName", "feeStandardVND", "feeVipVND", "note"],
            ["TÍN DỤNG", "Phí thẩm định hồ sơ vay vốn cá nhân", "0", "0", "Miễn phí thẩm định ban đầu"],
            ["TÍN DỤNG", "Phí trả nợ trước hạn (năm thứ 1 - 2)", "1.5%", "0.5%", "Tính trên số tiền gốc trả trước"],
            ["TÍN DỤNG", "Phí trả nợ trước hạn (từ năm thứ 5 trở đi)", "0", "0", "Miễn phí hoàn toàn"],
            ["BẢO LÃNH", "Phát hành bảo lãnh dự thầu doanh nghiệp", "0.2%", "0.15%", "Tối thiểu 500.000 VND / chứng thư"],
            ["BẢO LÃNH", "Phát hành bảo lãnh thực hiện hợp đồng", "0.3%", "0.2%", "Tối thiểu 1.000.000 VND / chứng thư"]
        ]),
        ("bieu_phi_dich_vu_ngan_quy_tien_mat", [
            ["category", "serviceName", "feeStandardVND", "feeVipVND", "note"],
            ["NGÂN QUỸ", "Nộp tiền mặt VND vào tài khoản tại chi nhánh mở", "0", "0", "Miễn phí"],
            ["NGÂN QUỸ", "Nộp tiền mặt VND khác tỉnh/thành phố chi nhánh", "0.03%", "0", "Tối đa 500.000 VND"],
            ["NGÂN QUỸ", "Kiểm đếm tiền mặt số lượng lớn (trên 1 tỷ VND)", "0.02%", "0", "Miễn phí nếu gửi tiết kiệm"],
            ["NGOẠI TỆ", "Rút tiền mặt ngoại tệ USD từ tài khoản ngoại tệ", "0.2%", "0.1%", "Tối thiểu 2 USD"],
            ["ĐỔI TIỀN", "Đổi tiền không đủ tiêu chuẩn lưu thông", "0", "0", "Theo quy định Ngân hàng Nhà nước"]
        ])
    ]

    for fname, data in fee_files:
        for d in dest_dirs:
            save_csv_and_excel(data, f"{d}/{fname}.csv", f"{d}/{fname}.xlsx", sheet_name="FeeSchedule")

    # =========================================================================
    # 5. 5 FILE CHI TRẢ LƯƠNG NHÂN VIÊN (PAYROLL CSV & EXCEL)
    # Schema: employeeName,accountNumber,amount,note
    # =========================================================================
    payroll_files = [
        ("bang_luong_khoi_cong_nghe_thong_tin", [
            ["employeeName", "accountNumber", "amount", "note"],
            ["Nguyễn Văn An", "0011004567890", "28500000", "Lương T9/2026 - Lead Developer"],
            ["Trần Thị Bích Ngọc", "0011009876543", "24000000", "Lương T9/2026 - Senior Backend"],
            ["Lê Hoàng Minh", "0011002345678", "21500000", "Lương T9/2026 - Frontend Engineer"],
            ["Phạm Thu Trang", "0011008765432", "26000000", "Lương T9/2026 - DevOps & Cloud"],
            ["Đỗ Hữu Nghĩa", "0011003456789", "19000000", "Lương T9/2026 - QA Automation"],
            ["Vũ Đình Quân", "0011001234567", "22500000", "Lương T9/2026 - UI/UX Designer"],
            ["Hoàng Khánh Linh", "0011007890123", "18000000", "Lương T9/2026 - Data Analyst"]
        ]),
        ("bang_luong_khoi_kinh_doanh_va_marketing", [
            ["employeeName", "accountNumber", "amount", "note"],
            ["Trần Quốc Toản", "0011006543210", "32000000", "Lương T9/2026 - Trưởng phòng Kinh doanh"],
            ["Võ Thị Mai", "0011007654321", "23500000", "Lương T9/2026 - Chuyên viên Sales B2B"],
            ["Đinh Quang Hải", "0011008765412", "19500000", "Lương T9/2026 - Chuyên viên Sales B2C"],
            ["Nguyễn Phương Thảo", "0011009871234", "25000000", "Lương T9/2026 - Trưởng nhóm Marketing"],
            ["Bùi Minh Đức", "0011001239876", "17500000", "Lương T9/2026 - Digital Marketing Executive"],
            ["Lê Mỹ Duyên", "0011003451239", "18000000", "Lương T9/2026 - Chuyên viên Content & PR"]
        ]),
        ("bang_luong_khoi_tai_chinh_ke_toan", [
            ["employeeName", "accountNumber", "amount", "note"],
            ["Phan Thu Hà", "0011005544332", "35000000", "Lương T9/2026 - Kế toán trưởng"],
            ["Dương Gia Bảo", "0011006655443", "24000000", "Lương T9/2026 - Kế toán tổng hợp"],
            ["Hồ Thảo My", "0011007766554", "18500000", "Lương T9/2026 - Kế toán thanh toán"],
            ["Nguyễn Đức Thắng", "0011008877665", "20000000", "Lương T9/2026 - Chuyên viên Quản trị rủi ro"],
            ["Trương Bích Thủy", "0011009988776", "17500000", "Lương T9/2026 - Thủ quỹ & Ngân quỹ"]
        ]),
        ("bang_luong_khoi_san_xuat_van_hanh", [
            ["employeeName", "accountNumber", "amount", "note"],
            ["Cao Văn Tùng", "0011001122334", "26000000", "Lương T9/2026 - Quản đốc phân xưởng"],
            ["Đoàn Thị Hồng", "0011002233445", "16500000", "Lương T9/2026 - Trưởng ca sản xuất"],
            ["Lý Thế Dân", "0011003344556", "15000000", "Lương T9/2026 - Kỹ thuật viên bảo trì"],
            ["Ngô Văn Khoa", "0011004455667", "14500000", "Lương T9/2026 - Kỹ thuật viên vận hành máy"],
            ["Mai Hồng Phượng", "0011005566778", "13800000", "Lương T9/2026 - Kiểm định chất lượng KCS"]
        ]),
        ("bang_chi_tra_thuong_hieu_suat_quy_3", [
            ["employeeName", "accountNumber", "amount", "note"],
            ["Nguyễn Văn An", "0011004567890", "15000000", "Thưởng hiệu suất xuất sắc Q3/2026"],
            ["Trần Quốc Toản", "0011006543210", "20000000", "Thưởng vượt chỉ tiêu doanh số Q3/2026"],
            ["Phan Thu Hà", "0011005544332", "18000000", "Thưởng quản trị tối ưu chi phí Q3/2026"],
            ["Võ Thị Mai", "0011007654321", "12000000", "Thưởng kinh doanh phát triển khách hàng mới"],
            ["Phạm Thu Trang", "0011008765432", "14000000", "Thưởng dự án chuyển đổi số đúng tiến độ"]
        ])
    ]

    for fname, data in payroll_files:
        for d in dest_dirs:
            save_csv_and_excel(data, f"{d}/{fname}.csv", f"{d}/{fname}.xlsx", sheet_name="PayrollEmployees")

    # =========================================================================
    # 6. 5 FILE BIỂU MẪU NGHIỆP VỤ WORD (.DOCX) CHUẨN VIETCOMBANK
    # =========================================================================
    word_templates = [
        (
            "Bieu_mau_01_Giay_de_nghi_vay_von_kiem_phuong_an_tra_no.docx",
            "GIẤY ĐỀ NGHỊ VAY VỐN KIÊM PHƯƠNG ÁN TRẢ NỢ",
            "BM-01/TD-VCB",
            "Áp dụng đối với Khách hàng Cá nhân vay tiêu dùng, bất động sản, sản xuất kinh doanh",
            [
                ("I. THÔNG TIN KHÁCH HÀNG VAY VỐN", [
                    ("Họ và tên khách hàng", "NGUYỄN VĂN AN"),
                    ("Ngày tháng năm sinh", "15/08/1990"),
                    ("Số CCCD / CMND", "001090012345 (Ngày cấp: 10/05/2022 tại Cục CS QLHC về TTXH)"),
                    ("Địa chỉ thường trú", "Số 123 Phố Huế, Phường Hàng Bài, Quận Hoàn Kiếm, Hà Nội"),
                    ("Số điện thoại liên hệ", "0912345678 - Email: an.nguyen@gmail.com"),
                    ("Tình trạng hôn nhân", "Đã kết hôn (Họ tên người đồng vay/vợ: Trần Thu Thảo)"),
                    ("Nơi làm việc hiện tại", "Công ty Cổ phần Công nghệ ABC (Vị trí: Quản lý kỹ thuật)"),
                    ("Thu nhập hàng tháng", "45,000,000 VND / tháng (Sao kê qua tài khoản Vietcombank)")
                ]),
                ("II. NỘI DUNG ĐỀ NGHỊ VAY VỐN", [
                    ("Mục đích vay vốn", "Vay mua nhà ở / căn hộ chung cư tại Dự án Vinhomes Ocean Park"),
                    ("Số tiền đề nghị vay", "1,500,000,000 VND (Bằng chữ: Một tỷ năm trăm triệu đồng chẵn)"),
                    ("Thời hạn vay", "120 tháng (10 năm)"),
                    ("Phương thức giải ngân", "Chuyển khoản trực tiếp cho bên bán / chủ đầu tư"),
                    ("Hình thức trả nợ", "Gốc trả định kỳ hàng tháng, Lãi trả hàng tháng theo dư nợ giảm dần")
                ]),
                ("III. BIỆN PHÁP BẢO ĐẢM TIỀN VAY", [
                    ("Tài sản thế chấp", "Căn hộ số 1204 Tòa S2.05, Dự án Vinhomes Ocean Park"),
                    ("Giá trị định giá dự kiến", "2,600,000,000 VND"),
                    ("Tỷ lệ cho vay trên TSBĐ", "57.69% (Nằm trong hạn mức cho phép tối đa 70% của VCB)")
                ]),
                ("IV. CAM KẾT CỦA KHÁCH HÀNG", [
                    ("Cam kết tính chính xác", "Tôi cam kết toàn bộ thông tin kê khai trên là hoàn toàn đúng sự thật."),
                    ("Cam kết sử dụng vốn", "Sử dụng vốn vay đúng mục đích đã đăng ký và tuân thủ trả nợ đúng hạn."),
                    ("Đồng ý tra cứu CIC", "Đồng ý cho Vietcombank tra cứu lịch sử tín dụng tại Trung tâm CIC.")
                ])
            ],
            [
                ["Kỳ thanh toán", "Số dư nợ đầu kỳ (VND)", "Tiền gốc trả (VND)", "Tiền lãi tạm tính 6.8%/năm", "Tổng số tiền trả"],
                ["Tháng 1", "1,500,000,000", "12,500,000", "8,500,000", "21,000,000"],
                ["Tháng 2", "1,487,500,000", "12,500,000", "8,429,000", "20,929,000"],
                ["Tháng 3", "1,475,000,000", "12,500,000", "8,358,000", "20,858,000"],
                ["Tháng ...", "...", "...", "...", "..."],
                ["Tháng 120", "12,500,000", "12,500,000", "70,833", "12,570,833"]
            ]
        ),
        (
            "Bieu_mau_02_Giay_de_nghi_phat_hanh_va_su_dung_the_tin_dung.docx",
            "GIẤY ĐỀ NGHỊ PHÁT HÀNH KIÊM HỢP ĐỒNG SỬ DỤNG THẺ TÍN DỤNG",
            "BM-02/CARD-VCB",
            "Sản phẩm Thẻ tín dụng Quốc tế Vietcombank Visa / Mastercard / JCB Platinum",
            [
                ("I. THÔNG TIN CHỦ THẺ CHÍNH", [
                    ("Họ và tên in trên thẻ", "NGUYEN VAN AN"),
                    ("Số CCCD", "001090012345"),
                    ("Hạn mức tín dụng yêu cầu", "100,000,000 VND (Một trăm triệu đồng chẵn)"),
                    ("Hạng thẻ đăng ký", "Vietcombank Visa Platinum Cash Back"),
                    ("Địa chỉ nhận thẻ", "Nhận trực tiếp tại Chi nhánh Vietcombank Hà Nội - 11 Láng Hạ")
                ]),
                ("II. HÌNH THỨC BẢO ĐẢM TÍN DỤNG", [
                    ("Hình thức", "Phát hành thẻ tín chấp theo uy tín và thu nhập tiền lương"),
                    ("Tài khoản trích nợ tự động", "0011004567890 tại Vietcombank Sở Giao dịch"),
                    ("Tỷ lệ trích nợ tự động", "Thanh toán toàn bộ 100% dư nợ sao kê hàng tháng")
                ]),
                ("III. CÁC ĐIỀU KHOẢN VÀ ĐIỀU KIỆN", [
                    ("Thời hạn miễn lãi", "Tối đa lên đến 45 ngày kể từ ngày giao dịch"),
                    ("Lãi suất quá hạn", "Theo biểu lãi suất thẻ tín dụng hiện hành do Vietcombank công bố"),
                    ("Xác thực giao dịch", "Bảo mật 3D-Secure qua mã OTP VCB Digibank")
                ])
            ],
            [
                ["STT", "Tên dịch vụ giá trị gia tăng kèm theo", "Đăng ký sử dụng", "Ghi chú"],
                ["1", "Thông báo biến động số dư chi tiêu qua OTT/SMS", "Có", "Miễn phí qua OTT Digibank"],
                ["2", "Bảo hiểm du lịch toàn cầu giá trị 11.65 tỷ VND", "Có", "Đặc quyền miễn phí cho chủ thẻ Platinum"],
                ["3", "Tích lũy điểm thưởng VCB Rewards đổi quà", "Có", "Tỷ lệ tích lũy 0.5% chi tiêu"]
            ]
        ),
        (
            "Bieu_mau_03_Don_de_nghi_tra_soat_kieu_nai_giao_dich.docx",
            "ĐƠN ĐỀ NGHỊ TRA SOÁT KHIẾU NẠI GIAO DỊCH",
            "BM-03/DISPUTE-VCB",
            "Dành cho Khách hàng khiếu nại giao dịch thẻ, ATM, chuyển khoản liên ngân hàng",
            [
                ("I. THÔNG TIN KHÁCH HÀNG KHIẾU NẠI", [
                    ("Họ và tên chủ tài khoản/chủ thẻ", "TRẦN THỊ BÍCH NGỌC"),
                    ("Số điện thoại liên hệ", "0987654321"),
                    ("Số tài khoản thanh toán / Số thẻ", "0011009876543 (4 số cuối thẻ: 8899)"),
                    ("Chi nhánh quản lý tài khoản", "Vietcombank Chi nhánh Ba Đình - Hà Nội")
                ]),
                ("II. CHI TIẾT GIAO DỊCH CẦN TRA SOÁT", [
                    ("Thời gian thực hiện giao dịch", "14:35 ngày 28/09/2026"),
                    ("Mã giao dịch / Mã chuẩn chi", "FT26271987654321"),
                    ("Số tiền giao dịch tra soát", "5,000,000 VND (Năm triệu đồng chẵn)"),
                    ("Kênh thực hiện giao dịch", "Cây ATM số 05 - Vietcombank Hoàn Kiếm (Hoặc Napas 247)")
                ]),
                ("III. NỘI DUNG VÀ LÝ DO TRA SOÁT", [
                    ("Lý do khiếu nại", "Tài khoản đã bị trừ tiền nhưng cây ATM không nhả tiền mặt"),
                    ("Yêu cầu của khách hàng", "Đề nghị Vietcombank kiểm quỹ ATM và hoàn trả lại 5,000,000 VND vào tài khoản"),
                    ("Tài liệu đính kèm", "Biên lai giao dịch ATM bị lỗi + Ảnh chụp thông báo trừ tiền Digibank")
                ])
            ],
            [
                ["Mã GD", "Kênh GD", "Số tiền (VND)", "Trạng thái hiển thị", "Thời gian"],
                ["FT26271987654321", "ATM Ngoại mạng", "5,000,000", "Đã trừ tài khoản", "28/09/2026 14:35:12"]
            ]
        ),
        (
            "Bieu_mau_04_Giay_dang_ky_dich_vu_ngan_hang_so_VCB_Digibank.docx",
            "GIẤY ĐĂNG KÝ / THAY ĐỔI DỊCH VỤ NGÂN HÀNG SỐ VCB DIGIBANK",
            "BM-04/EBANK-VCB",
            "Đăng ký mới, cấp lại mật khẩu, mở khóa tài khoản và cài đặt hạn mức giao dịch",
            [
                ("I. THÔNG TIN KHÁCH HÀNG ĐĂNG KÝ", [
                    ("Họ và tên khách hàng", "LÊ HOÀNG MINH"),
                    ("Số CCCD", "001201009876"),
                    ("Số điện thoại đăng ký nhận Smart OTP", "0934567890"),
                    ("Địa chỉ Email nhận thông báo", "minh.lehoang@gmail.com")
                ]),
                ("II. DỊCH VỤ YÊU CẦU THỰC HIỆN", [
                    ("Loại yêu cầu", "[X] Đăng ký mới   [ ] Cấp lại mật khẩu   [ ] Thay đổi SĐT"),
                    ("Phương thức xác thực mong muốn", "VCB Smart OTP tích hợp trên ứng dụng di động"),
                    ("Hạn mức giao dịch trực tuyến ngày", "Gói hạn mức Nâng cao (Tối đa 3,000,000,000 VND / ngày)"),
                    ("Dịch vụ SMS chủ động", "Kích hoạt nhận tin nhắn biến động số dư cho các giao dịch từ 50,000 VND")
                ])
            ],
            [
                ["Gói dịch vụ", "Hạn mức tối đa/lần (VND)", "Hạn mức tối đa/ngày (VND)", "Phương thức xác thực"],
                ["Gói Cơ bản", "100,000,000", "500,000,000", "SMS OTP"],
                ["Gói Nâng cao", "1,000,000,000", "3,000,000,000", "VCB Smart OTP"],
                ["Gói Doanh nghiệp", "5,000,000,000", "20,000,000,000", "Hard Token OTP / Chữ ký số"]
            ]
        ),
        (
            "Bieu_mau_05_Giay_de_nghi_mo_tai_khoan_thanh_toan_to_chuc.docx",
            "GIẤY ĐỀ NGHỊ MỞ TÀI KHOẢN VÀ SỬ DỤNG DỊCH VỤ CHI LƯƠNG TỔ CHỨC",
            "BM-05/CORP-VCB",
            "Áp dụng cho Doanh nghiệp, Tổ chức kinh tế sử dụng dịch vụ trả lương qua tài khoản VCB",
            [
                ("I. THÔNG TIN DOANH NGHIỆP / TỔ CHỨC", [
                    ("Tên đầy đủ của tổ chức", "CÔNG TY CỔ PHẦN CÔNG NGHỆ VÀ TRUYỀN THÔNG ĐÔNG NAM Á"),
                    ("Mã số doanh nghiệp / Mã số thuế", "0109876543 do Sở KH&ĐT TP. Hà Nội cấp"),
                    ("Địa chỉ trụ sở chính", "Tầng 18, Tòa nhà Keangnam Landmark 72, Nam Từ Liêm, Hà Nội"),
                    ("Người đại diện theo pháp luật", "Ông PHẠM HOÀNG LONG (Chức vụ: Tổng Giám Đốc)"),
                    ("Kế toán trưởng / Người phụ trách kế toán", "Bà NGUYỄN THỊ MINH TÂM")
                ]),
                ("II. DỊCH VỤ ĐĂNG KÝ SỬ DỤNG", [
                    ("Tài khoản trích nợ chi lương", "0011008889999 (Tài khoản thanh toán VND doanh nghiệp)"),
                    ("Gói dịch vụ chi trả lương", "VCB Payroll Online - Tự động duyệt lô qua cổng doanh nghiệp"),
                    ("Chính sách ưu đãi nhân viên", "Miễn phí phát hành thẻ ATM, miễn phí thường niên thẻ và miễn phí chuyển tiền")
                ]),
                ("III. HỒ SƠ PHÁP LÝ KÈM THEO", [
                    ("Giấy chứng nhận ĐKKD", "Bản sao chứng thực Giấy chứng nhận đăng ký kinh doanh"),
                    ("Quyết định bổ nhiệm", "Bản sao quyết định bổ nhiệm Tổng Giám Đốc và Kế toán trưởng"),
                    ("Mẫu dấu và chữ ký", "Bản đăng ký mẫu con dấu và chữ ký của chủ tài khoản")
                ])
            ],
            [
                ["STT", "Hạng mục đăng ký dịch vụ tổ chức", "Tùy chọn", "Chi nhánh phục vụ"],
                ["1", "Cổng giao dịch điện tử VCB B-Office", "Có", "Chi nhánh Vietcombank Hoàn Kiếm"],
                ["2", "Dịch vụ chi lương tự động theo file Excel", "Có", "Chi nhánh Vietcombank Hoàn Kiếm"],
                ["3", "Thu hộ / Chi hộ tự động qua API Webhook", "Có", "Chi nhánh Vietcombank Hoàn Kiếm"]
            ]
        )
    ]

    for fname, title, code, subtitle, sections, table_data in word_templates:
        for d in dest_dirs:
            create_word_document(f"{d}/{fname}", title, code, subtitle, sections, table_data)

    print("\n=======================================================")
    print("HOAN TAT TAO TOAN BO FILE MAU CSV, EXCEL, WORD!")
    print("=======================================================")

if __name__ == "__main__":
    main()
