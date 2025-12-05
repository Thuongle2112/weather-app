import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../data/model/weather/time_mark.dart';

class TimeProgressBar extends StatefulWidget {
  final List<TimeMark> marks;
  final DateTime currentTime;

  const TimeProgressBar({
    super.key,
    required this.marks,
    required this.currentTime,
  });

  @override
  State<TimeProgressBar> createState() => _TimeProgressBarState();
}

class _TimeProgressBarState extends State<TimeProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int leftIndex;
  late int rightIndex;
  late double percent;

  @override
  void initState() {
    super.initState();
    _calculateIndicesAndPercent();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    _animation = Tween<double>(
      begin: 0,
      end: percent,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: false);
  }

  @override
  void didUpdateWidget(covariant TimeProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _calculateIndicesAndPercent();
    _animation = Tween<double>(
      begin: 0,
      end: percent,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: false);
  }

  void _calculateIndicesAndPercent() {
    final marks = widget.marks;
    final now = widget.currentTime;

    List<DateTime> times = [];
    DateTime base = DateTime(now.year, now.month, now.day);
    int prevHour = 0;
    int prevMinute = 0;
    int dayOffset = 0;

    for (int i = 0; i < marks.length; i++) {
      final parts = marks[i].time.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      if (i > 0 &&
          (hour < prevHour || (hour == prevHour && minute < prevMinute))) {
        dayOffset += 1;
      }
      prevHour = hour;
      prevMinute = minute;
      times.add(
        base.add(Duration(days: dayOffset, hours: hour, minutes: minute)),
      );
    }

    if (now.isBefore(times.first)) {
      leftIndex = 0;
      rightIndex = 1;
      percent = 0;
      return;
    }

    if (now.isAfter(times.last)) {
      leftIndex = times.length - 2;
      rightIndex = times.length - 1;
      percent = 1;
      return;
    }

    for (int i = 0; i < times.length - 1; i++) {
      if (now.isAfter(times[i]) && now.isBefore(times[i + 1])) {
        leftIndex = i;
        rightIndex = i + 1;
        final total = times[i + 1].difference(times[i]).inSeconds;
        final passed = now.difference(times[i]).inSeconds;
        percent = total == 0 ? 0 : passed / total;
        return;
      }
    }

    leftIndex = times.length - 2;
    rightIndex = times.length - 1;
    percent = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leftMark = widget.marks[leftIndex];
    final rightMark = widget.marks[rightIndex];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: AssetImage('assets/images/noel_time_progress_bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildLabel(leftMark), _buildLabel(rightMark)],
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 32.h,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final width = constraints.maxWidth;
                      final pos = width * _animation.value;
                      return Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 6.h,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                          Positioned(
                            left: pos - 16.w,
                            child: Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.deepPurple,
                              ),
                              child: Icon(
                                Icons.nightlight_round,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leftMark.time,
                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                ),
                Text(
                  rightMark.time,
                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(TimeMark mark) {
    return Row(
      children: [
        Icon(mark.icon, color: Colors.white, size: 20.sp),
        SizedBox(width: 4.w),
        Text(
          mark.label,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ],
    );
  }
}
