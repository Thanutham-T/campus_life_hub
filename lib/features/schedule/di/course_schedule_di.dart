import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Course Schedule DI - Dependency Injection for Course Schedule Feature
/// ใช้เก็บ function ทั้งหมดของ Course Schedule feature เพื่อความสะดวกตอนที่ต้องการจะเรียกใช้
class CourseScheduleDI {

  /// Sample course schedule data
  static final List<Map<String, dynamic>> _courses = [
    {
      'id': 'CS101',
      'name': 'Introduction to Computer Science',
      'nameEn': 'Introduction to Computer Science',
      'nameTh': 'หลักการวิทยาการคอมพิวเตอร์',
      'credits': 3,
      'instructor': 'ผศ.ดร.สมชาย ใจดี',
      'section': '001',
      'room': 'SC301',
      'building': 'อาคารวิทยาศาสตร์',
      'schedule': [
        {
          'day': 'monday',
          'startTime': '09:00',
          'endTime': '10:30',
        },
        {
          'day': 'wednesday',
          'startTime': '09:00',
          'endTime': '10:30',
        },
      ],
      'semester': '1/2025',
      'status': 'active',
      'color': 0xFF2196F3,
    },
    {
      'id': 'MAT101',
      'name': 'Calculus I',
      'nameEn': 'Calculus I',
      'nameTh': 'แคลคูลัส 1',
      'credits': 3,
      'instructor': 'รศ.ดร.วิชัย คณิตกร',
      'section': '002',
      'room': 'SC205',
      'building': 'อาคารวิทยาศาสตร์',
      'schedule': [
        {
          'day': 'tuesday',
          'startTime': '10:30',
          'endTime': '12:00',
        },
        {
          'day': 'thursday',
          'startTime': '10:30',
          'endTime': '12:00',
        },
      ],
      'semester': '1/2025',
      'status': 'active',
      'color': 0xFF4CAF50,
    },
    {
      'id': 'ENG102',
      'name': 'English for Communication',
      'nameEn': 'English for Communication',
      'nameTh': 'ภาษาอังกฤษเพื่อการสื่อสาร',
      'credits': 3,
      'instructor': 'อ.สุวิทย์ ภาษาดี',
      'section': '001',
      'room': 'LA101',
      'building': 'อาคารศิลปศาสตร์',
      'schedule': [
        {
          'day': 'monday',
          'startTime': '13:30',
          'endTime': '15:00',
        },
        {
          'day': 'friday',
          'startTime': '13:30',
          'endTime': '15:00',
        },
      ],
      'semester': '1/2025',
      'status': 'active',
      'color': 0xFFFF9800,
    },
  ];

  /// Days of week
  static final List<Map<String, String>> _daysOfWeek = [
    {'id': 'monday', 'name': 'จันทร์', 'short': 'จ.'},
    {'id': 'tuesday', 'name': 'อังคาร', 'short': 'อ.'},
    {'id': 'wednesday', 'name': 'พุธ', 'short': 'พ.'},
    {'id': 'thursday', 'name': 'พฤหัสบดี', 'short': 'พฤ.'},
    {'id': 'friday', 'name': 'ศุกร์', 'short': 'ศ.'},
    {'id': 'saturday', 'name': 'เสาร์', 'short': 'ส.'},
    {'id': 'sunday', 'name': 'อาทิตย์', 'short': 'อา.'},
  ];

  /// Time slots
  static final List<String> _timeSlots = [
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30',
    '11:00', '11:30', '12:00', '12:30', '13:00', '13:30',
    '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
    '17:00', '17:30', '18:00', '18:30', '19:00', '19:30',
    '20:00', '20:30', '21:00'
  ];

  /// Get all courses
  static List<Map<String, dynamic>> getAllCourses() {
    return List.from(_courses);
  }

  /// Get courses by day
  static List<Map<String, dynamic>> getCoursesByDay(String day) {
    return _courses.where((course) {
      final schedule = course['schedule'] as List;
      return schedule.any((slot) => slot['day'] == day);
    }).toList();
  }

  /// Get today's courses
  static List<Map<String, dynamic>> getTodaysCourses() {
    final today = _getTodayDayId();
    return getCoursesByDay(today);
  }

  /// Get tomorrow's courses
  static List<Map<String, dynamic>> getTomorrowsCourses() {
    final tomorrow = _getTomorrowDayId();
    return getCoursesByDay(tomorrow);
  }

  /// Get course by ID
  static Map<String, dynamic>? getCourseById(String id) {
    try {
      return _courses.firstWhere((course) => course['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Get next class
  static Map<String, dynamic>? getNextClass() {
    final now = DateTime.now();
    final today = _getTodayDayId();
    final todaysCourses = getCoursesByDay(today);
    
    for (final course in todaysCourses) {
      final schedule = course['schedule'] as List;
      for (final slot in schedule) {
        if (slot['day'] == today) {
          final startTime = _parseTime(slot['startTime']);
          final courseDateTime = DateTime(
            now.year, now.month, now.day, 
            startTime.hour, startTime.minute
          );
          
          if (courseDateTime.isAfter(now)) {
            return {
              'course': course,
              'schedule': slot,
              'timeUntil': courseDateTime.difference(now),
            };
          }
        }
      }
    }
    return null;
  }

  /// Get current class
  static Map<String, dynamic>? getCurrentClass() {
    final now = DateTime.now();
    final today = _getTodayDayId();
    final todaysCourses = getCoursesByDay(today);
    
    for (final course in todaysCourses) {
      final schedule = course['schedule'] as List;
      for (final slot in schedule) {
        if (slot['day'] == today) {
          final startTime = _parseTime(slot['startTime']);
          final endTime = _parseTime(slot['endTime']);
          
          final startDateTime = DateTime(
            now.year, now.month, now.day, 
            startTime.hour, startTime.minute
          );
          final endDateTime = DateTime(
            now.year, now.month, now.day, 
            endTime.hour, endTime.minute
          );
          
          if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
            return {
              'course': course,
              'schedule': slot,
              'timeRemaining': endDateTime.difference(now),
            };
          }
        }
      }
    }
    return null;
  }

  /// Get weekly schedule
  static Map<String, List<Map<String, dynamic>>> getWeeklySchedule() {
    final weeklySchedule = <String, List<Map<String, dynamic>>>{};
    
    for (final day in _daysOfWeek) {
      weeklySchedule[day['id']!] = getCoursesByDay(day['id']!);
    }
    
    return weeklySchedule;
  }

  /// Get days of week
  static List<Map<String, String>> getDaysOfWeek() {
    return List.from(_daysOfWeek);
  }

  /// Get time slots
  static List<String> getTimeSlots() {
    return List.from(_timeSlots);
  }

  /// Navigation methods
  static void navigateToSchedule(BuildContext context) {
    context.go('/schedule');
  }

  static void navigateToCourseDetail(BuildContext context, String courseId) {
    context.go('/schedule/$courseId');
  }

  static void navigateToAddCourse(BuildContext context) {
    context.go('/schedule/add');
  }

  /// Get day name
  static String getDayName(String dayId) {
    try {
      return _daysOfWeek.firstWhere((day) => day['id'] == dayId)['name']!;
    } catch (e) {
      return dayId;
    }
  }

  /// Get day short name
  static String getDayShortName(String dayId) {
    try {
      return _daysOfWeek.firstWhere((day) => day['id'] == dayId)['short']!;
    } catch (e) {
      return dayId;
    }
  }

  /// Format time
  static String formatTime(String time) {
    return time;
  }

  /// Format time range
  static String formatTimeRange(String startTime, String endTime) {
    return '$startTime - $endTime';
  }

  /// Get course color
  static Color getCourseColor(Map<String, dynamic> course) {
    return Color(course['color'] ?? 0xFF2196F3);
  }

  /// Get total credits
  static int getTotalCredits() {
    return _courses.fold(0, (sum, course) => sum + (course['credits'] as int));
  }

  /// Get courses count
  static int getCoursesCount() {
    return _courses.length;
  }

  /// Check if time conflicts
  static bool hasTimeConflict(String day, String startTime, String endTime, {String? excludeCourseId}) {
    final coursesOnDay = getCoursesByDay(day);
    
    final newStart = _parseTime(startTime);
    final newEnd = _parseTime(endTime);
    
    for (final course in coursesOnDay) {
      if (excludeCourseId != null && course['id'] == excludeCourseId) continue;
      
      final schedule = course['schedule'] as List;
      for (final slot in schedule) {
        if (slot['day'] == day) {
          final existingStart = _parseTime(slot['startTime']);
          final existingEnd = _parseTime(slot['endTime']);
          
          // Check for overlap
          if ((newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart))) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Get course statistics
  static Map<String, dynamic> getCourseStatistics() {
    final totalCourses = getCoursesCount();
    final totalCredits = getTotalCredits();
    final activeCourses = _courses.where((course) => course['status'] == 'active').length;
    
    final dailyCount = <String, int>{};
    for (final day in _daysOfWeek) {
      dailyCount[day['name']!] = getCoursesByDay(day['id']!).length;
    }
    
    return {
      'totalCourses': totalCourses,
      'totalCredits': totalCredits,
      'activeCourses': activeCourses,
      'dailyCount': dailyCount,
    };
  }

  /// Helper methods
  static String _getTodayDayId() {
    final weekday = DateTime.now().weekday;
    switch (weekday) {
      case 1: return 'monday';
      case 2: return 'tuesday';
      case 3: return 'wednesday';
      case 4: return 'thursday';
      case 5: return 'friday';
      case 6: return 'saturday';
      case 7: return 'sunday';
      default: return 'monday';
    }
  }

  static String _getTomorrowDayId() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final weekday = tomorrow.weekday;
    switch (weekday) {
      case 1: return 'monday';
      case 2: return 'tuesday';
      case 3: return 'wednesday';
      case 4: return 'thursday';
      case 5: return 'friday';
      case 6: return 'saturday';
      case 7: return 'sunday';
      default: return 'monday';
    }
  }

  static DateTime _parseTime(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(0, 1, 1, hour, minute);
  }
}
