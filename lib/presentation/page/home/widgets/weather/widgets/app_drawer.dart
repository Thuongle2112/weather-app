import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/constants/language_constants.dart';
import 'package:weather_app/presentation/providers/theme_provider.dart';

import '../../../../settings/notification_settings_page.dart';
import '../../../../weather_radar_page.dart';
import '../../widgets.dart';
import 'gradient_text.dart';

class AppDrawer extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const AppDrawer({super.key, this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDarkMode
                    ? [Colors.grey[900]!, Colors.grey[850]!]
                    : [Colors.blue[400]!, Colors.blue[700]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildDrawerHeader(context),
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
                  ],
                ),
              ),
              _buildDrawerFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: GradientText(
        text: 'weather_app_title'.tr(),
        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD32F2F), // Gold
            Color(0xFFFFFFFF), // White
            Color(0xFF1B5E20), // Sky blue
          ],
        ),
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
              color: Colors.white.withOpacity(0.7),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
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
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13.sp),
      ),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) => themeProvider.toggleTheme(),
        activeColor: Colors.blue[300],
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
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13.sp),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(currentLanguage.flag, style: TextStyle(fontSize: 20.sp)),
          SizedBox(width: 8.w),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.5),
            size: 14.sp,
          ),
        ],
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
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
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13.sp),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white.withOpacity(0.5),
        size: 14.sp,
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
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
        ),
      ),
      subtitle: Text(
        'view_weather_radar'.tr(),
        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13.sp),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white.withOpacity(0.5),
        size: 14.sp,
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
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

  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Weather Today',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Version 1.2.0',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
