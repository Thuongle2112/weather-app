import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/weather/air_pollution.dart';

class AirPollutionRemoteDataSource {
  final Dio dio;

  AirPollutionRemoteDataSource(this.dio);

  Future<String> _getCurrentLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('language_code') ?? 'en';
    } catch (e) {
      return 'en';
    }
  }

  Future<AirPollution> getAirPollution(double? lat, double? lon) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found');
    }

    final languageCode = await _getCurrentLanguage();

    try {
      Map<String, dynamic> queryParams = {
        'appid': apiKey,
        'lang': languageCode,
      };

      queryParams['lat'] = lat;
      queryParams['lon'] = lon;

      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/air_pollution',
        queryParameters: queryParams,
      );
      debugPrint('✅ RemoteDataSource: getAirPollution completed successfully');
      final list = response.data['list'] as List?;
      final airData = (list != null && list.isNotEmpty) ? list[0] : null;
      if (airData == null) throw Exception('No air pollution data found');
      return AirPollution.fromJson(airData);
    } catch (e) {
      debugPrint('❌ RemoteDataSource: getAirPollution failed: $e');
      rethrow;
    }
  }
}
