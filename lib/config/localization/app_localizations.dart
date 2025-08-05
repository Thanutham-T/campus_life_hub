import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('th', 'TH'),
    Locale('en', 'US'),
  ];

  // Common
  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get ok => _localizedValues[locale.languageCode]!['ok']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get confirm => _localizedValues[locale.languageCode]!['confirm']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get warning => _localizedValues[locale.languageCode]!['warning']!;
  String get info => _localizedValues[locale.languageCode]!['info']!;

  // Authentication
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get register => _localizedValues[locale.languageCode]!['register']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get firstName => _localizedValues[locale.languageCode]!['first_name']!;
  String get lastName => _localizedValues[locale.languageCode]!['last_name']!;
  String get phoneNumber => _localizedValues[locale.languageCode]!['phone_number']!;
  String get department => _localizedValues[locale.languageCode]!['department']!;
  String get studentId => _localizedValues[locale.languageCode]!['student_id']!;

  // Validation messages
  String get emailRequired => _localizedValues[locale.languageCode]!['email_required']!;
  String get emailInvalid => _localizedValues[locale.languageCode]!['email_invalid']!;
  String get passwordRequired => _localizedValues[locale.languageCode]!['password_required']!;
  String get passwordTooShort => _localizedValues[locale.languageCode]!['password_too_short']!;
  String get firstNameRequired => _localizedValues[locale.languageCode]!['first_name_required']!;
  String get lastNameRequired => _localizedValues[locale.languageCode]!['last_name_required']!;

  // Error messages
  String get loginFailed => _localizedValues[locale.languageCode]!['login_failed']!;
  String get registerFailed => _localizedValues[locale.languageCode]!['register_failed']!;
  String get networkError => _localizedValues[locale.languageCode]!['network_error']!;
  String get serverError => _localizedValues[locale.languageCode]!['server_error']!;
  String get unknownError => _localizedValues[locale.languageCode]!['unknown_error']!;

  // Navigation
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;

  // Date formatting
  String formatDate(DateTime date) {
    final formatter = DateFormat.yMMMd(locale.languageCode);
    return formatter.format(date);
  }

  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat.yMMMd(locale.languageCode).add_jm();
    return formatter.format(dateTime);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'th': {
      // Common
      'app_name': 'ศูนย์กลางชีวิตมหาวิทยาลัย',
      'ok': 'ตกลง',
      'cancel': 'ยกเลิก',
      'confirm': 'ยืนยัน',
      'save': 'บันทึก',
      'delete': 'ลบ',
      'edit': 'แก้ไข',
      'loading': 'กำลังโหลด...',
      'error': 'ข้อผิดพลาด',
      'success': 'สำเร็จ',
      'warning': 'คำเตือน',
      'info': 'ข้อมูล',

      // Authentication
      'login': 'เข้าสู่ระบบ',
      'register': 'สร้างบัญชี',
      'logout': 'ออกจากระบบ',
      'email': 'อีเมล',
      'password': 'รหัสผ่าน',
      'first_name': 'ชื่อ',
      'last_name': 'นามสกุล',
      'phone_number': 'เบอร์โทรศัพท์',
      'department': 'ภาควิชา',
      'student_id': 'รหัสนักศึกษา',

      // Validation messages
      'email_required': 'กรุณากรอกอีเมล',
      'email_invalid': 'รูปแบบอีเมลไม่ถูกต้อง',
      'password_required': 'กรุณากรอกรหัสผ่าน',
      'password_too_short': 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร',
      'first_name_required': 'กรุณากรอกชื่อ',
      'last_name_required': 'กรุณากรอกนามสกุล',

      // Error messages
      'login_failed': 'เข้าสู่ระบบไม่สำเร็จ',
      'register_failed': 'สร้างบัญชีไม่สำเร็จ',
      'network_error': 'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้',
      'server_error': 'เกิดข้อผิดพลาดจากเซิร์ฟเวอร์',
      'unknown_error': 'เกิดข้อผิดพลาดที่ไม่คาดคิด',

      // Navigation
      'home': 'หน้าหลัก',
      'profile': 'โปรไฟล์',
      'settings': 'การตั้งค่า',
    },
    'en': {
      // Common
      'app_name': 'Campus Life Hub',
      'ok': 'OK',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'info': 'Info',

      // Authentication
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'phone_number': 'Phone Number',
      'department': 'Department',
      'student_id': 'Student ID',

      // Validation messages
      'email_required': 'Please enter email',
      'email_invalid': 'Invalid email format',
      'password_required': 'Please enter password',
      'password_too_short': 'Password must be at least 6 characters',
      'first_name_required': 'Please enter first name',
      'last_name_required': 'Please enter last name',

      // Error messages
      'login_failed': 'Login failed',
      'register_failed': 'Registration failed',
      'network_error': 'No internet connection',
      'server_error': 'Server error occurred',
      'unknown_error': 'Unknown error occurred',

      // Navigation
      'home': 'Home',
      'profile': 'Profile',
      'settings': 'Settings',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['th', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
