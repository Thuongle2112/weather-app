import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

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
        color: Colors.black26,
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
                      Gap(4.h),
                      Flexible(
                        child: Text(
                          city,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        temperature ?? '--°',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
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
