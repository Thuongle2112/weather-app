import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/domain/usecase/weather/get_air_pollution.dart';

import '../../../../domain/usecase/weather/get_uv_index.dart';
import '../../../../domain/usecase/weather/get_weather_by_city.dart';
import '../../../../domain/usecase/weather/get_weather_by_coordinates.dart';
import '../../../../domain/usecase/weather/get_hourly_forecast.dart';
import '../../../../domain/usecase/weather/get_daily_forecast.dart';
import 'home_event.dart';
import 'home_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherByCity getWeatherByCity;
  final GetWeatherByCoordinates getWeatherByCoordinates;
  final GetHourlyForecast getHourlyForecast;
  final GetDailyForecast getDailyForecast;
  final GetAirPollution getAirPollution;
  final GetUVIndex getUVIndex;

  WeatherBloc({
    required this.getWeatherByCity,
    required this.getWeatherByCoordinates,
    required this.getHourlyForecast,
    required this.getDailyForecast,
    required this.getAirPollution,
    required this.getUVIndex,
  }) : super(WeatherInitial()) {
    on<WeatherStartLoading>((event, emit) {
      emit(WeatherLoading());
    });

    on<FetchWeatherByCity>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await getWeatherByCity(event.cityName);
        final lat = weather.latitude;
        final lon = weather.longitude;

        if (event.includeForecast) {
          final hourlyForecast = await getHourlyForecast(
            cityName: event.cityName,
          );
          final dailyForecast = await getDailyForecast(
            cityName: event.cityName,
          );
          final airPollution = await getAirPollution(lat, lon);
          final uvIndex = await getUVIndex(
            cityName: event.cityName,
          );

          emit(
            WeatherLoaded(
              weather,
              hourlyForecast: hourlyForecast,
              dailyForecast: dailyForecast,
              latitude: lat,
              longitude: lon,
              airPollution: airPollution,
              uvIndex: uvIndex,
            ),
          );
        } else {
          emit(WeatherLoaded(weather, latitude: lat, longitude: lon));
        }
      } catch (e) {
        emit(WeatherError('City not found or API failed'));
      }
    });

    on<FetchWeatherByCoordinates>((event, emit) async {
      debugPrint('🔄 Bloc: Processing FetchWeatherByCoordinates event');
      try {
        emit(WeatherLoading());
        debugPrint('🔄 Bloc: Calling getWeatherByCoordinates usecase');

        final weather = await getWeatherByCoordinates(
          event.latitude,
          event.longitude,
        );

        if (event.includeForecast) {
          final hourlyForecast = await getHourlyForecast(
            lat: event.latitude,
            lon: event.longitude,
          );
          final dailyForecast = await getDailyForecast(
            lat: event.latitude,
            lon: event.longitude,
          );
          final airPollution = await getAirPollution(
            event.latitude,
            event.longitude,
          );
          final uvIndex = await getUVIndex(
            lat: event.latitude,
            lon: event.longitude,
          );

          debugPrint('✅ Bloc: Weather and forecast fetched successfully');
          emit(
            WeatherLoaded(
              weather,
              hourlyForecast: hourlyForecast,
              dailyForecast: dailyForecast,
              latitude: event.latitude,
              longitude: event.longitude,
              airPollution: airPollution,
              uvIndex: uvIndex,
            ),
          );
        } else {
          debugPrint('✅ Bloc: Weather fetched successfully');
          emit(
            WeatherLoaded(
              weather,
              latitude: event.latitude,
              longitude: event.longitude,
            ),
          );
        }
      } catch (e) {
        debugPrint('❌ Bloc: Failed to get weather: $e');
        emit(WeatherError('Failed to get weather for your location: $e'));
      }
    });
  }
}
