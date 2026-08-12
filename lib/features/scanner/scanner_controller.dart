import 'package:edn_checker/core/enums/scanner_status.dart';
import 'package:edn_checker/core/services/scanner_sound_service.dart';
import 'package:edn_checker/models/case_model.dart';
import 'package:edn_checker/models/part_model.dart';
import 'package:edn_checker/providers/scanner_provider.dart';

class ScannerController {
  final ScannerProvider provider;

  final ScannerSoundService _soundService =
      ScannerSoundService();

  ScannerController(this.provider);

  //---------------------------------
  // BARCODE MASUK
  //---------------------------------

  Future<void> onBarcodeScanned(String barcode) async {
    final cleanedBarcode = _cleanBarcode(barcode);

    if (cleanedBarcode.isEmpty) return;

    //---------------------------------
    // 1. COBA CARI CASE
    //---------------------------------

    final CaseModel? caseModel =
        _findCaseSmart(cleanedBarcode);

    if (caseModel != null) {
      _scanCase(caseModel);
      return;
    }

    //---------------------------------
    // 2. COBA CARI PART
    //---------------------------------

    await _scanPart(cleanedBarcode);
  }

  //---------------------------------
  // BERSIHKAN BARCODE
  //---------------------------------

  String _cleanBarcode(String barcode) {
    return barcode
        .trim()
        .toUpperCase()
        .replaceAll(RegExp(r'\s+'), '');
  }

  //---------------------------------
  // SMART FIND CASE
  //---------------------------------

  CaseModel? _findCaseSmart(String barcode) {
    final edn = provider.currentEdn;

    if (edn == null) {
      return null;
    }

    //---------------------------------
    // EXACT MATCH
    //---------------------------------

    for (final caseModel in edn.cases) {
      final caseNo =
          _cleanBarcode(caseModel.caseNo);

      if (barcode == caseNo) {
        return caseModel;
      }
    }

    //---------------------------------
    // PREFIX MATCH
    //---------------------------------

    final List<CaseModel> candidates = [];

    for (final caseModel in edn.cases) {
      final caseNo =
          _cleanBarcode(caseModel.caseNo);

      if (barcode.startsWith(caseNo)) {
        final extraLength =
            barcode.length - caseNo.length;

        //---------------------------------
        // MAKSIMAL 2 KARAKTER TAMBAHAN
        //---------------------------------

        if (extraLength > 0 &&
            extraLength <= 2) {
          candidates.add(caseModel);
        }
      }
    }

    //---------------------------------
    // HANYA TERIMA JIKA UNIK
    //---------------------------------

    if (candidates.length == 1) {
      return candidates.first;
    }

    return null;
  }

  //---------------------------------
  // SMART FIND PART
  //---------------------------------

  PartModel? _findPartSmart(String barcode) {
    final activeCase = provider.activeCase;

    if (activeCase == null) {
      return null;
    }

    //---------------------------------
    // EXACT MATCH
    //---------------------------------

    for (final part in activeCase.parts) {
      final partNo =
          _cleanBarcode(part.partNo);

      if (barcode == partNo) {
        return part;
      }
    }

    //---------------------------------
    // PREFIX MATCH
    //---------------------------------

    final List<PartModel> candidates = [];

    for (final part in activeCase.parts) {
      final partNo =
          _cleanBarcode(part.partNo);

      if (barcode.startsWith(partNo)) {
        final extraLength =
            barcode.length - partNo.length;

        //---------------------------------
        // MAKSIMAL 2 KARAKTER TAMBAHAN
        //---------------------------------

        if (extraLength > 0 &&
            extraLength <= 2) {
          candidates.add(part);
        }
      }
    }

    //---------------------------------
    // HANYA TERIMA JIKA UNIK
    //---------------------------------

    if (candidates.length == 1) {
      return candidates.first;
    }

    return null;
  }

  //---------------------------------
  // SCAN CASE
  //---------------------------------

  void _scanCase(CaseModel caseModel) {
    provider.setActiveCase(caseModel);

    provider.setStatus(
      ScannerStatus.caseChanged,
    );

    //---------------------------------
    // SUARA BERHASIL
    //---------------------------------

    _soundService.playSuccess();
  }

  //---------------------------------
  // SCAN PART
  //---------------------------------

  Future<void> _scanPart(String partNo) async {
    //---------------------------------
    // BELUM ADA CASE
    //---------------------------------

    if (provider.activeCase == null) {
      provider.setStatus(
        ScannerStatus.noActiveCase,
      );

      return;
    }

    //---------------------------------
    // CARI PART
    //---------------------------------

    final PartModel? part =
        _findPartSmart(partNo);

    //---------------------------------
    // PART TIDAK DITEMUKAN
    //---------------------------------

    if (part == null) {
      provider.setStatus(
        ScannerStatus.partNotFound,
      );

      return;
    }

    //---------------------------------
    // QTY SUDAH PENUH
    //---------------------------------

    if (part.isComplete) {
      provider.setStatus(
        ScannerStatus.qtyFull,
      );

      return;
    }

    //---------------------------------
    // AUTO FULL QTY
    //---------------------------------

    if (provider.autoFullQty) {
      part.completeQty();
    } else {
      //---------------------------------
      // SCAN NORMAL
      //---------------------------------

      part.addScan();
    }

    //---------------------------------
    // SIMPAN LAST SCAN
    //---------------------------------

    provider.setLastScan(part);

    //---------------------------------
    // SUARA BERHASIL
    //---------------------------------

    _soundService.playSuccess();

    //---------------------------------
    // REFRESH UI
    //---------------------------------

    provider.refresh();

    //---------------------------------
    // SIMPAN PROGRESS KE HP
    //---------------------------------

    await provider.saveProgress();

    //---------------------------------
    // CEK CASE SELESAI
    //---------------------------------

    if (provider.activeCase!.isComplete) {
      provider.setStatus(
        ScannerStatus.caseCompleted,
      );
    } else {
      provider.setStatus(
        ScannerStatus.partScanned,
      );
    }
  }
}