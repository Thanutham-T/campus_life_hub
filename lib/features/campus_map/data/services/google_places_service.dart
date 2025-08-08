import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/place_entity.dart';

class GooglePlacesService {
  static const String _apiKey = 'AIzaSyCY1ZdVt3W2qlTYOxmKmrbApG3n7pHvoW0';

  // Fetch places by specific type
  Future<List<PlaceEntity>> fetchPlacesByType(
    LatLng center,
    int radius,
    String type,
  ) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${center.latitude},${center.longitude}'
        '&radius=$radius'
        '&type=$type'
        '&key=$_apiKey'
        '&language=th';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final List<PlaceEntity> places = [];
        
        for (var place in data['results']) {
          final placeEntity = _mapPlaceToEntity(place);
          places.add(placeEntity);
        }
        
        return places;
      }
    } catch (e) {
      // Error fetching places by type
    }
    
    return [];
  }

  // Fetch nearby places from Google Places API
  Future<List<PlaceEntity>> fetchNearbyPlaces(LatLng center, int radius) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${center.latitude},${center.longitude}'
        '&radius=$radius'
        '&key=$_apiKey'
        '&language=th';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final List<PlaceEntity> places = [];
        
        for (var place in data['results']) {
          final placeEntity = _mapPlaceToEntity(place);
          places.add(placeEntity);
        }
        
        // If we have next_page_token, fetch more results
        if (data['next_page_token'] != null && places.length < 40) {
          await Future.delayed(const Duration(seconds: 2)); // Required delay
          final nextPagePlaces = await _fetchNextPagePlaces(data['next_page_token']);
          places.addAll(nextPagePlaces);
        }
        
        return places;
      }
    } catch (e) {
      // Error fetching places
    }
    
    return [];
  }

  // Fetch next page of places
  Future<List<PlaceEntity>> _fetchNextPagePlaces(String pageToken) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?pagetoken=$pageToken'
        '&key=$_apiKey'
        '&language=th';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final List<PlaceEntity> places = [];
        
        for (var place in data['results']) {
          final placeEntity = _mapPlaceToEntity(place);
          places.add(placeEntity);
        }
        
        return places;
      }
    } catch (e) {
      // Error fetching places
    }
    
    return [];
  }

  // Get detailed place information
  Future<PlaceEntity?> getPlaceDetails(String placeId) async {
    final url = 'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId'
        '&fields=name,formatted_address,formatted_phone_number,website,opening_hours,rating,reviews,photos'
        '&key=$_apiKey'
        '&language=th';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final result = data['result'];
        return PlaceEntity(
          name: result['name'] ?? '',
          position: const LatLng(0, 0), // Will be updated with existing data
          description: result['formatted_address'] ?? '',
          type: 'detail',
          types: [],
          address: result['formatted_address'],
          phone: result['formatted_phone_number'],
          website: result['website'],
          rating: result['rating']?.toDouble(),
          openingHours: result['opening_hours']?['weekday_text']?.cast<String>(),
          isOpenNow: result['opening_hours']?['open_now'],
        );
      }
    } catch (e) {
      // Error fetching place details
    }
    
    return null;
  }

  // Helper method to map API response to PlaceEntity
  PlaceEntity _mapPlaceToEntity(Map<String, dynamic> place) {
    final name = place['name'] ?? 'ไม่ทราบชื่อ';
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];
    final types = List<String>.from(place['types'] ?? []);
    final rating = place['rating']?.toDouble();
    final isOpen = place['opening_hours']?['open_now'];

    return PlaceEntity(
      name: name,
      position: LatLng(lat, lng),
      description: place['vicinity'] ?? 'ไม่มีข้อมูลที่อยู่',
      type: _getPlaceType(types),
      rating: rating,
      priceLevel: place['price_level'],
      isOpen: isOpen,
      placeId: place['place_id'],
      photos: place['photos'],
      types: types,
    );
  }

  // Convert Google Places types to our type system
  String _getPlaceType(List<String> types) {
    if (types.contains('restaurant') || types.contains('food') || types.contains('meal_takeaway')) return 'restaurant';
    if (types.contains('hospital') || types.contains('health')) return 'hospital';
    if (types.contains('school') || types.contains('university') || types.contains('educational_institution')) return 'faculty';
    if (types.contains('library')) return 'library';
    if (types.contains('bank') || types.contains('atm') || types.contains('finance')) return 'bank';
    if (types.contains('parking')) return 'parking';
    if (types.contains('park') || types.contains('campground')) return 'park';
    if (types.contains('convenience_store') || types.contains('store') || types.contains('supermarket')) return 'convenience';
    if (types.contains('lodging') || types.contains('tourist_attraction')) return 'dormitory';
    if (types.contains('gym') || types.contains('stadium')) return 'sports';
    if (types.contains('gas_station')) return 'gas_station';
    if (types.contains('pharmacy')) return 'pharmacy';
    if (types.contains('shopping_mall') || types.contains('department_store')) return 'shopping';
    return 'other';
  }
}
