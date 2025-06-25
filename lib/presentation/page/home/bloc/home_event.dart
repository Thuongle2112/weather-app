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

  const FetchWeatherByCity(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class FetchWeatherByCoordinates extends WeatherEvent {
  final double latitude;
  final double longitude;

  const FetchWeatherByCoordinates(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}