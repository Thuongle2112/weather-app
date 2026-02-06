import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
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
            context: context,
          ),
        ),
        Expanded(
          child: _buildInfoItem(
            icon: Icons.device_thermostat,
            value: '${weather.rainChance ?? 0}%',
            label: 'chance_of_rain'.tr(),
            context: context,
          ),
        ),
        Expanded(
          child: _buildInfoItem(
            icon: Icons.air,
            value:
                '${weather.windSpeed != null ? weather.windSpeed!.toInt() : 0} ${'km_per_hour'.tr()}',
            label: 'wind'.tr(),
            context: context,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String value,
    required String label,
    required BuildContext context,
  }) {
    return Container(
      constraints: BoxConstraints(minWidth: 80.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16.sp),
          Gap(4.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: textColor.withOpacity(0.7),
              ),
            ),
          ),
          Gap(4.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
