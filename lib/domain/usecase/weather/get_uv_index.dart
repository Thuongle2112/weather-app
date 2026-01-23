import '../../../data/model/weather/uv_index.dart';
import '../../repository/weather/weather_repository.dart';

class GetUVIndex {
  final WeatherRepository repository;

  GetUVIndex(this.repository);

  Future<UVIndex> call({
    double? lat,
    double? lon,
    String? cityName,
  }) {
    return repository.getUVIndex(
      lat: lat,
      lon: lon,
      cityName: cityName,
    );
  }
}