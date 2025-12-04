import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import '../page/home/bloc/home_bloc.dart';
import '../page/home/bloc/home_event.dart';

class WeatherService {
  static Future<void> getWeatherByCurrentLocation(BuildContext context) async {
    try {
      debugPrint('🔍 Getting current location...');
      context.read<WeatherBloc>().add(const WeatherStartLoading());

      // 1. CHECK: Location services enabled?
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('❌ GPS is OFF on device');
        if (context.mounted) {
          _showGPSDisabledDialog(context);
          // Fallback to default city
          context.read<WeatherBloc>().add(const FetchWeatherByCity('Hanoi'));
        }
        return;
      }

      // 2. CHECK: Permission granted?
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('⚠️ Permission denied, requesting...');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('❌ Permission denied by user');
          if (context.mounted) {
            _showPermissionDeniedMessage(context);
            context.read<WeatherBloc>().add(const FetchWeatherByCity('Hanoi'));
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ Permission permanently denied');
        if (context.mounted) {
          _showPermanentlyDeniedDialog(context);
          context.read<WeatherBloc>().add(const FetchWeatherByCity('Hanoi'));
        }
        return;
      }

      // 3. TRY: Get last known position first (FAST)
      Position? lastPosition;
      try {
        lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          debugPrint('📍 Using last known position: ${lastPosition.latitude}, ${lastPosition.longitude}');
          if (context.mounted) {
            context.read<WeatherBloc>().add(
              FetchWeatherByCoordinates(
                lastPosition.latitude,
                lastPosition.longitude,
              ),
            );
          }
        }
      } catch (e) {
        debugPrint('⚠️ No last known position: $e');
      }

      // 4. GET: Current position (SLOW but accurate)
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium, // Balance speed vs accuracy
          timeLimit: const Duration(seconds: 15), // Increased timeout
          forceAndroidLocationManager: false, // Use Google Play Services
        ).timeout(
          const Duration(seconds: 20), // Backup timeout
          onTimeout: () {
            throw TimeoutException('GPS timeout after 20 seconds');
          },
        );

        debugPrint('✅ Current position: ${position.latitude}, ${position.longitude}');

        if (context.mounted) {
          context.read<WeatherBloc>().add(
            FetchWeatherByCoordinates(
              position.latitude,
              position.longitude,
            ),
          );
        }
      } on TimeoutException catch (e) {
        debugPrint('⏱️ GPS TIMEOUT: $e');
        
        if (lastPosition != null) {
          // Already using last position above
          if (context.mounted) {
            _showGPSTimeoutMessage(context, hasLastPosition: true);
          }
        } else {
          // No position at all, use default city
          if (context.mounted) {
            _showGPSTimeoutMessage(context, hasLastPosition: false);
            context.read<WeatherBloc>().add(const FetchWeatherByCity('Hanoi'));
          }
        }
      }
    } catch (e) {
      debugPrint('❌ GPS ERROR: $e');
      if (context.mounted) {
        _showErrorMessage(context, e.toString());
        context.read<WeatherBloc>().add(const FetchWeatherByCity('Hanoi'));
      }
    }
  }

  static Future<void> checkLocationPermission(
    BuildContext context,
    Function(bool) onPermissionDetermined,
  ) async {
    try {
      // Check GPS enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        onPermissionDetermined(false);
        if (context.mounted) {
          _showGPSDisabledDialog(context);
          context.read<WeatherBloc>().add(const FetchWeatherByCity('Hanoi'));
        }
        return;
      }

      // Check permission
      final status = await Permission.locationWhenInUse.status;
      
      if (status.isGranted) {
        onPermissionDetermined(true);
        getWeatherByCurrentLocation(context);
      } else if (status.isDenied) {
        onPermissionDetermined(false);
      } else if (status.isPermanentlyDenied) {
        onPermissionDetermined(false);
        if (context.mounted) {
          _showPermanentlyDeniedDialog(context);
        }
      }
    } catch (e) {
      debugPrint('❌ Check permission error: $e');
      onPermissionDetermined(false);
    }
  }

  static Future<void> requestLocationPermission(BuildContext context) async {
    try {
      // Check GPS first
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          _showGPSDisabledDialog(context);
        }
        return;
      }

      // Request permission
      final status = await Permission.locationWhenInUse.request();

      if (status.isGranted) {
        getWeatherByCurrentLocation(context);
      } else if (status.isPermanentlyDenied) {
        if (context.mounted) {
          _showPermanentlyDeniedDialog(context);
        }
      } else {
        if (context.mounted) {
          _showPermissionDeniedMessage(context);
        }
      }
    } catch (e) {
      debugPrint('❌ Request permission error: $e');
      if (context.mounted) {
        _showErrorMessage(context, e.toString());
      }
    }
  }

  // ========== UI FEEDBACK METHODS ==========

  static void _showGPSDisabledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.location_off, color: Colors.red),
            const SizedBox(width: 8),
            Text('gps_disabled'.tr()),
          ],
        ),
        content: Text('please_enable_gps'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
            child: Text('open_settings'.tr()),
          ),
        ],
      ),
    );
  }

  static void _showPermissionDeniedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('permission_denied'.tr())),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.orange,
        action: SnackBarAction(
          label: 'settings'.tr(),
          textColor: Colors.white,
          onPressed: () => openAppSettings(),
        ),
      ),
    );
  }

  static void _showPermanentlyDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.block, color: Colors.red),
            const SizedBox(width: 8),
            Text('permission_required'.tr()),
          ],
        ),
        content: Text('permission_permanently_denied'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('open_settings'.tr()),
          ),
        ],
      ),
    );
  }

  static void _showGPSTimeoutMessage(
    BuildContext context, {
    required bool hasLastPosition,
  }) {
    final message = hasLastPosition
        ? 'gps_timeout_using_last'.tr()
        : 'gps_timeout_using_default'.tr();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.orange,
      ),
    );
  }

  static void _showErrorMessage(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('${'error'.tr()}: $error')),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }
}