class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String language;
  final double? windSpeed;
  final int? humidity;
  final int? rainChance;
  final double latitude;
  final double longitude;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.language,
    this.windSpeed,
    this.humidity,
    this.rainChance,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'description': description,
      'language': language,
      'windSpeed': windSpeed,
      'humidity': humidity,
      'rainChance': rainChance,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['cityName'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      description: json['description'] as String,
      language: json['language'] as String,
      windSpeed: json['windSpeed'] != null ? (json['windSpeed'] as num).toDouble() : null,
      humidity: json['humidity'] as int?,
      rainChance: json['rainChance'] as int?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
