package com.bank.admin.data;

import com.bank.admin.common.ApiException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

/**
 * Parser Excel (.xlsx, .xls) và CSV (.csv) cho import dữ liệu thị trường hàng loạt.
 * Mỗi sheet / file CSV: dòng đầu là header, các dòng sau:
 *   Tỷ giá:    currencyCode | buy | sell | transfer | effectiveDate (yyyy-MM-dd hoặc dd/MM/yyyy)
 *   Giá vàng:  goldType     | buy | sell | effectiveDate
 *   Lãi suất:  productCode  | termMonths | ratePercentage | effectiveDate
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class RateDataImportParser {

    public record ParsedRates<T>(List<T> rows, int skipped) {}

    public ParsedRates<ExchangeRate> parseExchange(MultipartFile file, Long userId) {
        if (isCsv(file)) {
            return parseCsv(file, (cols, lineNum) -> {
                if (cols.length < 5) throw badRow(lineNum, "thiếu cột dữ liệu (cần ít nhất 5 cột: currencyCode, buy, sell, transfer, effectiveDate)");
                String code = cols[0].trim();
                if (code.isEmpty()) return null;
                LocalDate date = parseDate(cols[4].trim());
                if (date == null) throw badRow(lineNum, "thiếu hoặc sai định dạng ngày hiệu lực: " + cols[4]);
                return ExchangeRate.builder()
                    .currencyCode(code.toUpperCase())
                    .buyRate(parseDecimal(cols[1]))
                    .sellRate(parseDecimal(cols[2]))
                    .transferRate(parseDecimal(cols[3]))
                    .effectiveDate(date)
                    .createdBy(userId)
                    .build();
            });
        }
        return parse(file, row -> {
            String code = text(row, 0);
            if (code.isEmpty()) return null;
            LocalDate date = date(row, 4);
            if (date == null) throw badRow(row.getRowNum(), "thiếu ngày hiệu lực");
            return ExchangeRate.builder()
                .currencyCode(code.toUpperCase())
                .buyRate(decimal(row, 1))
                .sellRate(decimal(row, 2))
                .transferRate(decimal(row, 3))
                .effectiveDate(date)
                .createdBy(userId)
                .build();
        });
    }

    public ParsedRates<GoldRate> parseGold(MultipartFile file, Long userId) {
        if (isCsv(file)) {
            return parseCsv(file, (cols, lineNum) -> {
                if (cols.length < 4) throw badRow(lineNum, "thiếu cột dữ liệu (cần ít nhất 4 cột: goldType, buy, sell, effectiveDate)");
                String type = cols[0].trim();
                if (type.isEmpty()) return null;
                LocalDate date = parseDate(cols[3].trim());
                if (date == null) throw badRow(lineNum, "thiếu hoặc sai định dạng ngày hiệu lực: " + cols[3]);
                return GoldRate.builder()
                    .goldType(type)
                    .buyPrice(parseDecimal(cols[1]))
                    .sellPrice(parseDecimal(cols[2]))
                    .effectiveDate(date)
                    .createdBy(userId)
                    .build();
            });
        }
        return parse(file, row -> {
            String type = text(row, 0);
            if (type.isEmpty()) return null;
            LocalDate date = date(row, 3);
            if (date == null) throw badRow(row.getRowNum(), "thiếu ngày hiệu lực");
            return GoldRate.builder()
                .goldType(type)
                .buyPrice(decimal(row, 1))
                .sellPrice(decimal(row, 2))
                .effectiveDate(date)
                .createdBy(userId)
                .build();
        });
    }

    public ParsedRates<InterestRate> parseInterest(MultipartFile file, Long userId) {
        if (isCsv(file)) {
            return parseCsv(file, (cols, lineNum) -> {
                if (cols.length < 4) throw badRow(lineNum, "thiếu cột dữ liệu (cần ít nhất 4 cột: productCode, termMonths, ratePercentage, effectiveDate)");
                String code = cols[0].trim();
                if (code.isEmpty()) return null;
                LocalDate date = parseDate(cols[3].trim());
                if (date == null) throw badRow(lineNum, "thiếu hoặc sai định dạng ngày hiệu lực: " + cols[3]);
                int term = (int) Double.parseDouble(cols[1].replaceAll("[^0-9.]", ""));
                if (term <= 0) throw badRow(lineNum, "kỳ hạn không hợp lệ");
                return InterestRate.builder()
                    .productCode(code.toUpperCase())
                    .termMonths(term)
                    .ratePercentage(parseDecimal(cols[2]))
                    .effectiveDate(date)
                    .createdBy(userId)
                    .build();
            });
        }
        return parse(file, row -> {
            String code = text(row, 0);
            if (code.isEmpty()) return null;
            LocalDate date = date(row, 3);
            if (date == null) throw badRow(row.getRowNum(), "thiếu ngày hiệu lực");
            double term = numeric(row, 1);
            if (term <= 0) throw badRow(row.getRowNum(), "kỳ hạn không hợp lệ");
            return InterestRate.builder()
                .productCode(code.toUpperCase())
                .termMonths((int) term)
                .ratePercentage(BigDecimal.valueOf(numeric(row, 2)))
                .effectiveDate(date)
                .createdBy(userId)
                .build();
        });
    }

    // ---------- CSV Parser ----------

    private interface CsvRowMapper<T> {
        T map(String[] cols, int lineNum);
    }

    private boolean isCsv(MultipartFile file) {
        String name = file.getOriginalFilename();
        if (name != null && name.toLowerCase().endsWith(".csv")) return true;
        String contentType = file.getContentType();
        return contentType != null && (contentType.contains("csv") || contentType.contains("text/plain"));
    }

    private <T> ParsedRates<T> parseCsv(MultipartFile file, CsvRowMapper<T> mapper) {
        List<T> rows = new ArrayList<>();
        int skipped = 0;
        int lineNum = 0;
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lineNum++;
                if (lineNum == 1) continue; // Bỏ qua header
                if (line.trim().isEmpty()) continue;
                String[] cols = splitCsvLine(line);
                if (cols.length == 0 || (cols.length == 1 && cols[0].isEmpty())) continue;
                try {
                    T item = mapper.map(cols, lineNum);
                    if (item == null) skipped++;
                    else rows.add(item);
                } catch (IllegalArgumentException e) {
                    log.warn("Bỏ qua dòng CSV {} khi import: {}", lineNum, e.getMessage());
                    skipped++;
                }
            }
            if (rows.isEmpty() && skipped == 0) {
                throw ApiException.badRequest("File CSV không có dữ liệu để import");
            }
            return new ParsedRates<>(rows, skipped);
        } catch (ApiException e) {
            throw e;
        } catch (Exception e) {
            log.error("Lỗi đọc file CSV import", e);
            throw ApiException.badRequest("Không đọc được file CSV: " + e.getMessage());
        }
    }

    private String[] splitCsvLine(String line) {
        if (line == null) return new String[0];
        if (line.startsWith("﻿")) line = line.substring(1); // Xử lý UTF-8 BOM
        char delimiter = (line.contains(";") && !line.contains(",")) ? ';' : ',';
        List<String> tokens = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        boolean inQuotes = false;
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == '\"') {
                inQuotes = !inQuotes;
            } else if (c == delimiter && !inQuotes) {
                tokens.add(sb.toString().trim());
                sb.setLength(0);
            } else {
                sb.append(c);
            }
        }
        tokens.add(sb.toString().trim());
        return tokens.toArray(new String[0]);
    }

    private BigDecimal parseDecimal(String s) {
        if (s == null) throw new IllegalArgumentException("thiếu cột số");
        String clean = s.replaceAll("[\"'\t\r\n ,]", "").trim();
        try {
            return new BigDecimal(clean);
        } catch (Exception e) {
            throw new IllegalArgumentException("giá trị số không hợp lệ: " + s);
        }
    }

    private LocalDate parseDate(String s) {
        if (s == null || s.isBlank()) return null;
        String clean = s.replaceAll("[\"'\t\r\n ]", "").trim();
        try {
            if (clean.matches("\\d{4}-\\d{2}-\\d{2}")) return LocalDate.parse(clean);
            if (clean.matches("\\d{1,2}/\\d{1,2}/\\d{4}")) {
                String[] p = clean.split("/");
                return LocalDate.of(Integer.parseInt(p[2]), Integer.parseInt(p[1]), Integer.parseInt(p[0]));
            }
        } catch (Exception ignored) {}
        return null;
    }

    // ---------- helpers ----------

    private interface RowMapper<T> {
        T map(Row row);
    }

    private <T> ParsedRates<T> parse(MultipartFile file, RowMapper<T> mapper) {
        try (Workbook wb = WorkbookFactory.create(file.getInputStream())) {
            List<T> rows = new ArrayList<>();
            int skipped = 0;
            Sheet sheet = wb.getSheetAt(0);
            for (int i = sheet.getFirstRowNum() + 1; i <= sheet.getLastRowNum(); i++) { // bỏ header
                Row row = sheet.getRow(i);
                if (row == null) continue;
                try {
                    T item = mapper.map(row);
                    if (item == null) skipped++; // dòng trống
                    else rows.add(item);
                } catch (IllegalArgumentException e) {
                    log.warn("Bỏ qua dòng {} khi import: {}", i + 1, e.getMessage());
                    skipped++;
                }
            }
            if (rows.isEmpty() && skipped == 0) {
                throw ApiException.badRequest("File không có dữ liệu để import");
            }
            return new ParsedRates<>(rows, skipped);
        } catch (ApiException e) {
            throw e;
        } catch (IOException | org.apache.poi.openxml4j.exceptions.NotOfficeXmlFileException e) {
            throw ApiException.badRequest("File không đúng định dạng Excel (.xlsx/.xls)");
        } catch (Exception e) {
            log.error("Lỗi đọc file import", e);
            throw ApiException.badRequest("Không đọc được file, vui lòng kiểm tra lại định dạng");
        }
    }

    private IllegalArgumentException badRow(int rowNum, String reason) {
        return new IllegalArgumentException("Dòng " + (rowNum + 1) + ": " + reason);
    }

    private String text(Row row, int idx) {
        Cell cell = row.getCell(idx);
        if (cell == null) return "";
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue().trim();
            case NUMERIC -> {
                double d = cell.getNumericCellValue();
                yield d == Math.floor(d) ? String.valueOf((long) d) : String.valueOf(d);
            }
            case FORMULA -> cell.getCachedFormulaResultType() == CellType.STRING
                ? cell.getStringCellValue().trim() : "";
            default -> "";
        };
    }

    private BigDecimal decimal(Row row, int idx) {
        Cell cell = row.getCell(idx);
        if (cell == null) throw new IllegalArgumentException("thiếu cột số");
        return switch (cell.getCellType()) {
            case NUMERIC -> BigDecimal.valueOf(cell.getNumericCellValue());
            case STRING -> {
                String s = cell.getStringCellValue().replace(",", "").trim();
                try {
                    yield new BigDecimal(s);
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("giá trị số không hợp lệ: " + s);
                }
            }
            default -> throw new IllegalArgumentException("thiếu cột số");
        };
    }

    private double numeric(Row row, int idx) {
        return decimal(row, idx).doubleValue();
    }

    /** Chấp nhận Excel date (numeric), yyyy-MM-dd hoặc dd/MM/yyyy. */
    private LocalDate date(Row row, int idx) {
        Cell cell = row.getCell(idx);
        if (cell == null) return null;
        try {
            if (cell.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(cell)) {
                return cell.getDateCellValue().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            }
            String s = text(row, idx);
            if (s.isEmpty()) return null;
            if (s.matches("\\d{4}-\\d{2}-\\d{2}")) return LocalDate.parse(s);
            if (s.matches("\\d{1,2}/\\d{1,2}/\\d{4}")) {
                String[] p = s.split("/");
                return LocalDate.of(Integer.parseInt(p[2]), Integer.parseInt(p[1]), Integer.parseInt(p[0]));
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }
}
