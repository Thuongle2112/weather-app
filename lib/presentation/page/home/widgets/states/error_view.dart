import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';

import '../../../../widgets/lazy_lottie.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isDarkMode;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/new_year_error.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: Container(
              color: Colors.black.withOpacity(isDarkMode ? 0.45 : 0.35),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200.w,
                  height: 200.h,
                  child: LazyLottie(
                    assetPath: 'assets/animations/no_internet_connection.json',
                    fit: BoxFit.cover,
                    repeat: true,
                    width: 200.w,
                    height: 200.h,
                  ),
                ),
                Gap(12.h),
                Text(
                  'halloween_error'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                ),
                Gap(20.h),
                SizedBox(
                  width: 180.w,
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'try_again'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
