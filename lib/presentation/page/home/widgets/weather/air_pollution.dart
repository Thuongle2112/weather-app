import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../data/model/weather/air_pollution.dart';
import '../buttons/air_gauge_painter.dart';

class AirPollutionGaugeWidget extends StatelessWidget {
  final AirPollution airPollution;

  const AirPollutionGaugeWidget({super.key, required this.airPollution});

  String getAqiText(int aqi) {
    switch (aqi) {
      case 1:
        return 'aqi_good'.tr();
      case 2:
        return 'aqi_fair'.tr();
      case 3:
        return 'aqi_moderate'.tr();
      case 4:
        return 'aqi_poor'.tr();
      case 5:
        return 'aqi_very_poor'.tr();
      default:
        return 'aqi_unknown'.tr();
    }
  }

  Color getAqiColor(int aqi) {
    switch (aqi) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final aqi = airPollution.aqi.clamp(1, 5);
    final aqiText = getAqiText(aqi);
    final aqiColor = getAqiColor(aqi);

    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "air_quality".tr(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Gap(16.h),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  return CustomPaint(
                    painter: AirGaugePainter(aqi: aqi),
                    size: Size(width, width * 0.45),
                  );
                },
              ),

              Gap(16.h),
              Text(
                '$aqi/5',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: aqiColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                aqiText,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: aqiColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
