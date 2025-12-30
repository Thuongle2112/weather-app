import '../../../data/model/weather/air_pollution.dart';
import '../../repository/weather/air_pollution_repository.dart';

class GetAirPollution {
  final AirPollutionRepository repository;

  GetAirPollution(this.repository);

  Future<AirPollution> call(double lat, double lon) {
    return repository.getAirPollution(lat, lon);
  }
}
