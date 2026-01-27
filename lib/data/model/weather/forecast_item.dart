class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int? clouds;
  final double? rain;

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    this.clouds,
    this.rain,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    // Handle both API response format and cached format
    if (json.containsKey('dt')) {
      // API response format
      return ForecastItem(
        dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
        temperature: (json['main']['temp'] as num).toDouble(),
        tempMin: (json['main']['temp_min'] as num).toDouble(),
        tempMax: (json['main']['temp_max'] as num).toDouble(),
        description: json['weather'][0]['description'] as String,
        icon: json['weather'][0]['icon'] as String,
        humidity: json['main']['humidity'] as int,
        windSpeed: (json['wind']['speed'] as num).toDouble() * 3.6,
        clouds: json['clouds']?['all'] as int?,
        rain: json['rain']?['3h'] as double?,
      );
    } else {
      // Cached format
      return ForecastItem(
        dateTime: DateTime.parse(json['dateTime'] as String),
        temperature: (json['temperature'] as num).toDouble(),
        tempMin: (json['tempMin'] as num).toDouble(),
        tempMax: (json['tempMax'] as num).toDouble(),
        description: json['description'] as String,
        icon: json['icon'] as String,
        humidity: json['humidity'] as int,
        windSpeed: (json['windSpeed'] as num).toDouble(),
        clouds: json['clouds'] as int?,
        rain: json['rain'] as double?,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'temperature': temperature,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'description': description,
      'icon': icon,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'clouds': clouds,
      'rain': rain,
    };
  }
}