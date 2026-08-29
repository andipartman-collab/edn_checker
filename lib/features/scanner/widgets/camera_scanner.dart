import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../../providers/scanner_provider.dart';

class CameraScanner extends StatefulWidget {
  final void Function(String barcode) onDetect;

  const CameraScanner({
    super.key,
    required this.onDetect,
  });

  @override
  State<CameraScanner> createState() => _CameraScannerState();
}

class _CameraScannerState extends State<CameraScanner> {
  late final MobileScannerController _scannerController;

  Timer? _scanCooldown;

  bool _scanProcessing = false;

  // ---------------------------------
  // UKURAN AREA SCAN
  // ---------------------------------

  static const double _scanWidth = 280;
  static const double _scanHeight = 126;

  // ---------------------------------
  // INTERVAL CONTINUOUS SCAN
  // ---------------------------------

  static const Duration _scanInterval =
      Duration(milliseconds: 400);

  // ---------------------------------
  // INIT
  // ---------------------------------

  @override
  void initState() {
    super.initState();

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  // ---------------------------------
  // DISPOSE
  // ---------------------------------

  @override
  void dispose() {
    _scanCooldown?.cancel();
    _scannerController.dispose();

    super.dispose();
  }

  // ---------------------------------
  // HANDLE BARCODE
  // ---------------------------------

  void _handleBarcode(String barcode) {
    final value = barcode.trim();

    if (value.isEmpty) {
      return;
    }

    // ---------------------------------
    // MASIH DALAM INTERVAL
    // ---------------------------------

    if (_scanProcessing) {
      return;
    }

    // ---------------------------------
    // LOCK SEMENTARA
    // ---------------------------------

    _scanProcessing = true;

    // ---------------------------------
    // KIRIM BARCODE
    // ---------------------------------

    widget.onDetect(value);

    // ---------------------------------
    // SIAP MEMBACA LAGI
    // ---------------------------------

    _scanCooldown?.cancel();

    _scanCooldown = Timer(
      _scanInterval,
      () {
        if (!mounted) {
          return;
        }

        setState(() {
          _scanProcessing = false;
        });
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  // ---------------------------------
  // BUILD
  // ---------------------------------

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (context, provider, child) {
        final activeCase = provider.activeCase;
        final lastScan = provider.lastScan;

        final caseNo = activeCase?.caseNo ?? "-";

        final scannedQty =
            lastScan?.scannedQty ?? 0;

        final targetQty =
            lastScan?.targetQty ?? 0;

        return ClipRRect(
          borderRadius: BorderRadius.circular(18),

          child: SizedBox(
            height: 360,

            child: LayoutBuilder(
              builder: (context, constraints) {
                // ---------------------------------
                // POSISI SCAN WINDOW
                // ---------------------------------

                final scanLeft =
                    (constraints.maxWidth - _scanWidth) / 2;

                final scanTop =
                    (constraints.maxHeight - _scanHeight) / 2;

                final scanWindow = Rect.fromLTWH(
                  scanLeft,
                  scanTop,
                  _scanWidth,
                  _scanHeight,
                );

                return Stack(
                  fit: StackFit.expand,

                  children: [

                    // ---------------------------------
                    // CAMERA
                    // ---------------------------------

                    MobileScanner(
                      controller: _scannerController,

                      scanWindow: scanWindow,

                      onDetect: (capture) {
                        if (capture.barcodes.isEmpty) {
                          return;
                        }

                        final barcode =
                            capture.barcodes.first.rawValue;

                        if (barcode == null) {
                          return;
                        }

                        _handleBarcode(barcode);
                      },
                    ),

                    // ---------------------------------
                    // DARK OVERLAY
                    // ---------------------------------

                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.55),
                                Colors.transparent,
                                Colors.black.withOpacity(0.65),
                              ],
                              stops: const [
                                0.0,
                                0.45,
                                1.0,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ---------------------------------
                    // CASE
                    // ---------------------------------

                    Positioned(
                      top: 14,
                      left: 16,
                      right: 16,

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Text(
                            "CASE",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            caseNo,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ---------------------------------
                    // SCAN WINDOW VISUAL
                    // ---------------------------------

                    Center(
                      child: Container(
                        width: _scanWidth,
                        height: _scanHeight,

                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),

                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    // ---------------------------------
                    // AUTO FULL QTY INDICATOR
                    // ---------------------------------

                    if (provider.autoFullQty)
                      Positioned(
                        top:
                            scanTop +
                            _scanHeight +
                            12,

                        left: 0,
                        right: 0,

                        child: Center(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color:
                                  Colors.green.withOpacity(0.9),

                              borderRadius:
                                  BorderRadius.circular(20),
                            ),

                            child: const Row(
                              mainAxisSize:
                                  MainAxisSize.min,

                              children: [

                                Icon(
                                  Icons.flash_on,
                                  color: Colors.white,
                                  size: 16,
                                ),

                                SizedBox(width: 5),

                                Text(
                                  "AUTO FULL QTY",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // ---------------------------------
                    // SCAN INFORMATION
                    // ---------------------------------

                    Positioned(
                      bottom: 104,
                      left: 20,
                      right: 20,

                      child: Text(
                        _scanProcessing
                            ? "Membaca..."
                            : "Arahkan barcode ke dalam kotak",

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color:
                              Colors.white.withOpacity(0.9),

                          fontSize: 11,

                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ),

                    // ---------------------------------
                    // LAST PNO + QTY
                    // ---------------------------------

                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 14,

                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,

                        children: [

                          // ---------------------------------
                          // PNO
                          // ---------------------------------

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                const Text(
                                  "PNO",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  lastScan?.partNo ?? "-",

                                  maxLines: 1,

                                  overflow:
                                      TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // ---------------------------------
                          // QTY
                          // ---------------------------------

                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,

                            children: [

                              const Text(
                                "Qty",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                "$scannedQty / $targetQty",

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}