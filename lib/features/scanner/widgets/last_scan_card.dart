import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/scanner_provider.dart';

class LastScanCard extends StatelessWidget {
  const LastScanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (context, provider, child) {
        final part = provider.lastScan;

        final scanned = part?.scannedQty ?? 0;
        final target = part?.targetQty ?? 0;

        final progress =
            target == 0 ? 0.0 : scanned / target;

        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                const Row(
                  children: [

                    Icon(
                      Icons.qr_code,
                      color: Colors.green,
                    ),

                    SizedBox(width: 8),

                    Text(
                      "LAST SCAN",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 15),

                Text(
                  part?.partNo ?? "-",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  part?.partName ?? "-",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Qty",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "$scanned / $target",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
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