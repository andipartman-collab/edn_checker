import 'package:excel/excel.dart';

import '../../models/case_model.dart';
import '../../models/edn_model.dart';
import '../../models/part_model.dart';
import 'edn_parser.dart';

class EdnReader {
  final EdnParser parser = EdnParser();

  EdnModel read(
    Excel excel,
    String fileName,
  ) {
    //---------------------------------
    // Cari Sheet EDN
    //---------------------------------

    final sheet = parser.findEdnSheet(excel);

    if (sheet == null) {
      throw Exception("Sheet EDN tidak ditemukan");
    }

    //---------------------------------
    // Header
    //---------------------------------

    final headerRow = parser.findHeaderRow(sheet);

    final columns = parser.findColumns(
      sheet,
      headerRow,
    );

    //---------------------------------
    // Ambil index kolom
    //---------------------------------

    final caseCol = columns["Shipping Case"];
    final partCol = columns["Part No."];
    final partNameCol = columns["Part Name"];
    final qtyCol = columns["Shipped Qty"];

    if (caseCol == null ||
        partCol == null ||
        partNameCol == null ||
        qtyCol == null) {
      throw Exception("Kolom EDN tidak lengkap.");
    }

    //---------------------------------
    // Temp Storage
    //---------------------------------

    final Map<String, Map<String, _PartTemp>> caseMap = {};

    //---------------------------------
    // Baca seluruh baris
    //---------------------------------

    for (int r = headerRow + 1; r < sheet.rows.length; r++) {
      final row = sheet.rows[r];

      if (row.length <= qtyCol) continue;

      final caseNo =
          row[caseCol]?.value.toString().trim() ?? "";

      final partNo =
          row[partCol]?.value.toString().trim() ?? "";

      final partName =
          row[partNameCol]?.value.toString().trim() ?? "";

      final qtyText =
          row[qtyCol]?.value.toString().trim() ?? "0";

      //---------------------------------
      // Lewati data kosong / null
      //---------------------------------

      if (caseNo.isEmpty ||
          caseNo.toLowerCase() == "null" ||
          partNo.isEmpty ||
          partNo.toLowerCase() == "null") {
        continue;
      }

      //---------------------------------
      // Qty
      //---------------------------------

      final qty =
          int.tryParse(qtyText.replaceAll(".0", "")) ?? 0;

      //---------------------------------
      // CASE
      //---------------------------------

      caseMap.putIfAbsent(caseNo, () => {});

      //---------------------------------
      // Merge Part Number
      //---------------------------------

      if (caseMap[caseNo]!.containsKey(partNo)) {
        caseMap[caseNo]![partNo]!.qty += qty;
      } else {
        caseMap[caseNo]![partNo] = _PartTemp(
          partNo: partNo,
          partName: partName,
          qty: qty,
        );
      }
    }

    //---------------------------------
    // Convert ke CaseModel
    //---------------------------------

    final List<CaseModel> cases = [];

    caseMap.forEach((caseNo, partsMap) {
      final List<PartModel> parts = [];

      for (final item in partsMap.values) {
        parts.add(
          PartModel(
            partNo: item.partNo,
            partName: item.partName,
            targetQty: item.qty,
          ),
        );
      }

      cases.add(
        CaseModel(
          caseNo: caseNo,
          parts: parts,
        ),
      );
    });

    //---------------------------------
    // Return
    //---------------------------------

    return EdnModel(
      fileName: fileName,
      cases: cases,
    );
  }
}

class _PartTemp {
  final String partNo;
  final String partName;

  int qty;

  _PartTemp({
    required this.partNo,
    required this.partName,
    required this.qty,
  });
}