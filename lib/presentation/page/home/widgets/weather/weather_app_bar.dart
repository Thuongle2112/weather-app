// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:provider/provider.dart';
// import 'package:weather_app/core/constants/language_constants.dart';

// import '../../../../providers/theme_provider.dart';

// import '../../../settings/notification_settings_page.dart';
// import '../language_selector_bottom_sheet.dart';

// class WeatherAppBar {
//   static Widget buildSliverAppBar(
//     BuildContext context,
//     String cityName,
//     Color textColor,
//   ) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return SliverAppBar(
//       pinned: false,
//       floating: true,
//       snap: true,
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Image.asset(
//           'assets/images/christmas_bg_appbar.jpg',
//           fit: BoxFit.cover,
//         ),
//       ),
//       actions: [
//         _buildNotificationButton(context, textColor),
//         _buildLanguageButton(context, textColor),
//         _buildThemeButton(context, themeProvider, textColor),
//       ],
//     );
//   }

//   static Widget _buildNotificationButton(
//     BuildContext context,
//     Color textColor,
//   ) {
//     return IconButton(
//       icon: Icon(Icons.notifications_outlined, color: textColor, size: 24.sp),
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const NotificationSettingsPage(),
//           ),
//         );
//       },
//       tooltip: 'notifications'.tr(),
//     );
//   }

//   static Widget _buildLanguageButton(BuildContext context, Color textColor) {
//     final currentLocale = context.locale.languageCode;
//     final currentLanguage = LanguageConstants.getLanguageByCode(currentLocale);

//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 4.w),
//       child: InkWell(
//         onTap: () {
//           showModalBottomSheet(
//             context: context,
//             backgroundColor: Colors.transparent,
//             isScrollControlled: true,
//             builder: (context) => const LanguageSelectorBottomSheet(),
//           );
//         },
//         borderRadius: BorderRadius.circular(8.r),
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(8.r),
//             border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(currentLanguage.flag, style: TextStyle(fontSize: 20.sp)),
//               SizedBox(width: 4.w),
//               Icon(Icons.arrow_drop_down, color: textColor, size: 20.sp),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   static Widget _buildThemeButton(
//     BuildContext context,
//     ThemeProvider themeProvider,
//     Color textColor,
//   ) {
//     return IconButton(
//       icon: Icon(
//         themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
//         color: textColor,
//         size: 24.sp,
//       ),
//       onPressed: themeProvider.toggleTheme,
//       tooltip: 'toggle_theme'.tr(),
//     );
//   }
// }
