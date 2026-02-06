class SelectedLocation {
  final double latitude;
  final double longitude;
  final String displayName;

  SelectedLocation({
    required this.latitude,
    required this.longitude,
    required this.displayName,
  });

  @override
  String toString() => 'SelectedLocation(lat: $latitude, lng: $longitude, name: $displayName)';
}
