import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../settings/settings_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.local_shipping,
          size: 38,
          color: AppColors.toyotaRed,
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "EDN CHECKER",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 2),

              Text(
                "Electronic Delivery Note",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // ---------------------------------
        // SETTING
        // ---------------------------------

        IconButton(
          tooltip: "Pengaturan",

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
          ),
        ),
      ],
    );
  }
}