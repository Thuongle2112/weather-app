import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class InitialView extends StatelessWidget {
  final VoidCallback onLocationRequest;
  final VoidCallback onSearchCity;
  final bool isDarkMode;

  const InitialView({
    super.key,
    required this.onLocationRequest,
    required this.onSearchCity,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [Colors.black, Colors.grey[850]!]
              : [Colors.blue, Colors.teal],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.cloud_outlined,
                size: 100,
                color: isDarkMode ? Colors.blue : Colors.white
            ),
            const SizedBox(height: 24),
            Text(
              'weather_app_title'.tr(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: onLocationRequest,
              icon: const Icon(Icons.my_location),
              label: Text('use_my_location'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.blue : Colors.white,
                foregroundColor: isDarkMode ? Colors.white : Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onSearchCity,
              child: Text(
                'search_for_city'.tr(),
                style: TextStyle(
                    color: isDarkMode ? Colors.blue : Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}