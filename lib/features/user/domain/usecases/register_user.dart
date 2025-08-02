import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
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
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? studentId;
  final String? department;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.studentId,
    this.department,
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
      ];
}

