import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CityCard extends StatelessWidget {
  final String city;
  final String temperature;
  final VoidCallback onTap;
  final bool isDarkMode;

  const CityCard({
    super.key,
    required this.city,
    required this.temperature,
    required this.onTap,
    this.isDarkMode = false,
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
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Icon(Icons.wb_sunny, color: Colors.yellow, size: 32.sp),
              SizedBox(height: 8.h),
              Text(
                city,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                temperature,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
