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
      padding: const EdgeInsets.all(16),
      color: isDarkMode ? Colors.grey[900] : Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(textColor),
          const SizedBox(height: 16),
          _buildCitiesList(context),
          const SizedBox(height: 16),
          _buildChangeLocationButton(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(Color textColor) {
    return Text(
      'other_cities'.tr(),
      style: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCitiesList(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          popularCities
              .map(
                (city) => CityCard(
                  city: city,
                  temperature: '${20 + (5 * popularCities.indexOf(city) % 3)}°',
                  onTap: () {
                    context.read<WeatherBloc>().add(FetchWeatherByCity(city));
                  },
                  isDarkMode: isDarkMode,
                ),
              )
              .toList(),
    );
  }

  Widget _buildChangeLocationButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => showSearchModal(),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? Colors.blue : Colors.amber,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'change_location'.tr(),
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.white),
        ),
      ),
    );
  }
}
