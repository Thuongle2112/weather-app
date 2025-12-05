import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../data/model/weather/weather.dart';
import '../../../../utils/weather_icon_mapper.dart';
import '../widgets.dart';

class TemperatureDisplay extends StatelessWidget {
  final Weather weather;
  final String cityName;
  final Color textColor;

  const TemperatureDisplay({
    super.key,
    required this.weather,
    required this.cityName,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting(context.locale.toString());

    final iconFileName = WeatherIconMapper.getIconByDescription(
      weather.description,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, top: 16.h),
          child: WeatherHeader(cityName: cityName, textColor: textColor),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 32.h),
                WeatherCard(
                  weather: weather,
                  iconFileName: iconFileName,
                  textColor: textColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
