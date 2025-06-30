import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../page/home/bloc/home_bloc.dart';
import '../page/home/bloc/home_event.dart';
import '../page/home/bloc/home_state.dart';
import 'weather_service.dart';

class PreferencesUtil {
  static Future<void> saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }

  static Future<void> refreshWeatherWithCurrentLanguage(BuildContext context) async {
    final state = context.read<WeatherBloc>().state;
    if (state is WeatherLoaded) {
      final currentCity = state.weather.cityName;
      context.read<WeatherBloc>().add(FetchWeatherByCity(currentCity));
    } else {
      WeatherService.getWeatherByCurrentLocation(context);
    }
  }
}