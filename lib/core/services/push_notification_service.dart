import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message received: ${message.messageId}');
}

@pragma('vm:entry-point')
void backgroundNotificationResponseHandler(NotificationResponse response) {
  debugPrint('Background notification response: ${response.payload}');
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

  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
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
      await androidPlugin.requestNotificationsPermission();
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
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
      return true;
    } catch (e) {
      debugPrint('Error showing weather alert: $e');
      return false;
    }
  }

  Future<bool> scheduleDailyWeatherNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    int id = 0,
  }) async {
    try {
      tz_data.initializeTimeZones();
      var timeZone = tz.local;
      var scheduledDate = tz.TZDateTime.from(scheduledTime, timeZone);

      final now = tz.TZDateTime.now(timeZone);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = tz.TZDateTime(
          timeZone,
          now.year,
          now.month,
          now.day + 1,
          scheduledTime.hour,
          scheduledTime.minute,
        );
      }

      await _flutterLocalNotificationsPlugin.cancel(id);

      try {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
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
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        return true;
      } catch (e) {
        if (e.toString().contains('exact_alarms_not_permitted')) {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            title,
            body,
            scheduledDate,
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
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
          );
          return true;
        }
        rethrow;
      }
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      return false;
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<bool> sendWelcomeNotification() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final currentTime = DateTime.now();
      final formattedTime =
          '${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')}';

      await _flutterLocalNotificationsPlugin.show(
        999,
        'Weather App is Ready',
        'It\'s $formattedTime. Tap for current weather updates!',
        NotificationDetails(
          android: AndroidNotificationDetails(
            _weatherUpdatesChannel.id,
            _weatherUpdatesChannel.name,
            channelDescription: _weatherUpdatesChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            styleInformation: const BigTextStyleInformation(
              'Weather notifications are working correctly. Check your settings to customize daily forecasts.',
            ),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      debugPrint('Welcome notification sent successfully');
      return true;
    } catch (e) {
      debugPrint('Error sending welcome notification: $e');
      return false;
    }
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
        status['notifications_enabled'] = notificationPermission;

        try {
          final exactAlarmPermission =
              await androidPlugin.requestExactAlarmsPermission();
          status['exact_alarm_requested'] = true;
        } catch (e) {
          status['exact_alarm_error'] = e.toString();
        }
      }

      final pendingNotifications = await getPendingNotifications();
      status['pending_notifications'] = pendingNotifications.length;
    } catch (e) {
      status['error'] = e.toString();
    }

    return status;
  }
}
