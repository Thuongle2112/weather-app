// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:lottie/lottie.dart';
//
// import '../../../../data/model/weather/weather.dart';
//
// class WeatherShareView extends StatefulWidget {
//   final Weather weather;
//   final bool isDarkMode;
//
//   const WeatherShareView({
//     super.key,
//     required this.weather,
//     required this.isDarkMode,
//   });
//
//   @override
//   State<WeatherShareView> createState() => _WeatherShareViewState();
// }
//
// class _WeatherShareViewState extends State<WeatherShareView> {
//   final ScreenshotController _screenshotController = ScreenshotController();
//
//   Future<void> _shareScreenshot() async {
//     final Uint8List? image = await _screenshotController.capture();
//     if (image != null) {
//       await Share.shareXFiles([
//         XFile.fromData(
//           image,
//           mimeType: 'image/png',
//           name: 'weather_halloween.png',
//         ),
//       ], text: '#WeatherHalloween2025');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Screenshot(
//       controller: _screenshotController,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Weather info background
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: widget.isDarkMode ? Colors.black : Colors.orange[100],
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   widget.weather.cityName,
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: widget.isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   '${widget.weather.temperature}°C',
//                   style: TextStyle(
//                     fontSize: 48,
//                     fontWeight: FontWeight.bold,
//                     color: widget.isDarkMode ? Colors.white : Colors.deepOrange,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   widget.weather.description,
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: widget.isDarkMode ? Colors.white70 : Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Halloween overlay (SVG/Lottie)
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: SvgPicture.asset(
//               'assets/svgs/halloween/halloween_bg_appbar.svg',
//               height: 120,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Positioned(
//             bottom: 16,
//             right: 16,
//             child: Lottie.asset(
//               'assets/animations/ghost_loading.json',
//               width: 80,
//               repeat: true,
//             ),
//           ),
//           // Badge
//           Positioned(
//             bottom: 16,
//             left: 16,
//             child: SvgPicture.asset(
//               'assets/svgs/halloween/halloween_badge.svg',
//               width: 60,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildShareButton() {
//     return ElevatedButton.icon(
//       onPressed: _shareScreenshot,
//       icon: Icon(Icons.share),
//       label: Text('Share #WeatherHalloween2025'),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.deepOrange,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }
// }
