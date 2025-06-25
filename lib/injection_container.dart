import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'data/datasource/weather_remote_data_source.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => WeatherRemoteDataSource(sl()));
}
