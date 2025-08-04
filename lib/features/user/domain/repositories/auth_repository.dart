import 'package:dartz/dartz.dart';
import '../../../../core/core_modules.dart';
import '../entities/profile_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, ProfileEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, ProfileEntity>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? studentId,
    String? department,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, ProfileEntity>> getCurrentUser();

  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? department,
    String? profileImageUrl,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, void>> resetPassword({
    required String email,
  });

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, void>> verifyEmail({
    required String verificationCode,
  });

  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<Failure, void>> clearLocalData();
}
