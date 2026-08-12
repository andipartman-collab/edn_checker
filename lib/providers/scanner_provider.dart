import 'package:flutter/material.dart';

import '../core/enums/scanner_status.dart';
import '../core/services/local_storage_service.dart';
import '../models/case_model.dart';
import '../models/edn_model.dart';
import '../models/part_model.dart';

class ScannerProvider extends ChangeNotifier {
  //---------------------------------
  // STORAGE
  //---------------------------------

  final LocalStorageService _storage =
      LocalStorageService();

  //---------------------------------
  // EDN
  //---------------------------------

  EdnModel? _currentEdn;

  EdnModel? get currentEdn => _currentEdn;

  bool get hasEdn => _currentEdn != null;

  //---------------------------------
  // ACTIVE CASE
  //---------------------------------

  CaseModel? _activeCase;

  CaseModel? get activeCase => _activeCase;

  //---------------------------------
  // LAST SCAN
  //---------------------------------

  PartModel? _lastScan;

  PartModel? get lastScan => _lastScan;

  //---------------------------------
  // STATUS
  //---------------------------------

  ScannerStatus _status =
      ScannerStatus.idle;

  ScannerStatus get status => _status;

  //---------------------------------
  // AUTO FULL QTY
  //---------------------------------

  bool _autoFullQty = false;

  bool get autoFullQty => _autoFullQty;

  void setAutoFullQty(bool value) {
    _autoFullQty = value;

    notifyListeners();
  }

  //---------------------------------
  // SET EDN BARU
  //---------------------------------

  Future<void> setEdn(EdnModel edn) async {
    //---------------------------------
    // HAPUS DATA EDN LAMA
    //---------------------------------

    await _storage.clearEdn();

    //---------------------------------
    // PASANG EDN BARU
    //---------------------------------

    _currentEdn = edn;
    _activeCase = null;
    _lastScan = null;
    _status = ScannerStatus.idle;

    //---------------------------------
    // AUTO FULL QTY OFF
    //---------------------------------

    _autoFullQty = false;

    //---------------------------------
    // SIMPAN EDN BARU
    //---------------------------------

    await _storage.saveEdn(edn);

    notifyListeners();
  }

  //---------------------------------
  // LOAD EDN TERSIMPAN
  //---------------------------------

  Future<void> loadSavedEdn() async {
    final savedEdn =
        await _storage.loadEdn();

    if (savedEdn == null) {
      return;
    }

    //---------------------------------
    // RESTORE EDN
    //---------------------------------

    _currentEdn = savedEdn;

    _activeCase = null;
    _lastScan = null;
    _status = ScannerStatus.idle;

    //---------------------------------
    // AUTO FULL QTY OFF
    //---------------------------------

    _autoFullQty = false;

    notifyListeners();
  }

  //---------------------------------
  // CLEAR EDN
  //---------------------------------

  Future<void> clearEdn() async {
    //---------------------------------
    // HAPUS STORAGE
    //---------------------------------

    await _storage.clearEdn();

    //---------------------------------
    // RESET MEMORY
    //---------------------------------

    _currentEdn = null;
    _activeCase = null;
    _lastScan = null;
    _status = ScannerStatus.idle;

    //---------------------------------
    // RESET AUTO FULL QTY
    //---------------------------------

    _autoFullQty = false;

    notifyListeners();
  }

  //---------------------------------
  // SAVE PROGRESS
  //---------------------------------

  Future<void> saveProgress() async {
    if (_currentEdn == null) {
      return;
    }

    await _storage.saveEdn(
      _currentEdn!,
    );
  }

  //---------------------------------
  // ACTIVE CASE
  //---------------------------------

  void setActiveCase(
    CaseModel caseModel,
  ) {
    _activeCase = caseModel;

    notifyListeners();
  }

  //---------------------------------
  // LAST SCAN
  //---------------------------------

  void setLastScan(
    PartModel part,
  ) {
    _lastScan = part;

    notifyListeners();
  }

  //---------------------------------
  // STATUS
  //---------------------------------

  void setStatus(
    ScannerStatus status,
  ) {
    _status = status;

    notifyListeners();
  }

  //---------------------------------
  // REFRESH
  //---------------------------------

  void refresh() {
    notifyListeners();
  }

  //---------------------------------
  // FIND CASE
  //---------------------------------

  CaseModel? findCase(
    String caseNo,
  ) {
    if (_currentEdn == null) {
      return null;
    }

    try {
      return _currentEdn!.cases.firstWhere(
        (e) => e.caseNo == caseNo,
      );
    } catch (_) {
      return null;
    }
  }

  //---------------------------------
  // FIND PART
  //---------------------------------

  PartModel? findPart(
    String partNo,
  ) {
    if (_activeCase == null) {
      return null;
    }

    try {
      return _activeCase!.parts.firstWhere(
        (e) => e.partNo == partNo,
      );
    } catch (_) {
      return null;
    }
  }

  //---------------------------------
  // EDN PROGRESS
  //---------------------------------

  double get ednProgress =>
      _currentEdn?.progress ?? 0;

  int get completedCase =>
      _currentEdn?.completedCase ?? 0;

  int get totalCase =>
      _currentEdn?.totalCase ?? 0;

  //---------------------------------
  // ACTIVE CASE - PART NUMBER
  //---------------------------------

  int get completedPart =>
      _activeCase?.completedPart ?? 0;

  int get totalPart =>
      _activeCase?.totalPart ?? 0;

  //---------------------------------
  // QTY PROGRESS
  //---------------------------------

  double get caseProgress =>
      _activeCase?.progress ?? 0;

  int get caseScanned =>
      _activeCase?.totalScanned ?? 0;

  int get caseTarget =>
      _activeCase?.totalTarget ?? 0;
}