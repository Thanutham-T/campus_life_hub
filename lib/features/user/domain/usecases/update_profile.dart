import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfile implements UseCase<ProfileEntity, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      phoneNumber: params.phoneNumber,
      department: params.department,
      profileImageUrl: params.profileImageUrl,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? department;
  final String? profileImageUrl;

  const UpdateProfileParams({
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

