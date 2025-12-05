import 'package:shake/shake.dart';

class ShakeDetectorService {
  late ShakeDetector _detector;
  int _shakeCount = 0;
  DateTime? _lastShakeTime;

  void initialize({
    required Function() onBooEffect,
    required Function() onMoneyRain,
  }) {
    _detector = ShakeDetector.autoStart(
      onPhoneShake: (event) {
        final now = DateTime.now();

        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) > const Duration(seconds: 3)) {
          _shakeCount = 1;
        } else {
          _shakeCount++;
        }
        _lastShakeTime = now;

        if (_shakeCount >= 5) {
          onMoneyRain();
          _shakeCount = 0;
        } else {
          onBooEffect();
        }
      },
    );
  }

  void dispose() {
    _detector.stopListening();
  }
}
