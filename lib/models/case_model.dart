import 'part_model.dart';

class CaseModel {
  final String caseNo;

  final List<PartModel> parts;

  CaseModel({
    required this.caseNo,
    required this.parts,
  });

  // ---------------------------------
  // TOTAL PNO
  // ---------------------------------

  int get totalPart => parts.length;

  // ---------------------------------
  // PNO YANG SUDAH SELESAI
  // ---------------------------------

  int get completedPart {
    return parts.where(
      (item) => item.scannedQty >= item.targetQty,
    ).length;
  }

  // ---------------------------------
  // TOTAL TARGET QTY
  // ---------------------------------

  int get totalTarget {
    return parts.fold(
      0,
      (sum, item) => sum + item.targetQty,
    );
  }

  // ---------------------------------
  // TOTAL SCANNED QTY
  // ---------------------------------

  int get totalScanned {
    return parts.fold(
      0,
      (sum, item) => sum + item.scannedQty,
    );
  }

  // ---------------------------------
  // REMAINING QTY
  // ---------------------------------

  int get remainingQty {
    return totalTarget - totalScanned;
  }

  // ---------------------------------
  // PROGRESS QTY
  // ---------------------------------

  double get progress {
    return totalTarget == 0
        ? 0
        : totalScanned / totalTarget;
  }

  // ---------------------------------
  // PROGRESS PNO
  // ---------------------------------

  double get partProgress {
    return totalPart == 0
        ? 0
        : completedPart / totalPart;
  }

  // ---------------------------------
  // CASE COMPLETE
  // ---------------------------------

  bool get isComplete {
    return totalScanned >= totalTarget;
  }
}