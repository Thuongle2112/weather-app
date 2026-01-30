import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:async';

import '../widgets/lazy_lottie.dart';

class NewYearMessageHelper {
  static String getTodayMessage(BuildContext context, {DateTime? testDate}) {
    final now = testDate ?? DateTime.now();
    // Show messages from Feb 17 to Feb 22 (inclusive)
    if (now.month == 2 && now.day >= 17 && now.day <= 22) {
      // Index: 0 for Feb 17, 1 for Feb 18, 2 for Feb 19, 3 for Feb 20, 4 for Feb 21, 5 for Feb 22
      int index = now.day - 17;
      final message = tr('new_year_messages.$index', context: context);
      return message;
    }
    return '';
  }

  static void showMessageDialog(
    BuildContext context,
    String message, {
    Duration autoDismissDuration = const Duration(seconds: 30),
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (dialogContext) => _NewYearAutoDismissDialog(
            message: message,
            autoDismissDuration: autoDismissDuration,
          ),
    );
  }
}

class _NewYearAutoDismissDialog extends StatefulWidget {
  final String message;
  final Duration autoDismissDuration;

  const _NewYearAutoDismissDialog({
    Key? key,
    required this.message,
    required this.autoDismissDuration,
  }) : super(key: key);

  @override
  State<_NewYearAutoDismissDialog> createState() =>
      _NewYearAutoDismissDialogState();
}

class _NewYearAutoDismissDialogState extends State<_NewYearAutoDismissDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.autoDismissDuration, () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).maybePop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1976D2).withOpacity(0.95),
                const Color(0xFFFFD600).withOpacity(0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LazyLottie(
                assetPath: 'assets/animations/new_year_message.json',
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
                repeat: true,
              ),
              Gap(16.h),

              Text(
                'happy_lunar_year'.tr(),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              Gap(12.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),

              Gap(20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                  (index) =>
                      Text('🎇', style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),

              Gap(16.h),

              ElevatedButton(
                onPressed:
                    () => Navigator.of(context, rootNavigator: true).maybePop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent.withOpacity(0.9),
                  foregroundColor: const Color(0xFF1976D2),
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'OK',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(8.w),
                    Text('🥂', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
