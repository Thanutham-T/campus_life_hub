import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/core_modules.dart';
import '../entities/profile_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUser implements UseCase<ProfileEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
      phoneNumber: params.phoneNumber,
      studentId: params.studentId,
      department: params.department,
      educationLevel: params.educationLevel,
      campus: params.campus,
      faculty: params.faculty,
      major: params.major,
      curriculum: params.curriculum,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String studentId;
  final String department;
  final String educationLevel;
  final String campus;
  final String faculty;
  final String major;
  final String curriculum;

  const RegisterParams({
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

