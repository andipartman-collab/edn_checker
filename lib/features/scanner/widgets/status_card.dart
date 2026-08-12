import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/scanner_status.dart';
import '../../../providers/scanner_provider.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (context, provider, child) {
        IconData icon = Icons.qr_code_scanner;
        Color color = Colors.blue;
        String text = "Siap Scan Shipping Case";

        switch (provider.status) {
          case ScannerStatus.idle:
            icon = Icons.qr_code_scanner;
            color = Colors.blue;
            text = "Siap Scan Shipping Case";
            break;

          case ScannerStatus.caseChanged:
            icon = Icons.inventory_2;
            color = Colors.green;
            text = "Silakan Scan Part";
            break;

          case ScannerStatus.partScanned:
            icon = Icons.check_circle;
            color = Colors.green;
            text = "Part Berhasil";
            break;

          case ScannerStatus.caseCompleted:
            icon = Icons.task_alt;
            color = Colors.green;
            text = "Shipping Case Selesai";
            break;

          case ScannerStatus.caseNotFound:
            icon = Icons.cancel;
            color = Colors.red;
            text = "Shipping Case Tidak Ditemukan";
            break;

          case ScannerStatus.noActiveCase:
            icon = Icons.info;
            color = Colors.orange;
            text = "Scan Shipping Case Terlebih Dahulu";
            break;

          case ScannerStatus.partNotFound:
            icon = Icons.cancel;
            color = Colors.red;
            text = "Part Tidak Ditemukan";
            break;

          case ScannerStatus.qtyFull:
            icon = Icons.warning_amber_rounded;
            color = Colors.orange;
            text = "Qty Sudah Penuh";
            break;
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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