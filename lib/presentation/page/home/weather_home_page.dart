import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/services/ad_service.dart';
import '../../../core/services/shake_detector_service.dart';
import '../../../data/model/weather/time_mark.dart';
import '../../../data/model/weather/weather.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../../widgets/lazy_lottie.dart';
import 'bloc/bloc.dart';
import 'widgets/weather/air_pollution.dart';
import 'widgets/weather/uv_index_card.dart';


import 'widgets/weather/widgets/app_drawer.dart';
import 'widgets/widgets.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage>
    with WidgetsBindingObserver {
  final TextEditingController _cityController = TextEditingController();

  late AdService _adService;
  late ShakeDetectorService _shakeService;

  bool _showFloatingHalloween = true;
  bool _hasShownHalloweenDialog = false;
  bool _showBoo = false;
  bool _showMoneyRain = false;
  int _searchCount = 0;

  final List<Map<String, dynamic>> _popularCities = [
    {'name': 'Ha Noi', 'lat': 21.0285, 'lon': 105.8542},
    {'name': 'Ho Chi Minh City', 'lat': 10.7769, 'lon': 106.7009},
    {'name': 'Da Nang', 'lat': 16.0544, 'lon': 108.2022},
    {'name': 'New York', 'lat': 40.7128, 'lon': -74.0060},
    {'name': 'London', 'lat': 51.5074, 'lon': -0.1278},
    {'name': 'Tokyo', 'lat': 35.6895, 'lon': 139.6917},
    {'name': 'Paris', 'lat': 48.8566, 'lon': 2.3522},
    {'name': 'Sydney', 'lat': -33.8688, 'lon': 151.2093},
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
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _adService.onAppLifecycleStateChanged(state);
  }

  void _initializeServices() {
    _adService = AdService(
      bannerAdUnitId: dotenv.env['ADMOB_BANNER_ID'] ?? '',
      interstitialAdUnitId: dotenv.env['ADMOB_INTERSTITIAL_ID'] ?? '',
      rewardedAdUnitId: dotenv.env['ADMOB_REWARDED_ID'] ?? '',
    );

    _adService.loadBannerAd(() => setState(() {}));
    _adService.loadInterstitialAd();
    _adService.loadRewardedAd();

    _shakeService = ShakeDetectorService();
    _shakeService.initialize(
      onBooEffect: () {
        if (!mounted) return;
        setState(() => _showBoo = true);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _showBoo = false);
        });
      },
      onMoneyRain: () {
        if (!mounted) return;
        setState(() => _showMoneyRain = true);
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _showMoneyRain = false);
        });
      },
    );

    // Auto request location on app start
    _autoRequestLocation();
  }

  Future<void> _autoRequestLocation() async {
    // Auto request location when entering home
    await Future.delayed(const Duration(milliseconds: 500)); // Small delay for smooth transition
    if (mounted) {
      await WeatherService.getWeatherByCurrentLocation(context);
    }
  }

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
    _adService.onUserInteraction(); // Notify ad service of user activity
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CitySearchModal(
            cityController: _cityController,
            popularCities: _popularCities,
            onCitySelected: (city) {
              _adService.onUserInteraction(); // Track interaction
              context.read<WeatherBloc>().add(FetchWeatherByCity(city));
              _searchCount++;

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
        endDrawer: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            double? lat;
            double? lon;

            if (state is WeatherLoaded) {
              lat = state.latitude;
              lon = state.longitude;
            }

            return AppDrawer(latitude: lat, longitude: lon);
          },
        ),
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
                  // Show loading while auto-requesting location
                  return const LoadingView();
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
        final message = NewYearMessageHelper.getTodayMessage(context);
        if (message.isNotEmpty) {
          NewYearMessageHelper.showMessageDialog(
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

    final state = context.read<WeatherBloc>().state;
    final hourlyForecast = state is WeatherLoaded ? state.hourlyForecast : null;
    final dailyForecast = state is WeatherLoaded ? state.dailyForecast : null;
    final airPollution = state is WeatherLoaded ? state.airPollution : null;
    final uvIndex = state is WeatherLoaded ? state.uvIndex : null;

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

    return Stack(
      children: [
        Container(
          decoration: WeatherUIHelper.getSimpleBackgroundByTheme(
            isDarkMode: isDarkMode,
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: TemperatureDisplay(
                          cityName: weather.cityName,
                          weather: weather,
                          textColor: textColor,
                        ),
                      ),

                      if (hourlyForecast != null && hourlyForecast.isNotEmpty)
                        SliverToBoxAdapter(
                          child: HourlyForecastSection(
                            hourlyForecast: hourlyForecast,
                            textColor: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),

                      if (dailyForecast != null && dailyForecast.isNotEmpty)
                        SliverToBoxAdapter(
                          child: DailyForecastSection(
                            dailyForecast: dailyForecast,
                            // textColor: textColor,
                          ),
                        ),

                      // if (airPollution != null)
                      //   SliverToBoxAdapter(
                      //     child: AirPollutionGaugeWidget(
                      //       airPollution: airPollution,
                      //     ),
                      //   ),

                      // if (uvIndex != null)
                      //   SliverToBoxAdapter(
                      //     child: UVIndexCard(
                      //       uvIndex: uvIndex,
                      //     ),
                      //   ),
                      if (airPollution != null || uvIndex != null)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (airPollution != null)
                                  Expanded(
                                    child: AirPollutionGaugeWidget(
                                      airPollution: airPollution,
                                    ),
                                  ),
                                if (airPollution != null && uvIndex != null)
                                  SizedBox(width: 12.w),
                                if (uvIndex != null)
                                  Expanded(
                                    child: UVIndexCard(uvIndex: uvIndex),
                                  ),
                              ],
                            ),
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
              // Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              context.push('/fortune-shake');
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
            child: LazyLottie(
              assetPath: 'assets/animations/new_year_floating_button.json',
              fit: BoxFit.contain,
              repeat: false,
            ),
          ),
        if (_showMoneyRain)
          Positioned.fill(
            child: LazyLottie(
              assetPath: 'assets/animations/money_rain.json',
              fit: BoxFit.cover,
              repeat: false,
            ),
          ),
      ],
    );
  }
}
