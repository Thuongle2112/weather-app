import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/services/push_notification_service.dart';

class NotificationSettingsProvider with ChangeNotifier {
  bool _morningForecastEnabled = true;
  TimeOfDay _morningTimeObj = const TimeOfDay(hour: 7, minute: 0);
  String _morningTime = '07:00';
  bool _severeWeatherAlertsEnabled = true;
  bool _rainAlertsEnabled = true;
  bool _currentLocationEnabled = true;
  final Map<String, bool> _cityEnabledMap = {};
  List<String> _savedCities = [];

  final PushNotificationService _notificationService =
      PushNotificationService();

  bool get morningForecastEnabled => _morningForecastEnabled;
  String get morningTime => _morningTime;
  TimeOfDay get morningTimeObj => _morningTimeObj;
  bool get severeWeatherAlertsEnabled => _severeWeatherAlertsEnabled;
  bool get rainAlertsEnabled => _rainAlertsEnabled;
  bool get currentLocationEnabled => _currentLocationEnabled;
  List<String> get savedCities => _savedCities;

  bool isCityEnabled(String city) => _cityEnabledMap[city] ?? false;

  NotificationSettingsProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    _morningForecastEnabled = prefs.getBool('morning_forecast_enabled') ?? true;
    _morningTime = prefs.getString('morning_forecast_time') ?? '07:00';
    _parseTimeString();

    _severeWeatherAlertsEnabled =
        prefs.getBool('severe_weather_alerts_enabled') ?? true;
    _rainAlertsEnabled = prefs.getBool('rain_alerts_enabled') ?? true;
    _currentLocationEnabled = prefs.getBool('current_location_enabled') ?? true;
    _savedCities = prefs.getStringList('saved_cities') ?? [];

    if (_savedCities.isEmpty) {
      _initializeDefaultCities();
    }

    for (final city in _savedCities) {
      _cityEnabledMap[city] = prefs.getBool('city_enabled_$city') ?? true;
    }

    notifyListeners();

    await applyNotificationSettings();
  }

  void _initializeDefaultCities() {
    _savedCities = ['Ho Chi Minh City', 'Ha Noi', 'Da Nang'];
    for (final city in _savedCities) {
      _cityEnabledMap[city] = true;
    }
  }

  void _parseTimeString() {
    final timeParts = _morningTime.split(':');
    if (timeParts.length == 2) {
      _morningTimeObj = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('morning_forecast_enabled', _morningForecastEnabled);
    await prefs.setString('morning_forecast_time', _morningTime);

    await prefs.setBool(
      'severe_weather_alerts_enabled',
      _severeWeatherAlertsEnabled,
    );
    await prefs.setBool('rain_alerts_enabled', _rainAlertsEnabled);
    await prefs.setBool('current_location_enabled', _currentLocationEnabled);
    await prefs.setStringList('saved_cities', _savedCities);
    for (final city in _savedCities) {
      await prefs.setBool('city_enabled_$city', _cityEnabledMap[city] ?? false);
    }
  }

  Future<void> applyNotificationSettings() async {
    try {
      await _notificationService.cancelAllNotifications();

      if (!_morningForecastEnabled &&
          !_currentLocationEnabled &&
          !_severeWeatherAlertsEnabled &&
          !_rainAlertsEnabled) {
        return;
      }

      if (_morningForecastEnabled) {
        await _scheduleMorningNotification();
      }

      // if (_currentLocationEnabled) {
      //   await _scheduleLocationBasedNotifications();
      // }

      // await _scheduleCityNotifications();

      // if (_severeWeatherAlertsEnabled || _rainAlertsEnabled) {
      //   await _scheduleWeatherAlertCheck();
      // }
    } catch (e) {
      debugPrint('Error applying notification settings: $e');
    }
  }

  Future<void> _scheduleMorningNotification() async {
    try {
      if (!_morningForecastEnabled) {
        debugPrint('Morning forecast disabled, cancelling task');
        await Workmanager().cancelByUniqueName('daily_weather_100');
        return;
      }

      final now = DateTime.now();
      final scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _morningTimeObj.hour,
        _morningTimeObj.minute,
      );

      debugPrint('Scheduling morning notification for: $_morningTime');

      final success = await _notificationService
          .scheduleDailyWeatherNotification(
            scheduledTime: scheduledDateTime,
            id: 100,
          );

      if (success) {
        debugPrint('Morning notification scheduled successfully');
      } else {
        debugPrint('Failed to schedule morning notification');
      }
    } catch (e) {
      debugPrint('Error scheduling morning notification: $e');
    }
  }

  // Future<void> _scheduleMorningNotification() async {
  //   try {
  //     final timeParts = _morningTime.split(':');
  //     final hour = int.parse(timeParts[0]);
  //     final minute = int.parse(timeParts[1]);

  //     final now = DateTime.now();
  //     var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

  //     if (scheduledTime.isBefore(now)) {
  //       scheduledTime = scheduledTime.add(const Duration(days: 1));
  //     }

  //     String title = 'Daily Weather Forecast';
  //     String body = 'Your morning weather update is ready';

  //     final enabledCities = _savedCities
  //         .where((city) => _cityEnabledMap[city] == true)
  //         .take(2);

  //     if (enabledCities.isNotEmpty) {
  //       body = 'Weather forecast for ${enabledCities.join(", ")}';

  //       if (enabledCities.length == 1) {
  //         title = 'Weather in ${enabledCities.first}';
  //       } else {
  //         title = 'Weather Updates';
  //       }
  //     }

  //     await _notificationService.scheduleDailyWeatherNotification(
  //       title: title,
  //       body: body,
  //       scheduledTime: scheduledTime,
  //       id: 0,
  //     );

  //     debugPrint(
  //       'Scheduled morning notification for ${scheduledTime.toString()}',
  //     );
  //   } catch (e) {
  //     debugPrint('Error scheduling morning notification: $e');
  //   }
  // }

  // Future<void> _scheduleCityNotifications() async {
  //   final enabledCities =
  //       _savedCities.where((city) => _cityEnabledMap[city] == true).toList();

  //   if (enabledCities.isEmpty) return;

  //   final now = DateTime.now();
  //   var baseTime = DateTime(now.year, now.month, now.day, 16, 0);

  //   if (baseTime.isBefore(now)) {
  //     baseTime = baseTime.add(const Duration(days: 1));
  //   }

  //   for (int i = 0; i < enabledCities.length; i++) {
  //     final city = enabledCities[i];
  //     final scheduledTime = baseTime.add(Duration(minutes: i * 5));

  //     try {
  //       await _notificationService.scheduleDailyWeatherNotification(
  //         title: 'Weather Update for $city',
  //         body: 'Tap to see the latest weather conditions in $city',
  //         scheduledTime: scheduledTime,
  //         id: i + 1,
  //       );

  //       debugPrint(
  //         'Scheduled notification for $city at ${scheduledTime.toString()}',
  //       );
  //     } catch (e) {
  //       debugPrint('Error scheduling notification for $city: $e');
  //     }
  //   }
  // }

  // Future<void> _scheduleWeatherAlertCheck() async {
  //   if (!_severeWeatherAlertsEnabled && !_rainAlertsEnabled) return;

  //   try {
  //     final now = DateTime.now();
  //     var alertCheckTime = DateTime(now.year, now.month, now.day, 9, 0);

  //     if (alertCheckTime.isBefore(now)) {
  //       alertCheckTime = alertCheckTime.add(const Duration(days: 1));
  //     }

  //     List<String> alertTypes = [];
  //     if (_severeWeatherAlertsEnabled) alertTypes.add('severe weather');
  //     if (_rainAlertsEnabled) alertTypes.add('rain');

  //     await _notificationService.scheduleDailyWeatherNotification(
  //       title: 'Weather Alert Check',
  //       body: 'We\'ll check for ${alertTypes.join(" and ")} alerts today',
  //       scheduledTime: alertCheckTime,
  //       id: 100,
  //     );

  //     debugPrint(
  //       'Scheduled alert check notification for ${alertCheckTime.toString()}',
  //     );
  //   } catch (e) {
  //     debugPrint('Error scheduling alert check: $e');
  //   }
  // }

  void setMorningForecastEnabled(bool value) {
    if (_morningForecastEnabled != value) {
      _morningForecastEnabled = value;
      _saveAndApplySettings();
    }
  }

  void setMorningTime(TimeOfDay time) {
    final formattedTime =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    if (_morningTime != formattedTime) {
      _morningTime = formattedTime;
      _morningTimeObj = time;
      _saveAndApplySettings();
    }
  }

  void setSevereWeatherAlertsEnabled(bool value) {
    if (_severeWeatherAlertsEnabled != value) {
      _severeWeatherAlertsEnabled = value;
      _saveAndApplySettings();
    }
  }

  void setRainAlertsEnabled(bool value) {
    if (_rainAlertsEnabled != value) {
      _rainAlertsEnabled = value;
      _saveAndApplySettings();
    }
  }

  void setCurrentLocationEnabled(bool value) {
    if (_currentLocationEnabled != value) {
      _currentLocationEnabled = value;
      _saveAndApplySettings();
    }
  }

  void setCityEnabled(String city, bool value) {
    if (_cityEnabledMap[city] != value) {
      _cityEnabledMap[city] = value;
      _saveAndApplySettings();
    }
  }

  void addCity(String city) {
    if (!_savedCities.contains(city)) {
      _savedCities.add(city);
      _cityEnabledMap[city] = true;
      _saveAndApplySettings();
    }
  }

  void removeCity(String city) {
    if (_savedCities.contains(city)) {
      _savedCities.remove(city);
      _cityEnabledMap.remove(city);
      _saveAndApplySettings();
    }
  }

  Future<void> _saveAndApplySettings() async {
    await _saveSettings();
    await applyNotificationSettings();
    notifyListeners();
  }

  // Future<bool> sendTestNotification() async {
  //   try {
  //     return await _notificationService.showWeatherAlert(
  //       title: 'Weather Test Notification',
  //       body:
  //           'This is a test notification to confirm your settings are working correctly. Current time: ${DateTime.now().toString().substring(0, 16)}',
  //     );
  //   } catch (e) {
  //     debugPrint('Error sending test notification: $e');
  //     return false;
  //   }
  // }

  Future<bool> sendTestNotification() async {
    try {
      return await _notificationService.sendImmediateWeatherNotification();
    } catch (e) {
      debugPrint('Error sending test notification: $e');
      return false;
    }
  }

  // Future<void> _scheduleLocationBasedNotifications() async {
  //   if (!_currentLocationEnabled) return;

  //   try {
  //     final now = DateTime.now();
  //     var locationTime = DateTime(now.year, now.month, now.day, 12, 0);

  //     if (locationTime.isBefore(now)) {
  //       locationTime = locationTime.add(const Duration(days: 1));
  //     }

  //     await _notificationService.scheduleDailyWeatherNotification(
  //       title: 'Weather at Your Location',
  //       body: 'Tap to see current weather conditions for your location',
  //       scheduledTime: locationTime,
  //       id: 50,
  //     );

  //     debugPrint(
  //       'Scheduled location-based notification for ${locationTime.toString()}',
  //     );
  //   } catch (e) {
  //     debugPrint('Error scheduling location notification: $e');
  //   }
  // }

  Future<void> checkNotificationPermissions() async {
    try {
      final service = PushNotificationService();
      await service.initialize();

      final lastNotificationCheck = await _getLastNotificationCheck();
      final now = DateTime.now();

      if (lastNotificationCheck == null ||
          lastNotificationCheck.day != now.day ||
          lastNotificationCheck.month != now.month) {
        await _saveLastNotificationCheck(now);

        await service.sendWelcomeNotification();
      }
    } catch (e) {
      debugPrint('Error checking notification permissions: $e');
    }
  }

  Future<DateTime?> _getLastNotificationCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('last_notification_check');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<void> _saveLastNotificationCheck(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_notification_check', time.millisecondsSinceEpoch);
  }
}
