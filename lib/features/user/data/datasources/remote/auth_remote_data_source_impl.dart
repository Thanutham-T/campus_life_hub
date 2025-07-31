import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/core.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../models/profile_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
  });

  @override
  Future<ProfileModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const ServerFailure('การเข้าสู่ระบบล้มเหลว');
      }

      return _mapFirebaseUserToProfile(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw const ServerFailure('เกิดข้อผิดพลาดที่ไม่คาดคิด');
    }
  }

  @override
  Future<ProfileModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? studentId,
    String? department,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const ServerFailure('การสร้างบัญชีล้มเหลว');
      }

      // Update display name in Firebase
      await credential.user!.updateDisplayName('$firstName $lastName');

      return _mapFirebaseUserToProfile(
        credential.user!,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        studentId: studentId,
        department: department,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw const ServerFailure('เกิดข้อผิดพลาดที่ไม่คาดคิด');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw const ServerFailure('เกิดข้อผิดพลาดในการออกจากระบบ');
    }
  }

  @override
  Future<ProfileModel> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const ServerFailure('ไม่พบผู้ใช้ที่เข้าสู่ระบบ');
      }

      return _mapFirebaseUserToProfile(currentUser);
    } catch (e) {
      throw const ServerFailure('เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้');
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? department,
    String? profileImageUrl,
  }) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const ServerFailure('ไม่พบผู้ใช้ที่เข้าสู่ระบบ');
      }

      // Update display name and photo URL in Firebase
      await currentUser.updateDisplayName('$firstName $lastName');
      if (profileImageUrl != null) {
        await currentUser.updatePhotoURL(profileImageUrl);
      }

      return _mapFirebaseUserToProfile(
        currentUser,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        department: department,
        profileImageUrl: profileImageUrl,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw const ServerFailure('เกิดข้อผิดพลาดในการอัปเดตโปรไฟล์');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const ServerFailure('ไม่พบผู้ใช้ที่เข้าสู่ระบบ');
      }

      // Re-authenticate user before changing password
      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );

      await currentUser.reauthenticateWithCredential(credential);
      await currentUser.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw const ServerFailure('เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw const ServerFailure('เกิดข้อผิดพลาดในการส่งอีเมลรีเซ็ตรหัสผ่าน');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const ServerFailure('ไม่พบผู้ใช้ที่เข้าสู่ระบบ');
      }

      await currentUser.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw const ServerFailure('เกิดข้อผิดพลาดในการส่งอีเมลยืนยัน');
    }
  }

  @override
  Future<void> verifyEmail({required String verificationCode}) async {
    try {
      await firebaseAuth.applyActionCode(verificationCode);
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw const ServerFailure('เกิดข้อผิดพลาดในการยืนยันอีเมล');
    }
  }

  @override
  Future<void> refreshToken() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        await currentUser.getIdToken(true); // Force refresh
      }
    } catch (e) {
      throw const ServerFailure('เกิดข้อผิดพลาดในการรีเฟรชโทเค็น');
    }
  }

  // Helper method to map Firebase User to ProfileModel
  ProfileModel _mapFirebaseUserToProfile(
    User user, {
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? studentId,
    String? department,
    String? profileImageUrl,
  }) {
    // Split display name if available
    final displayName = user.displayName ?? '';
    final nameParts = displayName.split(' ');
    final defaultFirstName = nameParts.isNotEmpty ? nameParts.first : '';
    final defaultLastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

    return ProfileModel(
      id: user.uid,
      email: user.email ?? '',
      firstName: firstName ?? defaultFirstName,
      lastName: lastName ?? defaultLastName,
      phoneNumber: phoneNumber ?? user.phoneNumber,
      profileImageUrl: profileImageUrl ?? user.photoURL,
      department: department,
      studentId: studentId,
      role: UserRole.student, // Default role
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'ไม่พบผู้ใช้นี้ในระบบ';
      case 'wrong-password':
        return 'รหัสผ่านไม่ถูกต้อง';
      case 'email-already-in-use':
        return 'อีเมลนี้ถูกใช้งานแล้ว';
      case 'weak-password':
        return 'รหัสผ่านไม่แข็งแรงพอ';
      case 'invalid-email':
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      case 'user-disabled':
        return 'บัญชีผู้ใช้นี้ถูกระงับ';
      case 'too-many-requests':
        return 'มีการพยายามเข้าสู่ระบบมากเกินไป กรุณาลองใหม่ภายหลัง';
      case 'operation-not-allowed':
        return 'การดำเนินการนี้ไม่ได้รับอนุญาต';
      case 'requires-recent-login':
        return 'กรุณาเข้าสู่ระบบใหม่เพื่อทำการนี้';
      default:
        return 'เกิดข้อผิดพลาดจาก Firebase: $errorCode';
    }
  }
}
