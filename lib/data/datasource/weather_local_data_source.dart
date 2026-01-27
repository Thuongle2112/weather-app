import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/weather/daily_forecast.dart';
import '../model/weather/forecast_item.dart';
import '../model/weather/weather.dart';

class WeatherLocalDataSource {
  static const String _hourlyForecastKey = 'cached_hourly_forecast';
  static const String _dailyForecastKey = 'cached_daily_forecast';
  static const String _hourlyForecastTimestampKey =
      'cached_hourly_forecast_timestamp';
  static const String _dailyForecastTimestampKey =
      'cached_daily_forecast_timestamp';
  static const String _hourlyForecastLocationKey =
      'cached_hourly_forecast_location';
  static const String _dailyForecastLocationKey =
      'cached_daily_forecast_location';
  static const String _weatherKey = 'cached_weather';
  static const String _weatherTimestampKey = 'cached_weather_timestamp';
  static const String _weatherLocationKey = 'cached_weather_location';

  final SharedPreferences prefs;

  WeatherLocalDataSource(this.prefs);

  /// Cache hourly forecast data
  Future<void> cacheHourlyForecast({
    required List<ForecastItem> forecasts,
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    try {
      final jsonData = forecasts.map((f) => f.toJson()).toList();
      await prefs.setString(_hourlyForecastKey, jsonEncode(jsonData));
      await prefs.setInt(
        _hourlyForecastTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      // Save location info to verify cache relevance
      final locationKey = _buildLocationKey(lat, lon, cityName);
      await prefs.setString(_hourlyForecastLocationKey, locationKey);

      debugPrint('✅ Cached ${forecasts.length} hourly forecast items');
    } catch (e) {
      debugPrint('❌ Error caching hourly forecast: $e');
    }
  }

  /// Cache daily forecast data
  Future<void> cacheDailyForecast({
    required List<DailyForecast> forecasts,
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    try {
      final jsonData = forecasts.map((f) => f.toJson()).toList();
      await prefs.setString(_dailyForecastKey, jsonEncode(jsonData));
      await prefs.setInt(
        _dailyForecastTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      // Save location info to verify cache relevance
      final locationKey = _buildLocationKey(lat, lon, cityName);
      await prefs.setString(_dailyForecastLocationKey, locationKey);

      debugPrint('✅ Cached ${forecasts.length} daily forecast items');
    } catch (e) {
      debugPrint('❌ Error caching daily forecast: $e');
    }
  }

  /// Get cached hourly forecast
  Future<List<ForecastItem>?> getCachedHourlyForecast({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    try {
      // Check if location matches
      final cachedLocation = prefs.getString(_hourlyForecastLocationKey);
      final requestedLocation = _buildLocationKey(lat, lon, cityName);

      if (cachedLocation != requestedLocation) {
        debugPrint('⚠️ Cached hourly forecast location mismatch');
        return null;
      }

      final jsonString = prefs.getString(_hourlyForecastKey);
      if (jsonString == null) {
        debugPrint('ℹ️ No cached hourly forecast found');
        return null;
      }

      final List<dynamic> jsonData = jsonDecode(jsonString);
      final forecasts =
          jsonData.map((item) => ForecastItem.fromJson(item)).toList();

      final timestamp = prefs.getInt(_hourlyForecastTimestampKey) ?? 0;
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final cacheAgeHours = (cacheAge / (1000 * 60 * 60)).round();

      debugPrint(
        '✅ Retrieved ${forecasts.length} cached hourly forecast items (${cacheAgeHours}h old)',
      );
      return forecasts;
    } catch (e) {
      debugPrint('❌ Error retrieving cached hourly forecast: $e');
      return null;
    }
  }

  /// Get cached daily forecast
  Future<List<DailyForecast>?> getCachedDailyForecast({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    try {
      // Check if location matches
      final cachedLocation = prefs.getString(_dailyForecastLocationKey);
      final requestedLocation = _buildLocationKey(lat, lon, cityName);

      if (cachedLocation != requestedLocation) {
        debugPrint('⚠️ Cached daily forecast location mismatch');
        return null;
      }

      final jsonString = prefs.getString(_dailyForecastKey);
      if (jsonString == null) {
        debugPrint('ℹ️ No cached daily forecast found');
        return null;
      }

      final List<dynamic> jsonData = jsonDecode(jsonString);
      final forecasts =
          jsonData.map((item) => DailyForecast.fromJson(item)).toList();

      final timestamp = prefs.getInt(_dailyForecastTimestampKey) ?? 0;
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final cacheAgeHours = (cacheAge / (1000 * 60 * 60)).round();

      debugPrint(
        '✅ Retrieved ${forecasts.length} cached daily forecast items (${cacheAgeHours}h old)',
      );
      return forecasts;
    } catch (e) {
      debugPrint('❌ Error retrieving cached daily forecast: $e');
      return null;
    }
  }

  /// Build a unique location key for cache validation
  String _buildLocationKey(double? lat, double? lon, String? cityName) {
    if (cityName != null) {
      return 'city:$cityName';
    } else if (lat != null && lon != null) {
      // Round coordinates to 2 decimal places for cache matching
      return 'coords:${lat.toStringAsFixed(2)},${lon.toStringAsFixed(2)}';
    }
    return 'unknown';
  }

  /// Clear all cached forecast data
  Future<void> clearCache() async {
    try {
      await prefs.remove(_hourlyForecastKey);
      await prefs.remove(_dailyForecastKey);
      await prefs.remove(_hourlyForecastTimestampKey);
      await prefs.remove(_dailyForecastTimestampKey);
      await prefs.remove(_hourlyForecastLocationKey);
      await prefs.remove(_dailyForecastLocationKey);
      await prefs.remove(_weatherKey);
      await prefs.remove(_weatherTimestampKey);
      await prefs.remove(_weatherLocationKey);
      debugPrint('✅ Cleared all cache');
    } catch (e) {
      debugPrint('❌ Error clearing cache: $e');
    }
  }

  /// Cache current weather data
  Future<void> cacheWeather({
    required Weather weather,
  }) async {
    try {
      final jsonData = weather.toJson();
      await prefs.setString(_weatherKey, jsonEncode(jsonData));
      await prefs.setInt(
        _weatherTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      final locationKey = _buildLocationKey(
        weather.latitude,
        weather.longitude,
        weather.cityName,
      );
      await prefs.setString(_weatherLocationKey, locationKey);

      debugPrint('✅ Cached weather for ${weather.cityName}');
    } catch (e) {
      debugPrint('❌ Error caching weather: $e');
    }
  }

  /// Get cached weather data
  Future<Weather?> getCachedWeather({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    try {
      final cachedLocation = prefs.getString(_weatherLocationKey);
      final requestedLocation = _buildLocationKey(lat, lon, cityName);

      if (cachedLocation != requestedLocation) {
        debugPrint('⚠️ Cached weather location mismatch');
        return null;
      }

      final jsonString = prefs.getString(_weatherKey);
      if (jsonString == null) {
        debugPrint('ℹ️ No cached weather found');
        return null;
      }

      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final weather = Weather.fromJson(jsonData);

      final timestamp = prefs.getInt(_weatherTimestampKey) ?? 0;
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final cacheAgeHours = (cacheAge / (1000 * 60 * 60)).round();

      debugPrint(
        '✅ Retrieved cached weather for ${weather.cityName} (${cacheAgeHours}h old)',
      );
      return weather;
    } catch (e) {
      debugPrint('❌ Error retrieving cached weather: $e');
      return null;
    }
  }
}
