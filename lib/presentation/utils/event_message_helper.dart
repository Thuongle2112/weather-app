import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class ChristmasMessageHelper {
  // Christmas period: Dec 20 - Dec 26
  static String getTodayMessage(BuildContext context, {DateTime? testDate}) {
    final now = testDate ?? DateTime.now();
    if (now.month == 12 && now.day >= 20 && now.day <= 26) {
      final index = now.day - 20; // 0-6 for 7 days
      final message = tr('christmas_messages.$index', context: context);
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
      builder: (dialogContext) => _AutoDismissDialog(
        message: message,
        autoDismissDuration: autoDismissDuration,
      ),
    );
  }
}

class _AutoDismissDialog extends StatefulWidget {
  final String message;
  final Duration autoDismissDuration;

  const _AutoDismissDialog({
    Key? key,
    required this.message,
    required this.autoDismissDuration,
  }) : super(key: key);

  @override
  _AutoDismissDialogState createState() => _AutoDismissDialogState();
}

class _AutoDismissDialogState extends State<_AutoDismissDialog> {
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
                const Color(0xFFD32F2F).withOpacity(0.95), // Đỏ Santa
                const Color(0xFF1B5E20).withOpacity(0.95), // Xanh lá thông
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 3,
            ),
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
              // Santa/Christmas animation
              Lottie.asset(
                'assets/animations/christmas_santa.json',
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
                repeat: true,
              ),
              SizedBox(height: 16.h),
              
              // Title
              Text(
                '🎄 Merry Christmas! 🎅',
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
              
              // Message
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
              
              // Decorative snowflakes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                  (index) => Text(
                    '❄️',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // OK button
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).maybePop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFD32F2F),
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
                    Text(
                      '🎁',
                      style: TextStyle(fontSize: 18.sp),
                    ),
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