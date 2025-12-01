import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/language_constants.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils/preferences_util.dart';

class LanguageSelectorBottomSheet extends StatelessWidget {
  const LanguageSelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final currentLocale = context.locale.languageCode;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'select_language'.tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1.h, color: Colors.grey.withOpacity(0.3)),

          // Language list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: LanguageConstants.supportedLanguages.length,
              itemBuilder: (context, index) {
                final language = LanguageConstants.supportedLanguages[index];
                final isSelected = currentLocale == language.code;

                return _buildLanguageItem(
                  context,
                  language,
                  isSelected,
                  isDarkMode,
                );
              },
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(
    BuildContext context,
    LanguageModel language,
    bool isSelected,
    bool isDarkMode,
  ) {
    return InkWell(
      onTap: () async {
        if (!isSelected) {
          await context.setLocale(Locale(language.code));
          await PreferencesUtil.saveLanguagePreference(language.code);
          PreferencesUtil.refreshWeatherWithCurrentLanguage(context);
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode
                  ? const Color(0xFF2196F3).withOpacity(0.2)
                  : const Color(0xFF2196F3).withOpacity(0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2196F3)
                : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag emoji
            Text(
              language.flag,
              style: TextStyle(fontSize: 32.sp),
            ),

            SizedBox(width: 16.w),

            // Language info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.nativeName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    language.name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Selected indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFF2196F3),
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }
}