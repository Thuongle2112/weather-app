import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../data/model/weather/weather.dart';
import '../../core/services/event_service.dart';

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
              ? 'assets/images/new_year_bg_dark.jpeg'
              : 'assets/images/new_year_bg_light.jpeg',
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  static Decoration getSimpleBackgroundByTheme({required bool isDarkMode}) {
    // Kiểm tra nếu đang trong event Tết
    final isLunarNewYear = EventService.isEventActive('lunar_new_year_2026');

    if (isLunarNewYear) {
      // Gradient màu Tết: đỏ và vàng
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDarkMode
                  ? [
                    const Color(0xFF141E30),
                    const Color(0xFF141E30),
                    const Color(0xFF243B55),
                  ]
                  : [
                    // const Color(0xFF8B0000), // Dark red
                    // const Color(0xFFB71C1C), // Red
                    // const Color(0xFF9C2C1C), // Dark red-brown
                    Color(0xFF7A0000), // red + black
                    Color(0xFFA31515),
                    Color(0xFF822518),
                  ],
          stops: const [0.0, 0.5, 1.0],
        ),
      );
    }

    // Màu nền bình thường
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors:
            isDarkMode
                ? [const Color(0xFF141E30), const Color(0xFF243B55)]
                : [const Color(0xFFDFF3F0), const Color(0xFFE8EEF7)],
        stops: const [0.0, 1.0],
      ),
    );
  }

  static String getLocalizedWeatherDescription(String description) {
    final lowercaseDesc = description.toLowerCase();

    if (lowercaseDesc.contains('clear')) {
      return 'weather_clear'.tr();
    } else if (lowercaseDesc.contains('cloud')) {
      return 'weather_clouds'.tr();
    } else if (lowercaseDesc.contains('rain') &&
        !lowercaseDesc.contains('drizzle')) {
      return 'weather_rain'.tr();
    } else if (lowercaseDesc.contains('drizzle')) {
      return 'weather_drizzle'.tr();
    } else if (lowercaseDesc.contains('thunder') ||
        lowercaseDesc.contains('storm')) {
      return 'weather_thunderstorm'.tr();
    } else if (lowercaseDesc.contains('snow')) {
      return 'weather_snow'.tr();
    } else if (lowercaseDesc.contains('mist')) {
      return 'weather_mist'.tr();
    } else if (lowercaseDesc.contains('fog')) {
      return 'weather_fog'.tr();
    } else if (lowercaseDesc.contains('haze')) {
      return 'weather_haze'.tr();
    } else if (lowercaseDesc.contains('smoke')) {
      return 'weather_smoke'.tr();
    } else if (lowercaseDesc.contains('dust')) {
      return 'weather_dust'.tr();
    } else if (lowercaseDesc.contains('sand')) {
      return 'weather_sand'.tr();
    } else if (lowercaseDesc.contains('ash')) {
      return 'weather_ash'.tr();
    } else if (lowercaseDesc.contains('squall')) {
      return 'weather_squall'.tr();
    } else if (lowercaseDesc.contains('tornado')) {
      return 'weather_tornado'.tr();
    }

    // Fallback: capitalize first letter of original description
    return capitalizeFirstLetter(description);
  }
}
