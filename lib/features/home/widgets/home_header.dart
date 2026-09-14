import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../settings/settings_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/edn_scanner_logo.png',
          width: 64,
          height: 64,
          fit: BoxFit.contain,
        ),

        const SizedBox(width: 10),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'EDN SCANNER',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
              ),

              SizedBox(height: 5),

              Text(
                'Electronic Delivery Note Scanner',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 6),

        IconButton(
          tooltip: 'Pengaturan',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.settings,
            size: 28,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 44,
          ),
        ),
      ],
    );
  }
}
