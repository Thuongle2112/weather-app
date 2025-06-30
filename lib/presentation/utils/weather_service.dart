import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../page/home/bloc/home_bloc.dart';
import '../page/home/bloc/home_event.dart';

class WeatherService {
  static Future<void> getWeatherByCurrentLocation(BuildContext context) async {
    try {
      debugPrint('🔍 Getting current location...');
      context.read<WeatherBloc>().add(const WeatherStartLoading());

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );

      debugPrint(
        '📍 Position obtained: ${position.latitude}, ${position.longitude}',
      );

      if (context.mounted) {
        context.read<WeatherBloc>().add(
          FetchWeatherByCoordinates(position.latitude, position.longitude),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> checkLocationPermission(
    BuildContext context,
    Function(bool) onPermissionDetermined,
  ) async {
    final status = await Permission.locationWhenInUse.status;
    onPermissionDetermined(true);

    if (status.isGranted) {
      getWeatherByCurrentLocation(context);
    }
  }

  static Future<void> requestLocationPermission(BuildContext context) async {
    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      getWeatherByCurrentLocation(context);
    } else {
      return;
    }
  }
}
