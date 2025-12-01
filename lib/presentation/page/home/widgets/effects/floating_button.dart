import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onHide;

  const FloatingButton({Key? key, this.onPressed, this.onHide})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24.w,
      bottom: 50.h,
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              onTap: onPressed,
              child: Padding(
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: 100.w,
                  height: 100.w,
                  child: ClipOval(
                    child: Lottie.asset(
                      // 'assets/animations/christmas/christmas_floating_button.json',
                      'assets/animations/christmas_floating_button.json',
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: -8.h,
            right: -8.w,
            child: GestureDetector(
              onTap: onHide,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(4.w),
                child: Icon(Icons.close, color: Colors.white, size: 18.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
