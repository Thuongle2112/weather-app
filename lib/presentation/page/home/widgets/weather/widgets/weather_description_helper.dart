import 'package:easy_localization/easy_localization.dart';

class WeatherDescriptionHelper {
  static const Map<String, String> _weatherKeys = {
    'clear sky': 'weather_clear_sky',
    'few clouds': 'weather_few_clouds',
    'scattered clouds': 'weather_scattered_clouds',
    'broken clouds': 'weather_broken_clouds',
    'overcast clouds': 'weather_overcast_clouds',
    'shower rain': 'weather_shower_rain',
    'rain': 'weather_rain',
    'light rain': 'weather_light_rain',
    'moderate rain': 'weather_moderate_rain',
    'heavy rain': 'weather_heavy_rain',
    'thunderstorm': 'weather_thunderstorm',
    'snow': 'weather_snow',
    'light snow': 'weather_light_snow',
    'heavy snow': 'weather_heavy_snow',
    'mist': 'weather_mist',
    'fog': 'weather_fog',
    'haze': 'weather_haze',
    'smoke': 'weather_smoke',
    'dust': 'weather_dust',
    'sand': 'weather_sand',
    'tornado': 'weather_tornado',
  };

  static String getLocalizedDescription(String description, String locale) {
    final desc = description.toLowerCase();

    for (var entry in _weatherKeys.entries) {
      if (desc.contains(entry.key)) {
        return entry.value.tr();
      }
    }

    return description;
  }
}