import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

/// Campus Map DI - Dependency Injection for Campus Map Feature
/// ใช้เก็บ function ทั้งหมดของ Campus Map feature เพื่อความสะดวกตอนที่ต้องการจะเรียกใช้
class CampusMapDI {

  /// Sample campus locations data
  static final List<Map<String, dynamic>> _locations = [
    {
      'id': '1',
      'name': 'อาคารวิทยาศาสตร์และเทคโนโลยี',
      'nameEn': 'Science and Technology Building',
      'category': 'academic',
      'description': 'อาคารเรียนหลักของคณะวิทยาศาสตร์และเทคโนโลยี',
      'coordinates': {'lat': 13.7563, 'lng': 100.5018},
      'floor': 4,
      'facilities': ['ห้องเรียน', 'ห้องแล็บ', 'ห้องปฏิบัติการคอมพิวเตอร์'],
      'openHours': '06:00-22:00',
      'image': null,
      'isAccessible': true,
    },
    {
      'id': '2',
      'name': 'ห้องสมุดกลาง',
      'nameEn': 'Central Library',
      'category': 'library',
      'description': 'ห้องสมุดหลักของมหาวิทยาลัย มีหนังสือและทรัพยากรการเรียนรู้',
      'coordinates': {'lat': 13.7560, 'lng': 100.5015},
      'floor': 5,
      'facilities': ['ห้องอ่านหนังสือ', 'ห้องกลุ่ม', 'ห้องคอมพิวเตอร์', 'WiFi'],
      'openHours': '07:00-21:00',
      'image': null,
      'isAccessible': true,
    },
    {
      'id': '3',
      'name': 'โรงอาหาร',
      'nameEn': 'Cafeteria',
      'category': 'dining',
      'description': 'โรงอาหารนักศึกษา มีอาหารหลากหลายราคาประหยัด',
      'coordinates': {'lat': 13.7565, 'lng': 100.5020},
      'floor': 1,
      'facilities': ['ร้านอาหาร', 'ที่นั่ง', 'ATM', 'ร้านสะดวกซื้อ'],
      'openHours': '06:00-20:00',
      'image': null,
      'isAccessible': true,
    },
    {
      'id': '4',
      'name': 'สนามกีฬา',
      'nameEn': 'Sports Complex',
      'category': 'sports',
      'description': 'สนามกีฬาและยิมเนเซียม สำหรับกิจกรรมกีฬาและออกกำลังกาย',
      'coordinates': {'lat': 13.7570, 'lng': 100.5025},
      'floor': 1,
      'facilities': ['สนามฟุตบอล', 'สนามบาสเก็ตบอล', 'ยิม', 'ห้องแต่งตัว'],
      'openHours': '05:00-21:00',
      'image': null,
      'isAccessible': true,
    },
    {
      'id': '5',
      'name': 'อาคารบริหาร',
      'nameEn': 'Administration Building',
      'category': 'admin',
      'description': 'อาคารบริหารงานของมหาวิทยาลัย ทำเรื่องต่างๆ',
      'coordinates': {'lat': 13.7558, 'lng': 100.5012},
      'floor': 3,
      'facilities': ['งานการศึกษา', 'งานการเงิน', 'งานทะเบียน', 'ห้องรับรอง'],
      'openHours': '08:00-16:30',
      'image': null,
      'isAccessible': true,
    },
  ];

  /// Location categories
  static final List<Map<String, dynamic>> _categories = [
    {
      'id': 'academic',
      'name': 'อาคารเรียน',
      'icon': Icons.school,
      'color': Colors.blue,
    },
    {
      'id': 'library',
      'name': 'ห้องสมุด',
      'icon': Icons.local_library,
      'color': Colors.green,
    },
    {
      'id': 'dining',
      'name': 'ร้านอาหาร',
      'icon': Icons.restaurant,
      'color': Colors.orange,
    },
    {
      'id': 'sports',
      'name': 'กีฬา',
      'icon': Icons.sports,
      'color': Colors.red,
    },
    {
      'id': 'admin',
      'name': 'บริหาร',
      'icon': Icons.business,
      'color': Colors.purple,
    },
    {
      'id': 'dormitory',
      'name': 'หอพัก',
      'icon': Icons.bed,
      'color': Colors.brown,
    },
    {
      'id': 'parking',
      'name': 'ที่จอดรถ',
      'icon': Icons.local_parking,
      'color': Colors.grey,
    },
  ];

  /// Get all locations
  static List<Map<String, dynamic>> getAllLocations() {
    return List.from(_locations);
  }

  /// Get locations by category
  static List<Map<String, dynamic>> getLocationsByCategory(String category) {
    return _locations.where((location) => 
        location['category'] == category).toList();
  }

  /// Get location by ID
  static Map<String, dynamic>? getLocationById(String id) {
    try {
      return _locations.firstWhere((location) => location['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Search locations
  static List<Map<String, dynamic>> searchLocations(String query) {
    if (query.isEmpty) return getAllLocations();
    
    return _locations.where((location) {
      return location['name'].toLowerCase().contains(query.toLowerCase()) ||
             location['nameEn'].toLowerCase().contains(query.toLowerCase()) ||
             location['description'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// Get nearby locations (mock implementation)
  static List<Map<String, dynamic>> getNearbyLocations(
      double userLat, double userLng, {double radiusKm = 1.0}) {
    // Simple distance calculation (not accurate, just for demo)
    return _locations.where((location) {
      final lat = location['coordinates']['lat'] as double;
      final lng = location['coordinates']['lng'] as double;
      final distance = _calculateDistance(userLat, userLng, lat, lng);
      return distance <= radiusKm;
    }).toList();
  }

  /// Get all categories
  static List<Map<String, dynamic>> getCategories() {
    return List.from(_categories);
  }

  /// Get category info
  static Map<String, dynamic>? getCategoryInfo(String categoryId) {
    try {
      return _categories.firstWhere((cat) => cat['id'] == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Get popular locations
  static List<Map<String, dynamic>> getPopularLocations() {
    // Return first 3 locations as popular (mock implementation)
    return _locations.take(3).toList();
  }

  /// Get accessible locations
  static List<Map<String, dynamic>> getAccessibleLocations() {
    return _locations.where((location) => 
        location['isAccessible'] == true).toList();
  }

  /// Navigation methods
  static void navigateToCampusMap(BuildContext context) {
    context.go('/map');
  }

  static void navigateToLocationDetail(BuildContext context, String locationId) {
    context.go('/map/$locationId');
  }

  static void navigateToDirections(BuildContext context, String fromId, String toId) {
    context.go('/map/directions?from=$fromId&to=$toId');
  }

  /// Get building info
  static Map<String, dynamic> getBuildingInfo(Map<String, dynamic> location) {
    return {
      'name': location['name'],
      'nameEn': location['nameEn'],
      'floors': location['floor'],
      'facilities': location['facilities'],
      'openHours': location['openHours'],
      'isAccessible': location['isAccessible'],
    };
  }

  /// Check if location is open
  static bool isLocationOpen(Map<String, dynamic> location) {
    final openHours = location['openHours'] as String?;
    if (openHours == null || openHours == '24/7') return true;
    
    final now = DateTime.now();
    final parts = openHours.split('-');
    if (parts.length != 2) return true;
    
    try {
      final openTime = _parseTime(parts[0].trim());
      final closeTime = _parseTime(parts[1].trim());
      
      final currentTime = DateTime(0, 1, 1, now.hour, now.minute);
      
      return currentTime.isAfter(openTime) && currentTime.isBefore(closeTime);
    } catch (e) {
      return true;
    }
  }

  /// Get location status
  static Map<String, dynamic> getLocationStatus(Map<String, dynamic> location) {
    final isOpen = isLocationOpen(location);
    return {
      'isOpen': isOpen,
      'status': isOpen ? 'เปิด' : 'ปิด',
      'statusColor': isOpen ? Colors.green : Colors.red,
    };
  }

  /// Format opening hours
  static String formatOpeningHours(String openHours) {
    if (openHours == '24/7') return 'เปิด 24 ชั่วโมง';
    return 'เปิด $openHours น.';
  }

  /// Get directions text (mock implementation)
  static String getDirectionsText(String fromId, String toId) {
    final from = getLocationById(fromId);
    final to = getLocationById(toId);
    
    if (from == null || to == null) return 'ไม่พบข้อมูลเส้นทาง';
    
    return 'เส้นทางจาก ${from['name']} ไป ${to['name']}:\n'
           '1. เดินออกจาก ${from['name']}\n'
           '2. เดินตามทางเดินหลัก\n'
           '3. มุ่งหน้าไปยัง ${to['name']}\n'
           'ระยะทางประมาณ ${_calculateDistance(
             from['coordinates']['lat'], 
             from['coordinates']['lng'],
             to['coordinates']['lat'], 
             to['coordinates']['lng']
           ).toStringAsFixed(0)} เมตร';
  }

  /// Get campus statistics
  static Map<String, dynamic> getCampusStatistics() {
    final totalLocations = _locations.length;
    final openLocations = _locations.where(isLocationOpen).length;
    final accessibleLocations = getAccessibleLocations().length;
    
    final categoryCount = <String, int>{};
    for (final location in _locations) {
      final category = location['category'] as String;
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }
    
    return {
      'totalLocations': totalLocations,
      'openLocations': openLocations,
      'accessibleLocations': accessibleLocations,
      'categoryCount': categoryCount,
    };
  }

  /// Helper methods
  static double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Simple distance calculation in meters (not accurate, just for demo)
    const double earthRadius = 6371000; // meters
    final double dLat = (lat2 - lat1) * (3.14159 / 180);
    final double dLng = (lng2 - lng1) * (3.14159 / 180);
    
    final double a = (dLat / 2) * (dLat / 2) +
        (dLng / 2) * (dLng / 2) * math.cos(lat1 * (3.14159 / 180)) * math.cos(lat2 * (3.14159 / 180));
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }

  static DateTime _parseTime(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(0, 1, 1, hour, minute);
  }
}
