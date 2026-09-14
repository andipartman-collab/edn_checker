import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'providers/scanner_provider.dart';

void main() {
  runApp(const EDNCheckerApp());
}

class EDNCheckerApp extends StatelessWidget {
  const EDNCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = ScannerProvider();

        // Restore EDN dan progress terakhir
        provider.loadSavedEdn();

        return provider;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EDN Scanner',
        theme: AppTheme.light(),
        home: const HomeScreen(),
      ),
    );
  }
}