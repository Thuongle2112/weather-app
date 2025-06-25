import '../../../data/model/weather/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeatherByCity(String cityName);
  Future<Weather> getWeatherByCoordinates(double lat, double lon);
}
