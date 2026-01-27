import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class MapLocationService {
  static const String _locationIqApiKey = 'pk.28eeb40e74e9cbb71e80113c2cfc9cb6';
  
  static Future<Position?> getCurrentLocation() async {
    try {
      final permission = await Permission.locationWhenInUse.status;
      
      if (!permission.isGranted) {
        final result = await Permission.locationWhenInUse.request();
        if (!result.isGranted) return null;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<String> getPlaceNameFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        'https://us1.locationiq.com/v1/reverse'
        '?key=$_locationIqApiKey'
        '&lat=$latitude'
        '&lon=$longitude'
        '&format=json'
        '&accept-language=en',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];
        
        final parts = <String>[];
        
        if (address['city'] != null) {
          parts.add(address['city']);
        } else if (address['town'] != null) {
          parts.add(address['town']);
        } else if (address['village'] != null) {
          parts.add(address['village']);
        }
        
        if (address['state'] != null) {
          parts.add(address['state']);
        }
        
        if (address['country'] != null) {
          parts.add(address['country']);
        }

        return parts.isNotEmpty 
            ? parts.join(', ')
            : '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
      }
      
      return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    } catch (e) {
      return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    }
  }

  static Future<bool> checkLocationPermission() async {
    final permission = await Permission.locationWhenInUse.status;
    return permission.isGranted;
  }

  static Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  static Future<List<SearchResult>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];
    
    try {
      final url = Uri.parse(
        'https://us1.locationiq.com/v1/search'
        '?key=$_locationIqApiKey'
        '&q=${Uri.encodeComponent(query)}'
        '&format=json'
        '&limit=5',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => SearchResult(
          displayName: item['display_name'] ?? '',
          latitude: double.parse(item['lat']),
          longitude: double.parse(item['lon']),
        )).toList();
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }
}

class SearchResult {
  final String displayName;
  final double latitude;
  final double longitude;

  SearchResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });
}
