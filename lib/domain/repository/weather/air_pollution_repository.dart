import '../../../data/model/weather/air_pollution.dart';

abstract class AirPollutionRepository {
  Future<AirPollution> getAirPollution(
    double? lat,
    double? lon,
  );
}
