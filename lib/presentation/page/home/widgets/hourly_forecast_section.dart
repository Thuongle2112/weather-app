import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../data/model/weather/forecast_item.dart';
import '../../../utils/weather_icon_mapper.dart';

class HourlyForecastSection extends StatelessWidget {
  final List<ForecastItem> hourlyForecast;
  final Color textColor;

  const HourlyForecastSection({
    super.key,
    required this.hourlyForecast,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Take only next 24 hours (8 items * 3 hours each)
    final next24Hours = hourlyForecast.take(8).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
              Icon(Icons.access_time, color: textColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'hourly-forecast'.tr(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: next24Hours.length,
              itemBuilder: (context, index) {
                final item = next24Hours[index];
                return _buildHourlyItem(item, textColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyItem(ForecastItem item, Color textColor) {
    final timeFormat = DateFormat('HH:mm');
    final iconFileName = WeatherIconMapper.getIconByDescription(
      item.description,
    );

    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            timeFormat.format(item.dateTime),
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          SvgPicture.asset(
            'assets/weather_icons/$iconFileName',
            height: 40.h,
            width: 40.w,
          ),
          SizedBox(height: 8.h),
          Text(
            '${item.temperature.round()}°',
            style: TextStyle(
              color: textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
