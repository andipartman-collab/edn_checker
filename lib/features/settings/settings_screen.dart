import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          "Pengaturan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // ---------------------------------
            // EDIT PROFILE
            // ---------------------------------

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),

                leading: Container(
                  width: 45,
                  height: 45,

                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    Icons.person,
                    color: Colors.blue.shade700,
                  ),
                ),

                title: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: const Text(
                  "Nama, kode, dan alamat dealer",
                ),

                trailing: const Icon(
                  Icons.chevron_right,
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const EditProfileScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------
            // SUARA SCANNER
            // ---------------------------------

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: SwitchListTile(
                contentPadding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),

                secondary: Container(
                  width: 45,
                  height: 45,

                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    Icons.volume_up,
                    color: Colors.green.shade700,
                  ),
                ),

                title: const Text(
                  "Suara Scanner",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: const Text(
                  "Aktifkan suara beep saat scanning",
                ),

                value: true,

                onChanged: (value) {
                  // Akan kita hubungkan
                  // ke LocalStorageService
                },
              ),
            ),

            const SizedBox(height: 40),

            const Divider(),

            const SizedBox(height: 20),

            // ---------------------------------
            // APP ICON
            // ---------------------------------

            const Icon(
              Icons.qr_code_scanner,
              size: 40,
              color: Colors.blueGrey,
            ),

            const SizedBox(height: 10),

            // ---------------------------------
            // APP NAME
            // ---------------------------------

            const Text(
              "EDN Checker",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // ---------------------------------
            // VERSION
            // ---------------------------------

            const Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------
            // DEVELOPER
            // ---------------------------------

            const Text(
              "Developed by",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 3),

            const Text(
              "Thoyi Lukman Hakim",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}