import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import 'city_card.dart';

class CityListSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      // color: isDarkMode ? Colors.grey[900] : Colors.black12,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.black12,
        image: DecorationImage(
          image: AssetImage(
            'assets/images/halloween_bg.jpg',
          ),
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
            child: _buildSectionTitle(textColor),
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
        Icon(
          Icons.arrow_forward,
          color: textColor.withOpacity(0.5),
          size: 18.sp,
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
        itemCount: popularCities.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: cardWidth.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: _buildCityCard(context, popularCities[index], index),
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
      isDarkMode: isDarkMode,
    );
  }

  Widget _buildChangeLocationButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient:
              isDarkMode
                  ? LinearGradient(
                    colors: [Color(0xFFFF6F00), Color(0xFF6A1B9A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : LinearGradient(
                    colors: [Color(0xFFFF6F00), Color(0xFF6A1B9A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          onPressed: () => showSearchModal(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 2,
          ),
          child: Text(
            'change_location'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
