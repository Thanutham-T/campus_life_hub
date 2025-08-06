import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/place_entity.dart';
import '../../data/services/google_places_service.dart';
import '../../data/services/google_directions_service.dart';
import '../../data/services/map_utils.dart';
import '../widgets/location_details_bottom_sheet_widget.dart';
import '../widgets/contact_options_modal_widget.dart';

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

  // Services
  final GooglePlacesService _placesService = GooglePlacesService();
  final GoogleDirectionsService _directionsService = GoogleDirectionsService();

  // Places data using PlaceEntity
  Map<String, PlaceEntity> _campusLocations = {};

  Set<Marker> _tempMarkers = {}; // For temporary location markers
  List<String> _searchResults = [];
  bool _showSearchResults = false;
  String? _selectedLocationName;
  PlaceEntity? _selectedLocationData;
  double? _drivingTime;
  double? _walkingTime;
  bool _isNavigationMode = false; // เพิ่ม state สำหรับโหมดนำทาง

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
      
      Map<String, PlaceEntity> allPlaces = {};
      
      // Fetch general nearby places first
      final generalPlaces = await _placesService.fetchNearbyPlaces(_universityCenter, 2000);
      allPlaces.addAll(_convertListToMap(generalPlaces));
      
      // Fetch specific types to ensure coverage
      for (String type in placeTypes) {
        try {
          final typePlaces = await _placesService.fetchPlacesByType(_universityCenter, 1500, type);
          allPlaces.addAll(_convertListToMap(typePlaces));
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

  // Helper method to convert List<PlaceEntity> to Map<String, PlaceEntity>
  Map<String, PlaceEntity> _convertListToMap(List<PlaceEntity> places) {
    final Map<String, PlaceEntity> placeMap = {};
    for (var place in places) {
      if (!placeMap.containsKey(place.name)) {
        placeMap[place.name] = place;
      }
    }
    return placeMap;
  }

  void _selectLocation(String name, PlaceEntity locationData) async {
    // Create marker for selected location
    final selectedMarker = Marker(
      markerId: MarkerId('selected_$name'),
      position: locationData.position,
      infoWindow: InfoWindow(
        title: name,
        snippet: locationData.description,
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
    if (locationData.placeId != null && locationData.placeId!.isNotEmpty) {
      final details = await _placesService.getPlaceDetails(locationData.placeId!);
      if (details != null) {
        setState(() {
          _selectedLocationData = locationData.copyWith(
            address: details.address,
            phone: details.phone,
            website: details.website,
            openingHours: details.openingHours,
            isOpenNow: details.isOpenNow,
          );
        });
      }
    }

    // Fetch travel times if current position is available
    if (_currentPosition != null) {
      final origin = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      final destination = locationData.position;
      
      // Fetch both driving and walking times
      final drivingResult = await _directionsService.fetchDirections(origin, destination, mode: 'driving');
      final walkingResult = await _directionsService.fetchDirections(origin, destination, mode: 'walking');
      
      setState(() {
        _drivingTime = drivingResult.travelTime;
        _walkingTime = walkingResult.travelTime;
      });
    }
  }



  void _showContactOptions(PlaceEntity place) {
    ContactOptionsModalWidget.show(context, place);
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
      final directionsResult = await _directionsService.fetchDirections(
        LatLng(currentPos.latitude, currentPos.longitude),
        destination,
      );

      final polyline = Polyline(
        polylineId: const PolylineId('route'),
        points: directionsResult.points,
        color: AppColors.primary,
        width: 4,
      );

      setState(() {
        _polylines = {polyline};
      });

      // ปรับกล้องให้เห็นเส้นทางทั้งหมด
      if (directionsResult.points.isNotEmpty) {
        double minLat = directionsResult.points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
        double maxLat = directionsResult.points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
        double minLng = directionsResult.points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
        double maxLng = directionsResult.points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

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
          final description = locationData.description.toLowerCase();
          final type = locationData.type.toLowerCase();
          final queryLower = query.toLowerCase();
          
          return locationName.contains(queryLower) || 
                 description.contains(queryLower) ||
                 type.contains(queryLower);
        })
        .toList();

    // Sort by distance if current position is available
    if (_currentPosition != null) {
      results.sort((a, b) {
        final posA = _campusLocations[a]!.position;
        final posB = _campusLocations[b]!.position;
        
        final distA = MapUtils.calculateDistance(
          _currentPosition!.latitude, _currentPosition!.longitude,
          posA.latitude, posA.longitude,
        );
        final distB = MapUtils.calculateDistance(
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
    final nearbyPlacesList = await _placesService.fetchNearbyPlaces(location, 500); // 500m radius
    final nearbyPlaces = _convertListToMap(nearbyPlacesList);
    
    if (nearbyPlaces.isNotEmpty) {
      // Find the closest place to the tapped location
      String? closestPlace;
      double minDistance = double.infinity;
      
      for (var entry in nearbyPlaces.entries) {
        final placeLocation = entry.value.position;
        final distance = MapUtils.calculateDistance(
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

    // Create temporary PlaceEntity for the selected location
    final tempPlace = PlaceEntity(
      name: 'ตำแหน่งที่เลือก',
      position: location,
      description: 'ตำแหน่งที่คุณเลือกบนแผนที่',
      type: 'location',
      types: ['location'],
    );

    setState(() {
      _tempMarkers = {tempMarker}; // Show only this marker
      _selectedLocationName = 'ตำแหน่งที่เลือก';
      _selectedLocationData = tempPlace;
      _drivingTime = null;
      _walkingTime = null;
    });

    // Fetch travel times if current position is available
    if (_currentPosition != null) {
      final origin = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      
      // Fetch both driving and walking times
      _directionsService.fetchDirections(origin, location, mode: 'driving').then((result) {
        setState(() {
          _drivingTime = result.travelTime;
        });
      });
      _directionsService.fetchDirections(origin, location, mode: 'walking').then((result) {
        setState(() {
          _walkingTime = result.travelTime;
        });
      });
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
                            MapUtils.getLocationIcon(locationData.type),
                            color: AppColors.primary,
                          ),
                          title: Text(
                            location,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            locationData.description,
                            style: TextStyle(color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          onTap: () {
                            setState(() {
                              _showSearchResults = false;
                            });
                            _searchController.text = location;
                            _goToLocation(locationData.position);
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
          if (_selectedLocationName != null && _selectedLocationData != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: 0,
              left: 0,
              right: 0,
              child: LocationDetailsBottomSheetWidget(
                place: _selectedLocationData!,
                placeName: _selectedLocationName!,
                isNavigationMode: _isNavigationMode,
                drivingTime: _drivingTime,
                walkingTime: _walkingTime,
                onClose: () {
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
                onNavigate: () => _navigateToLocation(_selectedLocationData!.position),
                onViewLocation: () => _goToLocation(_selectedLocationData!.position),
                onShowContact: () => _showContactOptions(_selectedLocationData!),
              ),
            ),
        ], // Close the Stack's children array
      );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

