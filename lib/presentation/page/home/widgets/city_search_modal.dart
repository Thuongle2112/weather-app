import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class CitySearchModal extends StatelessWidget {
  final TextEditingController cityController;
  final List<String> popularCities;
  final Function(String) onCitySelected;

  const CitySearchModal({
    super.key,
    required this.cityController,
    required this.popularCities,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final Map<String, List<String>> citiesByRegion = {
      'Vietnam': [
        'Hanoi',
        'Ho Chi Minh City',
        'Da Nang',
        'Hue',
        'Nha Trang',
        'Hai Phong',
        'Can Tho',
      ],
      'East Asia': [
        'Tokyo',
        'Seoul',
        'Beijing',
        'Shanghai',
        'Hong Kong',
        'Taipei',
      ],
      'Southeast Asia': [
        'Singapore',
        'Bangkok',
        'Kuala Lumpur',
        'Jakarta',
        'Manila',
        'Phnom Penh',
      ],
      'Europe': [
        'London',
        'Paris',
        'Berlin',
        'Rome',
        'Madrid',
        'Amsterdam',
        'Prague',
      ],
      'North America': [
        'New York',
        'Los Angeles',
        'Chicago',
        'Toronto',
        'Vancouver',
        'Mexico City',
      ],
      'Others': [
        'Sydney',
        'Dubai',
        'Cairo',
        'Istanbul',
        'Mumbai',
        'Rio de Janeiro',
      ],
    };

    return Container(
      height: 0.8.sh,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'search_city'.tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                hintText: 'enter_city'.tr(),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.white60 : null,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: isDarkMode ? Colors.grey[800] : null,
                filled: isDarkMode,
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  onCitySelected(value);
                  Navigator.pop(context);
                }
              },
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 24),
            Text(
              'popular_cities'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: citiesByRegion.length,
                itemBuilder: (context, index) {
                  String region = citiesByRegion.keys.elementAt(index);
                  List<String> cities = citiesByRegion[region]!;

                  return ExpansionTile(
                    title: Text(
                      region,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    children:
                        cities
                            .map(
                              (city) => ListTile(
                                leading: const Icon(Icons.location_city),
                                title: Text(
                                  city,
                                  style: TextStyle(
                                    color:
                                        isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  onCitySelected(city);
                                  Navigator.pop(context);
                                },
                              ),
                            )
                            .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
