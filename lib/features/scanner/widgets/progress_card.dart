import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/scanner_provider.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  // =============================================================
  // STATUS PNO
  // =============================================================

  static int _partStatus({
    required int scannedQty,
    required int targetQty,
  }) {
    if (scannedQty >= targetQty && targetQty > 0) {
      return 2; // SELESAI
    }

    if (scannedQty > 0) {
      return 1; // SEBAGIAN
    }

    return 0; // BELUM SCAN
  }

  // =============================================================
  // STATUS CASE
  // =============================================================

  static int _caseStatus({
    required int scannedPart,
    required int totalPart,
  }) {
    if (scannedPart >= totalPart && totalPart > 0) {
      return 2; // SELESAI
    }

    if (scannedPart > 0) {
      return 1; // SEBAGIAN
    }

    return 0; // BELUM SCAN
  }

  // =============================================================
  // DETAIL CASE
  // =============================================================

  void _showCaseDetail(
    BuildContext context,
    ScannerProvider provider,
  ) {
    final activeCase = provider.activeCase;

    if (activeCase == null) {
      _showMessage(
        context,
        'Belum ada CASE yang sedang diproses.',
      );

      return;
    }

    final parts = List.of(activeCase.parts);

    final lastScanPartNo =
        provider.lastScan?.partNo;

    // ===========================================================
    // SORTING
    //
    // 1. PNO yang sedang di-scan
    // 2. PNO belum selesai / sebagian
    // 3. PNO sudah selesai
    // ===========================================================

    parts.sort((a, b) {
      final aIsActive =
          lastScanPartNo != null &&
          a.partNo == lastScanPartNo;

      final bIsActive =
          lastScanPartNo != null &&
          b.partNo == lastScanPartNo;

      if (aIsActive && !bIsActive) {
        return -1;
      }

      if (!aIsActive && bIsActive) {
        return 1;
      }

      final aStatus = _partStatus(
        scannedQty: a.scannedQty,
        targetQty: a.targetQty,
      );

      final bStatus = _partStatus(
        scannedQty: b.scannedQty,
        targetQty: b.targetQty,
      );

      // Sebagian / belum scan lebih dulu
      // daripada yang sudah selesai.
      if (aStatus != bStatus) {
        return aStatus.compareTo(bStatus);
      }

      return 0;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(sheetContext).size.height *
                    0.75,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [

              // =================================================
              // HEADER
              // =================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  12,
                  14,
                ),
                child: Row(
                  children: [

                    Container(
                      padding:
                          const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.inventory_2,
                        color: Colors.red.shade700,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          const Text(
                            'DETAIL CASE',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            activeCase.caseNo,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // =================================================
              // PART LIST
              // =================================================

              Expanded(
                child: parts.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada PNO dalam CASE ini.',
                        ),
                      )
                    : ListView.separated(
                        padding:
                            const EdgeInsets.all(16),
                        itemCount: parts.length,
                        separatorBuilder:
                            (_, __) =>
                                const SizedBox(
                          height: 8,
                        ),
                        itemBuilder:
                            (context, index) {
                          final part =
                              parts[index];

                          final isActive =
                              lastScanPartNo != null &&
                              part.partNo ==
                                  lastScanPartNo;

                          final complete =
                              part.targetQty > 0 &&
                              part.scannedQty >=
                                  part.targetQty;

                          final partial =
                              part.scannedQty > 0 &&
                              !complete;

                          Color statusColor;
                          IconData statusIcon;
                          String statusText;

                          if (isActive) {
                            statusColor =
                                Colors.blue;
                            statusIcon =
                                Icons.qr_code_scanner;
                            statusText =
                                'SEDANG DI-SCAN';
                          } else if (complete) {
                            statusColor =
                                Colors.green;
                            statusIcon =
                                Icons.check_circle;
                            statusText =
                                'SELESAI';
                          } else if (partial) {
                            statusColor =
                                Colors.orange;
                            statusIcon =
                                Icons.timelapse;
                            statusText =
                                'SEBAGIAN';
                          } else {
                            statusColor =
                                Colors.red;
                            statusIcon =
                                Icons.circle_outlined;
                            statusText =
                                'BELUM SCAN';
                          }

                          return Container(
                            padding:
                                const EdgeInsets.all(
                              14,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  statusColor.withOpacity(
                                0.06,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                              border: Border.all(
                                color:
                                    statusColor.withOpacity(
                                  0.25,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [

                                Icon(
                                  statusIcon,
                                  color:
                                      statusColor,
                                  size: 24,
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        part.partNo,
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 4,
                                      ),

                                      Text(
                                        'Qty ${part.scannedQty} / ${part.targetQty}',
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  statusText,
                                  style: TextStyle(
                                    color:
                                        statusColor,
                                    fontSize: 10,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =============================================================
  // DETAIL EDN
  // =============================================================

  void _showEdnDetail(
    BuildContext context,
    ScannerProvider provider,
  ) {
    final edn = provider.currentEdn;

    if (edn == null) {
      _showMessage(
        context,
        'Belum ada EDN.',
      );

      return;
    }

    final cases = List.of(edn.cases);

    final activeCaseNo =
        provider.activeCase?.caseNo;

    // ===========================================================
    // SORTING
    //
    // 1. CASE aktif
    // 2. CASE belum selesai
    // 3. CASE selesai
    // ===========================================================

    cases.sort((a, b) {
      final aIsActive =
          activeCaseNo != null &&
          a.caseNo == activeCaseNo;

      final bIsActive =
          activeCaseNo != null &&
          b.caseNo == activeCaseNo;

      if (aIsActive && !bIsActive) {
        return -1;
      }

      if (!aIsActive && bIsActive) {
        return 1;
      }

      final aCompleted =
          a.parts.where(
        (part) =>
            part.targetQty > 0 &&
            part.scannedQty >=
                part.targetQty,
      ).length;

      final bCompleted =
          b.parts.where(
        (part) =>
            part.targetQty > 0 &&
            part.scannedQty >=
                part.targetQty,
      ).length;

      final aTotal =
          a.parts.length;

      final bTotal =
          b.parts.length;

      final aStatus = _caseStatus(
        scannedPart: aCompleted,
        totalPart: aTotal,
      );

      final bStatus = _caseStatus(
        scannedPart: bCompleted,
        totalPart: bTotal,
      );

      if (aStatus != bStatus) {
        return aStatus.compareTo(
          bStatus,
        );
      }

      return 0;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(sheetContext).size.height *
                    0.80,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [

              // =================================================
              // HEADER
              // =================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  12,
                  14,
                ),
                child: Row(
                  children: [

                    Container(
                      padding:
                          const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.local_shipping,
                        color: Colors.red.shade700,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            'DETAIL EDN',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 2),

                          Text(
                            'Progress Case',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // =================================================
              // CASE LIST
              // =================================================

              Expanded(
                child: cases.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada CASE dalam EDN.',
                        ),
                      )
                    : ListView.separated(
                        padding:
                            const EdgeInsets.all(16),
                        itemCount: cases.length,
                        separatorBuilder:
                            (_, __) =>
                                const SizedBox(
                          height: 8,
                        ),
                        itemBuilder:
                            (context, index) {
                          final caseModel =
                              cases[index];

                          final completedPart =
                              caseModel.parts
                                  .where(
                            (part) =>
                                part.targetQty > 0 &&
                                part.scannedQty >=
                                    part.targetQty,
                          )
                                  .length;

                          final totalPart =
                              caseModel.parts.length;

                          final scannedPart =
                              caseModel.parts
                                  .where(
                            (part) =>
                                part.scannedQty > 0,
                          )
                                  .length;

                          final isActive =
                              activeCaseNo != null &&
                              caseModel.caseNo ==
                                  activeCaseNo;

                          final isComplete =
                              totalPart > 0 &&
                              completedPart ==
                                  totalPart;

                          final hasProgress =
                              scannedPart > 0;

                          Color statusColor;
                          IconData statusIcon;
                          String statusText;

                          if (isActive) {
                            statusColor =
                                Colors.blue;
                            statusIcon =
                                Icons.qr_code_scanner;
                            statusText =
                                'SEDANG DI-SCAN';
                          } else if (isComplete) {
                            statusColor =
                                Colors.green;
                            statusIcon =
                                Icons.check_circle;
                            statusText =
                                'SELESAI';
                          } else if (hasProgress) {
                            statusColor =
                                Colors.orange;
                            statusIcon =
                                Icons.timelapse;
                            statusText =
                                'SEBAGIAN';
                          } else {
                            statusColor =
                                Colors.red;
                            statusIcon =
                                Icons.circle_outlined;
                            statusText =
                                'BELUM SCAN';
                          }

                          return Container(
                            padding:
                                const EdgeInsets.all(
                              14,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  statusColor.withOpacity(
                                0.06,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),
                              border: Border.all(
                                color:
                                    statusColor.withOpacity(
                                  0.25,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [

                                Icon(
                                  statusIcon,
                                  color:
                                      statusColor,
                                  size: 25,
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        'CASE ${caseModel.caseNo}',
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 4,
                                      ),

                                      Text(
                                        '$completedPart / $totalPart PNO',
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),

                                      if (scannedPart >
                                          completedPart)
                                        Text(
                                          '$scannedPart PNO sudah discan',
                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.grey,
                                            fontSize:
                                                11,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                Text(
                                  statusText,
                                  style: TextStyle(
                                    color:
                                        statusColor,
                                    fontSize: 10,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =============================================================
  // MESSAGE
  // =============================================================

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (context, provider, child) {
        return Card(
          elevation: 3,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            child: Row(
              children: [

                // =================================================
                // CASE
                // =================================================

                Expanded(
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(12),
                    onTap: () {
                      _showCaseDetail(
                        context,
                        provider,
                      );
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      child: Column(
                        children: [

                          const Icon(
                            Icons.inventory_2,
                            color: Colors.red,
                            size: 28,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            '${provider.completedPart} / '
                            '${provider.totalPart} PNO',
                            style:
                                const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // =================================================
                // PEMBATAS
                // =================================================

                Container(
                  width: 1,
                  height: 70,
                  color:
                      Colors.grey.shade300,
                ),

                // =================================================
                // EDN
                // =================================================

                Expanded(
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(12),
                    onTap: () {
                      _showEdnDetail(
                        context,
                        provider,
                      );
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      child: Column(
                        children: [

                          const Icon(
                            Icons.local_shipping,
                            color: Colors.red,
                            size: 28,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            '${provider.completedCase} / '
                            '${provider.totalCase} CASE',
                            style:
                                const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}