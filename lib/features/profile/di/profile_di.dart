import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Profile DI - Dependency Injection for Profile Feature
/// ใช้เก็บ function ทั้งหมดของ Profile feature เพื่อความสะดวกตอนที่ต้องการจะเรียกใช้
class ProfileDI {

  /// Sample user profile data
  static final Map<String, dynamic> _userProfile = {
    'id': 'user123',
    'name': 'นาย ธนุธรรม ทองทรัพย์',
    'studentId': '65142312345',
    'email': 'thanutham@university.ac.th',
    'phone': '0812345678',
    'faculty': 'คณะวิทยาศาสตร์และเทคโนโลยี',
    'department': 'สาขาวิชาวิทยาการคอมพิวเตอร์',
    'year': 3,
    'gpa': 3.45,
    'profileImage': null,
    'joinedDate': DateTime(2022, 6, 1),
    'preferences': {
      'language': 'th',
      'notifications': true,
      'darkMode': false,
    },
  };

  /// User settings
  static final Map<String, dynamic> _userSettings = {
    'notifications': {
      'events': true,
      'announcements': true,
      'deadlines': true,
      'social': false,
    },
    'privacy': {
      'showProfile': true,
      'showEmail': false,
      'showPhone': false,
    },
    'appearance': {
      'theme': 'light',
      'fontSize': 'medium',
      'language': 'th',
    },
  };

  /// Get user profile
  static Map<String, dynamic> getUserProfile() {
    return Map.from(_userProfile);
  }

  /// Get user settings
  static Map<String, dynamic> getUserSettings() {
    return Map.from(_userSettings);
  }

  /// Update user profile
  static void updateUserProfile(Map<String, dynamic> updates) {
    _userProfile.addAll(updates);
  }

  /// Update user settings
  static void updateUserSettings(String category, String key, dynamic value) {
    if (_userSettings.containsKey(category)) {
      _userSettings[category][key] = value;
    }
  }

  /// Get user name
  static String getUserName() {
    return _userProfile['name'] ?? 'ไม่ระบุชื่อ';
  }

  /// Get student ID
  static String getStudentId() {
    return _userProfile['studentId'] ?? 'ไม่ระบุรหัส';
  }

  /// Get user email
  static String getUserEmail() {
    return _userProfile['email'] ?? 'ไม่ระบุอีเมล';
  }

  /// Get user faculty
  static String getUserFaculty() {
    return _userProfile['faculty'] ?? 'ไม่ระบุคณะ';
  }

  /// Get user department
  static String getUserDepartment() {
    return _userProfile['department'] ?? 'ไม่ระบุสาขา';
  }

  /// Get user year
  static int getUserYear() {
    return _userProfile['year'] ?? 1;
  }

  /// Get user GPA
  static double getUserGPA() {
    return _userProfile['gpa'] ?? 0.0;
  }

  /// Get profile image
  static String? getProfileImage() {
    return _userProfile['profileImage'];
  }

  /// Update profile image
  static void updateProfileImage(String? imagePath) {
    _userProfile['profileImage'] = imagePath;
  }

  /// Get notification settings
  static Map<String, bool> getNotificationSettings() {
    return Map<String, bool>.from(_userSettings['notifications']);
  }

  /// Update notification setting
  static void updateNotificationSetting(String key, bool value) {
    updateUserSettings('notifications', key, value);
  }

  /// Get privacy settings
  static Map<String, bool> getPrivacySettings() {
    return Map<String, bool>.from(_userSettings['privacy']);
  }

  /// Update privacy setting
  static void updatePrivacySetting(String key, bool value) {
    updateUserSettings('privacy', key, value);
  }

  /// Get appearance settings
  static Map<String, String> getAppearanceSettings() {
    return Map<String, String>.from(_userSettings['appearance']);
  }

  /// Update appearance setting
  static void updateAppearanceSetting(String key, String value) {
    updateUserSettings('appearance', key, value);
  }

  /// Get user statistics
  static Map<String, dynamic> getUserStatistics() {
    return {
      'eventsJoined': 12,
      'announcementsRead': 45,
      'studyGroupsJoined': 3,
      'coursesEnrolled': 8,
      'loginDays': 89,
    };
  }

  /// Navigation methods
  static void navigateToProfile(BuildContext context) {
    context.go('/profile');
  }

  static void navigateToEditProfile(BuildContext context) {
    context.go('/profile/edit');
  }

  static void navigateToSettings(BuildContext context) {
    context.go('/profile/settings');
  }

  static void navigateToPrivacySettings(BuildContext context) {
    context.go('/profile/privacy');
  }

  static void navigateToNotificationSettings(BuildContext context) {
    context.go('/profile/notifications');
  }

  /// Profile menu items
  static List<Map<String, dynamic>> getProfileMenuItems(BuildContext context) {
    return [
      {
        'title': 'แก้ไขโปรไฟล์',
        'icon': Icons.edit,
        'onTap': () => navigateToEditProfile(context),
      },
      {
        'title': 'การตั้งค่า',
        'icon': Icons.settings,
        'onTap': () => navigateToSettings(context),
      },
      {
        'title': 'การแจ้งเตือน',
        'icon': Icons.notifications,
        'onTap': () => navigateToNotificationSettings(context),
      },
      {
        'title': 'ความเป็นส่วนตัว',
        'icon': Icons.privacy_tip,
        'onTap': () => navigateToPrivacySettings(context),
      },
      {
        'title': 'เกี่ยวกับ',
        'icon': Icons.info,
        'onTap': () => _showAboutDialog(context),
      },
      {
        'title': 'ออกจากระบบ',
        'icon': Icons.logout,
        'onTap': () => _showLogoutConfirmation(context),
      },
    ];
  }

  /// Show about dialog
  static void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เกี่ยวกับแอป'),
        content: const Text(
          'Campus Life Hub\n'
          'เวอร์ชัน 1.0.0\n'
          'แอปพลิเคชันสำหรับจัดการชีวิตในมหาวิทยาลัย'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  /// Show logout confirmation
  static void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ออกจากระบบ'),
        content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context);
            },
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }

  /// Logout function
  static void _logout(BuildContext context) {
    // Clear user data
    // Navigate to login screen
    context.go('/login');
  }

  /// Format join date
  static String formatJoinDate() {
    final joinDate = _userProfile['joinedDate'] as DateTime?;
    if (joinDate == null) return 'ไม่ทราบวันที่เข้าร่วม';
    
    final now = DateTime.now();
    final difference = now.difference(joinDate).inDays;
    final years = (difference / 365).floor();
    final months = ((difference % 365) / 30).floor();
    
    if (years > 0) {
      return '$years ปี $months เดือน';
    } else if (months > 0) {
      return '$months เดือน';
    } else {
      return '$difference วัน';
    }
  }

  /// Get year text
  static String getYearText() {
    final year = getUserYear();
    switch (year) {
      case 1:
        return 'ปี 1';
      case 2:
        return 'ปี 2';
      case 3:
        return 'ปี 3';
      case 4:
        return 'ปี 4';
      default:
        return 'ปี $year';
    }
  }

  /// Get GPA color based on value
  static Color getGPAColor() {
    final gpa = getUserGPA();
    if (gpa >= 3.5) return Colors.green;
    if (gpa >= 3.0) return Colors.orange;
    if (gpa >= 2.5) return Colors.red;
    return Colors.grey;
  }
}
