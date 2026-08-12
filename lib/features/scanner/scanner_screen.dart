import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/scanner_provider.dart';
import 'scanner_controller.dart';

import 'widgets/scanner_header.dart';
import 'widgets/camera_scanner.dart';
import 'widgets/progress_card.dart';
import 'widgets/scanner_input.dart';
import 'widgets/status_card.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScannerProvider>(context);

    final controller = ScannerController(provider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [

              //----------------------------------
              // HEADER
              //----------------------------------

              const ScannerHeader(),

              const SizedBox(height: 16),

              //----------------------------------
              // CAMERA
              //----------------------------------

              if (!provider.hasEdn)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius:
                        BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange,
                    ),
                  ),

                  child: const Column(
                    children: [

                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 45,
                      ),

                      SizedBox(height: 10),

                      Text(
                        "Belum ada EDN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        "Silakan upload EDN terlebih dahulu sebelum melakukan scanning.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                CameraScanner(
                  onDetect: (barcode) {
                    controller.onBarcodeScanned(
                      barcode,
                    );
                  },
                ),

              const SizedBox(height: 12),

              //----------------------------------
              // STATUS
              //----------------------------------

              const StatusCard(),

              const SizedBox(height: 12),

              //----------------------------------
              // PROGRESS
              //----------------------------------

              const ProgressCard(),

              const SizedBox(height: 12),

              //----------------------------------
              // AUTO FULL QTY
              //----------------------------------

              if (provider.hasEdn)
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12),

                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,

                    title: const Text(
                      "AUTO FULL QTY",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    secondary: Icon(
                      Icons.all_inclusive,
                      color: provider.autoFullQty
                          ? Colors.green
                          : Colors.grey,
                    ),

                    value: provider.autoFullQty,

                    onChanged: (value) {
                      provider.setAutoFullQty(value);
                    },

                    activeThumbColor: Colors.green,
                  ),
                ),

              const SizedBox(height: 12),

              //----------------------------------
              // INPUT MANUAL
              //----------------------------------

              if (provider.hasEdn)
                ScannerInput(
                  onScanned: (barcode) {
                    controller.onBarcodeScanned(
                      barcode,
                    );
                  },
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}