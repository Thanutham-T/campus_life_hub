import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Study Group DI - Dependency Injection for Study Group Feature
/// ใช้เก็บ function ทั้งหมดของ Study Group feature เพื่อความสะดวกตอนที่ต้องการจะเรียกใช้
class StudyGroupDI {

  /// Sample study group data
  static final List<Map<String, dynamic>> _studyGroups = [
    {
      'id': '1',
      'name': 'กลุ่มเรียนคณิตศาสตร์',
      'subject': 'MAT101',
      'description': 'กลุ่มเรียนคณิตศาสตร์พื้นฐาน สำหรับนักศึกษาปี 1',
      'members': 8,
      'maxMembers': 12,
      'category': 'mathematics',
      'difficulty': 'beginner',
      'schedule': 'จันทร์ เวลา 18:00-20:00',
      'location': 'ห้องสมุด ชั้น 2',
      'createdDate': DateTime(2025, 7, 15),
      'isJoined': true,
      'isActive': true,
    },
    {
      'id': '2',
      'name': 'Programming Study Circle',
      'subject': 'CS101',
      'description': 'เรียนรู้การเขียนโปรแกรมพื้นฐาน Python และ Java',
      'members': 15,
      'maxMembers': 20,
      'category': 'programming',
      'difficulty': 'intermediate',
      'schedule': 'พุธ เวลา 19:00-21:00',
      'location': 'ห้อง Lab คอมพิวเตอร์ 301',
      'createdDate': DateTime(2025, 7, 10),
      'isJoined': false,
      'isActive': true,
    },
    {
      'id': '3',
      'name': 'กลุ่มเรียนภาษาอังกฤษ',
      'subject': 'ENG102',
      'description': 'ฝึกพูดและเขียนภาษาอังกฤษ เตรียมสอบ TOEIC',
      'members': 6,
      'maxMembers': 10,
      'category': 'language',
      'difficulty': 'intermediate',
      'schedule': 'ศุกร์ เวลา 17:00-19:00',
      'location': 'ห้องประชุม A205',
      'createdDate': DateTime(2025, 7, 8),
      'isJoined': true,
      'isActive': true,
    },
  ];

  /// Get all study groups
  static List<Map<String, dynamic>> getAllStudyGroups() {
    return List.from(_studyGroups);
  }

  /// Get study groups by category
  static List<Map<String, dynamic>> getStudyGroupsByCategory(String category) {
    return _studyGroups.where((group) => 
        group['category'] == category).toList();
  }

  /// Get study groups by difficulty
  static List<Map<String, dynamic>> getStudyGroupsByDifficulty(String difficulty) {
    return _studyGroups.where((group) => 
        group['difficulty'] == difficulty).toList();
  }

  /// Get joined study groups
  static List<Map<String, dynamic>> getJoinedStudyGroups() {
    return _studyGroups.where((group) => 
        group['isJoined'] == true).toList();
  }

  /// Get available study groups (not joined)
  static List<Map<String, dynamic>> getAvailableStudyGroups() {
    return _studyGroups.where((group) => 
        group['isJoined'] == false && group['isActive'] == true).toList();
  }

  /// Get study groups with available slots
  static List<Map<String, dynamic>> getStudyGroupsWithSlots() {
    return _studyGroups.where((group) => 
        group['members'] < group['maxMembers']).toList();
  }

  /// Search study groups
  static List<Map<String, dynamic>> searchStudyGroups(String query) {
    if (query.isEmpty) return getAllStudyGroups();
    
    return _studyGroups.where((group) {
      return group['name'].toLowerCase().contains(query.toLowerCase()) ||
             group['subject'].toLowerCase().contains(query.toLowerCase()) ||
             group['description'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// Get study group by ID
  static Map<String, dynamic>? getStudyGroupById(String id) {
    try {
      return _studyGroups.firstWhere((group) => group['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Join study group
  static bool joinStudyGroup(String id) {
    final index = _studyGroups.indexWhere((group) => group['id'] == id);
    if (index != -1) {
      final group = _studyGroups[index];
      if (group['members'] < group['maxMembers'] && !group['isJoined']) {
        _studyGroups[index]['isJoined'] = true;
        _studyGroups[index]['members']++;
        return true;
      }
    }
    return false;
  }

  /// Leave study group
  static bool leaveStudyGroup(String id) {
    final index = _studyGroups.indexWhere((group) => group['id'] == id);
    if (index != -1 && _studyGroups[index]['isJoined']) {
      _studyGroups[index]['isJoined'] = false;
      _studyGroups[index]['members']--;
      return true;
    }
    return false;
  }

  /// Get categories
  static List<Map<String, dynamic>> getCategories() {
    return [
      {
        'id': 'mathematics',
        'name': 'คণิตศาสตร์',
        'icon': Icons.calculate,
        'color': Colors.blue,
      },
      {
        'id': 'programming',
        'name': 'การเขียนโปรแกรม',
        'icon': Icons.code,
        'color': Colors.green,
      },
      {
        'id': 'language',
        'name': 'ภาษา',
        'icon': Icons.language,
        'color': Colors.orange,
      },
      {
        'id': 'science',
        'name': 'วิทยาศาสตร์',
        'icon': Icons.science,
        'color': Colors.purple,
      },
      {
        'id': 'business',
        'name': 'ธุรกิจ',
        'icon': Icons.business,
        'color': Colors.red,
      },
    ];
  }

  /// Get difficulty levels
  static List<Map<String, dynamic>> getDifficultyLevels() {
    return [
      {
        'id': 'beginner',
        'name': 'เริ่มต้น',
        'color': Colors.green,
        'icon': Icons.school,
      },
      {
        'id': 'intermediate',
        'name': 'กลาง',
        'color': Colors.orange,
        'icon': Icons.trending_up,
      },
      {
        'id': 'advanced',
        'name': 'สูง',
        'color': Colors.red,
        'icon': Icons.star,
      },
    ];
  }

  /// Navigation methods
  static void navigateToStudyGroups(BuildContext context) {
    context.go('/study-groups');
  }

  static void navigateToStudyGroupDetail(BuildContext context, String id) {
    context.go('/study-groups/$id');
  }

  static void navigateToCreateStudyGroup(BuildContext context) {
    context.go('/study-groups/create');
  }

  static void navigateToMyStudyGroups(BuildContext context) {
    context.go('/study-groups/my-groups');
  }

  /// Get category info
  static Map<String, dynamic>? getCategoryInfo(String categoryId) {
    try {
      return getCategories().firstWhere((cat) => cat['id'] == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Get difficulty info
  static Map<String, dynamic>? getDifficultyInfo(String difficultyId) {
    try {
      return getDifficultyLevels().firstWhere((diff) => diff['id'] == difficultyId);
    } catch (e) {
      return null;
    }
  }

  /// Get member status text
  static String getMemberStatusText(Map<String, dynamic> group) {
    final members = group['members'] as int;
    final maxMembers = group['maxMembers'] as int;
    return '$members/$maxMembers คน';
  }

  /// Check if group is full
  static bool isGroupFull(Map<String, dynamic> group) {
    return group['members'] >= group['maxMembers'];
  }

  /// Get group status color
  static Color getGroupStatusColor(Map<String, dynamic> group) {
    if (group['isJoined']) return Colors.green;
    if (isGroupFull(group)) return Colors.red;
    return Colors.blue;
  }

  /// Get group status text
  static String getGroupStatusText(Map<String, dynamic> group) {
    if (group['isJoined']) return 'เข้าร่วมแล้ว';
    if (isGroupFull(group)) return 'เต็มแล้ว';
    return 'ว่าง';
  }

  /// Format creation date
  static String formatCreationDate(DateTime date) {
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

  /// Sort study groups by members count
  static List<Map<String, dynamic>> sortByPopularity(
      List<Map<String, dynamic>> groups, {bool ascending = false}) {
    final sortedGroups = List<Map<String, dynamic>>.from(groups);
    sortedGroups.sort((a, b) => ascending 
        ? a['members'].compareTo(b['members'])
        : b['members'].compareTo(a['members']));
    return sortedGroups;
  }

  /// Sort study groups by creation date
  static List<Map<String, dynamic>> sortByDate(
      List<Map<String, dynamic>> groups, {bool ascending = false}) {
    final sortedGroups = List<Map<String, dynamic>>.from(groups);
    sortedGroups.sort((a, b) => ascending 
        ? a['createdDate'].compareTo(b['createdDate'])
        : b['createdDate'].compareTo(a['createdDate']));
    return sortedGroups;
  }

  /// Get study statistics
  static Map<String, int> getStudyStatistics() {
    return {
      'totalGroups': _studyGroups.length,
      'joinedGroups': getJoinedStudyGroups().length,
      'availableGroups': getAvailableStudyGroups().length,
      'fullGroups': _studyGroups.where((group) => isGroupFull(group)).length,
    };
  }
}
