import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/datasource/weather_remote_data_source.dart';
import '../../data/model/weather/weather.dart';

class WeatherNotificationHelper {
  final WeatherRemoteDataSource _weatherDataSource;

  WeatherNotificationHelper(this._weatherDataSource);

  Future<Map<String, String>> fetchWeatherForNotification() async {
    try {
      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
      } catch (e) {
        position =
            await Geolocator.getLastKnownPosition() ??
            Position(
              latitude: 21.0285,
              longitude: 105.8542,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 0,
              altitudeAccuracy: 0,
              headingAccuracy: 0,
            );
      }

      final weather = await _weatherDataSource.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      final title = _formatTitle(weather);
      final body = _formatBody(weather);

      return {
        'title': title,
        'body': body,
        'temperature': '${weather.temperature.round()}°C',
        'condition': weather.description,
      };
    } catch (e) {
      debugPrint('Error fetching weather for notification: $e');

      return {
        'title': 'Weather Update',
        'body': 'Tap to view current weather conditions',
        'temperature': '--°C',
        'condition': 'Unknown',
      };
    }
  }

  String _formatTitle(Weather weather) {
    final now = DateTime.now();
    final dayOfWeek = _getDayOfWeek(now.weekday);
    final date = '${now.day}/${now.month}';

    return '☀️ $dayOfWeek, $date - ${weather.temperature.round()}°C';
  }

  String _formatBody(Weather weather) {
    final description = _translateCondition(weather.description);
    final feelsLike = weather.temperature.round();
    final humidity = weather.humidity;

    return '$description • Cảm giác như $feelsLike°C • Độ ẩm $humidity%';
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Thứ Hai';
      case 2:
        return 'Thứ Ba';
      case 3:
        return 'Thứ Tư';
      case 4:
        return 'Thứ Năm';
      case 5:
        return 'Thứ Sáu';
      case 6:
        return 'Thứ Bảy';
      case 7:
        return 'Chủ Nhật';
      default:
        return '';
    }
  }

  String _translateCondition(String condition) {
    final conditionMap = {
      'Clear': 'Quang đãng',
      'Clouds': 'Nhiều mây',
      'Rain': 'Mưa',
      'Drizzle': 'Mưa phùn',
      'Thunderstorm': 'Giông bão',
      'Snow': 'Tuyết',
      'Mist': 'Sương mù',
      'Haze': 'Sương mù nhẹ',
    };

    return conditionMap[condition] ?? condition;
  }
}
