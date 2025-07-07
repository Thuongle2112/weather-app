import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../data/datasource/weather_remote_data_source.dart';
import '../../data/repository/weather/weather_repository_impl.dart';
import '../../domain/usecase/weather/get_weather_by_city.dart';
import '../../domain/usecase/weather/get_weather_by_coordinates.dart';
import '../../presentation/page/home/bloc/home_bloc.dart';
import '../../presentation/providers/theme_provider.dart';

class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator _instance = ServiceLocator._();
  static ServiceLocator get instance => _instance;

  final GetIt _getIt = GetIt.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Dio get dio => Dio();

  WeatherRemoteDataSource get weatherRemoteDataSource =>
      WeatherRemoteDataSource(dio);

  WeatherRepositoryImpl get weatherRepository =>
      WeatherRepositoryImpl(weatherRemoteDataSource);

  GetWeatherByCity get getWeatherByCity => GetWeatherByCity(weatherRepository);
  GetWeatherByCoordinates get getWeatherByCoordinates =>
      GetWeatherByCoordinates(weatherRepository);

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

  void registerSingleton<T extends Object>(T instance) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerSingleton<T>(instance);
    }
  }

  T get<T extends Object>() {
    return _getIt.get<T>();
  }

  Future<T?> navigateTo<T>(Widget page) {
    return navigatorKey.currentState!.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void navigateFromNotification(
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    if (route == 'weather_details' && arguments != null) {
      final city = arguments['city'] as String?;
      if (city != null) {}
    }
  }
}
