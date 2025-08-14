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
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.category,
    required this.status,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for creating Event from Firestore document
  factory Event.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Event(
      id: documentId,
      title: data['title']?.toString() ?? '',
      date: _parseDateTime(data['date']),
      location: data['location']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      category: _parseCategory(data['category']?.toString()),
      status: _parseStatus(data['status']?.toString()),
      imageUrl: data['imageUrl']?.toString(),
      createdAt: _parseDateTime(data['createdAt']),
      updatedAt: _parseDateTime(data['updatedAt']),
    );
  }

  // Convert Event to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
      'category': category.name,
      'status': status.name,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper method to parse DateTime from various formats
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      return parsed ?? DateTime.now();
    }
    
    // Handle Firestore Timestamp
    if (value is Map && value.containsKey('_seconds')) {
      final seconds = value['_seconds'] as int?;
      if (seconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      }
    }
    
    return DateTime.now();
  }

  // Helper method to parse EventCategory
  static EventCategory _parseCategory(String? categoryString) {
    if (categoryString == null) return EventCategory.general;
    
    for (EventCategory category in EventCategory.values) {
      if (category.name.toLowerCase() == categoryString.toLowerCase()) {
        return category;
      }
    }
    return EventCategory.general;
  }

  // Helper method to parse EventStatus
  static EventStatus _parseStatus(String? statusString) {
    if (statusString == null) return EventStatus.upcoming;
    
    for (EventStatus status in EventStatus.values) {
      if (status.name.toLowerCase() == statusString.toLowerCase()) {
        return status;
      }
    }
    return EventStatus.upcoming;
  }

  // Copy with method
  Event copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? location,
    String? description,
    EventCategory? category,
    EventStatus? status,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      location: location ?? this.location,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
