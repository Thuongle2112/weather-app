class WeatherIconMapper {
  static Map<String, String> _descriptionToIcon = {
    'clear sky': '3D Ico_01.svg',
    'few clouds': '3D Ico_01.svg',
    'scattered clouds': '3D Ico_01.svg',
    'broken clouds': '3D Ico_04.svg',
    'overcast clouds': '3D Ico_13.svg',

    'light rain': '3D Ico_07.svg',
    'moderate rain': '3D Ico_07.svg',
    'heavy rain': '3D Ico_17.svg',
    'rain': '3D Ico_17.svg',
    'shower rain': '3D Ico_17.svg',

    'thunderstorm': '3D Ico_13.svg',
    'thunderstorm with rain': '3D Ico_13.svg',
    'thunderstorm with heavy rain': '3D Ico_13.svg',

    'light snow': '3D Ico_20.svg',
    'snow': '3D Ico_05.svg',
    'heavy snow': '3D Ico_05.svg',
    'sleet': '3D Ico_27.svg',

    'mist': '3D Ico_32.svg',
    'fog': '3D Ico_32.svg',
    'haze': '3D Ico_32.svg',

    'bầu trời quang đãng': '3D Ico_01.svg',
    'mây thưa': '3D Ico_01.svg',
    'mây rải rác': '3D Ico_01.svg',
    'mây cụm': '3D Ico_04.svg',
    'mây đen u ám': '3D Ico_13.svg',
    'mưa nhẹ': '3D Ico_07.svg',
    'mưa vừa': '3D Ico_07.svg',
    'mưa nặng hạt': '3D Ico_17.svg',
    'mưa rào': '3D Ico_17.svg',
    'mưa': '3D Ico_17.svg',
    'giông bão': '3D Ico_13.svg',
    'giông bão có mưa': '3D Ico_13.svg',
    'giông bão với mưa lớn': '3D Ico_13.svg',
    'tuyết nhẹ': '3D Ico_20.svg',
    'tuyết': '3D Ico_05.svg',
    'tuyết dày': '3D Ico_05.svg',
    'mưa tuyết': '3D Ico_27.svg',
    'sương mù': '3D Ico_32.svg',
    'sương': '3D Ico_32.svg',
    'sương khói': '3D Ico_32.svg',
  };

  static String getIconByDescription(String description) {
    final lowercaseDesc = description.toLowerCase();

    return _descriptionToIcon[lowercaseDesc] ??
        getIconByCondition(lowercaseDesc);
  }

  static String getIconByCondition(String description) {
    if (description.contains('thunder')) {
      return '3D Ico_13.svg';
    } else if (description.contains('drizzle')) {
      return '3D Ico_17.svg';
    } else if (description.contains('rain')) {
      return '3D Ico_07.svg';
    } else if (description.contains('snow')) {
      return '3D Ico_27.svg';
    } else if (description.contains('clear')) {
      return '3D Ico_01.svg';
    } else if (description.contains('cloud')) {
      return '3D Ico_04.svg';
    } else if (description.contains('mist') ||
        description.contains('fog') ||
        description.contains('haze')) {
      return '3D Ico_32.svg';
    }

    return '3D Ico_35.svg';
  }
}
