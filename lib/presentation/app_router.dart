import 'package:go_router/go_router.dart';
import 'package:weather_app/presentation/page/home/weather_home_page.dart';
import 'package:weather_app/presentation/page/home/widgets/states/error_view.dart';
import 'package:weather_app/presentation/page/splash/splash_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const WeatherHomePage(),
    ),
  ],
);