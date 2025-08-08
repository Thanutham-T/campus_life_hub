import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? profileImageUrl;
  final String department;
  final String studentId;
  final String educationLevel; // ระดับการศึกษา
  final String campus; // วิทยาเขต
  final String faculty; // คณะ
  final String major; // สาขาวิชา
  final String curriculum; // หลักสูตร
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.department,
    required this.studentId,
    required this.educationLevel,
    required this.campus,
    required this.faculty,
    required this.major,
    required this.curriculum,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  String get displayName => fullName.isNotEmpty ? fullName : email;

  bool get isStudent => role == UserRole.student;

  bool get isStaff => role == UserRole.staff;

  bool get isAdmin => role == UserRole.admin;

  ProfileEntity copyWith({
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
    return ProfileEntity(
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

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        phoneNumber,
        profileImageUrl,
        department,
        studentId,
        educationLevel,
        campus,
        faculty,
        major,
        curriculum,
        role,
        createdAt,
        updatedAt,
      ];
}

enum UserRole {
  student,
  staff,
  admin,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'นักศึกษา';
      case UserRole.staff:
        return 'เจ้าหน้าที่';
      case UserRole.admin:
        return 'ผู้ดูแลระบบ';
    }
  }

  String get value {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.staff:
        return 'staff';
      case UserRole.admin:
        return 'admin';
    }
  }

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'staff':
        return UserRole.staff;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.student;
    }
  }
}

