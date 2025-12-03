import '../../../data/model/weather/daily_forecast.dart';
import '../../repository/weather/weather_repository.dart';

class GetDailyForecast {
  final WeatherRepository repository;

  GetDailyForecast(this.repository);

  Future<List<DailyForecast>> call({
    double? lat,
    double? lon,
    String? cityName,
  }) {
    return repository.getDailyForecast(
      lat: lat,
      lon: lon,
      cityName: cityName,
    );
  }
}