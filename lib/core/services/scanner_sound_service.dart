import 'package:audioplayers/audioplayers.dart';

class ScannerSoundService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSuccess() async {
    await _player.stop();

    await _player.play(
      AssetSource('sounds/scan_success.wav'),
    );
  }

  Future<void> playError() async {
    await _player.stop();

    await _player.play(
      AssetSource('sounds/scan_error.wav'),
    );
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}