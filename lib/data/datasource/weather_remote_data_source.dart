import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/weather/weather.dart';

class WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSource(this.dio);

  Future<String> _getCurrentLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('language_code') ?? 'en';
    } catch (e) {
      return 'en';
    }
  }

  Future<Weather> getWeatherByCity(String cityName) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null) {
      debugPrint(
        '❌ API key is null. Make sure your .env file is correctly configured.',
      );
      throw Exception('API key not found. Check your .env file');
    }

    final languageCode = await _getCurrentLanguage();
    debugPrint(
      '🔍 Fetching weather for city: $cityName with language: $languageCode',
    );

    try {
      debugPrint('📡 Calling Geocoding API for city: $cityName');

      final geoResponse = await dio.get(
        'https://api.openweathermap.org/geo/1.0/direct',
        queryParameters: {'q': cityName, 'limit': 1, 'appid': apiKey},
      );

      debugPrint(
        '✅ Geocoding API response received: ${geoResponse.statusCode}',
      );

      if (geoResponse.data.isEmpty) {
        debugPrint('❌ City not found in geocoding response');
        throw Exception('City not found');
      }

      final lat = geoResponse.data[0]['lat'];
      final lon = geoResponse.data[0]['lon'];
      final locationName = geoResponse.data[0]['name'];

      debugPrint('📍 Coordinates found - Lat: $lat, Lon: $lon');

      return _getWeatherData(lat, lon, locationName, languageCode);
    } catch (e) {
      debugPrint('❌ Exception in getWeatherByCity: $e');
      throw Exception('Failed to fetch weather: $e');
    }
  }

  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final languageCode = await _getCurrentLanguage();
      debugPrint(
        '🔍 Fetching weather for coordinates: Lat: $lat, Lon: $lon with language: $languageCode',
      );

      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      if (apiKey == null) {
        debugPrint('❌ API key is null');
        throw Exception('API key not found');
      }

      debugPrint('📡 Calling Reverse Geocoding API');

      final geoResponse = await dio.get(
        'https://api.openweathermap.org/geo/1.0/reverse',
        queryParameters: {'lat': lat, 'lon': lon, 'limit': 1, 'appid': apiKey},
      );

      debugPrint('✅ Reverse Geocoding API response received');

      String locationName = 'Current Location';
      if (geoResponse.data.isNotEmpty) {
        locationName = geoResponse.data[0]['name'];
        debugPrint('📍 Location found: $locationName');
      } else {
        debugPrint('⚠️ No location name found, using default: $locationName');
      }

      return _getWeatherData(lat, lon, locationName, languageCode);
    } catch (e) {
      debugPrint('❌ Exception in getWeatherByCoordinates: $e');
      throw Exception('Failed to fetch weather: $e');
    }
  }

  Future<Weather> _getWeatherData(
    double lat,
    double lon,
    String locationName,
    String languageCode,
  ) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

    debugPrint('📡 Calling Weather API with language: $languageCode');
    debugPrint('🔗 URL: $baseUrl?lat=$lat&lon=$lon&lang=$languageCode');

    final weatherResponse = await dio.get(
      baseUrl,
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
        'units': 'metric',
        'lang': languageCode,
      },
    );

    debugPrint(
      '✅ Weather API response received: ${weatherResponse.statusCode}',
    );

    final data = weatherResponse.data;
    final mainTemp = data['main']['temp'].toDouble();
    final desc = data['weather'][0]['description'];
    final windSpeed =
        data['wind']?['speed'] != null
            ? (data['wind']['speed'] * 3.6).toDouble()
            : null;
    final humidity = data['main']['humidity'] as int?;
    // final rainChance = data['pop'] != null ? (data['pop'] * 100).toInt() : null;
    final rainChance = data['clouds']?['all'] as int?;

    return Weather(
      cityName: locationName,
      temperature: mainTemp,
      description: desc,
      language: languageCode,
      windSpeed: windSpeed,
      humidity: humidity,
      rainChance: rainChance,
    );
  }
}
