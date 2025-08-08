import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.phoneNumber,
    super.profileImageUrl,
    required super.department,
    required super.studentId,
    required super.educationLevel,
    required super.campus,
    required super.faculty,
    required super.major,
    required super.curriculum,
    required super.role,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    print('📥 ProfileModel.fromJson: Processing data from Firestore');
    print('📋 Input JSON: $json');
    
    final model = ProfileModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      profileImageUrl: json['profileImageUrl']?.toString(),
      department: json['department']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      educationLevel: json['educationLevel']?.toString() ?? '',
      campus: json['campus']?.toString() ?? '',
      faculty: json['faculty']?.toString() ?? '',
      major: json['major']?.toString() ?? '',
      curriculum: json['curriculum']?.toString() ?? '',
      role: UserRoleExtension.fromString(json['role']?.toString() ?? 'student'),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );

    print('✅ ProfileModel created successfully:');
    print('   - ID: ${model.id}');
    print('   - Email: ${model.email}');
    print('   - Name: ${model.firstName} ${model.lastName}');
    print('   - Student ID: ${model.studentId}');
    print('   - Faculty: ${model.faculty}');
    print('   - Major: ${model.major}');
    print('   - Campus: ${model.campus}');
    print('   - Education Level: ${model.educationLevel}');
    print('   - Department: ${model.department}');
    print('   - Phone: ${model.phoneNumber}');
    
    return model;
  }

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'department': department,
      'studentId': studentId,
      'educationLevel': educationLevel,
      'campus': campus,
      'faculty': faculty,
      'major': major,
      'curriculum': curriculum,
      'role': role.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phoneNumber: entity.phoneNumber,
      profileImageUrl: entity.profileImageUrl,
      department: entity.department,
      studentId: entity.studentId,
      educationLevel: entity.educationLevel,
      campus: entity.campus,
      faculty: entity.faculty,
      major: entity.major,
      curriculum: entity.curriculum,
      role: entity.role,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ProfileModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    String? department,
    String? studentId,
    String? educationLevel,
    String? campus,
    String? faculty,
    String? major,
    String? curriculum,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      department: department ?? this.department,
      studentId: studentId ?? this.studentId,
      educationLevel: educationLevel ?? this.educationLevel,
      campus: campus ?? this.campus,
      faculty: faculty ?? this.faculty,
      major: major ?? this.major,
      curriculum: curriculum ?? this.curriculum,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
