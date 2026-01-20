import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../data/model/weather/uv_index.dart';

class UVIndexCard extends StatelessWidget {
  final UVIndex uvIndex;

  const UVIndexCard({super.key, required this.uvIndex});

  @override
  Widget build(BuildContext context) {
    final uvLevel = _getUvLevel(uvIndex.value);
    final uvColor = _getUvColor(uvIndex.value);
    final uvAdvice = _getUvAdvice(uvIndex.value);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [uvColor.withOpacity(0.3), uvColor.withOpacity(0.1)],
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
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Header Row
            Row(
              children: [
                Icon(_getUvIcon(uvIndex.value), color: uvColor, size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  'uv_index'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // UV Value and Level
            Text(
              uvIndex.value.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
                color: uvColor,
                height: 1,
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: uvColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  uvLevel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // UV Level Bar
            _buildUvLevelBar(),
            SizedBox(height: 12.h),

            // Health Advice
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    uvAdvice,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.3,
                    ),
                    // maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUvLevelBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: SizedBox(
        height: 6.h,
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.yellow,
                    Colors.orange,
                    Colors.red,
                    Colors.purple,
                  ],
                  stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                ),
              ),
            ),
            // Current position indicator
            FractionallySizedBox(
              widthFactor: (uvIndex.value / 12).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Functions
  String _getUvLevel(double uv) {
    if (uv <= 2) return 'uv_low'.tr();
    if (uv <= 5) return 'uv_moderate'.tr();
    if (uv <= 7) return 'uv_high'.tr();
    if (uv <= 10) return 'uv_very_high'.tr();
    return 'uv_extreme'.tr();
  }

  Color _getUvColor(double uv) {
    if (uv <= 2) return Colors.green;
    if (uv <= 5) return Colors.yellow.shade700;
    if (uv <= 7) return Colors.orange;
    if (uv <= 10) return Colors.red;
    return Colors.purple;
  }

  IconData _getUvIcon(double uv) {
    if (uv <= 5) return Icons.wb_sunny;
    if (uv <= 7) return Icons.wb_sunny_outlined;
    return Icons.warning_amber_rounded;
  }

  String _getUvAdvice(double uv) {
    if (uv <= 2) return 'uv_advice_low'.tr();
    if (uv <= 5) return 'uv_advice_moderate'.tr();
    if (uv <= 7) return 'uv_advice_high'.tr();
    if (uv <= 10) return 'uv_advice_very_high'.tr();
    return 'uv_advice_extreme'.tr();
  }
}
