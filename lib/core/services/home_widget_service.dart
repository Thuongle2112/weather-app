import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';
import '../../data/model/weather/weather.dart';

import '../../domain/repository/weather/weather_repository.dart';
import '../di/service_locator.dart';

class HomeWidgetService {
  static const String _androidWidgetName = 'WeatherWidgetProvider';
  static const String _iosWidgetName = 'WeatherWidget';
  static const String widgetUpdateTask = 'weatherWidgetUpdate';

  /// Initialize home widget
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.com.zamoon6.weather_today');

      // ✅ Save default data immediately after init
      await _saveDefaultData();

      debugPrint('✅ Home widget initialized with default data');
    } catch (e) {
      debugPrint('❌ Home widget init error: $e');
    }
  }

  /// Save default data to prevent widget crash
  static Future<void> _saveDefaultData() async {
    try {
      await HomeWidget.saveWidgetData<String>('city', 'Loading...');
      await HomeWidget.saveWidgetData<int>('temperature', 25);
      await HomeWidget.saveWidgetData<String>('description', 'Tap to update');
      await HomeWidget.saveWidgetData<String>('icon', '01d');
      await HomeWidget.saveWidgetData<int>('humidity', 0);
      await HomeWidget.saveWidgetData<double>('windSpeed', 0.0);
      await HomeWidget.saveWidgetData<int>(
        'lastUpdate',
        DateTime.now().millisecondsSinceEpoch,
      );

      debugPrint('✅ Default widget data saved');
    } catch (e) {
      debugPrint('❌ Failed to save default data: $e');
    }
  }

  /// Update widget with weather data
  static Future<void> updateWidget(Weather weather) async {
    try {
      // Save data to widget with null safety
      await HomeWidget.saveWidgetData<String>(
        'city',
        weather.cityName ?? 'Unknown',
      );
      await HomeWidget.saveWidgetData<int>(
        'temperature',
        weather.temperature?.round() ?? 0,
      );
      await HomeWidget.saveWidgetData<String>(
        'description',
        weather.description ?? 'No data',
      );
      await HomeWidget.saveWidgetData<String>('icon', weather.icon ?? '01d');
      await HomeWidget.saveWidgetData<int>('humidity', weather.humidity ?? 0);
      await HomeWidget.saveWidgetData<double>(
        'windSpeed',
        weather.windSpeed ?? 0.0,
      );
      await HomeWidget.saveWidgetData<int>(
        'lastUpdate',
        DateTime.now().millisecondsSinceEpoch,
      );

      // Update widget UI
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        iOSName: _iosWidgetName,
      );

      debugPrint(
        '✅ Widget updated: ${weather.cityName} ${weather.temperature}°',
      );
    } catch (e) {
      debugPrint('❌ Widget update error: $e');
      // Don't rethrow - continue app execution
    }
  }

  /// Setup periodic widget updates
  static Future<void> setupPeriodicUpdates() async {
    try {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: false, // Change to false for release
      );

      await Workmanager().registerPeriodicTask(
        widgetUpdateTask,
        widgetUpdateTask,
        frequency: const Duration(minutes: 30),
        constraints: Constraints(networkType: NetworkType.connected),
      );

      debugPrint('✅ Periodic widget updates scheduled');
    } catch (e) {
      debugPrint('❌ Workmanager setup error: $e');
      // Don't crash if workmanager fails
    }
  }

  /// Cancel periodic updates
  static Future<void> cancelPeriodicUpdates() async {
    try {
      await Workmanager().cancelByUniqueName(widgetUpdateTask);
      debugPrint('✅ Periodic updates cancelled');
    } catch (e) {
      debugPrint('❌ Cancel updates error: $e');
    }
  }

  /// Handle widget tap to open app
  static void registerInteractivity() {
    try {
      HomeWidget.widgetClicked.listen((uri) {
        debugPrint('🎯 Widget tapped: $uri');
        // Handle widget tap
      });
    } catch (e) {
      debugPrint('❌ Widget interactivity error: $e');
    }
  }
}

/// Background callback for WorkManager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      debugPrint('🔄 Background widget update started');

      // Check if service locator is initialized
      if (!ServiceLocator.instance.isRegistered<WeatherRepository>()) {
        debugPrint('⚠️ Service locator not initialized in background');
        return Future.value(false);
      }

      final weatherRepo = ServiceLocator.instance.get<WeatherRepository>();
      final lastCity = await HomeWidget.getWidgetData<String>('city');
      final cityName = lastCity ?? 'Hanoi';

      final weather = await weatherRepo.getWeatherByCity(cityName);
      await HomeWidgetService.updateWidget(weather);

      debugPrint('✅ Background widget update completed');
      return Future.value(true);
    } catch (e) {
      debugPrint('❌ Background update error: $e');
      return Future.value(false);
    }
  });
}
