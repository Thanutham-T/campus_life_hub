import '../../models/profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<ProfileModel> login({
    required String email,
    required String password,
  });

  Future<ProfileModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? studentId,
    String? department,
  });

  Future<void> logout();

  Future<ProfileModel> getCurrentUser();

  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? department,
    String? profileImageUrl,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> resetPassword({
    required String email,
  });

  Future<void> sendEmailVerification();

  Future<void> verifyEmail({
    required String verificationCode,
  });

  Future<void> refreshToken();
}

