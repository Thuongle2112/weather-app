import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/lazy_lottie.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onHide;

  const FloatingButton({super.key, this.onPressed, this.onHide});

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
                    child: LazyLottie(
                      assetPath: 'assets/animations/new_year_floating_button.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      width: 100.w,
                      height: 100.w,
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
