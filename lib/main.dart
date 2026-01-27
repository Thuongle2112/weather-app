import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/theme/app_text_theme.dart';
import 'package:weather_app/presentation/app_router.dart';
import 'package:weather_app/presentation/providers/notification_settings_provider.dart';
import 'package:weather_app/presentation/providers/theme_provider.dart';
import 'core/constants/language_constants.dart';
import 'core/di/service_locator.dart';
import 'core/services/animation_preloader.dart';
import 'core/services/optimized_translation_loader.dart';
import 'core/services/push_notification_service.dart';
import 'data/datasource/preferences_manager.dart';
import 'firebase_options.dart';

// Global variable for saved locale
Locale? _savedLocale;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // UI configuration (synchronous, fast)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations (synchronous)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Parallel initialization of independent services
  final startTime = DateTime.now();
  debugPrint('🚀 Starting app initialization...');

  await Future.wait([
    // Core services
    dotenv.load(fileName: '.env'),
    EasyLocalization.ensureInitialized(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    ServiceLocator.instance.init(),
    MobileAds.instance.initialize(),
    PreferencesManager.getSavedLocale().then((locale) => _savedLocale = locale),
    // Preload critical animations
    AnimationPreloader().preloadCritical(),
  ]);

  // Initialize push notifications after Firebase
  final pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize();

  ServiceLocator.instance.registerSingleton<PushNotificationService>(
    pushNotificationService,
  );

  // Non-blocking notification tasks
  pushNotificationService.getPendingNotifications().then((notifications) {
    debugPrint('Pending notifications: ${notifications.length}');
  });

  Future.delayed(const Duration(seconds: 1), () {
    pushNotificationService.sendWelcomeNotification();
  });

  final savedLocale = _savedLocale ?? const Locale('en');
  
  final duration = DateTime.now().difference(startTime);
  // Preload secondary animations in background
  AnimationPreloader().preloadInBackground();

  debugPrint('✅ App initialized in ${duration.inMilliseconds}ms');

  runApp(
    EasyLocalization(
      supportedLocales: LanguageConstants.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: savedLocale,
      saveLocale: true,
      assetLoader: const OptimizedTranslationLoader(), // 🎯 Only load current locale
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
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Thời tiết',
          routerConfig: appRouter,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: GoogleFonts.poppins().fontFamily,
            textTheme: AppTextTheme.lightTextTheme(),
            primarySwatch: Colors.blue,
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.poppins().fontFamily,
            textTheme: AppTextTheme.darkTextTheme(),
            primarySwatch: Colors.blue,
          ),
        );
      },
    );
  }
}
