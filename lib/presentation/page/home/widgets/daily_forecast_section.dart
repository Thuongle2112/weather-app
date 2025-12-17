import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/model/weather/daily_forecast.dart';
import '../../../utils/weather_icon_mapper.dart';
import '../../../utils/weather_ui_helper.dart';

class DailyForecastSection extends StatelessWidget {
  final List<DailyForecast> dailyForecast;
  final Color textColor;

  const DailyForecastSection({
    super.key,
    required this.dailyForecast,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: textColor, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      '5-day-forecast'.tr(),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                ...dailyForecast
                    .map((day) => _buildDailyItem(context, day, textColor))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyItem(
    BuildContext context,
    DailyForecast day,
    Color textColor,
  ) {
    final locale = context.locale.languageCode;

    String formattedDate;
    try {
      switch (locale) {
        case 'vi':
          formattedDate = DateFormat("EEE, dd 'Th'M", locale).format(day.date);
          break;
        case 'ja':
          formattedDate = DateFormat('EEE, M月d日', locale).format(day.date);
          break;
        case 'ko':
          formattedDate = DateFormat('EEE, M월 d일', locale).format(day.date);
          break;
        case 'zh':
          formattedDate = DateFormat('EEE, M月d日', locale).format(day.date);
          break;
        case 'th':
          formattedDate = DateFormat('EEE, d MMM', locale).format(day.date);
          break;
        case 'fr':
          formattedDate = DateFormat('EEE, d MMM', locale).format(day.date);
          break;
        case 'de':
          formattedDate = DateFormat('EEE, d. MMM', locale).format(day.date);
          break;
        case 'es':
          formattedDate = DateFormat('EEE, d MMM', locale).format(day.date);
          break;
        case 'en':
        default:
          formattedDate = DateFormat('EEE, MMM d', locale).format(day.date);
          break;
      }

      formattedDate = WeatherUIHelper.capitalizeFirstLetter(formattedDate);
    } catch (e) {
      formattedDate = DateFormat('EEE, MMM d', 'en').format(day.date);
    }

    final iconFileName = WeatherIconMapper.getIconByDescription(
      day.description,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              formattedDate,
              style: TextStyle(
                color: textColor.withOpacity(0.9),
                fontSize: 13.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SvgPicture.asset(
            'assets/weather_icons/$iconFileName',
            height: 32.h,
            width: 32.w,
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Text(
              WeatherUIHelper.capitalizeFirstLetter(day.description),
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: 12.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Text(
            '${day.tempMin.round()}° / ${day.tempMax.round()}°',
            style: TextStyle(
              color: textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
