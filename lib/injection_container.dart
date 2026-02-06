import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_interceptor.dart';
import 'core/storage/indexed_preferences.dart';
import 'data/datasource/weather_local_data_source.dart';
import 'data/datasource/weather_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External - Create optimized Dio instance with retry logic
  sl.registerLazySingleton(() => NetworkClient.create(
    maxRetries: 3,
    retryDelay: const Duration(seconds: 2),
    timeout: const Duration(seconds: 15),
    enableLogging: true,
  ));
  
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  
  // Indexed preferences for fast key lookups
  final indexedPrefs = IndexedPreferences(prefs);
  await indexedPrefs.buildIndex();
  sl.registerLazySingleton(() => indexedPrefs);
  
  // Data sources
  sl.registerLazySingleton(() => WeatherRemoteDataSource(sl()));
  sl.registerLazySingleton(() => WeatherLocalDataSource(sl()));
}
