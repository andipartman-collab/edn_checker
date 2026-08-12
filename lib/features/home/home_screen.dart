import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/menu_card.dart';

import '../scanner/scanner_screen.dart';
import '../upload/upload_screen.dart';
import '../monitoring/monitoring_screen.dart';
import '../report/report_screen.dart';

import 'widgets/edn_status_card.dart';
import 'widgets/home_footer.dart';
import 'widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              // ---------------------------------
              // HEADER
              // ---------------------------------

              const HomeHeader(),

              const SizedBox(height: 20),

              // ---------------------------------
              // EDN STATUS
              // ---------------------------------

              const EdnStatusCard(),

              const SizedBox(height: 28),

              // ---------------------------------
              // UPLOAD EDN
              // ---------------------------------

              MenuCard(
                title: "UPLOAD EDN",
                icon: Icons.upload_file,
                color: AppColors.upload,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const UploadScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------------------------------
              // SCANNER
              // ---------------------------------

              MenuCard(
                title: "SCANNER",
                icon: Icons.qr_code_scanner,
                color: AppColors.scanner,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ScannerScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------------------------------
              // MONITORING
              // ---------------------------------

              MenuCard(
                title: "MONITORING",
                icon: Icons.monitor,
                color: AppColors.monitoring,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const MonitoringScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------------------------------
              // REPORT
              // ---------------------------------

              MenuCard(
                title: "REPORT",
                icon: Icons.description,
                color: AppColors.report,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ReportScreen(),
                    ),
                  );
                },
              ),

              // ---------------------------------
              // FOOTER
              // ---------------------------------

              const HomeFooter(),
            ],
          ),
        ),
      ),
    );
  }
}