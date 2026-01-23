import '../../../data/model/weather/daily_forecast.dart';
import '../../../data/model/weather/forecast_item.dart';
import '../../../data/model/weather/uv_index.dart';
import '../../../data/model/weather/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeatherByCity(String cityName);
  Future<Weather> getWeatherByCoordinates(double lat, double lon);
  Future<List<ForecastItem>> getHourlyForecast({
    double? lat,
    double? lon,
    String? cityName,
  });
  Future<List<DailyForecast>> getDailyForecast({
    double? lat,
    double? lon,
    String? cityName,
  });
  Future<UVIndex> getUVIndex({
    double? lat,
    double? lon,
    String? cityName,
  });
}
