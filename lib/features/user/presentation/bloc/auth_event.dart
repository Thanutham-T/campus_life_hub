import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// App lifecycle events
class AppStarted extends AuthEvent {}

class AuthStatusRequested extends AuthEvent {}

// Login events
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class LoginWithGoogleRequested extends AuthEvent {}

class LoginWithFacebookRequested extends AuthEvent {}

// Register events
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String studentId;
  final String department;
  final String educationLevel; // ระดับการศึกษา
  final String campus; // วิทยาเขต
  final String faculty; // คณะ
  final String major; // สาขาวิชา
  final String curriculum; // หลักสูตร

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.studentId,
    required this.department,
    required this.educationLevel,
    required this.campus,
    required this.faculty,
    required this.major,
    required this.curriculum,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        firstName,
        lastName,
        phoneNumber,
        studentId,
        department,
        educationLevel,
        campus,
        faculty,
        major,
        curriculum,
      ];
}

// Logout events
class LogoutRequested extends AuthEvent {}

// Profile events
class ProfileRequested extends AuthEvent {}

class ProfileUpdateRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? department;
  final String? profileImageUrl;

  const ProfileUpdateRequested({
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.department,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        phoneNumber,
        department,
        profileImageUrl,
      ];
}

class PasswordChangeRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const PasswordChangeRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

// Password reset events
class PasswordResetRequested extends AuthEvent {
  final String email;

  const PasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

// Email verification events
class EmailVerificationRequested extends AuthEvent {}

class EmailVerificationCompleted extends AuthEvent {
  final String verificationCode;

  const EmailVerificationCompleted({required this.verificationCode});

  @override
  List<Object?> get props => [verificationCode];
}

// Profile image events
class ProfileImageUploadRequested extends AuthEvent {
  final String imagePath;

  const ProfileImageUploadRequested({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

