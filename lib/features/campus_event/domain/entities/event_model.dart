enum EventCategory {
  competition,
  academic,
  sports,
  cultural,
  general,
}

enum EventStatus {
  upcoming,
  ongoing,
  completed,
  cancelled,
}

class Event {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final String description;
  final EventCategory category;
  final EventStatus status;
  final String? imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.category,
    required this.status,
    this.imageUrl,
  });

  // Helper method to get category display name
  String get categoryDisplayName {
    switch (category) {
      case EventCategory.competition:
        return 'การแข่งขันกีฬา';
      case EventCategory.academic:
        return 'การอบรมให้ความรู้';
      case EventCategory.sports:
        return 'กิจกรรมกีฬา';
      case EventCategory.cultural:
        return 'กิจกรรมวัฒนธรรม';
      case EventCategory.general:
        return 'กิจกรรมทั่วไป';
    }
  }

  // Helper method to get status display name
  String get statusDisplayName {
    switch (status) {
      case EventStatus.upcoming:
        return 'กำลังจะมาถึง';
      case EventStatus.ongoing:
        return 'กำลังดำเนินการ';
      case EventStatus.completed:
        return 'เสร็จสิ้นแล้ว';
      case EventStatus.cancelled:
        return 'ยกเลิก';
    }
  }

  // Helper method to check if event is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  // Helper method to check if event is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    
    return date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
           date.isBefore(endOfWeek.add(Duration(days: 1)));
  }

  @override
  String toString() {
    return 'Event{id: $id, title: $title, date: $date, category: $category, status: $status}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
