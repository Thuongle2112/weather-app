import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../data/model/weather/weather.dart';
import '../../../utils/weather_icon_mapper.dart';
import '../../../utils/weather_ui_helper.dart';

class TemperatureDisplay extends StatelessWidget {
  final Weather weather;
  final Color textColor;

  const TemperatureDisplay({
    super.key,
    required this.weather,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(context.locale.toString());

    final iconFileName = WeatherIconMapper.getIconByDescription(
      weather.description,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildWeatherIcon(iconFileName),
            const SizedBox(height: 20),
            _buildTemperature(textColor),
            const SizedBox(height: 16),
            _buildDescription(textColor),
            const SizedBox(height: 8),
            _buildHighLowTemperature(textColor),
            const SizedBox(height: 8),
            _buildCurrentDate(textColor, context),
            const SizedBox(height: 16),
            _buildExtraWeatherInfo(textColor, context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherIcon(String iconFileName) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: SvgPicture.asset(
        'assets/weather_icons/$iconFileName',
        height: 100,
        width: 150,
      ),
    );
  }

  Widget _buildTemperature(Color textColor) {
    return Text(
      '${weather.temperature.toInt()}°C',
      style: TextStyle(
        color: textColor,
        fontSize: 80,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription(Color textColor) {
    return Text(
      WeatherUIHelper.capitalizeFirstLetter(weather.description),
      style: TextStyle(color: textColor, fontSize: 24),
    );
  }

  Widget _buildCurrentDate(Color textColor, BuildContext context) {
    final now = DateTime.now();
    String formattedDate;

    if (context.locale.languageCode == 'vi') {
      formattedDate = DateFormat("EEEE, dd 'tháng' MM", 'vi').format(now);
    } else {
      formattedDate = DateFormat('EEEE, MMMM d', 'en').format(now);
    }

    return Text(
      formattedDate,
      style: TextStyle(
        color: textColor.withOpacity(0.8),
        fontSize: 18,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _buildHighLowTemperature(Color textColor) {
    return Text(
      'H:${(weather.temperature + 2).toInt()}° L:${(weather.temperature - 2).toInt()}°',
      style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16),
    );
  }

  Widget _buildExtraWeatherInfo(Color textColor, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildWeatherInfoItem(
                icon: Icons.air,
                value:
                    '${weather.windSpeed != null ? weather.windSpeed!.toInt() : 0} km/h',
                label: 'wind'.tr(),
                textColor: textColor,
              ),
            ),
            Expanded(
              child: _buildWeatherInfoItem(
                icon: Icons.water_drop,
                value: '${weather.humidity ?? 0}%',
                label: 'humidity'.tr(),
                textColor: textColor,
              ),
            ),
            Expanded(
              child: _buildWeatherInfoItem(
                icon: Icons.umbrella,
                value: '${weather.rainChance ?? 0}%',
                label: 'chance_of_rain'.tr(),
                textColor: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfoItem({
    required IconData icon,
    required String value,
    required String label,
    required Color textColor,
  }) {
    return Container(
      constraints: const BoxConstraints(minWidth: 80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
