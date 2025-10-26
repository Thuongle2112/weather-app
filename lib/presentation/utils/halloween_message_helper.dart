import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class HalloweenMessageHelper {
  static String getTodayMessage(BuildContext context, {DateTime? testDate}) {
    final now = testDate ?? DateTime.now();
    if (now.month == 10 && now.day >= 25 && now.day <= 31) {
      final index = now.day - 25;
      final message = tr('halloween_messages.$index', context: context);
      return message ?? '';
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
          (dialogContext) => _AutoDismissDialog(
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
        // Use rootNavigator to ensure we pop the dialog route
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
            color: Colors.black.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.orangeAccent, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/Jack O Lantern Witch.json',
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
                repeat: true,
              ),
              SizedBox(height: 16.h),
              Text(
                widget.message,
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed:
                    () => Navigator.of(context, rootNavigator: true).maybePop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
