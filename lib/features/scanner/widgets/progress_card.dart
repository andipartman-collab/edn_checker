import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/scanner_provider.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (context, provider, child) {
        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            child: Row(
              children: [

                //----------------------------------
                // CASE
                //----------------------------------

                Expanded(
                  child: Column(
                    children: [

                      const Icon(
                        Icons.inventory_2,
                        color: Colors.red,
                        size: 28,
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "CASE",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "${provider.completedPart} / ${provider.totalPart}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                //----------------------------------
                // GARIS PEMBATAS
                //----------------------------------

                Container(
                  width: 1,
                  height: 70,
                  color: Colors.grey.shade300,
                ),

                //----------------------------------
                // EDN
                //----------------------------------

                Expanded(
                  child: Column(
                    children: [

                      const Icon(
                        Icons.local_shipping,
                        color: Colors.red,
                        size: 28,
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "EDN",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "${provider.completedCase} / ${provider.totalCase}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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