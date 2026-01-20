import 'package:flutter/material.dart';

import '../../../domain/repository/weather/weather_repository.dart';

import '../../datasource/weather_remote_data_source.dart';
import '../../model/weather/daily_forecast.dart';
import '../../model/weather/forecast_item.dart';
import '../../model/weather/uv_index.dart';
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

  @override
  Future<List<ForecastItem>> getHourlyForecast({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    debugPrint('🔄 Repository: getHourlyForecast called');
    try {
      final result = await remoteDataSource.getHourlyForecast(
        lat: lat,
        lon: lon,
        cityName: cityName,
      );
      debugPrint('✅ Repository: getHourlyForecast completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ Repository: getHourlyForecast failed: $e');
      rethrow;
    }
  }

  @override
  Future<List<DailyForecast>> getDailyForecast({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    debugPrint('🔄 Repository: getDailyForecast called');
    try {
      final result = await remoteDataSource.getDailyForecast(
        lat: lat,
        lon: lon,
        cityName: cityName,
      );
      debugPrint('✅ Repository: getDailyForecast completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ Repository: getDailyForecast failed: $e');
      rethrow;
    }
  }

  @override
  Future<UVIndex> getUVIndex({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    debugPrint('🔄 Repository: getUVIndex called');
    try {
      final result = await remoteDataSource.getUVIndex(
        lat: lat,
        lon: lon,
        cityName: cityName,
      );
      debugPrint('✅ Repository: getUVIndex completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ Repository: getUVIndex failed: $e');
      rethrow;
    }
  }
}
