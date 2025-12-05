import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../data/model/weather/weather.dart';

class WeatherExtraInfo extends StatelessWidget {
  final Weather weather;
  final Color textColor;

  const WeatherExtraInfo({
    super.key,
    required this.weather,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildInfoItem(
            icon: Icons.water_drop,
            value: '${weather.humidity ?? 0}%',
            label: 'humidity'.tr(),
          ),
        ),
        Expanded(
          child: _buildInfoItem(
            icon: Icons.device_thermostat,
            value: '${weather.rainChance ?? 0}%',
            label: 'chance_of_rain'.tr(),
          ),
        ),
        Expanded(
          child: _buildInfoItem(
            icon: Icons.air,
            value:
                '${weather.windSpeed != null ? weather.windSpeed!.toInt() : 0} ${'km_per_hour'.tr()}',
            label: 'wind'.tr(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      constraints: BoxConstraints(minWidth: 80.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 24.sp),
          SizedBox(height: 8.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}