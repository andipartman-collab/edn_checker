import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 11,
                          height: 11,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'EDN READY',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      provider.currentEdn!.fileName,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _InfoItem(
                            value: provider.currentEdn!.totalCase.toString(),
                            title: 'Case',
                          ),
                        ),
                        Expanded(
                          child: _InfoItem(
                            value: provider.currentEdn!.totalPartNumber.toString(),
                            title: 'Part No',
                          ),
                        ),
                        Expanded(
                          child: _InfoItem(
                            value: provider.currentEdn!.totalTarget.toString(),
                            title: 'Qty',
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const Column(
                  children: [
                    Text(
                      'BELUM ADA EDN',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Silakan upload file EDN',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
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
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.red,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
