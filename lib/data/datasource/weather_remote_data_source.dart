import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/weather/daily_forecast.dart';
import '../model/weather/forecast_item.dart';
import '../model/weather/uv_index.dart';
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
    final rainChance = data['clouds']?['all'] as int?;

    return Weather(
      cityName: locationName,
      temperature: mainTemp,
      description: desc,
      language: languageCode,
      windSpeed: windSpeed,
      humidity: humidity,
      rainChance: rainChance,
      latitude: lat,
      longitude: lon,
    );
  }

  Future<List<ForecastItem>> getHourlyForecast({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found');
    }

    final languageCode = await _getCurrentLanguage();
    debugPrint('🔍 Fetching hourly forecast with language: $languageCode');

    try {
      Map<String, dynamic> queryParams = {
        'appid': apiKey,
        'units': 'metric',
        'lang': languageCode,
      };

      if (cityName != null) {
        queryParams['q'] = cityName;
      } else if (lat != null && lon != null) {
        queryParams['lat'] = lat;
        queryParams['lon'] = lon;
      } else {
        throw Exception('Either cityName or coordinates must be provided');
      }

      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/forecast',
        queryParameters: queryParams,
      );

      debugPrint('✅ Hourly forecast API response: ${response.statusCode}');

      final List<dynamic> list = response.data['list'];
      final now = DateTime.now();

      final allForecasts =
          list.map((item) => ForecastItem.fromJson(item)).toList();

      final currentIndex = allForecasts.indexWhere(
        (item) =>
            item.dateTime.isAfter(now) ||
            item.dateTime.difference(now).abs().inMinutes < 90,
      );

      final startIndex = currentIndex > 0 ? currentIndex - 1 : 0;

      return allForecasts.skip(startIndex).take(9).toList();
    } catch (e) {
      debugPrint('❌ Error fetching hourly forecast: $e');
      throw Exception('Failed to fetch hourly forecast: $e');
    }
  }

  Future<List<ForecastItem>> _getAllForecast({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found');
    }

    final languageCode = await _getCurrentLanguage();

    try {
      Map<String, dynamic> queryParams = {
        'appid': apiKey,
        'units': 'metric',
        'lang': languageCode,
      };

      if (cityName != null) {
        queryParams['q'] = cityName;
      } else if (lat != null && lon != null) {
        queryParams['lat'] = lat;
        queryParams['lon'] = lon;
      } else {
        throw Exception('Either cityName or coordinates must be provided');
      }

      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/forecast',
        queryParameters: queryParams,
      );

      final List<dynamic> list = response.data['list'];

      return list.map((item) => ForecastItem.fromJson(item)).toList();
    } catch (e) {
      debugPrint('❌ Error fetching all forecast: $e');
      throw Exception('Failed to fetch forecast: $e');
    }
  }

  Future<List<DailyForecast>> getDailyForecast({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    final allForecasts = await _getAllForecast(
      lat: lat,
      lon: lon,
      cityName: cityName,
    );

    debugPrint('📊 Total forecast items received: ${allForecasts.length}');

    final Map<String, List<ForecastItem>> groupedByDay = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var item in allForecasts) {
      final itemDate = DateTime(
        item.dateTime.year,
        item.dateTime.month,
        item.dateTime.day,
      );

      if (itemDate.isBefore(today)) {
        continue;
      }

      final dateKey =
          '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';
      groupedByDay.putIfAbsent(dateKey, () => []);
      groupedByDay[dateKey]!.add(item);
    }

    debugPrint('📅 Days grouped: ${groupedByDay.length}');

    final List<DailyForecast> dailyForecasts = [];

    groupedByDay.forEach((dateKey, items) {
      if (items.isEmpty) return;

      final date = items.first.dateTime;
      final temps = items.map((e) => e.temperature).toList();
      final tempDay = temps.reduce((a, b) => a + b) / temps.length;
      final tempMin = temps.reduce((a, b) => a < b ? a : b);
      final tempMax = temps.reduce((a, b) => a > b ? a : b);

      final descriptions = items.map((e) => e.description).toList();
      final mostCommonDesc = _getMostCommon(descriptions);

      final icons = items.map((e) => e.icon).toList();
      final mostCommonIcon = _getMostCommon(icons);

      final humidity =
          (items.map((e) => e.humidity).reduce((a, b) => a + b) / items.length)
              .round();
      final windSpeed =
          items.map((e) => e.windSpeed).reduce((a, b) => a + b) / items.length;
      final clouds =
          items.where((e) => e.clouds != null).isNotEmpty
              ? (items.map((e) => e.clouds ?? 0).reduce((a, b) => a + b) /
                      items.length)
                  .round()
              : null;

      dailyForecasts.add(
        DailyForecast(
          date: date,
          tempDay: tempDay,
          tempMin: tempMin,
          tempMax: tempMax,
          description: mostCommonDesc,
          icon: mostCommonIcon,
          humidity: humidity,
          windSpeed: windSpeed,
          clouds: clouds,
        ),
      );
    });

    dailyForecasts.sort((a, b) => a.date.compareTo(b.date));
    final result = dailyForecasts.take(5).toList();

    debugPrint('✅ Daily forecasts generated: ${result.length} days');
    for (var forecast in result) {
      debugPrint(
        '  📆 ${forecast.date}: ${forecast.tempMin}°-${forecast.tempMax}° ${forecast.description}',
      );
    }

    return result;
  }

  String _getMostCommon(List<String> items) {
    final counts = <String, int>{};
    for (var item in items) {
      counts[item] = (counts[item] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Future <UVIndex> getUVIndex({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found');
    }

    if (cityName != null) {
      final geoResponse = await dio.get(
        'https://api.openweathermap.org/geo/1.0/direct',
        queryParameters: {'q': cityName, 'limit': 1, 'appid': apiKey},
      );

      if (geoResponse.data.isEmpty) {
        throw Exception('City not found');
      }

      lat = geoResponse.data[0]['lat'];
      lon = geoResponse.data[0]['lon'];
    }

    if (lat == null || lon == null) {
      throw Exception('Either cityName or coordinates must be provided');
    }

    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/uvi',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
      },
    );

    return UVIndex.fromJson(response.data);
  }
}
