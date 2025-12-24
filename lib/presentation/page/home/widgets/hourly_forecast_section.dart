import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/model/weather/forecast_item.dart';
import '../../../utils/date_formatter.dart';
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
    final formattedDate = DateFormatter.formatShortDate(
      now,
      context.locale.languageCode,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      // child: ClipRRect(
      //   borderRadius: BorderRadius.circular(12.r),
      //   child: BackdropFilter(
      //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      //     child: Container(
      //       padding: EdgeInsets.all(16.w),
      //       decoration: BoxDecoration(
      //         // color: Colors.white.withOpacity(0.1),
      //         borderRadius: BorderRadius.circular(12.r),
      //         border: Border.all(
      //           color: Colors.white.withOpacity(0.3),
      //           width: 1.5,
      //         ),
      //       ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.1),
          //     blurRadius: 10,
          //     offset: const Offset(0, 4),
          //     spreadRadius: 2,
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'hourly-forecast'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  formattedDate,
                  style: Theme.of(context).textTheme.titleMedium,
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
                    context,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      //   ),
      // ),
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
    BuildContext context,
  ) {
    final iconFileName = WeatherIconMapper.getIconByDescription(
      item.description,
    );

    final gradientColors =
        isCurrent ? WeatherGradientHelper.getGradientColors() : null;

    return Container(
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient:
            gradientColors != null
                ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradientColors,
                  stops:
                      gradientColors.length == 2 ? [0.0, 1.0] : [0.0, 0.5, 1.0],
                )
                : null,
        color: isCurrent ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          color: isCurrent ? Colors.white.withOpacity(0.5) : Colors.transparent,
          width: 2,
        ),
      ),
      child: SizedBox(
        child: _buildItemContent(
          item,
          label,
          isCurrent,
          textColor,
          iconFileName,
          context,
        ),
      ),
    );
  }

  //   return Padding(
  //     padding: EdgeInsets.only(right: 12.w),
  //     child: SizedBox(
  //       width: 70.w,
  //       child: _buildItemContent(item, label, false, textColor, iconFileName, context),
  //     )
  //   );
  // }

  Widget _buildItemContent(
    ForecastItem item,
    String label,
    bool isCurrent,
    Color textColor,
    String iconFileName,
    BuildContext context,
  ) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label == 'now' ? 'now'.tr() : label,
            // style: TextStyle(
            //   color: isCurrent ? Colors.white : textColor.withOpacity(0.8),
            //   fontSize: isCurrent ? 13.sp : 11.sp,
            //   fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            // ),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: isCurrent ? Colors.white : textColor.withOpacity(0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          SvgPicture.asset(
            'assets/weather_icons/$iconFileName',
            height: 32.h,
            width: 32.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 4.h),
          Text(
            '${item.temperature.round()}°',
            // style: TextStyle(
            //   color: isCurrent ? Colors.white : textColor,
            //   fontSize: isCurrent ? 18.sp : 15.sp,
            //   fontWeight: FontWeight.bold,
            // ),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: isCurrent ? Colors.white : textColor,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
