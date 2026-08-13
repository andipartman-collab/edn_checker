import 'package:flutter/material.dart';

import '../../core/services/local_storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  // ==========================================
  // STORAGE
  // ==========================================

  final LocalStorageService _storage =
      LocalStorageService();

  // ==========================================
  // CONTROLLERS
  // ==========================================

  final TextEditingController _dealerNameController =
      TextEditingController();

  final TextEditingController _dealerCodeController =
      TextEditingController();

  final TextEditingController _dealerAddressController =
      TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  // ==========================================
  // INIT
  // ==========================================

  @override
  void initState() {
    super.initState();

    _loadProfile();
  }

  // ==========================================
  // LOAD PROFILE
  // ==========================================

  Future<void> _loadProfile() async {
    final profile =
        await _storage.loadDealerProfile();

    if (!mounted) {
      return;
    }

    if (profile != null) {
      _dealerNameController.text =
          profile['dealerName'] ?? '';

      _dealerCodeController.text =
          profile['dealerCode'] ?? '';

      _dealerAddressController.text =
          profile['dealerAddress'] ?? '';
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ==========================================
  // SAVE PROFILE
  // ==========================================

  Future<void> _saveProfile() async {
    final dealerName =
        _dealerNameController.text.trim();

    final dealerCode =
        _dealerCodeController.text.trim();

    final dealerAddress =
        _dealerAddressController.text.trim();

    // ==========================================
    // VALIDASI
    // ==========================================

    if (dealerName.isEmpty) {
      _showMessage(
        'Nama dealer belum diisi.',
      );

      return;
    }

    if (dealerCode.isEmpty) {
      _showMessage(
        'Kode dealer belum diisi.',
      );

      return;
    }

    if (dealerAddress.isEmpty) {
      _showMessage(
        'Alamat dealer belum diisi.',
      );

      return;
    }

    setState(() {
      _isSaving = true;
    });

    // ==========================================
    // SAVE
    // ==========================================

    await _storage.saveDealerProfile(
      dealerName: dealerName,
      dealerCode: dealerCode,
      dealerAddress: dealerAddress,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    // ==========================================
    // SUCCESS
    // ==========================================

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profil dealer berhasil disimpan.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Tunggu sebentar supaya SnackBar terlihat,
    // kemudian kembali ke Settings.
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) {
      return;
    }

    Navigator.pop(context);
  }

  // ==========================================
  // MESSAGE
  // ==========================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================
  // DISPOSE
  // ==========================================

  @override
  void dispose() {
    _dealerNameController.dispose();
    _dealerCodeController.dispose();
    _dealerAddressController.dispose();

    super.dispose();
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey.shade100,

      // ========================================
      // APP BAR
      // ========================================

      appBar: AppBar(
        title: const Text(
          'Edit Profile Dealer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // ========================================
      // BODY
      // ========================================

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // --------------------------------
                  // INFO
                  // --------------------------------

                  Container(
                    width: double.infinity,

                    padding:
                        const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,

                      borderRadius:
                          BorderRadius.circular(16),

                      border: Border.all(
                        color:
                            Colors.blue.shade100,
                      ),
                    ),

                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Icon(
                          Icons.info_outline,
                          color:
                              Colors.blue.shade700,
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            'Data profil ini akan digunakan sebagai informasi dealer pada hasil export PDF.',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --------------------------------
                  // NAMA DEALER
                  // --------------------------------

                  const Text(
                    'Nama Dealer',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller:
                        _dealerNameController,

                    textCapitalization:
                        TextCapitalization.characters,

                    decoration:
                        InputDecoration(
                      hintText:
                          'Contoh: NASMOCO BENGAWAN MOTOR SLAMET RIYADI',
                      prefixIcon:
                          const Icon(
                        Icons.business,
                      ),

                      filled: true,

                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                        borderSide:
                            BorderSide.none,
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                        borderSide:
                            BorderSide(
                          color:
                              Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                        borderSide:
                            const BorderSide(
                          color:
                              Colors.blue,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // --------------------------------
                  // KODE DEALER
                  // --------------------------------

                  const Text(
                    'Kode Dealer',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller:
                        _dealerCodeController,

                    textCapitalization:
                        TextCapitalization.characters,

                    decoration:
                        InputDecoration(
                      hintText:
                          'Contoh: 23007',

                      prefixIcon:
                          const Icon(
                        Icons.tag,
                      ),

                      filled: true,

                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                        borderSide:
                            BorderSide.none,
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                        borderSide:
                            BorderSide(
                          color:
                              Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                        borderSide:
                            const BorderSide(
                          color:
                              Colors.blue,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // --------------------------------
                  // ALAMAT
                  // --------------------------------

                  const Text(
                    'Alamat Dealer',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller:
                        _dealerAddressController,

                    maxLines: 4,

                    textCapitalization:
                        TextCapitalization.sentences,

                    decoration:
                        InputDecoration(
                      hintText:
                          'Masukkan alamat dealer',

                      prefixIcon:
                          const Padding(
                        padding:
                            EdgeInsets.only(
                          bottom: 60,
                        ),

                        child: Icon(
                          Icons.location_on,
                        ),
                      ),

                      filled: true,

                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                        borderSide:
                            BorderSide.none,
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                        borderSide:
                            BorderSide(
                          color:
                              Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                        borderSide:
                            const BorderSide(
                          color:
                              Colors.blue,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --------------------------------
                  // BUTTON SIMPAN
                  // --------------------------------

                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton.icon(
                      onPressed: _isSaving
                          ? null
                          : _saveProfile,

                      icon: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.save,
                            ),

                      label: Text(
                        _isSaving
                            ? 'Menyimpan...'
                            : 'Simpan Profile',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue,

                        foregroundColor:
                            Colors.white,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}