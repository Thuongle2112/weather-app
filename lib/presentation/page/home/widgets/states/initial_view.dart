import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class InitialView extends StatelessWidget {
  final VoidCallback onLocationRequest;
  final VoidCallback onSearchCity;
  final bool isDarkMode;

  const InitialView({
    super.key,
    required this.onLocationRequest,
    required this.onSearchCity,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            isDarkMode
                ? 'assets/images/noel_bg_dark.jpg'
                : 'assets/images/noel_bg_light.jpg',
            fit: BoxFit.cover,
          ),
        ),

        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.1),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_outlined,
                size: 100.sp,
                color: isDarkMode ? Colors.blue : Colors.white,
              ),
              SizedBox(height: 24.h),
              Text(
                'weather_app_title'.tr(),
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.white,
                ),
              ),
              SizedBox(height: 48.h),
              ElevatedButton.icon(
                onPressed: onLocationRequest,
                icon: Icon(Icons.my_location, size: 24.sp),
                label: Text(
                  'use_my_location'.tr(),
                  style: TextStyle(fontSize: 16.sp),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.blue : Colors.white,
                  foregroundColor: isDarkMode ? Colors.white : Colors.blue,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: onSearchCity,
                child: Text(
                  'search_for_city'.tr(),
                  style: TextStyle(
                    color: isDarkMode ? Colors.blue : Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
