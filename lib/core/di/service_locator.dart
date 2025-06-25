import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../data/datasource/weather_remote_data_source.dart';
import '../../data/repository/weather/weather_repository_impl.dart';
import '../../domain/usecase/weather/get_weather_by_city.dart';
import '../../domain/usecase/weather/get_weather_by_coordinates.dart';
import '../../presentation/page/home/bloc/home_bloc.dart';
import '../../presentation/providers/theme_provider.dart';

class ServiceLocator {
  // Singleton pattern
  ServiceLocator._();
  static final ServiceLocator _instance = ServiceLocator._();
  static ServiceLocator get instance => _instance;

  // Services
  Dio get dio => Dio();

  // Data sources
  WeatherRemoteDataSource get weatherRemoteDataSource =>
      WeatherRemoteDataSource(dio);

  // Repositories
  WeatherRepositoryImpl get weatherRepository =>
      WeatherRepositoryImpl(weatherRemoteDataSource);

  // Use cases
  GetWeatherByCity get getWeatherByCity => GetWeatherByCity(weatherRepository);
  GetWeatherByCoordinates get getWeatherByCoordinates =>
      GetWeatherByCoordinates(weatherRepository);

  // Providers
  List<SingleChildWidget> get providers => [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    BlocProvider<WeatherBloc>(
      create:
          (context) => WeatherBloc(
            getWeatherByCity: getWeatherByCity,
            getWeatherByCoordinates: getWeatherByCoordinates,
          ),
    ),
  ];
}
