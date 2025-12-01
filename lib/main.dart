import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/presentation/app_router.dart';
import 'package:weather_app/presentation/providers/notification_settings_provider.dart';
import 'package:weather_app/presentation/providers/theme_provider.dart';
import 'core/di/service_locator.dart';
import 'core/services/push_notification_service.dart';
import 'data/datasource/preferences_manager.dart';
import 'firebase_options.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: '.env');

  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize();

  ServiceLocator.instance.registerSingleton<PushNotificationService>(
    pushNotificationService,
  );

  final pendingNotifications =
      await pushNotificationService.getPendingNotifications();
  debugPrint('Pending notifications: ${pendingNotifications.length}');

  Future.delayed(const Duration(seconds: 1), () {
    pushNotificationService.sendWelcomeNotification();
  });

  final savedLocale = await PreferencesManager.getSavedLocale();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: savedLocale,
      saveLocale: true,
      child: MultiProvider(
        providers: [
          ...ServiceLocator.instance.providers,
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => NotificationSettingsProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X size, change if needed
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Thời tiết (Halloween)',
          routerConfig: appRouter,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          // home: const WeatherHomePage(),
          // navigatorKey: ServiceLocator.instance.navigatorKey,
        );
      },
    );
  }
}
