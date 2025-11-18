import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:workmanager/workmanager.dart';
import '../../data/datasource/weather_remote_data_source.dart';
import '../../data/repository/weather/weather_repository_impl.dart';
import 'weather_notification_helper.dart';

// Background task name
const String weatherNotificationTask = 'weatherNotificationTask';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message received: ${message.messageId}');
}

@pragma('vm:entry-point')
void backgroundNotificationResponseHandler(NotificationResponse response) {
  debugPrint('Background notification response: ${response.payload}');
}

// Background callback for WorkManager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      debugPrint('Background task started: $task');

      if (task == weatherNotificationTask) {
        // FIX: Initialize dependencies properly
        final dio = Dio();
        final weatherDataSource = WeatherRemoteDataSource(dio);
        final helper = WeatherNotificationHelper(weatherDataSource);

        // Fetch weather data
        final weatherData = await helper.fetchWeatherForNotification();

        // Show notification with real weather data
        final FlutterLocalNotificationsPlugin notificationsPlugin =
            FlutterLocalNotificationsPlugin();

        const androidDetails = AndroidNotificationDetails(
          'weather_updates',
          'Weather Updates',
          channelDescription: 'Daily weather forecast notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

        const notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );

        await notificationsPlugin.show(
          100, // Morning forecast ID
          weatherData['title']!,
          weatherData['body']!,
          notificationDetails,
        );

        debugPrint('Weather notification sent: ${weatherData['title']}');
      }

      return Future.value(true);
    } catch (e) {
      debugPrint('Error in background task: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return Future.value(false);
    }
  });
}

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _weatherUpdatesChannel =
      AndroidNotificationChannel(
        'weather_updates',
        'Weather Updates',
        description: 'Notifications about weather updates and changes',
        importance: Importance.high,
      );

  static const AndroidNotificationChannel _weatherAlertsChannel =
      AndroidNotificationChannel(
        'weather_alerts',
        'Weather Alerts',
        description: 'Important alerts about extreme weather conditions',
        importance: Importance.max,
      );

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('PushNotificationService already initialized');
      return;
    }

    try {
      // Initialize timezone
      tz_data.initializeTimeZones();
      final locationName = await _getLocalTimezoneName();
      tz.setLocalLocation(tz.getLocation(locationName));
      debugPrint('Timezone initialized: $locationName');

      // Initialize WorkManager for background tasks
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
      debugPrint('WorkManager initialized');
    } catch (e) {
      debugPrint('Error initializing timezone: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('User notification permission: ${settings.authorizationStatus}');

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('Notification response: ${response.payload}');
      },
      onDidReceiveBackgroundNotificationResponse:
          backgroundNotificationResponseHandler,
    );

    final androidPlugin =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_weatherUpdatesChannel);
      await androidPlugin.createNotificationChannel(_weatherAlertsChannel);

      final notificationPermission =
          await androidPlugin.areNotificationsEnabled();
      debugPrint('Android notifications enabled: $notificationPermission');

      if (notificationPermission == true) {
        try {
          final exactAlarmPermission =
              await androidPlugin.requestExactAlarmsPermission();
          debugPrint('Exact alarm permission: $exactAlarmPermission');
        } catch (e) {
          debugPrint('Error requesting exact alarms: $e');
        }
      } else {
        await androidPlugin.requestNotificationsPermission();
      }
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    _isInitialized = true;
    debugPrint('PushNotificationService initialized successfully');
  }

  Future<String> _getLocalTimezoneName() async {
    try {
      final now = DateTime.now();
      final offset = now.timeZoneOffset;

      if (offset.inHours == 7) return 'Asia/Ho_Chi_Minh';
      if (offset.inHours == 8) return 'Asia/Singapore';
      if (offset.inHours == 9) return 'Asia/Tokyo';

      return 'Asia/Ho_Chi_Minh';
    } catch (e) {
      return 'Asia/Ho_Chi_Minh';
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _weatherUpdatesChannel.id,
            _weatherUpdatesChannel.name,
            channelDescription: _weatherUpdatesChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
  }

  Future<bool> showWeatherAlert({
    required String title,
    required String body,
    String? bigText,
  }) async {
    try {
      final id = DateTime.now().microsecondsSinceEpoch % 100000;

      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _weatherUpdatesChannel.id,
            _weatherUpdatesChannel.name,
            channelDescription: _weatherUpdatesChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            styleInformation: BigTextStyleInformation(bigText ?? body),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      debugPrint('Weather alert shown successfully: $title');
      return true;
    } catch (e) {
      debugPrint('Error showing weather alert: $e');
      return false;
    }
  }

  /// Schedule daily weather notification with REAL weather data
  Future<bool> scheduleDailyWeatherNotification({
    required DateTime scheduledTime,
    int id = 100,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // Cancel existing task
      await Workmanager().cancelByUniqueName('daily_weather_$id');

      // Calculate initial delay
      final now = DateTime.now();
      var nextRun = DateTime(
        now.year,
        now.month,
        now.day,
        scheduledTime.hour,
        scheduledTime.minute,
      );

      if (nextRun.isBefore(now)) {
        nextRun = nextRun.add(const Duration(days: 1));
      }

      final initialDelay = nextRun.difference(now);

      debugPrint('Scheduling daily weather notification:');
      debugPrint('  Current time: $now');
      debugPrint('  Next run: $nextRun');
      debugPrint('  Initial delay: $initialDelay');

      // Register periodic task with WorkManager
      await Workmanager().registerPeriodicTask(
        'daily_weather_$id',
        weatherNotificationTask,
        frequency: const Duration(days: 1),
        initialDelay: initialDelay,
        constraints: Constraints(networkType: NetworkType.connected),
        inputData: {
          'notification_id': id,
          'scheduled_hour': scheduledTime.hour,
          'scheduled_minute': scheduledTime.minute,
        },
      );

      debugPrint('Daily weather notification scheduled successfully');
      return true;
    } catch (e) {
      debugPrint('Error scheduling daily notification: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  /// Send immediate weather notification with real data
  Future<bool> sendImmediateWeatherNotification() async {
    try {
      // FIX: Initialize dependencies properly
      final dio = Dio();
      final weatherDataSource = WeatherRemoteDataSource(dio);
      final helper = WeatherNotificationHelper(weatherDataSource);

      final weatherData = await helper.fetchWeatherForNotification();

      await _flutterLocalNotificationsPlugin.show(
        999,
        weatherData['title']!,
        weatherData['body']!,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _weatherUpdatesChannel.id,
            _weatherUpdatesChannel.name,
            channelDescription: _weatherUpdatesChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );

      debugPrint(
        'Immediate weather notification sent: ${weatherData['title']}',
      );
      return true;
    } catch (e) {
      debugPrint('Error sending immediate weather notification: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      final pending =
          await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
      debugPrint('Pending notifications: ${pending.length}');
      for (var notification in pending) {
        debugPrint('  - ID: ${notification.id}, Title: ${notification.title}');
      }
      return pending;
    } catch (e) {
      debugPrint('Error getting pending notifications: $e');
      return [];
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      await Workmanager().cancelAll();
      debugPrint('All notifications and tasks cancelled');
    } catch (e) {
      debugPrint('Error cancelling notifications: $e');
    }
  }

  Future<bool> sendWelcomeNotification() async {
    return sendImmediateWeatherNotification();
  }

  Future<Map<String, dynamic>> checkNotificationStatus() async {
    final status = <String, dynamic>{};

    try {
      final firebaseSettings =
          await _firebaseMessaging.getNotificationSettings();
      status['firebase_auth_status'] =
          firebaseSettings.authorizationStatus.toString();

      final androidPlugin =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidPlugin != null) {
        final notificationPermission =
            await androidPlugin.areNotificationsEnabled();
        status['notifications_enabled'] = notificationPermission ?? false;

        try {
          final exactAlarmPermission =
              await androidPlugin.requestExactAlarmsPermission();
          status['exact_alarm_permission'] = exactAlarmPermission ?? false;
        } catch (e) {
          status['exact_alarm_error'] = e.toString();
        }
      }

      final pendingNotifications = await getPendingNotifications();
      status['pending_notifications'] = pendingNotifications.length;
      status['pending_list'] =
          pendingNotifications
              .map((n) => {'id': n.id, 'title': n.title, 'body': n.body})
              .toList();

      debugPrint('Notification status: $status');
    } catch (e) {
      status['error'] = e.toString();
      debugPrint('Error checking notification status: $e');
    }

    return status;
  }
}
