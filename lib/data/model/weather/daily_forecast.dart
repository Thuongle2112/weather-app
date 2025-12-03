class DailyForecast {
  final DateTime date;
  final double tempDay;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int? clouds;

  DailyForecast({
    required this.date,
    required this.tempDay,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    this.clouds,
  });
}