import 'package:flutter/material.dart';

import '../../../domain/repository/weather/weather_repository.dart';

import '../../datasource/weather_remote_data_source.dart';
import '../../model/weather/weather.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl(this.remoteDataSource);

  @override
  Future<Weather> getWeatherByCity(String cityName) async {
    debugPrint('🔄 Repository: getWeatherByCity called for city: $cityName');
    try {
      final result = await remoteDataSource.getWeatherByCity(cityName);
      debugPrint('✅ Repository: getWeatherByCity completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ Repository: getWeatherByCity failed: $e');
      rethrow;
    }
  }

  @override
  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    debugPrint(
      '🔄 Repository: getWeatherByCoordinates called with lat: $lat, lon: $lon',
    );
    try {
      final result = await remoteDataSource.getWeatherByCoordinates(lat, lon);
      debugPrint(
        '✅ Repository: getWeatherByCoordinates completed successfully',
      );
      return result;
    } catch (e) {
      debugPrint('❌ Repository: getWeatherByCoordinates failed: $e');
      rethrow;
    }
  }
}
