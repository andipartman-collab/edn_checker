import 'package:flutter/material.dart';

import '../../core/services/local_storage_service.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  final LocalStorageService _storage =
      LocalStorageService();

  bool _scannerSoundEnabled = true;
  bool _loadingSoundSetting = true;

  @override
  void initState() {
    super.initState();

    _loadSoundSetting();
  }

  Future<void> _loadSoundSetting() async {
    final enabled =
        await _storage.getScannerSoundEnabled();

    if (!mounted) {
      return;
    }

    setState(() {
      _scannerSoundEnabled = enabled;
      _loadingSoundSetting = false;
    });
  }

  Future<void> _setScannerSound(
    bool value,
  ) async {
    setState(() {
      _scannerSoundEnabled = value;
    });

    await _storage.setScannerSoundEnabled(
      value,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Suara scanner diaktifkan'
              : 'Suara scanner dimatikan',
        ),
        duration:
            const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          'Pengaturan',
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
                borderRadius:
                    BorderRadius.circular(16),
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
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  child: Icon(
                    Icons.person,
                    color: Colors.blue.shade700,
                  ),
                ),

                title: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: const Text(
                  'Nama, kode, dan alamat dealer',
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
                borderRadius:
                    BorderRadius.circular(16),
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
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  child: Icon(
                    _scannerSoundEnabled
                        ? Icons.volume_up
                        : Icons.volume_off,
                    color: _scannerSoundEnabled
                        ? Colors.green.shade700
                        : Colors.grey.shade600,
                  ),
                ),

                title: const Text(
                  'Suara Scanner',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(
                  _loadingSoundSetting
                      ? 'Memuat pengaturan...'
                      : _scannerSoundEnabled
                          ? 'Aktifkan suara beep saat scanning'
                          : 'Suara beep dimatikan',
                ),

                value: _scannerSoundEnabled,

                onChanged: _loadingSoundSetting
                    ? null
                    : _setScannerSound,
              ),
            ),

            const SizedBox(height: 40),

            const Divider(),

            const SizedBox(height: 20),

            // ---------------------------------
            // APP LOGO
            // ---------------------------------

            Image.asset(
              'assets/images/nasmoco_logo.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 10),

            // ---------------------------------
            // APP NAME
            // ---------------------------------

            const Text(
              'EDN Scanner',
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
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------
            // DEVELOPER
            // ---------------------------------

            const Text(
              'Developed by',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 3),

            const Text(
              'Thoyi Lukman Hakim',
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
