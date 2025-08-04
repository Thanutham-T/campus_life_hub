// DateTime extensions for formatting and operations
extension DateTimeExtensions on DateTime {
  // Format as Thai date
  String toThaiDate() {
    const months = [
      'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
    ];
    return '$day ${months[month - 1]} ${year + 543}';
  }
  
  // Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  // Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }
  
  // Get relative date string
  String get relativeDate {
    final now = DateTime.now();
    final difference = this.difference(now).inDays;
    
    if (difference == 0) return 'วันนี้';
    if (difference == 1) return 'พรุ่งนี้';
    if (difference > 1 && difference <= 7) return 'ใน $difference วัน';
    return toThaiDate();
  }
}
