import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Debug tool to check cached forecast data
class CacheDebugHelper {
  static Future<void> printCacheStatus() async {
    final prefs = await SharedPreferences.getInstance();
    
    debugPrint('═══════════════════════════════════════════');
    debugPrint('🔍 CACHE DEBUG STATUS');
    debugPrint('═══════════════════════════════════════════');
    
    // Current Weather
    final weatherCache = prefs.getString('cached_weather');
    final weatherTimestamp = prefs.getInt('cached_weather_timestamp');
    final weatherLocation = prefs.getString('cached_weather_location');
    
    debugPrint('\n🌤️  CURRENT WEATHER:');
    debugPrint('  Exists: ${weatherCache != null}');
    debugPrint('  Location: $weatherLocation');
    if (weatherTimestamp != null) {
      final age = DateTime.now().millisecondsSinceEpoch - weatherTimestamp;
      final ageHours = (age / (1000 * 60 * 60)).round();
      debugPrint('  Age: ${ageHours}h ago');
    }
    if (weatherCache != null) {
      debugPrint('  Size: ${weatherCache.length} bytes');
    }
    
    // Hourly forecast
    final hourlyCache = prefs.getString('cached_hourly_forecast');
    final hourlyTimestamp = prefs.getInt('cached_hourly_forecast_timestamp');
    final hourlyLocation = prefs.getString('cached_hourly_forecast_location');
    
    debugPrint('\n📊 HOURLY FORECAST:');
    debugPrint('  Exists: ${hourlyCache != null}');
    debugPrint('  Location: $hourlyLocation');
    if (hourlyTimestamp != null) {
      final age = DateTime.now().millisecondsSinceEpoch - hourlyTimestamp;
      final ageHours = (age / (1000 * 60 * 60)).round();
      debugPrint('  Age: ${ageHours}h ago');
    }
    if (hourlyCache != null) {
      debugPrint('  Size: ${hourlyCache.length} bytes');
    }
    
    // Daily forecast
    final dailyCache = prefs.getString('cached_daily_forecast');
    final dailyTimestamp = prefs.getInt('cached_daily_forecast_timestamp');
    final dailyLocation = prefs.getString('cached_daily_forecast_location');
    
    debugPrint('\n📆 DAILY FORECAST:');
    debugPrint('  Exists: ${dailyCache != null}');
    debugPrint('  Location: $dailyLocation');
    if (dailyTimestamp != null) {
      final age = DateTime.now().millisecondsSinceEpoch - dailyTimestamp;
      final ageHours = (age / (1000 * 60 * 60)).round();
      debugPrint('  Age: ${ageHours}h ago');
    }
    if (dailyCache != null) {
      debugPrint('  Size: ${dailyCache.length} bytes');
    }
    
    debugPrint('\n═══════════════════════════════════════════');
  }
  
  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_weather');
    await prefs.remove('cached_weather_timestamp');
    await prefs.remove('cached_weather_location');
    await prefs.remove('cached_hourly_forecast');
    await prefs.remove('cached_daily_forecast');
    await prefs.remove('cached_hourly_forecast_timestamp');
    await prefs.remove('cached_daily_forecast_timestamp');
    await prefs.remove('cached_hourly_forecast_location');
    await prefs.remove('cached_daily_forecast_location');
    debugPrint('✅ All cache cleared');
  }
}
