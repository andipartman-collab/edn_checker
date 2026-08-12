import 'package:flutter/material.dart';

class CameraOverlay extends StatelessWidget {
  const CameraOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Area gelap
            Container(
              color: Colors.black.withOpacity(0.45),
            ),

            // Kotak scan
            Center(
              child: Container(
                width: constraints.maxWidth * 0.82,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Garis bidik
            Center(
              child: Container(
                width: constraints.maxWidth * 0.70,
                height: 2,
                color: Colors.white,
              ),
            ),

            // Tulisan petunjuk
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Text(
                "Arahkan barcode ke dalam kotak",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(.9),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}