import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: isDarkMode ? Colors.grey[900] : Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSectionTitle(textColor),
          ),
          const SizedBox(height: 16),
          _buildCitiesScrollList(context),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Icon(Icons.arrow_forward, color: textColor.withOpacity(0.5), size: 18),
      ],
    );
  }

  Widget _buildCitiesScrollList(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth / 3.5;

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: popularCities.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: cardWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
      child: ElevatedButton(
        onPressed: () => showSearchModal(),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? Colors.blue : Colors.lightBlue,
          padding: const EdgeInsets.symmetric(vertical: 16),
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
    );
  }
}
