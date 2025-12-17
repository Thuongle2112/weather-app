import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class WeatherHeader extends StatelessWidget {
  final String cityName;
  final Color textColor;

  const WeatherHeader({
    super.key,
    required this.cityName,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = _getFormattedDate(
      DateTime.now(),
      context.locale.languageCode,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationRow(),
              SizedBox(height: 4.h),
              _buildDateText(formattedDate),
            ],
          ),
        ),
        _buildMenuButton(context),
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, color: Colors.white, size: 24.sp),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            cityName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDateText(String formattedDate) {
    return Text(
      formattedDate,
      style: TextStyle(
        color: textColor.withOpacity(0.7),
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
      icon: Icon(Icons.menu, color: Colors.white, size: 28.sp),
      padding: EdgeInsets.all(12.w),
      constraints: const BoxConstraints(),
    );
  }

  String _getFormattedDate(DateTime now, String locale) {
    try {
      switch (locale) {
        case 'vi':
          return DateFormat("EEEE, 'ngày' dd 'tháng' MM", locale).format(now);
        case 'ja':
          return DateFormat('M月d日 (EEEE)', locale).format(now);
        case 'ko':
          return DateFormat('M월 d일 EEEE', locale).format(now);
        case 'zh':
          return DateFormat('M月d日 EEEE', locale).format(now);
        case 'th':
          return DateFormat('EEEE ที่ d MMMM', locale).format(now);
        case 'fr':
          return DateFormat('EEEE d MMMM', locale).format(now);
        case 'de':
          return DateFormat('EEEE, d. MMMM', locale).format(now);
        case 'es':
          return DateFormat('EEEE, d \'de\' MMMM', locale).format(now);
        case 'en':
        default:
          return DateFormat('EEEE, MMMM d', locale).format(now);
      }
    } catch (e) {
      return DateFormat('EEEE, MMMM d', 'en').format(now);
    }
  }
}
