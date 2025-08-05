import 'package:flutter/material.dart';

/// Simple App Localization Configuration
/// จัดการการแปลภาษาของแอป (แบบง่าย)
class AppLocalization {
  
  final Locale locale;
  
  AppLocalization(this.locale);
  
  static AppLocalization? of(BuildContext context) {
    return Localizations.of(context, AppLocalization);
  }
  
  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('th', 'TH'), // Thai
  ];

  /// Current language strings
  late Map<String, String> _localizedStrings;

  /// English strings
  static const Map<String, String> _en = {
    'appName': 'Campus Life Hub',
    'dashboard': 'Dashboard',
    'events': 'Events',
    'schedule': 'Schedule',
    'map': 'Map',
    'studyGroups': 'Study Groups',
    'announcements': 'Announcements',
    'profile': 'Profile',
    'settings': 'Settings',
    'login': 'Login',
    'logout': 'Logout',
    'welcome': 'Welcome',
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'cancel': 'Cancel',
    'ok': 'OK',
    'save': 'Save',
    'delete': 'Delete',
    'edit': 'Edit',
    'add': 'Add',
    'search': 'Search',
    'filter': 'Filter',
    'sort': 'Sort',
    'today': 'Today',
    'tomorrow': 'Tomorrow',
    'thisWeek': 'This Week',
    'upcoming': 'Upcoming',
    'completed': 'Completed',
    'cancelled': 'Cancelled',
    'ongoing': 'Ongoing',
  };

  /// Thai strings
  static const Map<String, String> _th = {
    'appName': 'Campus Life Hub',
    'dashboard': 'หน้าหลัก',
    'events': 'กิจกรรม',
    'schedule': 'ตารางเรียน',
    'map': 'แผนที่',
    'studyGroups': 'กลุ่มเรียน',
    'announcements': 'ประกาศ',
    'profile': 'โปรไฟล์',
    'settings': 'การตั้งค่า',
    'login': 'เข้าสู่ระบบ',
    'logout': 'ออกจากระบบ',
    'welcome': 'ยินดีต้อนรับ',
    'loading': 'กำลังโหลด...',
    'error': 'ข้อผิดพลาด',
    'success': 'สำเร็จ',
    'cancel': 'ยกเลิก',
    'ok': 'ตกลง',
    'save': 'บันทึก',
    'delete': 'ลบ',
    'edit': 'แก้ไข',
    'add': 'เพิ่ม',
    'search': 'ค้นหา',
    'filter': 'กรอง',
    'sort': 'เรียง',
    'today': 'วันนี้',
    'tomorrow': 'พรุ่งนี้',
    'thisWeek': 'สัปดาห์นี้',
    'upcoming': 'กำลังจะมาถึง',
    'completed': 'เสร็จสิ้นแล้ว',
    'cancelled': 'ยกเลิก',
    'ongoing': 'กำลังดำเนินการ',
  };

  /// Initialize based on locale
  Future<bool> load() async {
    if (locale.languageCode == 'th') {
      _localizedStrings = _th;
    } else {
      _localizedStrings = _en;
    }
    return true;
  }

  /// Get localized string
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  /// Get current locale
  static Locale getCurrentLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }

  /// Check if current locale is Thai
  static bool isThaiLocale(BuildContext context) {
    return getCurrentLocale(context).languageCode == 'th';
  }

  /// Check if current locale is English
  static bool isEnglishLocale(BuildContext context) {
    return getCurrentLocale(context).languageCode == 'en';
  }

  /// Format locale display name
  static String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'th':
        return 'ไทย';
      case 'en':
        return 'English';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  /// Get available language options for settings
  static List<Map<String, dynamic>> getLanguageOptions() {
    return supportedLocales.map((locale) {
      return {
        'locale': locale,
        'name': getLocaleDisplayName(locale),
        'code': locale.languageCode,
      };
    }).toList();
  }
}

/// Localization delegate
class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalization.supportedLocales
        .any((supportedLocale) => supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    final localization = AppLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
