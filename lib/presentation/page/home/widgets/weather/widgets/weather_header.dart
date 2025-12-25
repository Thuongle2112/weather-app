import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherHeader extends StatelessWidget {
  final String cityName;
  final Color textColor;
  final bool isDarkMode;

  const WeatherHeader({
    super.key,
    required this.cityName,
    required this.textColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildLocationRow(context)],
          ),
        ),
        _buildMenuButton(context),
      ],
    );
  }

  Widget _buildLocationRow(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, color: Colors.red, size: 24.sp),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            cityName,
            style: Theme.of(context).textTheme.headlineSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: IconButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 24.sp,
          ),
          padding: EdgeInsets.all(8.w),
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }
}
