import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../data/model/weather/weather.dart';
import '../../widgets.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final String iconFileName;
  final Color textColor;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.iconFileName,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = WeatherGradientHelper.getGradientColors();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
            stops: gradientColors.length == 2 ? [0.0, 1.0] : [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          // boxShadow: [
          //   BoxShadow(
          //     color: gradientColors.first.withOpacity(0.3),
          //     blurRadius: 15,
          //     offset: const Offset(0, 8),
          //     spreadRadius: 2,
          //   ),
          // ],
        ),
        child: Column(
          children: [
            WeatherMainInfo(
              weather: weather,
              iconFileName: iconFileName,
              textColor: textColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Divider(
                color: Colors.white.withOpacity(0.2),
                thickness: 1,
                height: 1,
              ),
            ),
            WeatherExtraInfo(weather: weather, textColor: textColor),
          ],
        ),
      ),
    );
  }
}
