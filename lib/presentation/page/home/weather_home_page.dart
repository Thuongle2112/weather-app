import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:weather_app/presentation/page/home/widgets/city_list_section.dart';
import 'package:weather_app/presentation/page/home/widgets/city_search_modal.dart';
import 'package:weather_app/presentation/page/home/widgets/error_view.dart';
import 'package:weather_app/presentation/page/home/widgets/initial_view.dart';
import 'package:weather_app/presentation/page/home/widgets/temperature_display.dart';
import 'package:weather_app/presentation/page/home/widgets/time_progress_bar.dart';
import 'package:weather_app/presentation/page/home/widgets/weather_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/model/weather/time_mark.dart';
import '../../../data/model/weather/weather.dart';
import '../../providers/theme_provider.dart';
import '../../utils/weather_service.dart';
import '../../utils/weather_ui_helper.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage>
    with WidgetsBindingObserver {
  final TextEditingController cityController = TextEditingController();
  bool isLocationPermissionDetermined = false;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  int _interstitialLoadAttempts = 0;
  int _rewardedLoadAttempts = 0;
  int _searchCount = 0;
  bool _isPremium = false;
  final int _maxAdLoadAttempts = 3;

  late final String _bannerAdUnitId;
  late final String _interstitialAdUnitId;
  late final String _rewardedAdUnitId;

  final List<String> popularCities = [
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
    _initAdIds();
    _initializeLocationService();
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    cityController.dispose();
    super.dispose();
  }

  void _initAdIds() {
    _bannerAdUnitId = dotenv.env['ADMOB_BANNER_ID'] ?? '';
    _interstitialAdUnitId = dotenv.env['ADMOB_INTERSTITIAL_ID'] ?? '';
    _rewardedAdUnitId = dotenv.env['ADMOB_REWARDED_ID'] ?? '';
  }

  void _loadBannerAd() {
    if (_isPremium) return;

    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded successfully');
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
          _bannerAd = null;
        },
      ),
    );
    _bannerAd?.load();
  }

  void _loadInterstitialAd() {
    if (_isPremium) return;
    if (_interstitialAd != null) return;

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
          debugPrint('Interstitial ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _interstitialLoadAttempts++;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= _maxAdLoadAttempts) {
            _loadInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      debugPrint('Attempting to show interstitial before loaded');
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Failed to show interstitial: $error');
        ad.dispose();
        _loadInterstitialAd();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _loadRewardedAd() {
    if (_rewardedAd != null) return;

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedLoadAttempts = 0;
          debugPrint('Rewarded ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: $error');
          _rewardedLoadAttempts++;
          _rewardedAd = null;
          if (_rewardedLoadAttempts <= _maxAdLoadAttempts) {
            _loadRewardedAd();
          }
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('reward_ad_not_ready'.tr())));
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Failed to show rewarded ad: $error');
        ad.dispose();
        _loadRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (_, reward) {
        setState(() {
          _isPremium = true;
          _bannerAd?.dispose();
          _bannerAd = null;
          _isAdLoaded = false;
        });

        Future.delayed(const Duration(hours: 1), () {
          if (mounted) {
            setState(() {
              _isPremium = false;
              _loadBannerAd();
            });
          }
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('premium_activated'.tr())));
      },
    );
    _rewardedAd = null;
  }

  Future<void> _initializeLocationService() async {
    WeatherService.checkLocationPermission(
      context,
      (value) => setState(() => isLocationPermissionDetermined = value),
    );
  }

  void _showCitySearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => CitySearchModal(
            cityController: cityController,
            popularCities: popularCities,
            onCitySelected: (city) {
              context.read<WeatherBloc>().add(FetchWeatherByCity(city));

              _searchCount++;

              if (!_isPremium && _searchCount % 3 == 0) {
                _showInterstitialAd();
              }
            },
          ),
    );
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

  int getCurrentTimeIndex(List<TimeMark> marks, DateTime currentTime) {
    List<DateTime> times =
        marks.map((mark) {
          final parts = mark.time.split(':');
          int hour = int.parse(parts[0]);
          int minute = int.parse(parts[1]);
          return DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            hour,
            minute,
          );
        }).toList();

    if (currentTime.isBefore(times.first)) return 0;
    if (currentTime.isAfter(times.last)) return times.length - 1;

    for (int i = 0; i < times.length - 1; i++) {
      if (currentTime.isAfter(times[i]) && currentTime.isBefore(times[i + 1])) {
        return i;
      }
    }
    return times.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        body: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return _buildLoadingView(isDarkMode);
            } else if (state is WeatherLoaded) {
              return _buildWeatherDisplay(context, state.weather);
            } else if (state is WeatherError) {
              return _buildErrorView(state.message, isDarkMode);
            } else {
              return _buildInitialView(isDarkMode);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView(bool isDarkMode) {
    return Center(
      child: SizedBox(
        width: 48.w,
        height: 48.w,
        child: CircularProgressIndicator(
          color: isDarkMode ? Colors.white : Colors.blue,
          strokeWidth: 4.w,
        ),
      ),
    );
  }

  Widget _buildErrorView(String message, bool isDarkMode) {
    return ErrorView(
      message: message,
      onRetry: _requestLocationPermission,
      isDarkMode: isDarkMode,
    );
  }

  Widget _buildInitialView(bool isDarkMode) {
    return InitialView(
      onLocationRequest: _requestLocationPermission,
      onSearchCity: _showCitySearchModal,
      isDarkMode: isDarkMode,
    );
  }

  Widget _buildWeatherDisplay(BuildContext context, Weather weather) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final now = DateTime.now();
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
    final currentIndex = getCurrentTimeIndex(marks, now);

    Color backgroundColor =
        isDarkMode
            ? Colors.black
            : WeatherUIHelper.getBackgroundColorByWeather(weather);
    Color textColor = isDarkMode ? Colors.white : Colors.white;

    return Container(
      decoration: BoxDecoration(color: backgroundColor),
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
                  SliverToBoxAdapter(
                    child: CityListSection(
                      popularCities: popularCities,
                      textColor: textColor,
                      isDarkMode: isDarkMode,
                      showSearchModal: _showCitySearchModal,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: TimeProgressBar(
                      marks: marks,
                      currentTime: DateTime.now(),
                    ),
                  ),
                  if (!_isPremium)
                    SliverToBoxAdapter(child: _buildPremiumButton()),
                ],
              ),
            ),
            if (_isAdLoaded && !_isPremium)
              Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumButton() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: ElevatedButton(
        onPressed: _showRewardedAd,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              'get_premium_1hour'.tr(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
