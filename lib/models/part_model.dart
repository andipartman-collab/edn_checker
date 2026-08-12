class PartModel {
  final String partNo;
  final String partName;
  final int targetQty;

  int scannedQty;

  PartModel({
    required this.partNo,
    required this.partName,
    required this.targetQty,
    this.scannedQty = 0,
  });

  bool get isComplete => scannedQty >= targetQty;

  int get remainingQty => targetQty - scannedQty;

  double get progress =>
      targetQty == 0 ? 0 : scannedQty / targetQty;

  // Scan normal: tambah 1
  void addScan() {
    if (scannedQty < targetQty) {
      scannedQty++;
    }
  }

  // Auto Full Qty: langsung penuh sesuai target
  void completeQty() {
    scannedQty = targetQty;
  }

  void removeScan() {
    if (scannedQty > 0) {
      scannedQty--;
    }
  }

  void reset() {
    scannedQty = 0;
  }
}