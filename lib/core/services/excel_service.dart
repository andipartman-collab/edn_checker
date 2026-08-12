import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class ExcelService {
  Future<Map<String, dynamic>?> pickAndReadExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result == null) return null;

    File file = File(result.files.single.path!);

    final bytes = file.readAsBytesSync();

    final excel = Excel.decodeBytes(bytes);

    return {
      "fileName": result.files.single.name,
      "sheetCount": excel.tables.length,
      "sheetNames": excel.tables.keys.toList(),
      "excel": excel,
    };
  }
}