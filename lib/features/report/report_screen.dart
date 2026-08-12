import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../models/case_model.dart';
import '../../models/part_model.dart';
import '../../providers/scanner_provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          'Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Consumer<ScannerProvider>(
        builder: (context, provider, child) {
          final edn = provider.currentEdn;

          if (edn == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
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
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // =====================================================
          // HITUNG DATA
          // =====================================================

          final List<_Discrepancy> discrepancies = [];

          int completedPart = 0;
          int totalPart = 0;

          for (final caseModel in edn.cases) {
            totalPart += caseModel.parts.length;

            for (final part in caseModel.parts) {
              if (part.scannedQty == part.targetQty) {
                completedPart++;
              }

              final difference =
                  part.scannedQty -
                  part.targetQty;

              if (difference != 0) {
                discrepancies.add(
                  _Discrepancy(
                    caseNo: caseModel.caseNo,
                    partNo: part.partNo,
                    targetQty: part.targetQty,
                    scannedQty: part.scannedQty,
                    difference: difference,
                  ),
                );
              }
            }
          }

          final bool isComplete =
              discrepancies.isEmpty &&
              edn.completedCase ==
                  edn.totalCase;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // =================================================
                // JUDUL
                // =================================================

                const _ReportTitle(),

                const SizedBox(height: 16),

                // =================================================
                // EDN INFO
                // =================================================

                _EdnInfoCard(
                  fileName: edn.fileName,
                ),

                const SizedBox(height: 16),

                // =================================================
                // PERNYATAAN
                // =================================================

                const _StatementCard(),

                const SizedBox(height: 16),

                // =================================================
                // HASIL
                // =================================================

                _ResultCard(
                  isComplete: isComplete,
                ),

                const SizedBox(height: 16),

                // =================================================
                // SUMMARY
                // =================================================

                _SummaryCard(
                  totalCase: edn.totalCase,
                  completedCase:
                      edn.completedCase,

                  totalPart: totalPart,
                  completedPart:
                      completedPart,

                  totalQty: edn.totalTarget,
                  scannedQty:
                      edn.totalScanned,

                  discrepancies:
                      discrepancies.length,
                ),

                // =================================================
                // KETIDAKSESUAIAN
                // =================================================

                if (discrepancies.isNotEmpty) ...[
                  const SizedBox(height: 16),

                  _DiscrepancyCard(
                    discrepancies:
                        discrepancies,
                  ),
                ],

                const SizedBox(height: 24),

                // =================================================
                // DETAIL
                // =================================================

                const Text(
                  'DETAIL PENGECEKAN',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ...edn.cases.map(
                  (caseModel) {
                    return _CaseReportCard(
                      caseModel: caseModel,
                    );
                  },
                ),

                const SizedBox(height: 24),

                // =================================================
                // EXPORT PDF
                // =================================================

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _exportPdf(
                        context: context,
                        edn: edn,
                        completedPart:
                            completedPart,
                        totalPart:
                            totalPart,
                        discrepancies:
                            discrepancies,
                        isComplete:
                            isComplete,
                      );
                    },

                    icon: const Icon(
                      Icons.picture_as_pdf,
                    ),

                    label: const Text(
                      'EXPORT PDF',
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // =============================================================
  // EXPORT PDF
  // =============================================================

  static Future<void> _exportPdf({
    required BuildContext context,
    required dynamic edn,
    required int completedPart,
    required int totalPart,
    required List<_Discrepancy>
        discrepancies,
    required bool isComplete,
  }) async {
    try {
      final pdf =
          pw.Document();

      final now =
          DateTime.now();

      final date =
          '${now.day.toString().padLeft(2, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.year}';

      final time =
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}';

      // =========================================================
      // PAGE 1
      // =========================================================

      pdf.addPage(
        pw.MultiPage(
          pageFormat:
              PdfPageFormat.a4,

          margin:
              const pw.EdgeInsets.all(36),

          footer: (context) {
            return pw.Align(
              alignment:
                  pw.Alignment.centerRight,

              child: pw.Text(
                'Halaman ${context.pageNumber}',
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),
            );
          },

          build: (context) {
            return [

              // -------------------------------------------------
              // TITLE
              // -------------------------------------------------

              pw.Center(
                child: pw.Text(
                  'BERITA ACARA PENERIMAAN BARANG\n'
                  'KIRIMAN DARI EKSPEDISI',

                  textAlign:
                      pw.TextAlign.center,

                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight:
                        pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 16),

              // -------------------------------------------------
              // DEALER / EDN
              // -------------------------------------------------

              pw.Container(
                width:
                    double.infinity,

                padding:
                    const pw.EdgeInsets.all(12),

                decoration:
                    pw.BoxDecoration(
                  border:
                      pw.Border.all(
                    color:
                        PdfColors.grey400,
                  ),
                ),

                child: pw.Column(
                  crossAxisAlignment:
                      pw.CrossAxisAlignment.start,

                  children: [

                    pw.Text(
                      'NASMOCO BENGAWAN MOTOR SLAMET RIYADI',

                      style: pw.TextStyle(
                        fontWeight:
                            pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),

                    pw.SizedBox(
                      height: 6,
                    ),

                    pw.Text(
                      'EDN : ${edn.fileName}',
                    ),

                    pw.Text(
                      'Tanggal Checking : $date',
                    ),

                    pw.Text(
                      'Waktu Checking : $time',
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // -------------------------------------------------
              // STATEMENT
              // -------------------------------------------------

              pw.Text(
                'Diterangkan bahwa pada tanggal '
                '$date pukul $time, telah diselesaikan '
                'rangkaian kegiatan pengecekan fisik '
                'penerimaan barang kiriman dari ekspedisi '
                'berdasarkan EDN yang diterima.',

                style: const pw.TextStyle(
                  fontSize: 10,
                  lineSpacing: 4,
                ),
              ),

              pw.SizedBox(height: 18),

              // -------------------------------------------------
              // RESULT
              // -------------------------------------------------

              pw.Container(
                width:
                    double.infinity,

                padding:
                    const pw.EdgeInsets.all(14),

                decoration:
                    pw.BoxDecoration(
                  color: isComplete
                      ? PdfColors.green50
                      : PdfColors.red50,

                  border:
                      pw.Border.all(
                    color: isComplete
                        ? PdfColors.green
                        : PdfColors.red,
                    width: 1.5,
                  ),
                ),

                child: pw.Column(
                  children: [

                    pw.Text(
                      'HASIL PENGECEKAN',

                      style: pw.TextStyle(
                        fontWeight:
                            pw.FontWeight.bold,

                        color: isComplete
                            ? PdfColors.green
                            : PdfColors.red,
                      ),
                    ),

                    pw.SizedBox(
                      height: 6,
                    ),

                    pw.Text(
                      isComplete
                          ? 'SELURUH DATA SESUAI'
                          : 'TERDAPAT KETIDAKSESUAIAN',

                      textAlign:
                          pw.TextAlign.center,

                      style: pw.TextStyle(
                        fontWeight:
                            pw.FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    if (!isComplete)
                      pw.Padding(
                        padding:
                            const pw.EdgeInsets.only(
                          top: 4,
                        ),

                        child: pw.Text(
                          '(Lihat detail pengecekan)',
                          style:
                              const pw.TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              pw.SizedBox(height: 18),

              // -------------------------------------------------
              // SUMMARY
              // -------------------------------------------------

              pw.Text(
                'SUMMARY',

                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight:
                      pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Table(
                border:
                    pw.TableBorder.all(
                  color:
                      PdfColors.grey400,
                ),

                columnWidths: {
                  0:
                      const pw.FlexColumnWidth(2),
                  1:
                      const pw.FlexColumnWidth(1),
                },

                children: [

                  _pdfSummaryRow(
                    'Total Case',
                    '${edn.completedCase} / ${edn.totalCase}',
                  ),

                  _pdfSummaryRow(
                    'Total PNO',
                    '$completedPart / $totalPart',
                  ),

                  _pdfSummaryRow(
                    'Total Qty',
                    '${edn.totalScanned} / ${edn.totalTarget}',
                  ),

                  _pdfSummaryRow(
                    'Selisih Qty',
                    '${edn.totalScanned - edn.totalTarget}',
                  ),

                  _pdfSummaryRow(
                    'Ketidaksesuaian',
                    '${discrepancies.length} item',
                  ),

                  _pdfSummaryRow(
                    'Status',
                    isComplete
                        ? 'SESUAI'
                        : 'TIDAK SESUAI',
                  ),
                ],
              ),

              // -------------------------------------------------
              // DISCREPANCY
              // -------------------------------------------------

              if (discrepancies.isNotEmpty) ...[
                pw.SizedBox(height: 18),

                pw.Text(
                  'KETIDAKSESUAIAN',

                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight:
                        pw.FontWeight.bold,

                    color:
                        PdfColors.red,
                  ),
                ),

                pw.SizedBox(height: 8),

                ...discrepancies.map(
                  (item) {
                    return pw.Container(
                      margin:
                          const pw.EdgeInsets.only(
                        bottom: 8,
                      ),

                      padding:
                          const pw.EdgeInsets.all(8),

                      decoration:
                          pw.BoxDecoration(
                        border:
                            pw.Border.all(
                          color:
                              PdfColors.red,
                        ),
                      ),

                      child: pw.Column(
                        crossAxisAlignment:
                            pw.CrossAxisAlignment.start,

                        children: [

                          pw.Text(
                            'CASE : ${item.caseNo}',

                            style: pw.TextStyle(
                              fontWeight:
                                  pw.FontWeight.bold,
                            ),
                          ),

                          pw.Text(
                            'PNO : ${item.partNo}',
                          ),

                          pw.Text(
                            'EDN Qty : ${item.targetQty}',
                          ),

                          pw.Text(
                            'Scan Qty : ${item.scannedQty}',
                          ),

                          pw.Text(
                            'Selisih : ${item.difference}',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ];
          },
        ),
      );

      // =========================================================
      // DETAIL PAGES
      // =========================================================

      pdf.addPage(
        pw.MultiPage(
          pageFormat:
              PdfPageFormat.a4,

          margin:
              const pw.EdgeInsets.all(30),

          footer: (context) {
            return pw.Align(
              alignment:
                  pw.Alignment.centerRight,

              child: pw.Text(
                'Halaman ${context.pageNumber}',
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),
            );
          },

          build: (context) {
            final List<pw.Widget>
                widgets = [];

            widgets.add(
              pw.Text(
                'LAMPIRAN DATA HASIL PENGECEKAN',

                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight:
                      pw.FontWeight.bold,
                ),
              ),
            );

            widgets.add(
              pw.SizedBox(height: 12),
            );

            for (final caseModel
                in edn.cases) {

              widgets.add(
                pw.Container(
                  margin:
                      const pw.EdgeInsets.only(
                    bottom: 14,
                  ),

                  child: pw.Column(
                    crossAxisAlignment:
                        pw.CrossAxisAlignment.start,

                    children: [

                      // -----------------------------------------
                      // CASE HEADER
                      // -----------------------------------------

                      pw.Container(
                        width:
                            double.infinity,

                        padding:
                            const pw.EdgeInsets.all(
                          8,
                        ),

                        color:
                            PdfColors.grey200,

                        child: pw.Row(
                          children: [

                            pw.Expanded(
                              child: pw.Text(
                                'CASE : ${caseModel.caseNo}',

                                style:
                                    pw.TextStyle(
                                  fontWeight:
                                      pw.FontWeight.bold,
                                ),
                              ),
                            ),

                            pw.Text(
                              'Qty ${caseModel.totalScanned}'
                              '/${caseModel.totalTarget}',
                            ),
                          ],
                        ),
                      ),

                      // -----------------------------------------
                      // PART TABLE
                      // -----------------------------------------

                      pw.Table(
                        border:
                            pw.TableBorder.all(
                          color:
                              PdfColors.grey400,
                        ),

                        columnWidths: {
                          0:
                              const pw.FlexColumnWidth(3),
                          1:
                              const pw.FlexColumnWidth(1),
                          2:
                              const pw.FlexColumnWidth(1),
                          3:
                              const pw.FlexColumnWidth(1),
                          4:
                              const pw.FlexColumnWidth(1.5),
                        },

                        children: [

                          pw.TableRow(
                            decoration:
                                const pw.BoxDecoration(
                              color:
                                  PdfColors.grey100,
                            ),

                            children: [

                              _pdfCell(
                                'PNO',
                                bold: true,
                              ),

                              _pdfCell(
                                'EDN',
                                bold: true,
                              ),

                              _pdfCell(
                                'SCAN',
                                bold: true,
                              ),

                              _pdfCell(
                                'SELISIH',
                                bold: true,
                              ),

                              _pdfCell(
                                'STATUS',
                                bold: true,
                              ),
                            ],
                          ),

                          ...caseModel.parts.map(
                            (part) {

                              final difference =
                                  part.scannedQty -
                                  part.targetQty;

                              final match =
                                  difference == 0;

                              return pw.TableRow(
                                children: [

                                  _pdfCell(
                                    part.partNo,
                                  ),

                                  _pdfCell(
                                    '${part.targetQty}',
                                  ),

                                  _pdfCell(
                                    '${part.scannedQty}',
                                  ),

                                  _pdfCell(
                                    '$difference',
                                  ),

                                  _pdfCell(
                                    match
                                        ? 'SESUAI'
                                        : 'SELISIH',
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            return widgets;
          },
        ),
      );

      // =========================================================
      // SHARE / SAVE PDF
      // =========================================================

      final bytes =
          await pdf.save();

      await Printing.sharePdf(
        bytes: bytes,
        filename:
            'Report_${_safeFileName(edn.fileName)}.pdf',
      );

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal membuat PDF: $e',
            ),
            backgroundColor:
                Colors.red,
          ),
        );
      }
    }
  }

  // =============================================================
  // PDF SUMMARY ROW
  // =============================================================

  static pw.TableRow _pdfSummaryRow(
    String label,
    String value,
  ) {
    return pw.TableRow(
      children: [

        _pdfCell(
          label,
          bold: true,
        ),

        _pdfCell(
          value,
        ),
      ],
    );
  }

  // =============================================================
  // PDF CELL
  // =============================================================

  static pw.Widget _pdfCell(
    String text, {
    bool bold = false,
  }) {
    return pw.Padding(
      padding:
          const pw.EdgeInsets.all(6),

      child: pw.Text(
        text,

        style: pw.TextStyle(
          fontSize: 8,

          fontWeight: bold
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
        ),
      ),
    );
  }

  // =============================================================
  // FILE NAME
  // =============================================================

  static String _safeFileName(
    String fileName,
  ) {
    return fileName
        .replaceAll(
          '.xlsx',
          '',
        )
        .replaceAll(
          '.xls',
          '',
        )
        .replaceAll(
          RegExp(r'[^\w\-]'),
          '_',
        );
  }
}

// =================================================================
// REPORT TITLE
// =================================================================

class _ReportTitle extends StatelessWidget {
  const _ReportTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'BERITA ACARA PENERIMAAN BARANG\n'
      'KIRIMAN DARI EKSPEDISI',

      textAlign: TextAlign.center,

      style: TextStyle(
        fontSize: 20,
        fontWeight:
            FontWeight.bold,
      ),
    );
  }
}

// =================================================================
// EDN INFO
// =================================================================

class _EdnInfoCard extends StatelessWidget {
  final String fileName;

  const _EdnInfoCard({
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'NASMOCO BENGAWAN MOTOR SLAMET RIYADI',

              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'EDN',

              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              fileName,

              style: const TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// STATEMENT
// =================================================================

class _StatementCard extends StatelessWidget {
  const _StatementCard();

  @override
  Widget build(BuildContext context) {
    final now =
        DateTime.now();

    final date =
        '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year}';

    final time =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 1,

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Text(
          'Diterangkan bahwa pada tanggal '
          '$date pukul $time, telah diselesaikan '
          'rangkaian kegiatan pengecekan fisik '
          'penerimaan barang kiriman dari ekspedisi '
          'berdasarkan EDN yang diterima.',

          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

// =================================================================
// RESULT
// =================================================================

class _ResultCard extends StatelessWidget {
  final bool isComplete;

  const _ResultCard({
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: isComplete
            ? Colors.green.shade50
            : Colors.red.shade50,

        borderRadius:
            BorderRadius.circular(10),

        border: Border.all(
          color: isComplete
              ? Colors.green
              : Colors.red,
        ),
      ),

      child: Column(
        children: [

          Icon(
            isComplete
                ? Icons.check_circle
                : Icons.warning_amber_rounded,

            color: isComplete
                ? Colors.green
                : Colors.red,

            size: 38,
          ),

          const SizedBox(height: 8),

          Text(
            'HASIL PENGECEKAN',

            style: TextStyle(
              fontWeight:
                  FontWeight.bold,

              color: isComplete
                  ? Colors.green
                  : Colors.red,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            isComplete
                ? 'SELURUH DATA SESUAI'
                : 'TERDAPAT KETIDAKSESUAIAN',

            textAlign:
                TextAlign.center,

            style: const TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// SUMMARY
// =================================================================

class _SummaryCard extends StatelessWidget {
  final int totalCase;
  final int completedCase;

  final int totalPart;
  final int completedPart;

  final int totalQty;
  final int scannedQty;

  final int discrepancies;

  const _SummaryCard({
    required this.totalCase,
    required this.completedCase,
    required this.totalPart,
    required this.completedPart,
    required this.totalQty,
    required this.scannedQty,
    required this.discrepancies,
  });

  @override
  Widget build(BuildContext context) {
    final difference =
        scannedQty - totalQty;

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
              'SUMMARY',

              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _SummaryRow(
              label: 'Total Case',
              value:
                  '$completedCase / $totalCase',
            ),

            _SummaryRow(
              label: 'Total PNO',
              value:
                  '$completedPart / $totalPart',
            ),

            _SummaryRow(
              label: 'Total Qty',
              value:
                  '$scannedQty / $totalQty',
            ),

            _SummaryRow(
              label: 'Selisih Qty',
              value:
                  '${difference > 0 ? '+' : ''}$difference',
              valueColor:
                  difference == 0
                      ? Colors.green
                      : Colors.red,
            ),

            _SummaryRow(
              label: 'Ketidaksesuaian',
              value:
                  '$discrepancies item',
              valueColor:
                  discrepancies == 0
                      ? Colors.green
                      : Colors.red,
            ),

            const Divider(
              height: 24,
            ),

            _SummaryRow(
              label: 'Status',
              value:
                  discrepancies == 0
                      ? 'SESUAI'
                      : 'TIDAK SESUAI',
              valueColor:
                  discrepancies == 0
                      ? Colors.green
                      : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// SUMMARY ROW
// =================================================================

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 5,
      ),

      child: Row(
        children: [

          Expanded(
            child: Text(
              label,

              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          Text(
            value,

            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// DISCREPANCY CARD
// =================================================================

class _DiscrepancyCard
    extends StatelessWidget {

  final List<_Discrepancy>
      discrepancies;

  const _DiscrepancyCard({
    required this.discrepancies,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      color: Colors.red.shade50,

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                ),

                const SizedBox(width: 8),

                const Expanded(
                  child: Text(
                    'KETIDAKSESUAIAN',

                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ...List.generate(
              discrepancies.length,

              (index) {
                final item =
                    discrepancies[index];

                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 14,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        '${index + 1}. CASE : ${item.caseNo}',

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        '   PNO  : ${item.partNo}',
                      ),

                      Text(
                        '   EDN  : ${item.targetQty}',
                      ),

                      Text(
                        '   Scan : ${item.scannedQty}',
                      ),

                      Text(
                        '   Selisih : '
                        '${item.difference > 0 ? '+' : ''}'
                        '${item.difference}',

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const Text(
              'Detail lengkap dapat dilihat pada '
              'bagian Detail Pengecekan.',

              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// CASE REPORT
// =================================================================

class _CaseReportCard
    extends StatelessWidget {

  final CaseModel caseModel;

  const _CaseReportCard({
    required this.caseModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      elevation: 1,

      child: ExpansionTile(
        leading: Icon(
          caseModel.isComplete
              ? Icons.check_circle
              : Icons.warning_amber_rounded,

          color:
              caseModel.isComplete
                  ? Colors.green
                  : Colors.orange,
        ),

        title: Text(
          caseModel.caseNo,

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        subtitle: Text(
          'Qty ${caseModel.totalScanned}/'
          '${caseModel.totalTarget}',
        ),

        children: [

          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              16,
            ),

            child: Column(
              children:
                  caseModel.parts.map(
                (part) {
                  return _PartReportRow(
                    part: part,
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// PART REPORT
// =================================================================

class _PartReportRow
    extends StatelessWidget {

  final PartModel part;

  const _PartReportRow({
    required this.part,
  });

  @override
  Widget build(BuildContext context) {
    final difference =
        part.scannedQty -
        part.targetQty;

    final bool match =
        difference == 0;

    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 10,
      ),

      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                Colors.grey.shade200,
          ),
        ),
      ),

      child: Row(
        children: [

          Icon(
            match
                ? Icons.check_circle
                : Icons.warning_amber_rounded,

            size: 20,

            color:
                match
                    ? Colors.green
                    : Colors.red,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              part.partNo,

              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,

            children: [

              Text(
                '${part.scannedQty} / '
                '${part.targetQty}',

                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              if (!match)
                Text(
                  'Selisih '
                  '${difference > 0 ? '+' : ''}'
                  '$difference',

                  style:
                      const TextStyle(
                    fontSize: 11,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// =================================================================
// DISCREPANCY MODEL
// =================================================================

class _Discrepancy {
  final String caseNo;
  final String partNo;

  final int targetQty;
  final int scannedQty;

  final int difference;

  _Discrepancy({
    required this.caseNo,
    required this.partNo,
    required this.targetQty,
    required this.scannedQty,
    required this.difference,
  });
}