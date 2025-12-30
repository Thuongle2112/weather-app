import 'package:flutter/material.dart';

import '../../../domain/repository/weather/air_pollution_repository.dart';
import '../../datasource/air_pollution_remote_data_source.dart';
import '../../model/weather/air_pollution.dart';

class AirPollutionRepositoryImpl implements AirPollutionRepository {
  final AirPollutionRemoteDataSource remoteDataSource;

  AirPollutionRepositoryImpl(this.remoteDataSource);

  @override
  Future<AirPollution> getAirPollution(double? lat, double? lon) async {
    try {
      final result = await remoteDataSource.getAirPollution(lat, lon);
      debugPrint('✅ Repository: getAirPollution completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ Repository: getAirPollution failed: $e');
      rethrow;
    }
  }
}
