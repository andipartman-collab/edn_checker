import 'package:flutter/material.dart';

class ScanResultCard extends StatelessWidget {
  final String partNo;
  final String partName;
  final Color statusColor;
  final String statusText;

  const ScanResultCard({
    super.key,
    required this.partNo,
    required this.partName,
    required this.statusColor,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Icon(
                  Icons.check_circle,
                  color: statusColor,
                ),

                const SizedBox(width: 8),

                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )

              ],
            ),

            const SizedBox(height: 12),

            Text(
              partNo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              partName,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            )

          ],
        ),
      ),
    );
  }
}