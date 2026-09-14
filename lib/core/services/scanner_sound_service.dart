import 'package:audioplayers/audioplayers.dart';

import 'local_storage_service.dart';

class ScannerSoundService {
  final AudioPlayer _player = AudioPlayer();
  final LocalStorageService _storage =
      LocalStorageService();

  Future<void> playSuccess() async {
    final enabled =
        await _storage.getScannerSoundEnabled();

    if (!enabled) {
      return;
    }

    await _player.stop();

    await _player.play(
      AssetSource('sounds/scan_success.wav'),
    );
  }

  Future<void> playError() async {
    final enabled =
        await _storage.getScannerSoundEnabled();

    if (!enabled) {
      return;
    }

    await _player.stop();

    await _player.play(
      AssetSource('sounds/scan_error.wav'),
    );
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
