import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:weather_app/presentation/page/home/widgets/city_list_section.dart';
import 'package:weather_app/presentation/page/home/widgets/city_search_modal.dart';
import 'package:weather_app/presentation/page/home/widgets/error_view.dart';
import 'package:weather_app/presentation/page/home/widgets/initial_view.dart';
import 'package:weather_app/presentation/page/home/widgets/temperature_display.dart';
import 'package:weather_app/presentation/page/home/widgets/weather_app_bar.dart';

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

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController cityController = TextEditingController();
  bool isLocationPermissionDetermined = false;

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
    _initializeLocationService();
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
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
      child: CircularProgressIndicator(
        color: isDarkMode ? Colors.white : Colors.blue,
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
            WeatherAppBar(cityName: weather.cityName, textColor: textColor),

            TemperatureDisplay(weather: weather, textColor: textColor),

            CityListSection(
              popularCities: popularCities,
              textColor: textColor,
              isDarkMode: isDarkMode,
              showSearchModal: _showCitySearchModal,
            ),
          ],
        ),
      ),
    );
  }
}
