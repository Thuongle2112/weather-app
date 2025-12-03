import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../data/model/weather/weather.dart';
import '../../../../utils/weather_icon_mapper.dart';
import '../../../../utils/weather_ui_helper.dart';

class TemperatureDisplay extends StatelessWidget {
  final Weather weather;
  final Color textColor;

  const TemperatureDisplay({
    super.key,
    required this.weather,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize date formatting for current locale
    initializeDateFormatting(context.locale.toString());

    final iconFileName = WeatherIconMapper.getIconByDescription(
      weather.description,
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildWeatherIcon(iconFileName),
            SizedBox(height: 20.h),
            _buildTemperature(textColor),
            SizedBox(height: 16.h),
            _buildDescription(textColor, context),
            SizedBox(height: 8.h),
            _buildHighLowTemperature(textColor),
            SizedBox(height: 8.h),
            _buildCurrentDate(textColor, context),
            SizedBox(height: 16.h),
            _buildExtraWeatherInfo(textColor, context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherIcon(String iconFileName) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: SvgPicture.asset(
        'assets/weather_icons/$iconFileName',
        height: 100.h,
        width: 150.w,
      ),
    );
  }

  Widget _buildTemperature(Color textColor) {
    return Text(
      '${weather.temperature.toInt()}°C',
      style: TextStyle(
        color: textColor,
        fontSize: 80.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription(Color textColor, BuildContext context) {
    // Get localized weather description
    final localizedDescription = _getLocalizedWeatherDescription(
      weather.description,
      context.locale.languageCode,
    );

    return Text(
      WeatherUIHelper.capitalizeFirstLetter(localizedDescription),
      style: TextStyle(
        color: textColor,
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  String _getLocalizedWeatherDescription(String description, String locale) {
    // Convert English description to lowercase for matching
    final desc = description.toLowerCase();

    // Weather description translation keys
    final Map<String, String> weatherKeys = {
      'clear sky': 'weather_clear_sky',
      'few clouds': 'weather_few_clouds',
      'scattered clouds': 'weather_scattered_clouds',
      'broken clouds': 'weather_broken_clouds',
      'overcast clouds': 'weather_overcast_clouds',
      'shower rain': 'weather_shower_rain',
      'rain': 'weather_rain',
      'light rain': 'weather_light_rain',
      'moderate rain': 'weather_moderate_rain',
      'heavy rain': 'weather_heavy_rain',
      'thunderstorm': 'weather_thunderstorm',
      'snow': 'weather_snow',
      'light snow': 'weather_light_snow',
      'heavy snow': 'weather_heavy_snow',
      'mist': 'weather_mist',
      'fog': 'weather_fog',
      'haze': 'weather_haze',
      'smoke': 'weather_smoke',
      'dust': 'weather_dust',
      'sand': 'weather_sand',
      'tornado': 'weather_tornado',
    };

    // Try to find translation key
    for (var entry in weatherKeys.entries) {
      if (desc.contains(entry.key)) {
        return entry.value.tr();
      }
    }

    // Return original if no translation found
    return description;
  }

  Widget _buildCurrentDate(Color textColor, BuildContext context) {
    final now = DateTime.now();
    final locale = context.locale.languageCode;
    String formattedDate;

    try {
      switch (locale) {
        case 'vi':
          formattedDate = DateFormat(
            "EEEE, 'ngày' dd 'tháng' MM",
            locale,
          ).format(now);
          break;
        case 'ja':
          formattedDate = DateFormat('M月d日 (EEEE)', locale).format(now);
          break;
        case 'ko':
          formattedDate = DateFormat('M월 d일 EEEE', locale).format(now);
          break;
        case 'zh':
          formattedDate = DateFormat('M月d日 EEEE', locale).format(now);
          break;
        case 'th':
          formattedDate = DateFormat('EEEE ที่ d MMMM', locale).format(now);
          break;
        case 'fr':
          formattedDate = DateFormat('EEEE d MMMM', locale).format(now);
          break;
        case 'de':
          formattedDate = DateFormat('EEEE, d. MMMM', locale).format(now);
          break;
        case 'es':
          formattedDate = DateFormat('EEEE, d \'de\' MMMM', locale).format(now);
          break;
        case 'en':
        default:
          formattedDate = DateFormat('EEEE, MMMM d', locale).format(now);
          break;
      }
    } catch (e) {
      // Fallback to English if locale initialization fails
      formattedDate = DateFormat('EEEE, MMMM d', 'en').format(now);
    }

    return Text(
      formattedDate,
      style: TextStyle(
        color: textColor.withOpacity(0.8),
        fontSize: 18.sp,
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildHighLowTemperature(Color textColor) {
    return Text(
      'H:${(weather.temperature + 2).toInt()}° L:${(weather.temperature - 2).toInt()}°',
      style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16.sp),
    );
  }

  Widget _buildExtraWeatherInfo(Color textColor, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildWeatherInfoItem(
                icon: Icons.air,
                value:
                    '${weather.windSpeed != null ? weather.windSpeed!.toInt() : 0} ${'km_per_hour'.tr()}',
                label: 'wind'.tr(),
                textColor: textColor,
              ),
            ),
            Expanded(
              child: _buildWeatherInfoItem(
                icon: Icons.water_drop,
                value: '${weather.humidity ?? 0}%',
                label: 'humidity'.tr(),
                textColor: textColor,
              ),
            ),
            Expanded(
              child: _buildWeatherInfoItem(
                icon: Icons.umbrella,
                value: '${weather.rainChance ?? 0}%',
                label: 'chance_of_rain'.tr(),
                textColor: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfoItem({
    required IconData icon,
    required String value,
    required String label,
    required Color textColor,
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
