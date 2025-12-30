import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class WeatherStartLoading extends WeatherEvent {
  const WeatherStartLoading();
}

class FetchWeatherByCity extends WeatherEvent {
  final String cityName;
  final bool includeForecast;

  const FetchWeatherByCity(this.cityName, {this.includeForecast = true});

  @override
  List<Object> get props => [cityName, includeForecast];
}

class FetchWeatherByCoordinates extends WeatherEvent {
  final double latitude;
  final double longitude;
  final bool includeForecast;

  const FetchWeatherByCoordinates(
    this.latitude,
    this.longitude, {
    this.includeForecast = true,
  });

  @override
  List<Object> get props => [latitude, longitude, includeForecast];
}

class FetchAirPollution extends WeatherEvent {
  final double latitude;
  final double longitude;

  const FetchAirPollution(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}
