import '../../../data/model/weather/weather.dart';
import '../../repository/weather/weather_repository.dart';

class GetWeatherByCity {
  final WeatherRepository repository;

  GetWeatherByCity(this.repository);

  Future<Weather> call(String cityName) {
    return repository.getWeatherByCity(cityName);
  }
}
