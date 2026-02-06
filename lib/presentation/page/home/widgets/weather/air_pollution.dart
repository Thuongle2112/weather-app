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

  String getAqiAdvice(int aqi) {
    switch (aqi) {
      case 1:
        return 'aqi_advice_good'.tr();
      case 2:
        return 'aqi_advice_fair'.tr();
      case 3:
        return 'aqi_advice_moderate'.tr();
      case 4:
        return 'aqi_advice_poor'.tr();
      case 5:
        return 'aqi_advice_very_poor'.tr();
      default:
        return '';
    }
  }

  IconData getAqiIcon(int aqi) {
    switch (aqi) {
      case 1:
        return Icons.mood;
      case 2:
        return Icons.sentiment_satisfied;
      case 3:
        return Icons.sentiment_neutral;
      case 4:
        return Icons.sentiment_dissatisfied;
      case 5:
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final aqi = airPollution.aqi.clamp(1, 5);
    final aqiText = getAqiText(aqi);
    final aqiAdvice = getAqiAdvice(aqi);
    final aqiColor = getAqiColor(aqi);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [aqiColor.withOpacity(0.3), aqiColor.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "air_quality".tr(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
            ),
          ),
          Gap(16.h),
          CustomPaint(
            painter: AirGaugePainter(aqi: aqi),
            size: Size(120.w, 60.h),
          ),
          Gap(24.h),
          // Text(
          //   '$aqi/5',
          //   style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          //     fontWeight: FontWeight.bold,
          //     color: aqiColor,
          //   ),
          // ),
          // Gap(12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: aqiColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              aqiText,
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Gap(12.h),
          Text(
            aqiAdvice,
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.copyWith(fontStyle: FontStyle.italic, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
