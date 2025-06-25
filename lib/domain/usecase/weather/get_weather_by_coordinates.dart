import 'package:flutter/material.dart';
import '../../../data/model/weather/weather.dart';
import '../../repository/weather/weather_repository.dart';

class GetWeatherByCoordinates {
  final WeatherRepository repository;

  GetWeatherByCoordinates(this.repository);

  Future<Weather> call(double latitude, double longitude) async {
    debugPrint('🔄 UseCase: GetWeatherByCoordinates called with lat: $latitude, lon: $longitude');
    try {
      final result = await repository.getWeatherByCoordinates(latitude, longitude);
      debugPrint('✅ UseCase: GetWeatherByCoordinates completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ UseCase: GetWeatherByCoordinates failed: $e');
      rethrow;
    }
  }
}