import 'package:flutter/material.dart';

class WeatherGradientHelper {
  static List<Color> getGradientColors() {
    final hour = DateTime.now().hour;

    if (hour >= 0 && hour < 6) {
      // Night
      return [const Color(0xFF142058), const Color(0xFF454DB7)];
    } else if (hour >= 6 && hour < 9) {
      // Early Morning
      return [
        const Color(0xFF142058),
        const Color(0xFF41489A),
        const Color(0xFFDE8ABA),
      ];
    } else if (hour >= 9 && hour < 12) {
      // Morning
      return [
        const Color(0xFF1E4DC5),
        const Color(0xFF61A4E6),
        const Color(0xFFFFDDB5),
      ];
    } else if (hour >= 12 && hour < 15) {
      // Noon
      return [
        const Color(0xFF365196),
        const Color(0xFF5576EC),
        const Color(0xFFFFE0B2),
      ];
    } else if (hour >= 15 && hour < 18) {
      // Afternoon
      return [
        const Color(0xFF263A99),
        const Color(0xFF565FCC),
        const Color(0xFFFFC19E),
      ];
    } else if (hour >= 18 && hour < 21) {
      // Evening
      return [
        const Color(0xFF142058),
        const Color(0xFF41489A),
        const Color(0xFFDE8ABA),
      ];
    } else {
      // Night
      return [const Color(0xFF142058), const Color(0xFF454DB7)];
    }
  }
}