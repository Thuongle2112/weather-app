class AirPollution {
  final int aqi;
  final double pm2_5;
  final double pm10;
  final double co;
  final double no2;
  final double o3;
  final double so2;

  AirPollution({
    required this.aqi,
    required this.pm2_5,
    required this.pm10,
    required this.co,
    required this.no2,
    required this.o3,
    required this.so2,
  });

  factory AirPollution.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final components = json['components'];
    return AirPollution(
      aqi: main?['aqi'] ?? 0,
      pm2_5: (components?['pm2_5'] as num?)?.toDouble() ?? 0,
      pm10: (components?['pm10'] as num?)?.toDouble() ?? 0,
      co: (components?['co'] as num?)?.toDouble() ?? 0,
      no2: (components?['no2'] as num?)?.toDouble() ?? 0,
      o3: (components?['o3'] as num?)?.toDouble() ?? 0,
      so2: (components?['so2'] as num?)?.toDouble() ?? 0,
    );
  }
}
