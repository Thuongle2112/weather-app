import 'package:flutter/material.dart';
import '../../../data/model/weather/weather.dart';

class WeatherUIHelper {
  static Color getBackgroundColorByWeather(Weather weather) {
    final description = weather.description.toLowerCase();
    final temperature = weather.temperature;

    if (description.contains('night') || description.contains('đêm')) {
      return const Color(0xFF1A237E);
    }

    if (description.contains('clear') ||
        description.contains('sunny') ||
        description.contains('quang đãng')) {
      return temperature > 30
          ? const Color(0xFFFFA000)
          : const Color(0xFF2196F3);
    }

    if (description.contains('rain') ||
        description.contains('shower') ||
        description.contains('mưa')) {
      return const Color(0xFF37474F);
    }

    if (description.contains('thunder') ||
        description.contains('storm') ||
        description.contains('giông')) {
      return const Color(0xFF263238);
    }

    if (description.contains('snow') || description.contains('tuyết')) {
      return const Color(0xFF90CAF9);
    }

    if (description.contains('mist') ||
        description.contains('fog') ||
        description.contains('haze') ||
        description.contains('sương')) {
      return const Color(0xFF78909C);
    }

    if (temperature > 30) {
      return const Color(0xFFFFC107);
    } else if (temperature > 20) {
      return const Color(0xFF4FC3F7);
    } else {
      return const Color(0xFF78909C);
    }
  }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static Decoration getBackgroundImageByTheme({required bool isDarkMode}) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          isDarkMode
              ? 'assets/images/halloween_bg_dark.jpg'
              : 'assets/images/halloween_bg_light.jpg',
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
