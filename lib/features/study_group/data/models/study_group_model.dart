import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/study_group.dart';

class StudyGroupModel extends StudyGroup {
  const StudyGroupModel({
    required super.id,
    required super.name,
    required super.subject,
    required super.description,
    required super.category,
    required super.difficulty,
    required super.location,
    required super.schedule,
    required super.maxMembers,
    required super.memberIds,
    required super.createdBy,
    required super.createdAt,
    required super.isActive,
    this.lastMessage,
    this.lastMessageAt,
    this.lastMessageSenderName,
  });

  final String? lastMessage;
  final DateTime? lastMessageAt;
  final String? lastMessageSenderName;

  factory StudyGroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudyGroupModel(
      id: doc.id,
      name: data['name'] ?? '',
      subject: data['subject'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      difficulty: data['difficulty'] ?? '',
      location: data['location'] ?? '',
      schedule: data['schedule'] ?? '',
      maxMembers: data['maxMembers'], // Nullable
      memberIds: data['memberIds'] != null 
        ? List<String>.from(data['memberIds']) 
        : null, // Nullable
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
  lastMessage: data['lastMessage'] as String?,
  lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
  lastMessageSenderName: data['lastMessageSenderName'] as String?,
    );
  }

  factory StudyGroupModel.fromEntity(StudyGroup studyGroup) {
    return StudyGroupModel(
      id: studyGroup.id,
      name: studyGroup.name,
      subject: studyGroup.subject,
      description: studyGroup.description,
      category: studyGroup.category,
      difficulty: studyGroup.difficulty,
      location: studyGroup.location,
      schedule: studyGroup.schedule,
      maxMembers: studyGroup.maxMembers,
      memberIds: studyGroup.memberIds,
      createdBy: studyGroup.createdBy,
      createdAt: studyGroup.createdAt,
      isActive: studyGroup.isActive,
  lastMessage: null,
  lastMessageAt: null,
  lastMessageSenderName: null,
    );
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = {
      'name': name,
      'subject': subject,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'location': location,
      'schedule': schedule,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
  if (lastMessage != null) 'lastMessage': lastMessage,
  if (lastMessageAt != null) 'lastMessageAt': Timestamp.fromDate(lastMessageAt!),
  if (lastMessageSenderName != null) 'lastMessageSenderName': lastMessageSenderName,
    };
    
    // Only include if not null
    if (maxMembers != null) data['maxMembers'] = maxMembers;
    if (memberIds != null) data['memberIds'] = memberIds;
    
    return data;
  }

  @override
  StudyGroupModel copyWith({
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
    return StudyGroupModel(
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

  // Convert from domain entity to model
  factory StudyGroupModel.fromDomain(StudyGroup studyGroup) {
    return StudyGroupModel(
      id: studyGroup.id,
      name: studyGroup.name,
      subject: studyGroup.subject,
      description: studyGroup.description,
      category: studyGroup.category,
      difficulty: studyGroup.difficulty,
      location: studyGroup.location,
      schedule: studyGroup.schedule,
      maxMembers: studyGroup.maxMembers,
      memberIds: studyGroup.memberIds,
      createdBy: studyGroup.createdBy,
      createdAt: studyGroup.createdAt,
      isActive: studyGroup.isActive,
  lastMessage: null,
  lastMessageAt: null,
  lastMessageSenderName: null,
    );
  }

  // Convert model to domain entity
  StudyGroup toDomain() {
    return StudyGroup(
      id: id,
      name: name,
      subject: subject,
      description: description,
      category: category,
      difficulty: difficulty,
      location: location,
      schedule: schedule,
      maxMembers: maxMembers,
      memberIds: memberIds,
      createdBy: createdBy,
      createdAt: createdAt,
      isActive: isActive,
  lastMessage: lastMessage,
  lastMessageAt: lastMessageAt,
  lastMessageSenderName: lastMessageSenderName,
    );
  }
}
