import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../utils/preferences_util.dart';
import '../../setting/notification_settings_page.dart';

class WeatherAppBar {
  static Widget buildSliverAppBar(BuildContext context, String cityName, Color textColor) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        cityName,
        style: TextStyle(
          color: textColor,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        _buildNotificationButton(context, textColor),
        _buildLanguageButton(context, textColor),
        _buildThemeButton(context, themeProvider, textColor),
      ],
    );
  }

  static Widget _buildNotificationButton(BuildContext context, Color textColor) {
    return IconButton(
      icon: Icon(Icons.notifications_outlined, color: textColor, size: 24.sp),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationSettingsPage(),
          ),
        );
      },
      tooltip: 'notifications'.tr(),
    );
  }

  static Widget _buildLanguageButton(BuildContext context, Color textColor) {
    return IconButton(
      icon: Icon(Icons.language, color: textColor, size: 24.sp),
      onPressed: () async {
        if (context.locale == const Locale('en')) {
          await context.setLocale(const Locale('vi'));
          await PreferencesUtil.saveLanguagePreference('vi');
        } else {
          await context.setLocale(const Locale('en'));
          await PreferencesUtil.saveLanguagePreference('en');
        }
        PreferencesUtil.refreshWeatherWithCurrentLanguage(context);
      },
      tooltip: 'change_language'.tr(),
    );
  }

  static Widget _buildThemeButton(
      BuildContext context,
      ThemeProvider themeProvider,
      Color textColor,
      ) {
    return IconButton(
      icon: Icon(
        themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
        color: textColor,
        size: 24.sp,
      ),
      onPressed: themeProvider.toggleTheme,
      tooltip: 'toggle_theme'.tr(),
    );
  }
}