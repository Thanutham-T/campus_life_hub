import 'dart:math' as math;
import 'package:flutter/material.dart';

class MapUtils {
  // Calculate distance between two points
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final double dLat = (lat2 - lat1) * (math.pi / 180);
    final double dLon = (lon2 - lon1) * (math.pi / 180);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * (math.pi / 180)) * math.cos(lat2 * (math.pi / 180)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  // Get location icon based on place type
  static IconData getLocationIcon(String type) {
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

  // Get operating status from opening hours data
  static String getOperatingStatus(dynamic openingHours, bool? isOpenNow) {
    if (openingHours == null) return 'ไม่มีข้อมูลเวลาทำการ';
    
    // If it's from Google Places API (isOpen field)
    if (isOpenNow != null) {
      return isOpenNow ? 'เปิดบริการ' : 'ปิดบริการ';
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
}
