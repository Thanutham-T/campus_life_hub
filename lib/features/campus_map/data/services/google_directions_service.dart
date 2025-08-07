import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleDirectionsService {
  static const String _apiKey = 'AIzaSyCY1ZdVt3W2qlTYOxmKmrbApG3n7pHvoW0';

  // Fetch directions from Google Directions API
  Future<DirectionsResult> fetchDirections(
    LatLng origin,
    LatLng destination, {
    String mode = 'walking',
  }) async {
    final url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=$mode'
        '&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
        final points = data['routes'][0]['overview_polyline']['points'];
        final duration = data['routes'][0]['legs'][0]['duration']['value']; // in seconds
        
        final routePoints = _decodePolyline(points);
        final travelTime = duration / 60.0; // convert to minutes
        
        return DirectionsResult(
          success: true,
          points: routePoints,
          travelTime: travelTime,
          mode: mode,
        );
      } else {
        // Directions API error - fall back to straight line
        return DirectionsResult(
          success: false,
          points: [origin, destination],
          travelTime: null,
          mode: mode,
        );
      }
    } catch (e) {
      // Error fetching directions - fall back to straight line
      return DirectionsResult(
        success: false,
        points: [origin, destination],
        travelTime: null,
        mode: mode,
      );
    }
  }

  // Decode polyline from Google Directions API
  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}

class DirectionsResult {
  final bool success;
  final List<LatLng> points;
  final double? travelTime;
  final String mode;

  DirectionsResult({
    required this.success,
    required this.points,
    this.travelTime,
    required this.mode,
  });
}
