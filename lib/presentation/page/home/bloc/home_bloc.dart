import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  WeatherBloc({
    required this.getWeatherByCity,
    required this.getWeatherByCoordinates,
    required this.getHourlyForecast,
    required this.getDailyForecast,
  }) : super(WeatherInitial()) {
    on<WeatherStartLoading>((event, emit) {
      emit(WeatherLoading());
    });

    on<FetchWeatherByCity>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await getWeatherByCity(event.cityName);

        if (event.includeForecast) {
          final hourlyForecast = await getHourlyForecast(cityName: event.cityName);
          final dailyForecast = await getDailyForecast(cityName: event.cityName);

          emit(WeatherLoaded(
            weather,
            hourlyForecast: hourlyForecast,
            dailyForecast: dailyForecast,
          ));
        } else {
          emit(WeatherLoaded(weather));
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
        
        final weather = await getWeatherByCoordinates(event.latitude, event.longitude);

        if (event.includeForecast) {
          final hourlyForecast = await getHourlyForecast(
            lat: event.latitude,
            lon: event.longitude,
          );
          final dailyForecast = await getDailyForecast(
            lat: event.latitude,
            lon: event.longitude,
          );

          debugPrint('✅ Bloc: Weather and forecast fetched successfully');
          emit(WeatherLoaded(
            weather,
            hourlyForecast: hourlyForecast,
            dailyForecast: dailyForecast,
          ));
        } else {
          debugPrint('✅ Bloc: Weather fetched successfully');
          emit(WeatherLoaded(weather));
        }
      } catch (e) {
        debugPrint('❌ Bloc: Failed to get weather: $e');
        emit(WeatherError('Failed to get weather for your location: $e'));
      }
    });
  }
}