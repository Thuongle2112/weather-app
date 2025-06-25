import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecase/weather/get_weather_by_city.dart';
import '../../../../domain/usecase/weather/get_weather_by_coordinates.dart';
import 'home_event.dart';
import 'home_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherByCity getWeatherByCity;
  final GetWeatherByCoordinates getWeatherByCoordinates;

  WeatherBloc({
    required this.getWeatherByCity,
    required this.getWeatherByCoordinates,
  }) : super(WeatherInitial()) {
    on<WeatherStartLoading>((event, emit) {
      emit(WeatherLoading());
    });

    on<FetchWeatherByCity>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await getWeatherByCity(event.cityName);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError('City not found or API failed'));
      }
    });

// Trong event handler FetchWeatherByCoordinates
    on<FetchWeatherByCoordinates>((event, emit) async {
      debugPrint('🔄 Bloc: Processing FetchWeatherByCoordinates event');
      try {
        emit(WeatherLoading());
        debugPrint('🔄 Bloc: Calling getWeatherByCoordinates usecase');
        final weather = await getWeatherByCoordinates(event.latitude, event.longitude);
        debugPrint('✅ Bloc: Weather fetched successfully');
        emit(WeatherLoaded(weather));
      } catch (e) {
        debugPrint('❌ Bloc: Failed to get weather: $e');
        emit(WeatherError('Failed to get weather for your location: $e'));
      }
    });
  }
}