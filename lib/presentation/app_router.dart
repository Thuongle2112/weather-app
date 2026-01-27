import 'package:go_router/go_router.dart';
import 'package:weather_app/presentation/page/home/weather_home_page.dart';
import 'package:weather_app/presentation/page/onboarding/onboarding_screen.dart';
import 'package:weather_app/presentation/page/splash/splash_screen.dart';

import 'page/home/widgets/fortune_shake/fortune_shake_widget.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const WeatherHomePage(),
    ),
    GoRoute(
      path: '/fortune-shake',
      builder: (context, state) => const FortuneShakeWidget(),
    ),
  ],
);
