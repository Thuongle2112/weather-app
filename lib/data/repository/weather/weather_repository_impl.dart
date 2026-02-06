import 'package:flutter/material.dart';

import '../../../domain/repository/weather/weather_repository.dart';

import '../../datasource/weather_local_data_source.dart';
import '../../datasource/weather_remote_data_source.dart';
import '../../model/weather/daily_forecast.dart';
import '../../model/weather/forecast_item.dart';
import '../../model/weather/uv_index.dart';
import '../../model/weather/weather.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Weather> getWeatherByCity(String cityName) async {
    debugPrint('🔄 Repository: getWeatherByCity called for city: $cityName');
    try {
      final result = await remoteDataSource.getWeatherByCity(cityName);
      
      // Cache the successful result
      await localDataSource.cacheWeather(weather: result);
      
      debugPrint('✅ Repository: getWeatherByCity completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ Repository: getWeatherByCity failed: $e');
      
      // Try to load from cache on error
      debugPrint('🔄 Attempting to load cached weather...');
      final cached = await localDataSource.getCachedWeather(
        cityName: cityName,
      );
      
      if (cached != null) {
        debugPrint('✅ Repository: Loaded cached weather (offline mode)');
        return cached;
      }
      
      debugPrint('❌ Repository: No cached weather available');
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
      
      // Cache the successful result
      await localDataSource.cacheWeather(weather: result);
      
      debugPrint(
        '✅ Repository: getWeatherByCoordinates completed successfully',
      );
      return result;
    } catch (e) {
      debugPrint('❌ Repository: getWeatherByCoordinates failed: $e');
      
      // Try to load from cache on error
      debugPrint('🔄 Attempting to load cached weather...');
      final cached = await localDataSource.getCachedWeather(
        lat: lat,
        lon: lon,
      );
      
      if (cached != null) {
        debugPrint('✅ Repository: Loaded cached weather (offline mode)');
        return cached;
      }
      
      debugPrint('❌ Repository: No cached weather available');
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
      // Try to fetch from remote
      final result = await remoteDataSource.getHourlyForecast(
        lat: lat,
        lon: lon,
        cityName: cityName,
      );
      
      // Cache the successful result
      await localDataSource.cacheHourlyForecast(
        forecasts: result,
        lat: lat,
        lon: lon,
        cityName: cityName,
      );
      
      debugPrint('✅ Repository: getHourlyForecast completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ Repository: getHourlyForecast failed: $e');
      
      // Try to load from cache on error
      debugPrint('🔄 Attempting to load cached hourly forecast...');
      final cached = await localDataSource.getCachedHourlyForecast(
        lat: lat,
        lon: lon,
        cityName: cityName,
      );
      
      if (cached != null && cached.isNotEmpty) {
        debugPrint('✅ Repository: Loaded cached hourly forecast (offline mode)');
        return cached;
      }
      
      debugPrint('❌ Repository: No cached hourly forecast available');
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
      // Try to fetch from remote
      final result = await remoteDataSource.getDailyForecast(
        lat: lat,
        lon: lon,
        cityName: cityName,
      );
      
      // Cache the successful result
      await localDataSource.cacheDailyForecast(
        forecasts: result,
        lat: lat,
        lon: lon,
        cityName: cityName,
      );
      
      debugPrint('✅ Repository: getDailyForecast completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ Repository: getDailyForecast failed: $e');
      
      // Try to load from cache on error
      debugPrint('🔄 Attempting to load cached daily forecast...');
      final cached = await localDataSource.getCachedDailyForecast(
        lat: lat,
        lon: lon,
        cityName: cityName,
      );
      
      if (cached != null && cached.isNotEmpty) {
        debugPrint('✅ Repository: Loaded cached daily forecast (offline mode)');
        return cached;
      }
      
      debugPrint('❌ Repository: No cached daily forecast available');
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
