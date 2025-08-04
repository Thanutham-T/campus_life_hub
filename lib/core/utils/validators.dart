class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'กรุณากรอกอีเมล';
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) return 'รูปแบบอีเมลไม่ถูกต้อง';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'กรุณากรอกรหัสผ่าน';
    if (value.length < 6) return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
    return null;
  }

  static String? validateNotEmpty(String? value, {String message = 'กรุณากรอกข้อมูล'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'กรุณากรอกเบอร์โทรศัพท์';
    const pattern = r'^[0-9]{9,10}$';
    if (!RegExp(pattern).hasMatch(value)) return 'เบอร์โทรศัพท์ไม่ถูกต้อง';
    return null;
  }
}
