class UVIndex {
  final double lat;
  final double lon;
  final DateTime dateIso;
  final double value;

  UVIndex({
    required this.lat,
    required this.lon,
    required this.dateIso,
    required this.value,
  });

  factory UVIndex.fromJson(Map<String, dynamic> json) {
    return UVIndex(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      dateIso: DateTime.fromMillisecondsSinceEpoch(
        (json['date'] as int) * 1000,
        isUtc: true,
      ),
      value: (json['value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
      'date': dateIso.millisecondsSinceEpoch ~/ 1000,
      'value': value,
    };
  }

  String getLevel() {
    if (value <= 2) return 'Low';
    if (value <= 5) return 'Moderate';
    if (value <= 7) return 'High';
    if (value <= 10) return 'Very High';
    return 'Extreme';
  }

  @override
  String toString() {
    return 'UVIndex(lat: $lat, lon: $lon, dateIso: $dateIso, value: $value, level: ${getLevel()})';
  }
}