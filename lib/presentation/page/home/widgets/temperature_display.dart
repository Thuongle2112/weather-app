import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final iconFileName = WeatherIconMapper.getIconByDescription(
      weather.description,
    );

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWeatherIcon(iconFileName),
            const SizedBox(height: 20),
            _buildTemperature(textColor),
            const SizedBox(height: 16),
            _buildDescription(textColor),
            const SizedBox(height: 8),
            _buildHighLowTemperature(textColor),
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
        height: 150,
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

  Widget _buildHighLowTemperature(Color textColor) {
    return Text(
      'H:${(weather.temperature + 2).toInt()}° L:${(weather.temperature - 2).toInt()}°',
      style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16),
    );
  }
}
