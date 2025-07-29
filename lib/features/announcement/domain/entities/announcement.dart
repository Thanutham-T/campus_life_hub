class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String priority; // high, medium, low
  final String category; // academic, scholarship, event, system
  final bool isRead;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.priority,
    required this.category,
    this.isRead = false,
  });

  Announcement copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    String? priority,
    String? category,
    bool? isRead,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Announcement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Announcement(id: $id, title: $title, priority: $priority, category: $category, isRead: $isRead)';
  }
}
