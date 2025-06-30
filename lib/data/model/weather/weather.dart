class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String language;
  final double? windSpeed;
  final int? humidity;
  final int? rainChance;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.language,
    this.windSpeed,
    this.humidity,
    this.rainChance,
  });
}
