import '../../../data/model/weather/forecast_item.dart';
import '../../repository/weather/weather_repository.dart';

class GetHourlyForecast {
  final WeatherRepository repository;

  GetHourlyForecast(this.repository);

  Future<List<ForecastItem>> call({
    double? lat,
    double? lon,
    String? cityName,
  }) {
    return repository.getHourlyForecast(
      lat: lat,
      lon: lon,
      cityName: cityName,
    );
  }
}