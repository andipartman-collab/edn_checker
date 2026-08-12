import '../../features/scanner/scanner_controller.dart';

class ScannerEngine {
  final ScannerController controller;

  ScannerEngine(this.controller);

  //--------------------------------------------------
  // FILTER DOUBLE SCAN
  //--------------------------------------------------

  String _lastBarcode = "";
  DateTime? _lastScanTime;

  //--------------------------------------------------
  // BARCODE MASUK
  //--------------------------------------------------

  void onBarcode(String barcode) {
    barcode = barcode.trim();

    if (barcode.isEmpty) return;

    final now = DateTime.now();

    if (_lastBarcode == barcode &&
        _lastScanTime != null &&
        now.difference(_lastScanTime!).inMilliseconds < 300) {
      return;
    }

    _lastBarcode = barcode;
    _lastScanTime = now;

    controller.onBarcodeScanned(barcode);
  }

  //--------------------------------------------------
  // RESET
  //--------------------------------------------------

  void reset() {
    _lastBarcode = "";
    _lastScanTime = null;
  }
}