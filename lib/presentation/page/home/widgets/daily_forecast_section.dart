import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
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
    );
  }

  Widget _buildDailyItem(
    BuildContext context,
    DailyForecast day,
    Color textColor,
  ) {
    // Get current locale
    final locale = context.locale.languageCode;

    // Format date based on locale
    String formattedDate;
    try {
      switch (locale) {
        case 'vi':
          // Vietnamese: "T2, 03 Th12" (Mon, 03 Dec)
          formattedDate = DateFormat("EEE, dd 'Th'M", locale).format(day.date);
          break;
        case 'ja':
          // Japanese: "月, 12月3日" (Mon, Dec 3)
          formattedDate = DateFormat('EEE, M月d日', locale).format(day.date);
          break;
        case 'ko':
          // Korean: "월, 12월 3일" (Mon, Dec 3)
          formattedDate = DateFormat('EEE, M월 d일', locale).format(day.date);
          break;
        case 'zh':
          // Chinese: "周一, 12月3日" (Mon, Dec 3)
          formattedDate = DateFormat('EEE, M月d日', locale).format(day.date);
          break;
        case 'th':
          // Thai: "จ., 3 ธ.ค." (Mon, 3 Dec)
          formattedDate = DateFormat('EEE, d MMM', locale).format(day.date);
          break;
        case 'fr':
          // French: "lun., 3 déc." (Mon, 3 Dec)
          formattedDate = DateFormat('EEE, d MMM', locale).format(day.date);
          break;
        case 'de':
          // German: "Mo., 3. Dez." (Mon, 3 Dec)
          formattedDate = DateFormat('EEE, d. MMM', locale).format(day.date);
          break;
        case 'es':
          // Spanish: "lun., 3 dic." (Mon, 3 Dec)
          formattedDate = DateFormat('EEE, d MMM', locale).format(day.date);
          break;
        case 'en':
        default:
          // English: "Mon, Dec 3"
          formattedDate = DateFormat('EEE, MMM d', locale).format(day.date);
          break;
      }

      // Capitalize first letter
      formattedDate = WeatherUIHelper.capitalizeFirstLetter(formattedDate);
    } catch (e) {
      // Fallback to English if locale initialization fails
      formattedDate = DateFormat('EEE, MMM d', 'en').format(day.date);
    }

    final iconFileName = WeatherIconMapper.getIconByDescription(
      day.description,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          // Day
          SizedBox(
            width: 90.w, // Increased width for longer text in some languages
            child: Text(
              formattedDate,
              style: TextStyle(
                color: textColor.withOpacity(0.9),
                fontSize: 13.sp, // Slightly smaller to fit better
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Icon
          SvgPicture.asset(
            'assets/weather_icons/$iconFileName',
            height: 32.h,
            width: 32.w,
          ),
          SizedBox(width: 12.w),
          // Description
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
          // Temperature range
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
