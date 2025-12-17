import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CityCard extends StatelessWidget {
  final String city;
  final String? temperature;
  final String? weatherIcon;
  final VoidCallback onTap;
  final bool isDarkMode;
  final bool isLoading;

  const CityCard({
    super.key,
    required this.city,
    this.temperature,
    this.weatherIcon,
    required this.onTap,
    this.isDarkMode = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isDarkMode ? Colors.black26 : Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child:
              isLoading
                  ? Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildWeatherIcon(),
                      SizedBox(height: 4.h),
                      Flexible(
                        child: Text(
                          city,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        temperature ?? '--°',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildWeatherIcon() {
    if (weatherIcon == null || weatherIcon!.isEmpty) {
      return Icon(Icons.wb_sunny, size: 28.sp);
    }

    return SvgPicture.asset(
      "assets/weather_icons/$weatherIcon",
      width: 32.w,
      height: 32.h,
    );
  }
}
