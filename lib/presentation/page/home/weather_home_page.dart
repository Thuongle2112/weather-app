import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/presentation/page/home/widgets/effects/event_effect.dart';

import '../../../core/services/ad_service.dart';
import '../../../core/services/home_widget_service.dart';
import '../../../core/services/shake_detector_service.dart';
import '../../../data/model/weather/time_mark.dart';
import '../../../data/model/weather/weather.dart';
import '../../providers/theme_provider.dart';
import '../../utils/event_message_helper.dart';
import '../../utils/weather_service.dart';
import '../../utils/weather_ui_helper.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'widgets/buttons/premium_button.dart';
import 'widgets/city/city_list_section.dart';
import 'widgets/city/city_search_modal.dart';
import 'widgets/daily_forecast_section.dart';
import 'widgets/effects/floating_button.dart';
import 'widgets/hourly_forecast_section.dart';
import 'widgets/states/error_view.dart';
import 'widgets/states/initial_view.dart';
import 'widgets/states/loading_view.dart';
import 'widgets/weather/temperature_display.dart';
import 'widgets/weather/time_progress_bar.dart';
import 'widgets/weather/weather_app_bar.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage>
    with WidgetsBindingObserver {
  // Controllers
  final TextEditingController _cityController = TextEditingController();

  // Services
  late AdService _adService;
  late ShakeDetectorService _shakeService;

  // State
  bool _showFloatingHalloween = true;
  bool _hasShownHalloweenDialog = false;
  bool _showBoo = false;
  bool _showMoneyRain = false;
  int _searchCount = 0;

  // Data
  final List<String> _popularCities = [
    'Hanoi',
    'Ho Chi Minh City',
    'Da Nang',
    'Hue',
    'Nha Trang',
    'Tokyo',
    'Bangkok',
    'Singapore',
    'London',
    'New York',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _adService.dispose();
    _shakeService.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _initializeServices() {
    // Initialize Ad Service
    _adService = AdService(
      bannerAdUnitId: dotenv.env['ADMOB_BANNER_ID'] ?? '',
      interstitialAdUnitId: dotenv.env['ADMOB_INTERSTITIAL_ID'] ?? '',
      rewardedAdUnitId: dotenv.env['ADMOB_REWARDED_ID'] ?? '',
    );

    _adService.loadBannerAd(() => setState(() {}));
    _adService.loadInterstitialAd();
    _adService.loadRewardedAd();

    // Initialize Shake Service
    _shakeService = ShakeDetectorService();
    _shakeService.initialize(
      onBooEffect: () {
        setState(() => _showBoo = true);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _showBoo = false);
        });
      },
      onMoneyRain: () {
        setState(() => _showMoneyRain = true);
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _showMoneyRain = false);
        });
      },
    );

    // Initialize Location Service
    _initializeLocationService();
  }

  Future<void> _initializeLocationService() async {}

  Future<void> _requestLocationPermission() async {
    try {
      await WeatherService.requestLocationPermission(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('location_error'.tr()),
            action: SnackBarAction(
              label: 'settings'.tr(),
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
    }
  }

  void _showCitySearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CitySearchModal(
            cityController: _cityController,
            popularCities: _popularCities,
            onCitySelected: (city) {
              context.read<WeatherBloc>().add(FetchWeatherByCity(city));
              _searchCount++;

              // Show interstitial every 3 searches
              if (!_adService.isPremium && _searchCount % 3 == 0) {
                _adService.showInterstitialAd();
              }
            },
          ),
    );
  }

  void _handleRewardedAd() {
    _adService.showRewardedAd(
      context,
      onRewardEarned: () {
        _adService.activatePremium(
          () {
            setState(() {});
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('premium_activated'.tr())));
          },
          () {
            setState(() {});
            _adService.loadBannerAd(() => setState(() {}));
          },
        );
      },
      onAdDismissed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return const LoadingView();
                } else if (state is WeatherLoaded) {
                  _showHalloweenDialogIfNeeded();
                  return _buildWeatherContent(state.weather, themeProvider);
                } else if (state is WeatherError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: _requestLocationPermission,
                    isDarkMode: isDarkMode,
                  );
                } else {
                  return InitialView(
                    onLocationRequest: _requestLocationPermission,
                    onSearchCity: _showCitySearchModal,
                    isDarkMode: isDarkMode,
                  );
                }
              },
            ),
            _buildOverlayEffects(context),
          ],
        ),
      ),
    );
  }

  void _showHalloweenDialogIfNeeded() {
    if (!_hasShownHalloweenDialog) {
      _hasShownHalloweenDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final message = ChristmasMessageHelper.getTodayMessage(context);
        if (message.isNotEmpty) {
          ChristmasMessageHelper.showMessageDialog(
            context,
            message,
            autoDismissDuration: const Duration(seconds: 30),
          );
        }
      });
    }
  }

  Widget _buildWeatherContent(Weather weather, ThemeProvider themeProvider) {
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.white;

    // Get forecast data from BLoC state
    final state = context.read<WeatherBloc>().state;
    final hourlyForecast = state is WeatherLoaded ? state.hourlyForecast : null;
    final dailyForecast = state is WeatherLoaded ? state.dailyForecast : null;

    final marks = [
      TimeMark(label: tr('sunrise'), time: '05:19', icon: Icons.wb_sunny),
      TimeMark(label: tr('noon'), time: '12:00', icon: Icons.wb_sunny_outlined),
      TimeMark(label: tr('sunset'), time: '18:42', icon: Icons.wb_twilight),
      TimeMark(
        label: tr('moonrise'),
        time: '20:00',
        icon: Icons.nightlight_round,
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateWidgetSafely(weather);
    });

    return Stack(
      children: [
        Container(
          decoration: WeatherUIHelper.getBackgroundImageByTheme(
            isDarkMode: isDarkMode,
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      WeatherAppBar.buildSliverAppBar(
                        context,
                        weather.cityName,
                        textColor,
                      ),
                      SliverToBoxAdapter(
                        child: TemperatureDisplay(
                          weather: weather,
                          textColor: textColor,
                        ),
                      ),

                      // Hourly Forecast Section
                      if (hourlyForecast != null && hourlyForecast.isNotEmpty)
                        SliverToBoxAdapter(
                          child: HourlyForecastSection(
                            hourlyForecast: hourlyForecast,
                            textColor: textColor,
                          ),
                        ),

                      // Daily Forecast Section
                      if (dailyForecast != null && dailyForecast.isNotEmpty)
                        SliverToBoxAdapter(
                          child: DailyForecastSection(
                            dailyForecast: dailyForecast,
                            textColor: textColor,
                          ),
                        ),

                      SliverToBoxAdapter(
                        child: CityListSection(
                          popularCities: _popularCities,
                          textColor: textColor,
                          isDarkMode: isDarkMode,
                          showSearchModal: _showCitySearchModal,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(height: 16.h),
                            TimeProgressBar(
                              marks: marks,
                              currentTime: DateTime.now(),
                            ),
                          ],
                        ),
                      ),
                      if (!_adService.isPremium)
                        SliverToBoxAdapter(
                          child: PremiumButton(onPressed: _handleRewardedAd),
                        ),
                    ],
                  ),
                ),
                if (_adService.isAdLoaded &&
                    !_adService.isPremium &&
                    _adService.bannerAd != null)
                  Container(
                    alignment: Alignment.center,
                    width: _adService.bannerAd!.size.width.toDouble(),
                    height: _adService.bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _adService.bannerAd!),
                  ),
              ],
            ),
          ),
        ),
        if (themeProvider.showHalloweenEffect)
          EventEffect(onCompleted: () => themeProvider.hideHalloweenEffect()),
        if (_showFloatingHalloween)
          FloatingButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            onHide: () => setState(() => _showFloatingHalloween = false),
          ),
      ],
    );
  }

  Widget _buildOverlayEffects(BuildContext context) {
    return Stack(
      children: [
        if (_showBoo)
          Center(
            child: Lottie.asset(
              'assets/animations/christmas_floating_button.json',
              fit: BoxFit.contain,
              repeat: false,
            ),
          ),
        if (_showMoneyRain)
          Positioned.fill(
            child: Lottie.asset(
              'assets/animations/snow_rain.json',
              fit: BoxFit.cover,
              repeat: false,
            ),
          ),
      ],
    );
  }
}

Future<void> _updateWidgetSafely(Weather weather) async {
  try {
    await HomeWidgetService.updateWidget(weather);
  } catch (e) {
    debugPrint('❌ Widget update failed in home page: $e');
    // Don't crash the app, just log the error
  }
}
