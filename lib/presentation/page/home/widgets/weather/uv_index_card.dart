import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';

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
            Center(
              child: Column(
                children: [
                  Text(
                    'uv_index'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Gap(8.h),
                  Text(
                    uvIndex.value.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: uvColor,
                    ),
                  ),
                  Gap(8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: uvColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      uvLevel,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Gap(12.h),

            // UV Level Bar
            _buildUvLevelBar(),
            Gap(12.h),

            // Health Advice
            Text(
              uvAdvice,
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontStyle: FontStyle.italic),
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

  String _getUvAdvice(double uv) {
    if (uv <= 2) return 'uv_advice_low'.tr();
    if (uv <= 5) return 'uv_advice_moderate'.tr();
    if (uv <= 7) return 'uv_advice_high'.tr();
    if (uv <= 10) return 'uv_advice_very_high'.tr();
    return 'uv_advice_extreme'.tr();
  }
}
