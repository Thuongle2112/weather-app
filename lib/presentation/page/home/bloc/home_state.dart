import 'package:equatable/equatable.dart';

import '../../../../data/model/weather/air_pollution.dart';
import '../../../../data/model/weather/daily_forecast.dart';
import '../../../../data/model/weather/forecast_item.dart';
import '../../../../data/model/weather/uv_index.dart';
import '../../../../data/model/weather/weather.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  @override
  List<Object?> get props => [];
}

class WeatherLoading extends WeatherState {
  @override
  List<Object?> get props => [];
}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  final List<ForecastItem>? hourlyForecast;
  final List<DailyForecast>? dailyForecast;
  final double latitude;
  final double longitude;
  final AirPollution? airPollution;
  final UVIndex? uvIndex;

  const WeatherLoaded(
    this.weather, {
    this.hourlyForecast,
    this.dailyForecast,
    required this.latitude,
    required this.longitude,
    this.airPollution,
    this.uvIndex,
  });

  @override
  List<Object?> get props => [
    weather,
    hourlyForecast,
    dailyForecast,
    latitude,
    longitude,
    airPollution,
    uvIndex,
  ];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}
