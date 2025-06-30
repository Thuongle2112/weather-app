import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';
import '../../../utils/preferences_util.dart';

class WeatherAppBar extends StatelessWidget {
  final String cityName;
  final Color textColor;

  const WeatherAppBar({
    super.key,
    required this.cityName,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              cityName,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildLanguageButton(context, textColor),
          _buildThemeButton(context, themeProvider, textColor),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, Color textColor) {
    return IconButton(
      icon: Icon(Icons.language, color: textColor),
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

  Widget _buildThemeButton(
    BuildContext context,
    ThemeProvider themeProvider,
    Color textColor,
  ) {
    return IconButton(
      icon: Icon(
        themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
        color: textColor,
      ),
      onPressed: themeProvider.toggleTheme,
      tooltip: 'toggle_theme'.tr(),
    );
  }
}
