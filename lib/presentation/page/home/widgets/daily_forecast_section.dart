import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/model/weather/daily_forecast.dart';
import '../../../utils/date_formatter.dart';
import '../../../utils/weather_icon_mapper.dart';
import '../../../utils/weather_ui_helper.dart';
import 'buttons/new-year-button-painter.dart';

class DailyForecastSection extends StatefulWidget {
  final List<DailyForecast> dailyForecast;

  const DailyForecastSection({super.key, required this.dailyForecast});

  @override
  State<DailyForecastSection> createState() => _DailyForecastSectionState();
}

class _DailyForecastSectionState extends State<DailyForecastSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _fireworkController;

  @override
  void initState() {
    super.initState();
    _fireworkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _fireworkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20.r),
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
                    Text(
                      '5-day-forecast'.tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                ...widget.dailyForecast
                    .map((day) => _buildDailyItem(context, day, Colors.black))
                    .toList(),
              ],
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: AnimatedBuilder(
                  animation: _fireworkController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: NewYearButtonPainter(
                        isDarkMode: isDarkMode,
                        animation: _fireworkController,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyItem(
    BuildContext context,
    DailyForecast day,
    Color textColor,
  ) {
    final formattedDate = DateFormatter.formatMediumDate(
      day.date,
      context.locale.languageCode,
    );

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
              style: Theme.of(context).textTheme.labelLarge,
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
              WeatherUIHelper.getLocalizedWeatherDescription(day.description),
              style: Theme.of(context).textTheme.labelLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${day.tempMin.round()}° / ${day.tempMax.round()}°',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
