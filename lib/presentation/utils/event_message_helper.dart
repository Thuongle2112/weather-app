import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import '../widgets/lazy_lottie.dart';

class NewYearMessageHelper {
  static String getTodayMessage(BuildContext context, {DateTime? testDate}) {
    final now = testDate ?? DateTime.now();
    // Show messages from Dec 29 to Jan 2 (inclusive)
    if ((now.month == 12 && now.day >= 29) ||
        (now.month == 1 && now.day <= 2)) {
      // Index: 0 for Dec 29, 1 for Dec 30, 2 for Dec 31, 3 for Jan 1, 4 for Jan 2
      int index;
      if (now.month == 12) {
        index = now.day - 29;
      } else {
        index = now.day + 2;
      }
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
              SizedBox(height: 16.h),

              Text(
                '🎆 Happy New Year! 🎉',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
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

              SizedBox(height: 12.h),

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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                  (index) => Text('🎇', style: TextStyle(fontSize: 20.sp)),
                ),
              ),

              SizedBox(height: 16.h),

              ElevatedButton(
                onPressed:
                    () => Navigator.of(context, rootNavigator: true).maybePop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
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
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text('🥂', style: TextStyle(fontSize: 18.sp)),
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
