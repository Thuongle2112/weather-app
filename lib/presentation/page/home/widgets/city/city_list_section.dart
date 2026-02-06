import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:weather_app/presentation/page/home/widgets/buttons/new_year_button_painter.dart';

import '../../../../../data/model/weather/weather.dart';
import '../../../../../data/model/location/selected_location.dart';
import '../../../../../core/services/ad_service.dart';
import '../../../../utils/utils.dart';
import '../../bloc/bloc.dart';
import '../widgets.dart';
import '../../../map_location_picker/map_location_picker_screen.dart';

class CityListSection extends StatefulWidget {
  final List<Map<String, dynamic>> popularCities;
  final Color textColor;
  final bool isDarkMode;
  final AdService adService;
  // final Function showSearchModal;

  const CityListSection({
    super.key,
    required this.popularCities,
    required this.textColor,
    required this.isDarkMode,
    required this.adService,
    // required this.showSearchModal,
  });

  @override
  State<CityListSection> createState() => _CityListSectionState();
}

class _CityListSectionState extends State<CityListSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _snowController;
  final Map<String, Weather?> _cityWeatherCache = {};
  final Map<String, bool> _loadingStates = {};
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _snowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _fetchCitiesWeather();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _snowController.dispose();
    super.dispose();
  }

  Future<void> _fetchCitiesWeather() async {
    // ✅ Get usecase from WeatherBloc
    final weatherBloc = context.read<WeatherBloc>();
    final getWeatherByCity = weatherBloc.getWeatherByCity;

    for (final city in widget.popularCities) {
      if (_isDisposed || !mounted) return;

      setState(() {
        _loadingStates[city['name']] = true;
      });

      try {
        final weather = await getWeatherByCity(city['name']);
        if (_isDisposed || !mounted) return;

        setState(() {
          _cityWeatherCache[city['name']] = weather;
          _loadingStates[city['name']] = false;
        });
      } catch (_) {
        if (_isDisposed || !mounted) return;

        setState(() {
          _cityWeatherCache[city['name']] = null;
          _loadingStates[city['name']] = false;
        });
      }

      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.grey[900] : Colors.black12,
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: const AssetImage('assets/images/new_year_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCitiesScrollList(context),
            Gap(12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildChangeLocationButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCitiesScrollList(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth / 3.5;

    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        itemCount: widget.popularCities.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: cardWidth.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: _buildCityCard(
                context,
                widget.popularCities[index]['name'],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCityCard(BuildContext context, String city) {
    final weather = _cityWeatherCache[city];
    final isLoading = _loadingStates[city] ?? false;

    String? temperature;
    String? weatherIcon;

    if (weather != null) {
      temperature = '${weather.temperature.round()}°';
      weatherIcon = WeatherIconMapper.getIconByDescription(weather.description);
    }

    return CityCard(
      city: city,
      temperature: temperature,
      weatherIcon: weatherIcon,
      isLoading: isLoading,
      onTap: () {
        context.read<WeatherBloc>().add(FetchWeatherByCity(city));
      },
      isDarkMode: widget.isDarkMode,
    );
  }

  Widget _buildChangeLocationButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                // widget.isDarkMode
                //     ? [
                //       const Color(0xFFFFD700), // Gold
                //       const Color(0xFFFF6B6B), // Red
                //       const Color(0xFF4ECDC4), // Cyan
                //       const Color(0xFFFFE66D), // Yellow
                //     ]
                //     : [
                //       const Color(0xFFFFE55C), // Light Gold
                //       const Color(0xFFF38181), // Light Red
                //       const Color(0xFF95E1D3), // Light Cyan
                //       const Color(0xFFFFD93D), // Light Yellow
                //     ],
                [
                  const Color(0xFFFFB703),
                  const Color(0xFFFB8500),
                  const Color(0xFFE63946),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
              // boxShadow: [
              //   BoxShadow(
              //     color: const Color(0xFFD32F2F).withValues(alpha: 0.3),
              //     blurRadius: 8,
              //     offset: const Offset(0, 4),
              //   ),
              // ],
            ),
            child: ElevatedButton(
              onPressed: () => _openMapLocationPicker(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                minimumSize: const Size(double.infinity, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'change_location'.tr(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _snowController,
                builder: (context, child) {
                  return CustomPaint(
                    // painter: SnowButtonPainter(
                    //   isDarkMode: widget.isDarkMode,
                    //   animation: _snowController,
                    // ),
                    painter: NewYearButtonPainter(
                      isDarkMode: widget.isDarkMode,
                      animation: _snowController,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMapLocationPicker(BuildContext context) async {
    // Show interstitial ad first (only if not premium)
    if (!widget.adService.isPremium) {
      widget.adService.showInterstitialAd();
      // Wait a bit for the ad to show
      await Future.delayed(const Duration(milliseconds: 500));
    }

    final location = await Navigator.push<SelectedLocation>(
      context,
      MaterialPageRoute(builder: (context) => const MapLocationPickerScreen()),
    );

    if (location != null && mounted) {
      context.read<WeatherBloc>().add(
        FetchWeatherByCoordinates(location.latitude, location.longitude),
      );
    }
  }
}
