import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
              isDarkMode
                  ? [Colors.black, Colors.red[900]!]
                  : [Colors.red, Colors.redAccent],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80.sp, color: Colors.white),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyle(fontSize: 20.sp, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.white : Colors.white,
                foregroundColor: isDarkMode ? Colors.red : Colors.red,
              ),
              child: Text('try_again'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
