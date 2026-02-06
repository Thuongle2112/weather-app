import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/lazy_lottie.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200.w,
        height: 200.w,
        child: LazyLottie(
          assetPath: 'assets/animations/new_year_loading.json',
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
          width: 200.w,
          height: 200.w,
        ),
      ),
    );
  }
}
