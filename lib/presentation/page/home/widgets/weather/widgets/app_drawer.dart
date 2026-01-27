import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/constants/language_constants.dart';
import 'package:weather_app/core/services/event_service.dart';
import 'package:weather_app/presentation/providers/theme_provider.dart';

import '../../../../../widgets/lazy_lottie.dart';

import '../../../../settings/notification_settings_page.dart';
import '../../../../weather_radar_page.dart';
import '../../widgets.dart';

class AppDrawer extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const AppDrawer({super.key, this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Kiểm tra xem có đang trong event Tết không
    final isLunarNewYearEvent = EventService.isEventActive(
      'lunar_new_year_2026',
    );

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          // Nếu là event Tết thì dùng ảnh, không thì dùng gradient như cũ
          image:
              isLunarNewYearEvent
                  ? const DecorationImage(
                    image: AssetImage('assets/images/drawer_bg.jpeg'),
                    fit: BoxFit.cover,
                    opacity: 0.6,
                    colorFilter: ColorFilter.mode(
                      Colors.black45,
                      BlendMode.softLight,
                    ),
                  )
                  : null,
          gradient:
              !isLunarNewYearEvent
                  ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:
                        isDarkMode
                            ? [Colors.grey[900]!, Colors.grey[850]!]
                            : [Colors.blue[400]!, Colors.blue[700]!],
                  )
                  : null,
          // Nếu có ảnh thì thêm màu đỏ đậm overlay
          color: isLunarNewYearEvent ? const Color(0xFFB71C1C) : null,
        ),
        // Thêm overlay để text dễ đọc hơn khi có ảnh nền
        child: Container(
          decoration:
              isLunarNewYearEvent
                  ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red[900]!.withOpacity(0.7),
                        Colors.red[800]!.withOpacity(0.8),
                      ],
                    ),
                  )
                  : null,
          child: SafeArea(
            child: Column(
              children: [
                _buildDrawerHeader(context, isLunarNewYearEvent),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildSection(
                        context,
                        title: 'appearance'.tr(),
                        children: [
                          _buildThemeTile(context, themeProvider, isDarkMode),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildSection(
                        context,
                        title: 'preferences'.tr(),
                        children: [
                          _buildLanguageTile(context),
                          _buildNotificationTile(context),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildSection(
                        context,
                        title: 'features'.tr(),
                        children: [_buildWeatherRadarTile(context)],
                      ),
                      if (isLunarNewYearEvent) ...[
                        SizedBox(height: 16.h),
                        _buildEventButton(context),
                      ],
                    ],
                  ),
                ),
                _buildDrawerFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, bool isLunarNewYear) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration:
          isLunarNewYear
              ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.amber.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              )
              : null,
      child: Row(
        children: [
          if (isLunarNewYear) ...[
            Text('🧧', style: TextStyle(fontSize: 32.sp)),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Text(
              'weather_app_title'.tr(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows:
                    isLunarNewYear
                        ? [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ]
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDarkMode,
  ) {
    return ListTile(
      leading: Icon(
        isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: Colors.white,
        size: 24.sp,
      ),
      title: Text(
        'theme'.tr(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        isDarkMode ? 'dark_mode'.tr() : 'light_mode'.tr(),
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13.sp),
      ),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) => themeProvider.toggleTheme(),
        activeColor: Colors.amber,
      ),
      onTap: () => themeProvider.toggleTheme(),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    final currentLocale = context.locale.languageCode;
    final currentLanguage = LanguageConstants.getLanguageByCode(currentLocale);

    return ListTile(
      leading: Icon(Icons.language, color: Colors.white, size: 24.sp),
      title: Text(
        'language'.tr(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        currentLanguage.name,
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13.sp),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(currentLanguage.flag, style: TextStyle(fontSize: 20.sp)),
          SizedBox(width: 8.w),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.7),
            size: 14.sp,
          ),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => const LanguageSelectorBottomSheet(),
        );
      },
    );
  }

  Widget _buildNotificationTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.notifications_outlined,
        color: Colors.white,
        size: 24.sp,
      ),
      title: Text(
        'notifications'.tr(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'notification_settings'.tr(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 13.sp,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white.withOpacity(0.7),
        size: 14.sp,
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationSettingsPage(),
          ),
        );
      },
    );
  }

  Widget _buildWeatherRadarTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.radar, color: Colors.white, size: 24.sp),
      title: Text(
        'weather_radar'.tr(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Text(
        'view_weather_radar'.tr(),
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13.sp),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white.withOpacity(0.7),
        size: 14.sp,
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => WeatherRadarPage(
                  latitude: latitude ?? 21.02,
                  longitude: longitude ?? 105.84,
                ),
          ),
        );
      },
    );
  }

  Widget _buildEventButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red[700]!, Colors.red[900]!],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.amber, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            Navigator.pop(context);
            context.push('/fortune-shake');
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'gieo_que_dau_xuan'.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'gieo_que_instructions'.tr(),
                        style: TextStyle(
                          color: Colors.amber[100],
                          fontSize: 12.sp,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                LazyLottie(
                  assetPath: 'assets/animations/lunar_year_button_drawer.json',
                  width: 60.w,
                  height: 60.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Weather Today',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12.sp,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Version 1.2.0',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
