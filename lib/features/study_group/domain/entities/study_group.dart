class StudyGroup {
  final String id;
  final String name;
  final String subject;
  final String description;
  final String category;
  final String difficulty;
  final String location;
  final String schedule;
  final int? maxMembers; // Make optional
  final List<String>? memberIds; // Make optional
  final String createdBy;
  final DateTime createdAt;
  final bool isActive;
  // Newly added optional chat summary fields
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final String? lastMessageSenderName;

  const StudyGroup({
    required this.id,
    required this.name,
    required this.subject,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.location,
    required this.schedule,
    this.maxMembers, // Optional
    this.memberIds, // Optional
    required this.createdBy,
    required this.createdAt,
    required this.isActive,
  this.lastMessage,
  this.lastMessageAt,
  this.lastMessageSenderName,
  });

  StudyGroup copyWith({
    String? id,
    String? name,
    String? subject,
    String? description,
    String? category,
    String? difficulty,
    String? location,
    String? schedule,
    int? maxMembers,
    List<String>? memberIds,
    String? createdBy,
    DateTime? createdAt,
    bool? isActive,
    String? lastMessage,
    DateTime? lastMessageAt,
    String? lastMessageSenderName,
  }) {
    return StudyGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      location: location ?? this.location,
      schedule: schedule ?? this.schedule,
      maxMembers: maxMembers ?? this.maxMembers,
      memberIds: memberIds ?? this.memberIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessageSenderName: lastMessageSenderName ?? this.lastMessageSenderName,
    );
  }

  // Check if group is full (always return false if no limit)
  bool get isFull => maxMembers != null && memberIds != null 
    ? memberIds!.length >= maxMembers! 
    : false;

  // Check if user is member (always return false if no member list)
  bool isMember(String userId) => memberIds?.contains(userId) ?? false;

  DateTime get lastActivityTime => lastMessageAt ?? createdAt;
}
