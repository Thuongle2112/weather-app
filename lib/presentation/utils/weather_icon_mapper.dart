class WeatherIconMapper {
  static const Map<String, String> _conditionToIcon = {
    'clear': 'clouds.svg',
    'sunny': 'sun.svg',

    'few_clouds': 'clouds.svg',
    'partly_cloudy': 'clouds.svg',
    'scattered_clouds': 'clouds.svg',
    'broken_clouds': 'clouds.svg',
    'overcast': 'clouds.svg',
    'cloudy': 'clouds.svg',

    'light_rain': 'rain.svg',
    'drizzle': 'rain.svg',
    'moderate_rain': 'rain.svg',
    'heavy_rain': 'rain.svg',
    'rain': 'rain.svg',
    'shower': 'rain.svg',

    'thunderstorm': 'lightning.svg',
    'thunder': 'lightning.svg',
    'lightning': 'lightning.svg',

    'light_snow': 'clouds-snow.svg',
    'snow': 'clouds-snow.svg',
    'heavy_snow': 'clouds-snow.svg',
    'blizzard': 'clouds-snow.svg',
    'sleet': 'clouds-snow.svg',

    'mist': 'clouds.svg',
    'fog': 'clouds.svg',
    'haze': 'clouds.svg',
    'smoke': 'clouds.svg',
    'dust': 'clouds.svg',
    'sand': 'clouds.svg',

    'tornado': 'lightning.svg',
    'squall': 'lightning.svg',
    'ash': 'clouds.svg',
  };

  static const Map<String, String> _descriptionToCondition = {
    'clear sky': 'clear',
    'few clouds': 'few_clouds',
    'scattered clouds': 'scattered_clouds',
    'broken clouds': 'broken_clouds',
    'overcast clouds': 'overcast',
    'light rain': 'light_rain',
    'moderate rain': 'moderate_rain',
    'heavy rain': 'heavy_rain',
    'rain': 'rain',
    'shower rain': 'shower',
    'drizzle': 'drizzle',
    'thunderstorm': 'thunderstorm',
    'thunderstorm with rain': 'thunderstorm',
    'thunderstorm with heavy rain': 'thunderstorm',
    'light snow': 'light_snow',
    'snow': 'snow',
    'heavy snow': 'heavy_snow',
    'sleet': 'sleet',
    'mist': 'mist',
    'fog': 'fog',
    'haze': 'haze',
    'smoke': 'smoke',
    'dust': 'dust',
    'sand': 'sand',
    'tornado': 'tornado',

    'trời quang đãng': 'clear',
    'bầu trời quang đãng': 'clear',
    'ít mây': 'few_clouds',
    'mây thưa': 'few_clouds',
    'mây rải rác': 'scattered_clouds',
    'nhiều mây': 'broken_clouds',
    'mây cụm': 'broken_clouds',
    'mây u ám': 'overcast',
    'mây đen u ám': 'overcast',
    'mưa nhỏ': 'light_rain',
    'mưa nhẹ': 'light_rain',
    'mưa vừa': 'moderate_rain',
    'mưa to': 'heavy_rain',
    'mưa nặng hạt': 'heavy_rain',
    'mưa': 'rain',
    'mưa rào': 'shower',
    'mưa phùn': 'drizzle',
    'dông bão': 'thunderstorm',
    'giông bão': 'thunderstorm',
    'giông bão có mưa': 'thunderstorm',
    'giông bão với mưa lớn': 'thunderstorm',
    'tuyết nhỏ': 'light_snow',
    'tuyết nhẹ': 'light_snow',
    'tuyết': 'snow',
    'tuyết lớn': 'heavy_snow',
    'tuyết dày': 'heavy_snow',
    'mưa tuyết': 'sleet',
    'sương mù nhẹ': 'mist',
    'sương mù': 'fog',
    'sương': 'mist',
    'sương khói': 'haze',
    'khói': 'smoke',
    'bụi': 'dust',
    'cát': 'sand',
    'lốc xoáy': 'tornado',

    '晴天': 'clear',
    '晴れ時々曇り': 'few_clouds',
    '薄曇り': 'scattered_clouds',
    '曇り': 'broken_clouds',
    'どんより曇り': 'overcast',
    '小雨': 'light_rain',
    '雨': 'rain',
    '大雨': 'heavy_rain',
    'にわか雨': 'shower',
    '霧雨': 'drizzle',
    '雷雨': 'thunderstorm',
    '小雪': 'light_snow',
    '雪': 'snow',
    '大雪': 'heavy_snow',
    'みぞれ': 'sleet',
    '薄霧': 'mist',
    '霧': 'fog',
    'もや': 'haze',
    '煙': 'smoke',
    '砂塵': 'dust',
    '砂': 'sand',
    '竜巻': 'tornado',

    '맑음': 'clear',
    '구름 조금': 'few_clouds',
    '구름 많음': 'scattered_clouds',
    '흐림': 'broken_clouds',
    '매우 흐림': 'overcast',
    '가벼운 비': 'light_rain',
    '보통 비': 'moderate_rain',
    '비': 'rain',
    '폭우': 'heavy_rain',
    '소나기': 'shower',
    '이슬비': 'drizzle',
    '뇌우': 'thunderstorm',
    '가벼운 눈': 'light_snow',
    '눈': 'snow',
    '폭설': 'heavy_snow',
    '진눈깨비': 'sleet',
    '안개': 'mist',
    '짙은 안개': 'fog',
    '실안개': 'haze',
    '연기': 'smoke',
    '먼지': 'dust',
    '모래': 'sand',
    '토네이도': 'tornado',

    '晴空': 'clear',
    '少云': 'few_clouds',
    '多云': 'scattered_clouds',
    '阴天': 'broken_clouds',
    '阴沉': 'overcast',
    '中雨': 'moderate_rain',
    '阵雨': 'shower',
    '毛毛雨': 'drizzle',
    '雷暴': 'thunderstorm',
    '雨夹雪': 'sleet',
    '薄雾': 'mist',
    '雾': 'fog',
    '霾': 'haze',
    '烟': 'smoke',
    '尘': 'dust',
    '沙': 'sand',
    '龙卷风': 'tornado',

    'ท้องฟ้าแจ่มใส': 'clear',
    'เมฆบางส่วน': 'few_clouds',
    'เมฆกระจาย': 'scattered_clouds',
    'เมฆมาก': 'broken_clouds',
    'ครึ้มมาก': 'overcast',
    'ฝนเล็กน้อย': 'light_rain',
    'ฝนปานกลาง': 'moderate_rain',
    'ฝน': 'rain',
    'ฝนหนัก': 'heavy_rain',
    'ฝนตกปรอย': 'shower',
    'ฝนฟ้าคะนอง': 'thunderstorm',
    'พายุฝนฟ้าคะนอง': 'thunderstorm',
    'หิมะเล็กน้อย': 'light_snow',
    'หิมะ': 'snow',
    'หิมะหนัก': 'heavy_snow',
    'ลูกเห็บ': 'sleet',
    'หมอกบาง': 'mist',
    'หมอก': 'fog',
    'ฝุ่นหมอก': 'haze',
    'ควัน': 'smoke',
    'ฝุ่น': 'dust',
    'ทราย': 'sand',
    'พายุทอร์นาโด': 'tornado',

    'ciel dégagé': 'clear',
    'quelques nuages': 'few_clouds',
    'nuages épars': 'scattered_clouds',
    'nuageux': 'broken_clouds',
    'couvert': 'overcast',
    'pluie légère': 'light_rain',
    'pluie modérée': 'moderate_rain',
    'pluie': 'rain',
    'forte pluie': 'heavy_rain',
    'averses': 'shower',
    'bruine': 'drizzle',
    'orage': 'thunderstorm',
    'neige légère': 'light_snow',
    'neige': 'snow',
    'forte neige': 'heavy_snow',
    'grésil': 'sleet',
    'brume': 'mist',
    'brouillard': 'fog',
    'brume sèche': 'haze',
    'fumée': 'smoke',
    'poussière': 'dust',
    'sable': 'sand',
    'tornade': 'tornado',

    'klarer himmel': 'clear',
    'wenige wolken': 'few_clouds',
    'vereinzelte wolken': 'scattered_clouds',
    'bewölkt': 'broken_clouds',
    'bedeckt': 'overcast',
    'leichter regen': 'light_rain',
    'mäßiger regen': 'moderate_rain',
    'regen': 'rain',
    'starker regen': 'heavy_rain',
    'regenschauer': 'shower',
    'nieselregen': 'drizzle',
    'gewitter': 'thunderstorm',
    'leichter schneefall': 'light_snow',
    'schnee': 'snow',
    'starker schneefall': 'heavy_snow',
    'schneeregen': 'sleet',
    'dunst': 'mist',
    'nebel': 'fog',
    'trübung': 'haze',
    'rauch': 'smoke',
    'staub': 'dust',

    'cielo despejado': 'clear',
    'pocas nubes': 'few_clouds',
    'nubes dispersas': 'scattered_clouds',
    'nublado': 'broken_clouds',
    'cubierto': 'overcast',
    'lluvia ligera': 'light_rain',
    'lluvia moderada': 'moderate_rain',
    'lluvia': 'rain',
    'lluvia intensa': 'heavy_rain',
    'chubascos': 'shower',
    'llovizna': 'drizzle',
    'tormenta': 'thunderstorm',
    'nieve ligera': 'light_snow',
    'nieve': 'snow',
    'nevada intensa': 'heavy_snow',
    'aguanieve': 'sleet',
    'neblina': 'mist',
    'niebla': 'fog',
    'calina': 'haze',
    'humo': 'smoke',
    'polvo': 'dust',
    'arena': 'sand',
  };

  static String getIconByDescription(String description) {
    final lowercaseDesc = description.toLowerCase().trim();

    final condition = _descriptionToCondition[lowercaseDesc];
    if (condition != null) {
      return _conditionToIcon[condition] ?? _getDefaultIcon();
    }

    return _getIconByKeywords(lowercaseDesc);
  }

  static String _getIconByKeywords(String description) {
    if (_containsAny(description, [
      'thunder',
      'lightning',
      'dông',
      'giông',
      '雷',
      '뇌',
      '雷暴',
      'ฟ้าคะนอง',
      'orage',
      'gewitter',
      'tormenta',
    ])) {
      return _conditionToIcon['thunderstorm']!;
    }

    if (_containsAny(description, [
      'heavy rain',
      'mưa to',
      'mưa nặng',
      '大雨',
      '폭우',
      'forte pluie',
      'starker regen',
      'lluvia intensa',
      'ฝนหนัก',
    ])) {
      return _conditionToIcon['heavy_rain']!;
    }

    if (_containsAny(description, [
      'light rain',
      'drizzle',
      'mưa nhỏ',
      'mưa phùn',
      '小雨',
      '霧雨',
      '가벼운 비',
      '이슬비',
      'pluie légère',
      'bruine',
      'leichter regen',
      'nieselregen',
      'lluvia ligera',
      'llovizna',
      'ฝนเล็กน้อย',
    ])) {
      return _conditionToIcon['light_rain']!;
    }

    if (_containsAny(description, [
      'rain',
      'shower',
      'mưa',
      '雨',
      '비',
      'pluie',
      'averses',
      'regen',
      'regenschauer',
      'lluvia',
      'chubascos',
      'ฝน',
    ])) {
      return _conditionToIcon['rain']!;
    }

    if (_containsAny(description, [
      'snow',
      'tuyết',
      '雪',
      '눈',
      'neige',
      'schnee',
      'nieve',
      'หิมะ',
    ])) {
      if (_containsAny(description, [
        'light',
        'nhỏ',
        'nhẹ',
        '小',
        '가벼운',
        'légère',
        'leichter',
        'ligera',
        'เล็กน้อย',
      ])) {
        return _conditionToIcon['light_snow']!;
      } else if (_containsAny(description, [
        'heavy',
        'lớn',
        'dày',
        '大',
        '폭',
        'forte',
        'starker',
        'intensa',
        'หนัก',
      ])) {
        return _conditionToIcon['heavy_snow']!;
      }
      return _conditionToIcon['snow']!;
    }

    if (_containsAny(description, [
      'sleet',
      'mưa tuyết',
      'みぞれ',
      '진눈깨비',
      '雨夹雪',
      'ลูกเห็บ',
      'grésil',
      'schneeregen',
      'aguanieve',
    ])) {
      return _conditionToIcon['sleet']!;
    }

    if (_containsAny(description, [
      'clear',
      'sunny',
      'quang',
      '晴',
      '맑',
      'dégagé',
      'klar',
      'despejado',
      'แจ่มใส',
    ])) {
      return _conditionToIcon['clear']!;
    }

    if (_containsAny(description, [
      'overcast',
      'u ám',
      'どんより',
      '阴沉',
      '매우 흐림',
      'ครึ้มมาก',
      'couvert',
      'bedeckt',
      'cubierto',
    ])) {
      return _conditionToIcon['overcast']!;
    }

    if (_containsAny(description, [
      'cloud',
      'mây',
      '雲',
      '구름',
      '云',
      'เมฆ',
      'nuage',
      'wolke',
      'nube',
    ])) {
      if (_containsAny(description, [
        'few',
        'ít',
        'thưa',
        'ばかり',
        '조금',
        '少',
        'บางส่วน',
        'quelques',
        'wenige',
        'pocas',
      ])) {
        return _conditionToIcon['few_clouds']!;
      } else if (_containsAny(description, [
        'scattered',
        'rải rác',
        '散',
        'กระจาย',
        'épars',
        'vereinzelte',
        'dispersas',
      ])) {
        return _conditionToIcon['scattered_clouds']!;
      } else if (_containsAny(description, [
        'broken',
        'nhiều',
        'cụm',
        '多',
        'มาก',
        'nuageux',
        'bewölkt',
        'nublado',
      ])) {
        return _conditionToIcon['broken_clouds']!;
      }
      return _conditionToIcon['cloudy']!;
    }

    if (_containsAny(description, [
      'fog',
      'mist',
      'haze',
      'sương',
      '霧',
      'もや',
      '안개',
      '雾',
      '霾',
      'หมอก',
      'ฝุ่นหมอก',
      'brume',
      'brouillard',
      'dunst',
      'nebel',
      'neblina',
      'niebla',
      'calina',
    ])) {
      return _conditionToIcon['fog']!;
    }

    if (_containsAny(description, [
      'smoke',
      'dust',
      'sand',
      'khói',
      'bụi',
      'cát',
      '煙',
      '砂塵',
      '연기',
      '먼지',
      '모래',
      '烟',
      '尘',
      '沙',
      'ควัน',
      'ฝุ่น',
      'ทราย',
      'fumée',
      'poussière',
      'rauch',
      'staub',
      'humo',
      'polvo',
      'arena',
    ])) {
      return _conditionToIcon['smoke']!;
    }

    if (_containsAny(description, [
      'tornado',
      'squall',
      'lốc xoáy',
      '竜巻',
      '토네이도',
      '龙卷风',
      'พายุทอร์นาโด',
      'tornade',
    ])) {
      return _conditionToIcon['tornado']!;
    }

    return _getDefaultIcon();
  }

  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword.toLowerCase()));
  }

  static String _getDefaultIcon() {
    return 'clouds.svg';
  }
}
