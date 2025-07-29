import '../../domain/entities/announcement.dart';

/// Data model for announcement with JSON serialization
class AnnouncementModel extends Announcement {
  const AnnouncementModel({
    required super.id,
    required super.title,
    required super.content,
    required super.date,
    required super.priority,
    required super.category,
    super.isRead = false,
  });

  /// Create from JSON
  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
      priority: json['priority'] as String,
      category: json['category'] as String,
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'priority': priority,
      'category': category,
      'isRead': isRead,
    };
  }

  /// Create from entity
  factory AnnouncementModel.fromEntity(Announcement announcement) {
    return AnnouncementModel(
      id: announcement.id,
      title: announcement.title,
      content: announcement.content,
      date: announcement.date,
      priority: announcement.priority,
      category: announcement.category,
      isRead: announcement.isRead,
    );
  }

  /// Convert to entity
  Announcement toEntity() {
    return Announcement(
      id: id,
      title: title,
      content: content,
      date: date,
      priority: priority,
      category: category,
      isRead: isRead,
    );
  }

  @override
  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    String? priority,
    String? category,
    bool? isRead,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
    );
  }
}
