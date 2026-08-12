enum ScannerStatus {

  /// Belum ada aktivitas
  idle,

  /// Shipping Case berhasil dipilih
  caseChanged,

  /// Part berhasil discan
  partScanned,

  /// Semua part dalam case selesai
  caseCompleted,

  /// Shipping Case tidak ditemukan
  caseNotFound,

  /// Belum memilih Shipping Case
  noActiveCase,

  /// Part tidak ada pada case aktif
  partNotFound,

  /// Qty part sudah penuh
  qtyFull,
}