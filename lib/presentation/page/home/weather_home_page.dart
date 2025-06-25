import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/presentation/page/home/widget/city_card.dart';
import 'package:weather_app/presentation/page/home/widget/city_search_modal.dart';
import 'package:weather_app/presentation/page/home/widget/error_view.dart';
import 'package:weather_app/presentation/page/home/widget/initial_view.dart';

import '../../../data/model/weather/weather.dart';
import '../../providers/theme_provider.dart';
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
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    setState(() {
      isLocationPermissionDetermined = true;
    });

    if (status.isGranted) {
      _getWeatherByCurrentLocation();
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      _getWeatherByCurrentLocation();
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('location_permission_denied'.tr()),
            action: SnackBarAction(
              label: 'settings'.tr(),
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
    }
  }

  Future<void> _getWeatherByCurrentLocation() async {
    try {
      debugPrint('🔍 Getting current location...');
      context.read<WeatherBloc>().add(const WeatherStartLoading());

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );

      debugPrint(
        '📍 Position obtained: ${position.latitude}, ${position.longitude}',
      );

      if (context.mounted) {
        debugPrint('🔄 Dispatching FetchWeatherByCoordinates event');
        context.read<WeatherBloc>().add(
          FetchWeatherByCoordinates(position.latitude, position.longitude),
        );
      }
    } catch (e) {
      debugPrint('❌ Error getting current location: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('location_error'.tr())));
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
            cityController: cityController,
            popularCities: popularCities,
            onCitySelected: (city) {
              context.read<WeatherBloc>().add(FetchWeatherByCity(city));
            },
          ),
    );
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
              return Center(
                child: CircularProgressIndicator(
                  color: isDarkMode ? Colors.white : Colors.blue,
                ),
              );
            } else if (state is WeatherLoaded) {
              return _buildWeatherDisplay(context, state.weather);
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
      ),
    );
  }

  Widget _buildWeatherDisplay(BuildContext context, Weather weather) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    Color backgroundColor =
        isDarkMode
            ? Colors.black
            : _getWeatherBackgroundColor(weather.temperature);

    Color textColor = isDarkMode ? Colors.white : Colors.white;

    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(weather.cityName, textColor),
            _buildTemperatureSection(weather, textColor),
            _buildOtherCitiesSection(textColor, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(String cityName, Color textColor) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              cityName,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          IconButton(
            icon: Icon(Icons.language, color: textColor),
            onPressed: () async {
              if (context.locale == const Locale('en')) {
                await context.setLocale(const Locale('vi'));
                await _saveLanguagePreference('vi');
                _refreshWeatherWithCurrentLanguage();
              } else {
                await context.setLocale(const Locale('en'));
                await _saveLanguagePreference('en');
                _refreshWeatherWithCurrentLanguage();
              }
            },
            tooltip: 'change_language'.tr(),
          ),

          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: textColor,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: 'toggle_theme'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureSection(Weather weather, Color textColor) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${weather.temperature.toInt()}°C',
              style: TextStyle(
                color: textColor,
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              capitalizeFirstLetter(weather.description),
              style: TextStyle(color: textColor, fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              'H:${(weather.temperature + 2).toInt()}° L:${(weather.temperature - 2).toInt()}°',
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherCitiesSection(Color textColor, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDarkMode ? Colors.grey[900] : Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'other_cities'.tr(),
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                popularCities
                    .map(
                      (city) => CityCard(
                        city: city,
                        temperature:
                            '${20 + (5 * popularCities.indexOf(city) % 3)}°',
                        onTap: () {
                          context.read<WeatherBloc>().add(
                            FetchWeatherByCity(city),
                          );
                        },
                        isDarkMode: isDarkMode,
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showCitySearchModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.blue : Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'change_location'.tr(),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getWeatherBackgroundColor(double temperature) {
    if (temperature > 30) {
      return const Color(0xFFFFC107);
    } else if (temperature > 20) {
      return const Color(0xFF4FC3F7);
    } else {
      return const Color(0xFF78909C);
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }

  Future<void> _refreshWeatherWithCurrentLanguage() async {
    final state = context.read<WeatherBloc>().state;
    if (state is WeatherLoaded) {
      final currentCity = state.weather.cityName;
      context.read<WeatherBloc>().add(FetchWeatherByCity(currentCity));
    } else {
      _getWeatherByCurrentLocation();
    }
  }
}
