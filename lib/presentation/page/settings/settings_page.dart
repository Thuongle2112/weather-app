import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/constants/language_constants.dart';

import '../../providers/theme_provider.dart';
import '../home/widgets/language_selector_bottom_sheet.dart';
import 'notification_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blue,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.grey[900]!, Colors.grey[850]!]
                : [Colors.blue[400]!, Colors.blue[700]!],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          children: [
            _buildSettingsSection(
              context,
              title: 'appearance'.tr(),
              children: [
                _buildThemeTile(context, themeProvider, isDarkMode),
              ],
            ),
            SizedBox(height: 16.h),
            _buildSettingsSection(
              context,
              title: 'preferences'.tr(),
              children: [
                _buildLanguageTile(context, isDarkMode),
                _buildNotificationTile(context, isDarkMode),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
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
              fontSize: 14.sp,
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
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
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
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        isDarkMode ? 'dark_mode'.tr() : 'light_mode'.tr(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14.sp,
        ),
      ),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) => themeProvider.toggleTheme(),
        activeColor: Colors.blue[300],
      ),
      onTap: () => themeProvider.toggleTheme(),
    );
  }

  Widget _buildLanguageTile(BuildContext context, bool isDarkMode) {
    final currentLocale = context.locale.languageCode;
    final currentLanguage = LanguageConstants.getLanguageByCode(currentLocale);

    return ListTile(
      leading: Icon(
        Icons.language,
        color: Colors.white,
        size: 24.sp,
      ),
      title: Text(
        'language'.tr(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        currentLanguage.name,
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14.sp,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentLanguage.flag,
            style: TextStyle(fontSize: 24.sp),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.5),
            size: 16.sp,
          ),
        ],
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => const LanguageSelectorBottomSheet(),
        );
      },
    );
  }

  Widget _buildNotificationTile(BuildContext context, bool isDarkMode) {
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
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'notification_settings'.tr(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14.sp,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white.withOpacity(0.5),
        size: 16.sp,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationSettingsPage(),
          ),
        );
      },
    );
  }
}