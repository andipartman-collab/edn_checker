import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_text.dart';
import '../../../providers/scanner_provider.dart';

class EdnStatusCard extends StatelessWidget {
  const EdnStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (context, provider, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: provider.hasEdn
              ? Column(
                  children: [
                    const Text(
                      "🟢 EDN SIAP",
                      style: AppText.status,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      provider.currentEdn!.fileName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        _InfoItem(
                          value: provider.currentEdn!.totalCase.toString(),
                          title: "Case",
                        ),

                        _InfoItem(
                          value: provider.currentEdn!.totalPartNumber.toString(),
                          title: "Part No",
                        ),

                        _InfoItem(
                          value: provider.currentEdn!.totalTarget.toString(),
                          title: "Qty",
                        ),
                      ],
                    ),
                  ],
                )
              : const Column(
                  children: [
                    Text(
                      "🔴 BELUM ADA EDN",
                      style: AppText.status,
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Silakan upload file EDN",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String value;
  final String title;

  const _InfoItem({
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}