import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsDI {
  /// Navigation methods
  static void navigateToSettings(BuildContext context) {
    context.go('/settings');
  }

  /// Settings items configuration
  static List<Map<String, dynamic>> getAccountSettings() {
    return [
      {
        'icon': Icons.person,
        'title': 'ข้อมูลส่วนตัว',
        'subtitle': 'จัดการข้อมูลโปรไฟล์ของคุณ',
        'available': false,
      },
      {
        'icon': Icons.security,
        'title': 'ความปลอดภัย',
        'subtitle': 'เปลี่ยนรหัสผ่านและการยืนยันตัวตน',
        'available': false,
      },
    ];
  }

  static List<Map<String, dynamic>> getNotificationSettings() {
    return [
      {
        'icon': Icons.notifications,
        'title': 'การแจ้งเตือนทั่วไป',
        'subtitle': 'ข่าวสาร กิจกรรม ประกาศต่างๆ',
        'switchValue': true,
        'available': false,
      },
      {
        'icon': Icons.calendar_today,
        'title': 'กิจกรรมและอีเวนต์',
        'subtitle': 'แจ้งเตือนเมื่อมีกิจกรรมใหม่',
        'switchValue': false,
        'available': false,
      },
      {
        'icon': Icons.groups,
        'title': 'กลุ่มการเรียน',
        'subtitle': 'แจ้งเตือนข้อความและการเปลี่ยนแปลง',
        'switchValue': true,
        'available': false,
      },
    ];
  }

  static List<Map<String, dynamic>> getAppearanceSettings() {
    return [
      {
        'icon': Icons.language,
        'title': 'ภาษา',
        'subtitle': 'ระบุชนิดภาษาที่แสดงผล',
        'available': false,
      },
    ];
  }

  /// Show not available message
  static void showFeatureNotAvailable(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ฟีเจอร์นี้จะเปิดใช้งานเร็วๆ นี้'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
