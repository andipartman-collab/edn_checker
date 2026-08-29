import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../settings/settings_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/nasmoco_logo.png',
          width: 90,
          height: 50,
          fit: BoxFit.contain,
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "EDN SCANNER",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 1),

              Text(
                "Electronic Delivery Note Scanner",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
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