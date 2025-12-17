import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/model/weather/forecast_item.dart';
import '../../../utils/weather_icon_mapper.dart';
import 'weather/widgets/weather_gradient_helper.dart';

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
    final now = DateTime.now();
    final displayItems = _getDisplayItems(hourlyForecast, now);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                    itemCount: displayItems.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final itemData = displayItems[index];
                      return _buildHourlyItem(
                        itemData['item'] as ForecastItem,
                        itemData['label'] as String,
                        itemData['isCurrent'] as bool,
                        textColor,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getDisplayItems(
    List<ForecastItem> forecasts,
    DateTime now,
  ) {
    if (forecasts.isEmpty) return [];

    final items = <Map<String, dynamic>>[];

    int closestIndex = 0;
    int minDifference = forecasts[0].dateTime.difference(now).abs().inMinutes;

    for (int i = 1; i < forecasts.length; i++) {
      final difference = forecasts[i].dateTime.difference(now).abs().inMinutes;
      if (difference < minDifference) {
        minDifference = difference;
        closestIndex = i;
      }
    }

    debugPrint('📍 Current time: $now');
    debugPrint('📍 Closest index: $closestIndex');
    debugPrint('📍 Closest time: ${forecasts[closestIndex].dateTime}');
    debugPrint('📍 Time difference: $minDifference minutes');

    final startIndex = closestIndex > 0 ? closestIndex - 1 : 0;

    for (int i = startIndex; i < forecasts.length && items.length < 9; i++) {
      final item = forecasts[i];
      final isCurrent = i == closestIndex;

      items.add({
        'item': item,
        'label': isCurrent ? 'now' : DateFormat('HH:mm').format(item.dateTime),
        'isCurrent': isCurrent,
      });

      debugPrint(
        '  ${isCurrent ? "👉" : "  "} Item $i: ${DateFormat('HH:mm').format(item.dateTime)} - ${isCurrent ? "NOW" : ""}',
      );
    }

    return items;
  }

  Widget _buildHourlyItem(
    ForecastItem item,
    String label,
    bool isCurrent,
    Color textColor,
  ) {
    final iconFileName = WeatherIconMapper.getIconByDescription(
      item.description,
    );

    if (isCurrent) {
      final gradientColors = WeatherGradientHelper.getGradientColors();

      return Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
            stops: gradientColors.length == 2 ? [0.0, 1.0] : [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: _buildItemContent(item, label, true, textColor, iconFileName),
      );
    }

    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: SizedBox(
        width: 70.w,
        child: _buildItemContent(item, label, false, textColor, iconFileName),
      ),
    );
  }

  Widget _buildItemContent(
    ForecastItem item,
    String label,
    bool isCurrent,
    Color textColor,
    String iconFileName,
  ) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label == 'now' ? 'now'.tr() : label,
            style: TextStyle(
              color: textColor.withOpacity(isCurrent ? 1.0 : 0.8),
              fontSize: isCurrent ? 13.sp : 11.sp,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          SvgPicture.asset(
            'assets/weather_icons/$iconFileName',
            height: isCurrent ? 40.h : 32.h,
            width: isCurrent ? 40.w : 32.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 4.h),
          Text(
            '${item.temperature.round()}°',
            style: TextStyle(
              color: textColor,
              fontSize: isCurrent ? 18.sp : 15.sp,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
