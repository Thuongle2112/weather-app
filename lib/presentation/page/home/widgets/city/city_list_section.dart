import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';

import '../../bloc/bloc.dart';
import '../widgets.dart';

class CityListSection extends StatefulWidget {
  final List<String> popularCities;
  final Color textColor;
  final bool isDarkMode;
  final Function showSearchModal;

  const CityListSection({
    super.key,
    required this.popularCities,
    required this.textColor,
    required this.isDarkMode,
    required this.showSearchModal,
  });

  @override
  State<CityListSection> createState() => _CityListSectionState();
}

class _CityListSectionState extends State<CityListSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _snowController;

  @override
  void initState() {
    super.initState();
    _snowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _snowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.grey[900] : Colors.black12,
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: const AssetImage('assets/images/noel_bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildSectionTitle(widget.textColor),
            ),
            SizedBox(height: 16.h),
            _buildCitiesScrollList(context),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildChangeLocationButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(Color textColor) {
    return Row(
      children: [
        Text(
          'other_cities'.tr(),
          style: TextStyle(
            color: textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFD32F2F).withOpacity(0.2),
                const Color(0xFF1B5E20).withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Lottie.asset(
            'assets/animations/horizontal_scroll.json',
            width: 32.w,
            height: 32.h,
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCitiesScrollList(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth / 3.5;

    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        itemCount: widget.popularCities.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: cardWidth.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: _buildCityCard(
                context,
                widget.popularCities[index],
                index,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCityCard(BuildContext context, String city, int index) {
    return CityCard(
      city: city,
      temperature: '${20 + (5 * index % 3)}°',
      onTap: () {
        context.read<WeatherBloc>().add(FetchWeatherByCity(city));
      },
      isDarkMode: widget.isDarkMode,
    );
  }

  Widget _buildChangeLocationButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      widget.isDarkMode
                          ? [
                            const Color(0xFFD32F2F),
                            const Color(0xFFFFFFFF),
                            const Color(0xFF1B5E20),
                          ]
                          : [
                            const Color(0xFFE53935),
                            const Color(0xFFF5F5F5),
                            const Color(0xFF2E7D32),
                          ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD32F2F).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => widget.showSearchModal(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  minimumSize: const Size(double.infinity, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'change_location'.tr(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.45),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _snowController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: SnowButtonPainter(
                        isDarkMode: widget.isDarkMode,
                        animation: _snowController,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
