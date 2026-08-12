import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/case_model.dart';
import '../../models/part_model.dart';
import '../../providers/scanner_provider.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          'Monitoring',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Consumer<ScannerProvider>(
        builder: (context, provider, child) {
          final edn = provider.currentEdn;

          // ---------------------------------
          // BELUM ADA EDN
          // ---------------------------------

          if (edn == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),

                    SizedBox(height: 16),

                    Text(
                      'Belum ada EDN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Silakan upload EDN terlebih dahulu.',
                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ---------------------------------
          // SORT CASE
          // BELUM SELESAI -> ATAS
          // SELESAI -> BAWAH
          // ---------------------------------

          final unfinishedCases = edn.cases
              .where(
                (item) => !item.isComplete,
              )
              .toList();

          final finishedCases = edn.cases
              .where(
                (item) => item.isComplete,
              )
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
              provider.refresh();
            },

            child: ListView(
              padding:
                  const EdgeInsets.all(16),

              children: [

                // =================================
                // EDN FILE
                // =================================

                _EdnFileCard(
                  fileName: edn.fileName,
                ),

                const SizedBox(height: 12),

                // =================================
                // PROGRESS EDN
                // =================================

                _EdnProgressCard(
                  completedCase:
                      edn.completedCase,
                  totalCase:
                      edn.totalCase,

                  completedPart:
                      edn.completedPartNumber,
                  totalPart:
                      edn.totalPartNumber,

                  scannedQty:
                      edn.totalScanned,
                  targetQty:
                      edn.totalTarget,

                  progress:
                      edn.progress,
                ),

                const SizedBox(height: 12),

                // =================================
                // CASE AKTIF
                // =================================

                if (provider.activeCase != null)
                  _ActiveCaseCard(
                    caseModel:
                        provider.activeCase!,
                  ),

                if (provider.activeCase != null)
                  const SizedBox(height: 12),

                // =================================
                // CASE BELUM SELESAI
                // =================================

                if (unfinishedCases.isNotEmpty)
                  _CaseSection(
                    title:
                        'Case Belum Selesai',

                    cases:
                        unfinishedCases,
                  ),

                // =================================
                // CASE SELESAI
                // =================================

                if (finishedCases.isNotEmpty)
                  const SizedBox(height: 12),

                if (finishedCases.isNotEmpty)
                  _CaseSection(
                    title:
                        'Case Selesai',

                    cases:
                        finishedCases,
                  ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// =================================================
// EDN FILE CARD
// =================================================

class _EdnFileCard extends StatelessWidget {
  final String fileName;

  const _EdnFileCard({
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Row(
          children: [

            const Icon(
              Icons.description_outlined,
              size: 32,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    'EDN',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    fileName,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================
// EDN PROGRESS CARD
// =================================================

class _EdnProgressCard extends StatelessWidget {
  final int completedCase;
  final int totalCase;

  final int completedPart;
  final int totalPart;

  final int scannedQty;
  final int targetQty;

  final double progress;

  const _EdnProgressCard({
    required this.completedCase,
    required this.totalCase,
    required this.completedPart,
    required this.totalPart,
    required this.scannedQty,
    required this.targetQty,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Progress EDN',
              style: TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Expanded(
                  child: _ProgressNumber(
                    title: 'CASE',
                    current:
                        completedCase,
                    total:
                        totalCase,
                  ),
                ),

                Expanded(
                  child: _ProgressNumber(
                    title: 'PNO',
                    current:
                        completedPart,
                    total:
                        totalPart,
                  ),
                ),

                Expanded(
                  child: _ProgressNumber(
                    title: 'QTY',
                    current:
                        scannedQty,
                    total:
                        targetQty,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            LinearProgressIndicator(
              value:
                  progress.clamp(0.0, 1.0),

              minHeight: 8,

              borderRadius:
                  BorderRadius.circular(10),
            ),

            const SizedBox(height: 8),

            Align(
              alignment:
                  Alignment.centerRight,

              child: Text(
                '${(progress * 100).toStringAsFixed(0)}%',

                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================
// PROGRESS NUMBER
// =================================================

class _ProgressNumber extends StatelessWidget {
  final String title;
  final int current;
  final int total;

  const _ProgressNumber({
    required this.title,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          '$current / $total',

          style: const TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// =================================================
// ACTIVE CASE
// =================================================

class _ActiveCaseCard extends StatelessWidget {
  final CaseModel caseModel;

  const _ActiveCaseCard({
    required this.caseModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Case Aktif',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              caseModel.caseNo,

              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [

                Expanded(
                  child: _ProgressNumber(
                    title: 'PNO',
                    current:
                        caseModel.completedPart,
                    total:
                        caseModel.totalPart,
                  ),
                ),

                Expanded(
                  child: _ProgressNumber(
                    title: 'QTY',
                    current:
                        caseModel.totalScanned,
                    total:
                        caseModel.totalTarget,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================
// CASE SECTION
// =================================================

class _CaseSection extends StatelessWidget {
  final String title;
  final List<CaseModel> cases;

  const _CaseSection({
    required this.title,
    required this.cases,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              title,

              style: const TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...cases.map(
              (caseModel) {
                return _CaseTile(
                  caseModel: caseModel,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================
// CASE TILE
// =================================================

class _CaseTile extends StatelessWidget {
  final CaseModel caseModel;

  const _CaseTile({
    required this.caseModel,
  });

  @override
  Widget build(BuildContext context) {
    final complete =
        caseModel.isComplete;

    return InkWell(
      borderRadius:
          BorderRadius.circular(10),

      onTap: () {
        showModalBottomSheet(
          context: context,

          isScrollControlled: true,

          builder: (context) {
            return _CaseDetailSheet(
              caseModel: caseModel,
            );
          },
        );
      },

      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          vertical: 11,
        ),

        child: Row(
          children: [

            Icon(
              complete
                  ? Icons.check_circle
                  : Icons
                      .radio_button_unchecked,

              color: complete
                  ? Colors.green
                  : Colors.grey,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                caseModel.caseNo,

                style: const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            Text(
              '${caseModel.completedPart}/${caseModel.totalPart}',

              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(width: 4),

            const Text(
              'PNO',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================
// CASE DETAIL
// =================================================

class _CaseDetailSheet extends StatelessWidget {
  final CaseModel caseModel;

  const _CaseDetailSheet({
    required this.caseModel,
  });

  @override
  Widget build(BuildContext context) {

    // ---------------------------------
    // BELUM SELESAI -> ATAS
    // SELESAI -> BAWAH
    // ---------------------------------

    final unfinishedParts =
        caseModel.parts
            .where(
              (part) =>
                  part.scannedQty <
                  part.targetQty,
            )
            .toList();

    final finishedParts =
        caseModel.parts
            .where(
              (part) =>
                  part.scannedQty >=
                  part.targetQty,
            )
            .toList();

    final sortedParts = [
      ...unfinishedParts,
      ...finishedParts,
    ];

    return SafeArea(
      child: SizedBox(
        height:
            MediaQuery.of(context)
                    .size
                    .height *
                0.80,

        child: Column(
          children: [

            // ---------------------------------
            // HEADER
            // ---------------------------------

            Padding(
              padding:
                  const EdgeInsets.all(16),

              child: Row(
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(
                          'Shipping Case',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          caseModel.caseNo,

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

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ---------------------------------
            // CASE SUMMARY
            // ---------------------------------

            Padding(
              padding:
                  const EdgeInsets.all(16),

              child: Row(
                children: [

                  Expanded(
                    child:
                        _ProgressNumber(
                      title: 'PNO',
                      current:
                          caseModel.completedPart,
                      total:
                          caseModel.totalPart,
                    ),
                  ),

                  Expanded(
                    child:
                        _ProgressNumber(
                      title: 'QTY',
                      current:
                          caseModel.totalScanned,
                      total:
                          caseModel.totalTarget,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ---------------------------------
            // PNO LIST
            // ---------------------------------

            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.all(16),

                itemCount:
                    sortedParts.length,

                itemBuilder:
                    (context, index) {

                  final part =
                      sortedParts[index];

                  final complete =
                      part.scannedQty >=
                          part.targetQty;

                  return _PartTile(
                    part: part,
                    complete:
                        complete,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================
// PART TILE
// =================================================

class _PartTile extends StatelessWidget {
  final PartModel part;
  final bool complete;

  const _PartTile({
    required this.part,
    required this.complete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,

      child: ListTile(

        leading: Icon(
          complete
              ? Icons.check_circle
              : Icons
                  .radio_button_unchecked,

          color: complete
              ? Colors.green
              : Colors.grey,
        ),

        title: Text(
          part.partNo,

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        trailing: Text(
          '${part.scannedQty} / ${part.targetQty}',

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }
}