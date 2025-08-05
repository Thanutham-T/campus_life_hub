import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Announcement DI - Dependency Injection for Announcement Feature
/// ใช้เก็บ function ทั้งหมดของ Announcement feature เพื่อความสะดวกตอนที่ต้องการจะเรียกใช้
class AnnouncementDI {

  /// Sample announcement data
  static final List<Map<String, dynamic>> _announcements = [
    {
      'id': '1',
      'title': 'ประกาศการปิดภาคเรียน',
      'content': 'มหาวิทยาลัยจะปิดภาคเรียนในวันที่ 15 สิงหาคม 2025',
      'date': DateTime(2025, 7, 25),
      'priority': 'high',
      'category': 'academic',
      'isRead': false,
    },
    {
      'id': '2',
      'title': 'การเปิดรับสมัครทุนการศึกษา',
      'content': 'มีทุนการศึกษาสำหรับนักศึกษาที่มีผลการเรียนดี',
      'date': DateTime(2025, 7, 20),
      'priority': 'medium',
      'category': 'scholarship',
      'isRead': true,
    },
    {
      'id': '3',
      'title': 'กิจกรรมวันปฐมนิเทศ',
      'content': 'ขอเชิญนักศึกษาใหม่เข้าร่วมกิจกรรมปฐมนิเทศ',
      'date': DateTime(2025, 7, 18),
      'priority': 'low',
      'category': 'event',
      'isRead': false,
    },
  ];

  /// Get all announcements
  static List<Map<String, dynamic>> getAllAnnouncements() {
    return List.from(_announcements);
  }

  /// Get announcements by priority
  static List<Map<String, dynamic>> getAnnouncementsByPriority(String priority) {
    return _announcements.where((announcement) => 
        announcement['priority'] == priority).toList();
  }

  /// Get announcements by category
  static List<Map<String, dynamic>> getAnnouncementsByCategory(String category) {
    return _announcements.where((announcement) => 
        announcement['category'] == category).toList();
  }

  /// Get unread announcements
  static List<Map<String, dynamic>> getUnreadAnnouncements() {
    return _announcements.where((announcement) => 
        !announcement['isRead']).toList();
  }

  /// Get read announcements
  static List<Map<String, dynamic>> getReadAnnouncements() {
    return _announcements.where((announcement) => 
        announcement['isRead']).toList();
  }

  /// Get high priority announcements
  static List<Map<String, dynamic>> getHighPriorityAnnouncements() {
    return getAnnouncementsByPriority('high');
  }

  /// Get recent announcements (last 7 days)
  static List<Map<String, dynamic>> getRecentAnnouncements() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return _announcements.where((announcement) => 
        announcement['date'].isAfter(sevenDaysAgo)).toList();
  }

  /// Search announcements
  static List<Map<String, dynamic>> searchAnnouncements(String query) {
    if (query.isEmpty) return getAllAnnouncements();
    
    return _announcements.where((announcement) {
      return announcement['title'].toLowerCase().contains(query.toLowerCase()) ||
             announcement['content'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// Get announcement by ID
  static Map<String, dynamic>? getAnnouncementById(String id) {
    try {
      return _announcements.firstWhere((announcement) => 
          announcement['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Mark announcement as read
  static void markAsRead(String id) {
    final index = _announcements.indexWhere((announcement) => 
        announcement['id'] == id);
    if (index != -1) {
      _announcements[index]['isRead'] = true;
    }
  }

  /// Mark announcement as unread
  static void markAsUnread(String id) {
    final index = _announcements.indexWhere((announcement) => 
        announcement['id'] == id);
    if (index != -1) {
      _announcements[index]['isRead'] = false;
    }
  }

  /// Get unread count
  static int getUnreadCount() {
    return getUnreadAnnouncements().length;
  }

  /// Navigate to announcements list
  static void navigateToAnnouncementsList(BuildContext context) {
    context.go('/announcements');
  }

  /// Navigate to announcement detail
  static void navigateToAnnouncementDetail(BuildContext context, String id) {
    context.go('/announcements/$id');
  }

  /// Get priority color
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Get priority icon
  static IconData getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.arrow_downward;
      default:
        return Icons.info;
    }
  }

  /// Get priority text
  static String getPriorityText(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'สำคัญมาก';
      case 'medium':
        return 'สำคัญปานกลาง';
      case 'low':
        return 'สำคัญน้อย';
      default:
        return 'ปกติ';
    }
  }

  /// Get category icon
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return Icons.school;
      case 'scholarship':
        return Icons.monetization_on;
      case 'event':
        return Icons.event;
      case 'system':
        return Icons.settings;
      default:
        return Icons.announcement;
    }
  }

  /// Get category text
  static String getCategoryText(String category) {
    switch (category.toLowerCase()) {
      case 'academic':
        return 'วิชาการ';
      case 'scholarship':
        return 'ทุนการศึกษา';
      case 'event':
        return 'กิจกรรม';
      case 'system':
        return 'ระบบ';
      default:
        return 'ทั่วไป';
    }
  }

  /// Format announcement date
  static String formatAnnouncementDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'วันนี้';
    } else if (difference == 1) {
      return 'เมื่อวาน';
    } else if (difference < 7) {
      return '$difference วันที่แล้ว';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks สัปดาห์ที่แล้ว';
    } else {
      final months = (difference / 30).floor();
      return '$months เดือนที่แล้ว';
    }
  }

  /// Sort announcements by date
  static List<Map<String, dynamic>> sortAnnouncementsByDate(
      List<Map<String, dynamic>> announcements, 
      {bool ascending = false}) {
    final sortedAnnouncements = List<Map<String, dynamic>>.from(announcements);
    sortedAnnouncements.sort((a, b) => ascending 
        ? a['date'].compareTo(b['date']) 
        : b['date'].compareTo(a['date']));
    return sortedAnnouncements;
  }

  /// Sort announcements by priority
  static List<Map<String, dynamic>> sortAnnouncementsByPriority(
      List<Map<String, dynamic>> announcements) {
    final priorityOrder = {'high': 3, 'medium': 2, 'low': 1};
    final sortedAnnouncements = List<Map<String, dynamic>>.from(announcements);
    sortedAnnouncements.sort((a, b) {
      final aPriority = priorityOrder[a['priority']] ?? 0;
      final bPriority = priorityOrder[b['priority']] ?? 0;
      return bPriority.compareTo(aPriority);
    });
    return sortedAnnouncements;
  }
}
