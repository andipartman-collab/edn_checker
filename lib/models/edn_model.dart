import 'case_model.dart';

class EdnModel {
  final String fileName;

  final List<CaseModel> cases;

  EdnModel({
    required this.fileName,
    required this.cases,
  });

  // ---------------------------------
  // TOTAL SHIPPING CASE
  // ---------------------------------

  int get totalCase {
    return cases.length;
  }

  // ---------------------------------
  // CASE SELESAI
  // ---------------------------------

  int get completedCase {
    return cases.where(
      (item) => item.isComplete,
    ).length;
  }

  // ---------------------------------
  // TOTAL PNO UNIK
  // ---------------------------------

  int get totalPartNumber {
    final Set<String> partNumbers = {};

    for (final caseModel in cases) {
      for (final part in caseModel.parts) {
        partNumbers.add(part.partNo);
      }
    }

    return partNumbers.length;
  }

  // ---------------------------------
  // TOTAL PNO SELESAI
  // ---------------------------------

  int get completedPartNumber {
    int result = 0;

    for (final caseModel in cases) {
      result += caseModel.completedPart;
    }

    return result;
  }

  // ---------------------------------
  // TOTAL TARGET QTY
  // ---------------------------------

  int get totalTarget {
    return cases.fold(
      0,
      (sum, item) => sum + item.totalTarget,
    );
  }

  // ---------------------------------
  // TOTAL SCANNED QTY
  // ---------------------------------

  int get totalScanned {
    return cases.fold(
      0,
      (sum, item) => sum + item.totalScanned,
    );
  }

  // ---------------------------------
  // REMAINING QTY
  // ---------------------------------

  int get remainingQty {
    return totalTarget - totalScanned;
  }

  // ---------------------------------
  // PROGRESS EDN
  // ---------------------------------

  double get progress {
    return totalTarget == 0
        ? 0
        : totalScanned / totalTarget;
  }
}