import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/constants/app_colors.dart';
import 'dart:math' as math;

class CampusMapPage extends StatefulWidget {
  const CampusMapPage({super.key});

  @override
  State<CampusMapPage> createState() => _CampusMapPageState();
}

class _CampusMapPageState extends State<CampusMapPage> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  Position? _currentPosition;
  bool _isLocationEnabled = false;
  Set<Polyline> _polylines = {}; // For navigation route

  // Prince of Songkla University coordinates
  static const LatLng _universityCenter = LatLng(7.0077, 100.4969);

  // Real places data from Google Places API
  Map<String, Map<String, dynamic>> _campusLocations = {};

  Set<Marker> _tempMarkers = {}; // For temporary location markers
  List<String> _searchResults = [];
  bool _showSearchResults = false;
  String? _selectedLocationName;
  Map<String, dynamic>? _selectedLocationData;
  double? _drivingTime;
  double? _walkingTime;
  bool _isNavigationMode = false; // เพิ่ม state สำหรับโหมดนำทาง

  // Google Maps API Key
  static const String _apiKey = 'AIzaSyCY1ZdVt3W2qlTYOxmKmrbApG3n7pHvoW0';

  @override
  void initState() {
    super.initState();
    _loadNearbyPlaces();
    _requestLocationPermission();
  }

  // Load nearby places using Google Places API  
  Future<void> _loadNearbyPlaces() async {
    try {
      // Load places in multiple categories for better coverage
      final List<String> placeTypes = [
        'restaurant', 'school', 'hospital', 'bank', 'pharmacy', 
        'gas_station', 'shopping_mall', 'park', 'tourist_attraction'
      ];
      
      Map<String, Map<String, dynamic>> allPlaces = {};
      
      // Fetch general nearby places first
      final generalPlaces = await _fetchNearbyPlaces(_universityCenter, 2000);
      allPlaces.addAll(generalPlaces);
      
      // Fetch specific types to ensure coverage
      for (String type in placeTypes) {
        try {
          final typePlaces = await _fetchPlacesByType(_universityCenter, 1500, type);
          allPlaces.addAll(typePlaces);
          await Future.delayed(const Duration(milliseconds: 500)); // Avoid rate limiting
        } catch (e) {
          // Continue with other types if one fails
        }
      }
      
      setState(() {
        _campusLocations = allPlaces;
        // Don't create markers - we'll use tap to show places
      });
    } catch (e) {
      // If Places API fails, keep empty map
    }
  }

  // Fetch places by specific type
  Future<Map<String, Map<String, dynamic>>> _fetchPlacesByType(LatLng center, int radius, String type) async {
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
        final Map<String, Map<String, dynamic>> places = {};
        
        for (var place in data['results']) {
          final name = place['name'] ?? 'ไม่ทราบชื่อ';
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];
          final types = List<String>.from(place['types'] ?? []);
          final rating = place['rating']?.toDouble();
          final isOpen = place['opening_hours']?['open_now'];
          
          places[name] = {
            'position': LatLng(lat, lng),
            'description': place['vicinity'] ?? 'ไม่มีข้อมูลที่อยู่',
            'type': _getPlaceType(types),
            'rating': rating,
            'priceLevel': place['price_level'],
            'isOpen': isOpen,
            'placeId': place['place_id'],
            'photos': place['photos'],
            'types': types,
          };
        }
        
        return places;
      }
    } catch (e) {
      // Error fetching places by type
    }
    
    return {};
  }

  // Fetch nearby places from Google Places API
  Future<Map<String, Map<String, dynamic>>> _fetchNearbyPlaces(LatLng center, int radius) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${center.latitude},${center.longitude}'
        '&radius=$radius'
        '&key=$_apiKey'
        '&language=th';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final Map<String, Map<String, dynamic>> places = {};
        
        for (var place in data['results']) {
          final name = place['name'] ?? 'ไม่ทราบชื่อ';
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];
          final types = List<String>.from(place['types'] ?? []);
          final rating = place['rating']?.toDouble();
          final isOpen = place['opening_hours']?['open_now'];
          
          // Skip if already exists or if it's a generic location type
          if (places.containsKey(name)) continue;
          
          places[name] = {
            'position': LatLng(lat, lng),
            'description': place['vicinity'] ?? 'ไม่มีข้อมูลที่อยู่',
            'type': _getPlaceType(types),
            'rating': rating,
            'priceLevel': place['price_level'],
            'isOpen': isOpen,
            'placeId': place['place_id'],
            'photos': place['photos'],
            'types': types,
          };
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
    
    return {};
  }

  // Fetch next page of places
  Future<Map<String, Map<String, dynamic>>> _fetchNextPagePlaces(String pageToken) async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?pagetoken=$pageToken'
        '&key=$_apiKey'
        '&language=th';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final Map<String, Map<String, dynamic>> places = {};
        
        for (var place in data['results']) {
          final name = place['name'] ?? 'ไม่ทราบชื่อ';
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];
          final types = List<String>.from(place['types'] ?? []);
          final rating = place['rating']?.toDouble();
          final isOpen = place['opening_hours']?['open_now'];
          
          places[name] = {
            'position': LatLng(lat, lng),
            'description': place['vicinity'] ?? 'ไม่มีข้อมูลที่อยู่',
            'type': _getPlaceType(types),
            'rating': rating,
            'priceLevel': place['price_level'],
            'isOpen': isOpen,
            'placeId': place['place_id'],
            'photos': place['photos'],
            'types': types,
          };
        }
        
        return places;
      }
    } catch (e) {
      // Error fetching places
    }
    
    return {};
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

  // Get detailed place information
  Future<Map<String, dynamic>?> _getPlaceDetails(String placeId) async {
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
        return {
          'name': result['name'],
          'address': result['formatted_address'],
          'phone': result['formatted_phone_number'],
          'website': result['website'],
          'rating': result['rating']?.toDouble(),
          'openingHours': result['opening_hours']?['weekday_text'],
          'isOpenNow': result['opening_hours']?['open_now'],
          'reviews': result['reviews'],
          'photos': result['photos'],
        };
      }
    } catch (e) {
      // Error fetching place details
    }
    
    return null;
  }

  // ฟังก์ชันเรียก Google Directions API
  Future<List<LatLng>> _fetchDirections(LatLng origin, LatLng destination, {String mode = 'walking'}) async {
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
        
        // Store travel times
        if (mode == 'driving') {
          _drivingTime = duration / 60.0; // convert to minutes
        } else if (mode == 'walking') {
          _walkingTime = duration / 60.0; // convert to minutes
        }
        
        return _decodePolyline(points);
      } else {
        // Directions API error - fall back to straight line
        return [origin, destination]; // Fall back to straight line
      }
    } catch (e) {
      // Error fetching directions - fall back to straight line
      return [origin, destination]; // Fall back to straight line
    }
  }

  // ฟังก์ชันถอดรหัส polyline จาก Google Directions API
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

  void _selectLocation(String name, Map<String, dynamic> locationData) async {
    // Create marker for selected location
    final selectedMarker = Marker(
      markerId: MarkerId('selected_$name'),
      position: locationData['position'],
      infoWindow: InfoWindow(
        title: name,
        snippet: locationData['description'],
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _selectedLocationName = name;
      _selectedLocationData = locationData;
      _drivingTime = null;
      _walkingTime = null;
      _tempMarkers = {selectedMarker}; // Show selected location marker
    });

    // Fetch detailed place information if placeId is available
    if (locationData['placeId'] != null) {
      final details = await _getPlaceDetails(locationData['placeId']);
      if (details != null) {
        setState(() {
          _selectedLocationData = {
            ..._selectedLocationData!,
            ...details,
          };
        });
      }
    }

    // Fetch travel times if current position is available
    if (_currentPosition != null) {
      final origin = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      final destination = locationData['position'];
      
      // Fetch both driving and walking times
      await _fetchDirections(origin, destination, mode: 'driving');
      await _fetchDirections(origin, destination, mode: 'walking');
      
      setState(() {}); // Update UI with travel times
    }
  }

  // ฟังก์ชันตรวจสอบสถานะเปิด-ปิด
  String _getOperatingStatus(dynamic openingHours) {
    if (openingHours == null) return 'ไม่มีข้อมูลเวลาทำการ';
    
    // If it's from Google Places API (isOpen field)
    if (_selectedLocationData?['isOpenNow'] != null) {
      return _selectedLocationData!['isOpenNow'] ? 'เปิดบริการ' : 'ปิดบริการ';
    }

    // If it's a string (legacy format)
    if (openingHours is String) {
      if (openingHours == '24 ชั่วโมง') return 'เปิดบริการ';
      
      final now = DateTime.now();
      final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      
      if (openingHours.contains(' - ')) {
        final times = openingHours.split(' - ');
        if (times.length == 2) {
          final openTime = times[0];
          final closeTime = times[1];
          
          if (currentTime.compareTo(openTime) >= 0 && currentTime.compareTo(closeTime) <= 0) {
            return 'เปิดบริการ';
          } else {
            return 'ปิดบริการ';
          }
        }
      }
    }
    
    return 'ไม่มีข้อมูลเวลาทำการ';
  }

  void _makePhoneCall(String? phoneNumber) {
    if (phoneNumber != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('เบอร์โทรศัพท์'),
          content: Text(phoneNumber),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ปิด'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่มีข้อมูลเบอร์โทรศัพท์'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showContactOptions(Map<String, dynamic> locationData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7, // จำกัดความสูงไม่เกิน 70% ของหน้าจอ
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ติดต่อ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Phone
                if (locationData['phone'] != null)
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.green),
                    title: Text(
                      locationData['phone'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: const Text('เบอร์โทรศัพท์'),
                    onTap: () => _makePhoneCall(locationData['phone']),
                  ),
                
                // Website
                if (locationData['website'] != null)
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.orange),
                    title: Text(
                      locationData['website'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: const Text('เว็บไซต์'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Website: ${locationData['website']}')),
                      );
                    },
                  ),
                
                // Address
                if (locationData['address'] != null)
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.red),
                    title: Text(
                      locationData['address'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    subtitle: const Text('ที่อยู่'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('ที่อยู่: ${locationData['address']}')),
                      );
                    },
                  ),
                
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('ปิด'),
                  ),
                ),
                // เพิ่ม padding ด้านล่างเพื่อให้มีพื้นที่เพียงพอสำหรับปุ่ม
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToLocation(LatLng destination) {
    if (_currentPosition != null) {
      setState(() {
        _isNavigationMode = true; // เปลี่ยนเป็นโหมดนำทาง
      });
      _createRoute(_currentPosition!, destination);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่สามารถระบุตำแหน่งปัจจุบันได้'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _createRoute(Position currentPos, LatLng destination) async {
    try {
      // เรียก Directions API เพื่อได้เส้นทางจริง
      final routePoints = await _fetchDirections(
        LatLng(currentPos.latitude, currentPos.longitude),
        destination,
      );

      final polyline = Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: AppColors.primary,
        width: 4,
      );

      setState(() {
        _polylines = {polyline};
      });

      // ปรับกล้องให้เห็นเส้นทางทั้งหมด
      if (routePoints.isNotEmpty) {
        double minLat = routePoints.map((p) => p.latitude).reduce(math.min);
        double maxLat = routePoints.map((p) => p.latitude).reduce(math.max);
        double minLng = routePoints.map((p) => p.longitude).reduce(math.min);
        double maxLng = routePoints.map((p) => p.longitude).reduce(math.max);

        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(minLat, minLng),
              northeast: LatLng(maxLat, maxLng),
            ),
            100.0, // padding
          ),
        );
      }
    } catch (e) {
      // Error creating route - use straight line instead
      final polyline = Polyline(
        polylineId: const PolylineId('route'),
        points: [
          LatLng(currentPos.latitude, currentPos.longitude),
          destination,
        ],
        color: AppColors.primary,
        width: 4,
      );

      setState(() {
        _polylines = {polyline};
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่สามารถหาเส้นทางได้ แสดงเส้นตรงแทน'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _goToLocation(LatLng location) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 18.0),
    );
  }

  void _searchLocation(String query) {
    if (query.isEmpty) {
      setState(() {
        _showSearchResults = false;
        _searchResults = [];
      });
      return;
    }

    final results = _campusLocations.keys
        .where((location) {
          final locationData = _campusLocations[location]!;
          final locationName = location.toLowerCase();
          final description = locationData['description'].toString().toLowerCase();
          final type = locationData['type'].toString().toLowerCase();
          final queryLower = query.toLowerCase();
          
          return locationName.contains(queryLower) || 
                 description.contains(queryLower) ||
                 type.contains(queryLower);
        })
        .toList();

    // Sort by distance if current position is available
    if (_currentPosition != null) {
      results.sort((a, b) {
        final posA = _campusLocations[a]!['position'] as LatLng;
        final posB = _campusLocations[b]!['position'] as LatLng;
        
        final distA = _calculateDistance(
          _currentPosition!.latitude, _currentPosition!.longitude,
          posA.latitude, posA.longitude,
        );
        final distB = _calculateDistance(
          _currentPosition!.latitude, _currentPosition!.longitude,
          posB.latitude, posB.longitude,
        );
        return distA.compareTo(distB);
      });
    }

    setState(() {
      _searchResults = results;
      _showSearchResults = true;
    });
  }

  // Calculate distance between two points
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final double dLat = (lat2 - lat1) * (math.pi / 180);
    final double dLon = (lon2 - lon1) * (math.pi / 180);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * (math.pi / 180)) * math.cos(lat2 * (math.pi / 180)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  Future<void> _requestLocationPermission() async {
    try {
      final permission = await Permission.location.request();
      if (permission.isGranted) {
        await _getCurrentLocation();
      }
    } catch (e) {
      // Error requesting permission - location features will be disabled
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _isLocationEnabled = true;
      });
    } catch (e) {
      // Error getting location - location features will be disabled
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  // Handle map tap to search for nearby places
  void _onMapTap(LatLng location) async {
    // Search for places near the tapped location
    final nearbyPlaces = await _fetchNearbyPlaces(location, 500); // 500m radius
    
    if (nearbyPlaces.isNotEmpty) {
      // Find the closest place to the tapped location
      String? closestPlace;
      double minDistance = double.infinity;
      
      for (var entry in nearbyPlaces.entries) {
        final placeLocation = entry.value['position'] as LatLng;
        final distance = _calculateDistance(
          location.latitude, location.longitude,
          placeLocation.latitude, placeLocation.longitude,
        );
        
        if (distance < minDistance) {
          minDistance = distance;
          closestPlace = entry.key;
        }
      }
      
      if (closestPlace != null && minDistance < 0.1) { // Within 100m
        _selectLocation(closestPlace, nearbyPlaces[closestPlace]!);
      } else {
        // If no close place found, show a temporary marker
        _showTemporaryLocation(location);
      }
    } else {
      // No places found, show temporary location
      _showTemporaryLocation(location);
    }
  }

  // Show temporary location details when tapping empty area
  void _showTemporaryLocation(LatLng location) {
    // Add temporary marker with blue color to distinguish from selected locations
    final tempMarker = Marker(
      markerId: const MarkerId('temp_location'),
      position: location,
      infoWindow: const InfoWindow(
        title: 'ตำแหน่งที่เลือก',
        snippet: 'กดเพื่อดูรายละเอียด',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    setState(() {
      _tempMarkers = {tempMarker}; // Show only this marker
      _selectedLocationName = 'ตำแหน่งที่เลือก';
      _selectedLocationData = {
        'position': location,
        'description': 'ตำแหน่งที่คุณเลือกบนแผนที่',
        'type': 'location',
        'rating': null,
        'isOpen': null,
        'placeId': null,
      };
      _drivingTime = null;
      _walkingTime = null;
    });

    // Fetch travel times if current position is available
    if (_currentPosition != null) {
      final origin = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      
      // Fetch both driving and walking times
      _fetchDirections(origin, location, mode: 'driving');
      _fetchDirections(origin, location, mode: 'walking');
    }
  }

  void _goToCurrentLocation() async {
    if (_currentPosition != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          18.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Google Map
        GoogleMap(
          onMapCreated: _onMapCreated,
          onTap: _onMapTap,
          initialCameraPosition: const CameraPosition(
            target: _universityCenter,
            zoom: 16.0,
          ),
          markers: _tempMarkers, // Show only temporary markers
          polylines: _polylines,
            myLocationEnabled: _isLocationEnabled,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
          ),
          
          // Compass button (top right)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _selectedLocationName != null 
                ? MediaQuery.of(context).padding.top + 16 + 60 // ปรับให้สมดุลกับปุ่มล่าง
                : MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.navigation, color: Colors.black54),
                onPressed: () {
                  // Reset map orientation to north
                  _mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: _universityCenter,
                        zoom: 16.0,
                        bearing: 0.0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Current location button (top right, below compass)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _selectedLocationName != null 
                ? MediaQuery.of(context).padding.top + 72 + 60 // ลดระยะห่างลง
                : MediaQuery.of(context).padding.top + 72,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location, color: Colors.white),
                onPressed: _goToCurrentLocation,
              ),
            ),
          ),
          
          // Search bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _selectedLocationName != null 
                ? MediaQuery.of(context).padding.top + 16
                : null,
            bottom: _selectedLocationName != null 
                ? null
                : 20,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchLocation,
                    decoration: InputDecoration(
                      hintText: 'ค้นหาสถานที่...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                _searchLocation('');
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.mic, color: Colors.grey),
                              onPressed: () {
                                // Voice search functionality can be added here
                              },
                            ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                // Search Results
                if (_showSearchResults && _searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(
                      maxHeight: 300, // Limit height to prevent overflow
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length > 8 ? 8 : _searchResults.length, // Limit to 8 results
                      itemBuilder: (context, index) {
                        final location = _searchResults[index];
                        final locationData = _campusLocations[location]!;
                        return ListTile(
                          leading: Icon(
                            _getLocationIcon(locationData['type']),
                            color: AppColors.primary,
                          ),
                          title: Text(
                            location,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            locationData['description'],
                            style: TextStyle(color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          onTap: () {
                            setState(() {
                              _showSearchResults = false;
                            });
                            _searchController.text = location;
                            _goToLocation(locationData['position']);
                            _selectLocation(location, locationData);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          
          // Selected location details (bottom)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _selectedLocationName != null && _selectedLocationData != null ? 0 : -400,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // แสดงแบบย่อเมื่ออยู่ในโหมดนำทาง
                      if (_isNavigationMode) ...[
                        // แสดงเฉพาะข้อมูลพื้นฐานเมื่อนำทาง
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedLocationName ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Travel times
                                if (_drivingTime != null || _walkingTime != null) ...[
                                  if (_drivingTime != null)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.directions_car, size: 16, color: Colors.blue),
                                        const SizedBox(width: 2),
                                        Text('${_drivingTime!.round()} นาที', style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  const SizedBox(width: 8),
                                  if (_walkingTime != null)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.directions_walk, size: 16, color: Colors.green),
                                        const SizedBox(width: 2),
                                        Text('${_walkingTime!.round()} นาที', style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  const SizedBox(width: 8),
                                ],
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _selectedLocationName = null;
                                      _selectedLocationData = null;
                                      _drivingTime = null;
                                      _walkingTime = null;
                                      _tempMarkers = {}; // Clear all markers
                                      _polylines = {}; // Clear navigation route
                                      _isNavigationMode = false; // Reset navigation mode
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ] else ...[
                        // แสดงแบบเต็มเมื่อไม่ได้นำทาง (แบบเดิม)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedLocationName ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _selectedLocationName = null;
                                _selectedLocationData = null;
                                _drivingTime = null;
                                _walkingTime = null;
                                _tempMarkers = {}; // Clear all markers
                                _polylines = {}; // Clear navigation route
                                _isNavigationMode = false; // Reset navigation mode
                              });
                            },
                          ),
                        ],
                      ),
                      if (_selectedLocationData != null && !_isNavigationMode) ...[
                        Text(
                          _selectedLocationData!['description'],
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        
                        // Travel times
                        if (_drivingTime != null || _walkingTime != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Wrap(
                              spacing: 16,
                              children: [
                                if (_drivingTime != null)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.directions_car, size: 20, color: Colors.blue),
                                      const SizedBox(width: 4),
                                      Text('${_drivingTime!.round()} นาที'),
                                    ],
                                  ),
                                if (_walkingTime != null)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.directions_walk, size: 20, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Text('${_walkingTime!.round()} นาที'),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 8),
                        
                        // Operating hours, rating, and status
                        if (_selectedLocationData!['rating'] != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text('${_selectedLocationData!['rating']} ดาว'),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        
                        // Operating status and hours
                        if (_selectedLocationData!['openingHours'] != null || _selectedLocationData!['isOpenNow'] != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              if (_selectedLocationData!['openingHours'] is List)
                                Flexible(
                                  child: Text(
                                    _selectedLocationData!['openingHours'][0] ?? 'ไม่มีข้อมูล',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                )
                              else
                                Flexible(
                                  child: Text(
                                    _selectedLocationData!['openingHours']?.toString() ?? 'ไม่มีข้อมูล',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Text(
                                '(${_getOperatingStatus(_selectedLocationData!['openingHours'])})',
                                style: TextStyle(
                                  color: _getOperatingStatus(_selectedLocationData!['openingHours']) == 'เปิดบริการ' 
                                      ? Colors.green 
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                        
                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _navigateToLocation(_selectedLocationData!['position']),
                                icon: const Icon(Icons.directions, size: 18),
                                label: const Text(
                                  'นำทาง',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                ),
                                ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _goToLocation(_selectedLocationData!['position']),
                                icon: const Icon(Icons.zoom_in, size: 18),
                                label: const Text(
                                  'ดูตำแหน่ง',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _showContactOptions(_selectedLocationData!),
                              icon: const Icon(Icons.contact_phone, color: Colors.green),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.green.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ], // Close the main if-else condition
                    ], // Close the Column's children array
                  ),
                ),
              ),
            ),
          ),
        ], // Close the Stack's children array
      );
  }

  IconData _getLocationIcon(String type) {
    switch (type) {
      case 'library':
        return Icons.local_library;
      case 'restaurant':
        return Icons.restaurant;
      case 'sports':
        return Icons.sports_soccer;
      case 'admin':
        return Icons.business;
      case 'faculty':
        return Icons.school;
      case 'dormitory':
        return Icons.home;
      case 'parking':
        return Icons.local_parking;
      case 'hospital':
        return Icons.local_hospital;
      case 'bank':
        return Icons.account_balance;
      case 'park':
        return Icons.park;
      case 'convenience':
        return Icons.store;
      case 'gas_station':
        return Icons.local_gas_station;
      case 'pharmacy':
        return Icons.local_pharmacy;
      case 'shopping':
        return Icons.shopping_cart;
      case 'location':
        return Icons.place;
      case 'other':
        return Icons.place;
      default:
        return Icons.location_on;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

