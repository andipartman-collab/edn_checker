import 'package:excel/excel.dart';

class EdnParser {
  /// ===============================
  /// Cari Sheet EDN
  /// ===============================
  Sheet? findEdnSheet(Excel excel) {
    for (final table in excel.tables.entries) {
      final sheet = table.value;

      for (final row in sheet.rows) {
        for (final cell in row) {
          final value = cell?.value.toString().trim() ?? "";

          if (value == "Part No.") {
            return sheet;
          }
        }
      }
    }

    return null;
  }

  /// ===============================
  /// Nama Sheet
  /// ===============================
  String? getSheetName(Excel excel, Sheet sheet) {
    for (final table in excel.tables.entries) {
      if (table.value == sheet) {
        return table.key;
      }
    }

    return null;
  }

  /// ===============================
  /// Cari Header
  /// ===============================
  int findHeaderRow(Sheet sheet) {
    for (int r = 0; r < sheet.rows.length; r++) {
      final row = sheet.rows[r];

      for (final cell in row) {
        final value = cell?.value.toString().trim() ?? "";

        if (value == "Part No.") {
          return r;
        }
      }
    }

    throw Exception("Header EDN tidak ditemukan");
  }

  /// ===============================
  /// Cari posisi semua kolom
  /// ===============================
  Map<String, int> findColumns(
    Sheet sheet,
    int headerRow,
  ) {
    final header = sheet.rows[headerRow];

    Map<String, int> columns = {};

    for (int c = 0; c < header.length; c++) {
      final value = header[c]?.value.toString().trim() ?? "";

      columns[value] = c;
    }

    return columns;
  }
}