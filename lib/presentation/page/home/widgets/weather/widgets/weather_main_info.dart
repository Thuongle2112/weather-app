import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../data/model/weather/weather.dart';
import '../../../../../utils/weather_ui_helper.dart';
import '../../widgets.dart';

class WeatherMainInfo extends StatelessWidget {
  final Weather weather;
  final String iconFileName;
  final Color textColor;

  const WeatherMainInfo({
    super.key,
    required this.weather,
    required this.iconFileName,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTemperature(context),
              SizedBox(height: 12.h),
              _buildHighLowTemperature(context),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWeatherIcon(),
              SizedBox(height: 12.h),
              _buildDescription(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTemperature(BuildContext context) {
    return Text(
      '${weather.temperature.toInt()}°C',
      style: Theme.of(
        context,
      ).textTheme.displayLarge!.copyWith(color: textColor),
    );
  }

  Widget _buildHighLowTemperature(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.arrow_upward,
          color: textColor.withOpacity(0.7),
          size: 20.sp,
        ),
        Text(
          '${(weather.temperature + 2).toInt()}°',
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: textColor.withOpacity(0.7)),
        ),
        SizedBox(width: 16.w),
        Icon(
          Icons.arrow_downward,
          color: textColor.withOpacity(0.7),
          size: 20.sp,
        ),
        Text(
          '${(weather.temperature - 2).toInt()}°',
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: textColor.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildWeatherIcon() {
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
        height: 57.h,
        width: 57.w,
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final localizedDescription =
        WeatherDescriptionHelper.getLocalizedDescription(
          weather.description,
          context.locale.languageCode,
        );

    return Text(
      WeatherUIHelper.capitalizeFirstLetter(localizedDescription),
      style: Theme.of(
        context,
      ).textTheme.titleLarge!.copyWith(color: textColor.withOpacity(0.9)),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
