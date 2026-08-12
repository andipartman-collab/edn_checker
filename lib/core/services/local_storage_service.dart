import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:edn_checker/models/case_model.dart';
import 'package:edn_checker/models/edn_model.dart';
import 'package:edn_checker/models/part_model.dart';

class LocalStorageService {
  static const String _ednKey = 'saved_edn';

  // ==========================================
  // SAVE EDN
  // ==========================================

  Future<void> saveEdn(EdnModel edn) async {
    final prefs = await SharedPreferences.getInstance();

    final data = {
      'fileName': edn.fileName,
      'cases': edn.cases.map((caseModel) {
        return {
          'caseNo': caseModel.caseNo,
          'parts': caseModel.parts.map((part) {
            return {
              'partNo': part.partNo,
              'partName': part.partName,
              'targetQty': part.targetQty,
              'scannedQty': part.scannedQty,
            };
          }).toList(),
        };
      }).toList(),
    };

    await prefs.setString(
      _ednKey,
      jsonEncode(data),
    );
  }

  // ==========================================
  // LOAD EDN
  // ==========================================

  Future<EdnModel?> loadEdn() async {
    final prefs = await SharedPreferences.getInstance();

    final savedData = prefs.getString(_ednKey);

    if (savedData == null) {
      return null;
    }

    try {
      final Map<String, dynamic> data =
          jsonDecode(savedData);

      final List<dynamic> casesData =
          data['cases'] ?? [];

      final List<CaseModel> cases =
          casesData.map((caseData) {
        final List<dynamic> partsData =
            caseData['parts'] ?? [];

        final List<PartModel> parts =
            partsData.map((partData) {
          return PartModel(
            partNo: partData['partNo'] ?? '',
            partName: partData['partName'] ?? '',
            targetQty: partData['targetQty'] ?? 0,
            scannedQty: partData['scannedQty'] ?? 0,
          );
        }).toList();

        return CaseModel(
          caseNo: caseData['caseNo'] ?? '',
          parts: parts,
        );
      }).toList();

      return EdnModel(
        fileName: data['fileName'] ?? '',
        cases: cases,
      );
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // CLEAR EDN
  // ==========================================

  Future<void> clearEdn() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_ednKey);
  }
}