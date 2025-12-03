import 'package:equatable/equatable.dart';

import '../../../../data/model/weather/daily_forecast.dart';
import '../../../../data/model/weather/forecast_item.dart';
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

  const WeatherLoaded(this.weather, {this.hourlyForecast, this.dailyForecast});

  @override
  List<Object?> get props => [weather, hourlyForecast, dailyForecast];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}
