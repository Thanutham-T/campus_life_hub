// String extensions for common operations
extension StringExtensions on String {
  // Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
  
  // Check if string is email
  bool get isEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
  
  // Check if string is phone number (Thai format)
  bool get isPhoneNumber {
    return RegExp(r'^(\+66|66|0)[0-9]{8,9}$').hasMatch(this);
  }
  
  // Remove all whitespace
  String get removeAllWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }
}
