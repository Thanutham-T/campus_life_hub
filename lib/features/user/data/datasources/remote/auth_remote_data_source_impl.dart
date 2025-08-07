import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/core_modules.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../models/profile_model.dart';
import 'auth_remote_data_source.dart';
import 'firestore_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirestoreDataSource firestoreDataSource;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestoreDataSource,
  });

  @override
  Future<ProfileModel> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 AuthRemoteDataSource: Logging in user: $email');
      
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const ServerFailure('การเข้าสู่ระบบล้มเหลว');
      }

      final user = credential.user!;
      print('✅ AuthRemoteDataSource: Firebase login successful for user: ${user.uid}');

      // ดึงข้อมูลจาก Firestore
      final profile = await firestoreDataSource.getUserProfile(user.uid);
      
      if (profile != null) {
        print('✅ AuthRemoteDataSource: Profile loaded from Firestore');
        return profile;
      }

      print('⚠️ AuthRemoteDataSource: No profile found in Firestore, creating basic profile');
      throw const ServerFailure('ไม่พบข้อมูลโปรไฟล์ในระบบ');
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
    required String phoneNumber,
    required String studentId,
    required String department,
    required String educationLevel,
    required String campus,
    required String faculty,
    required String major,
    required String curriculum,
  }) async {
    try {
      print('📝 AuthRemoteDataSource: Registering new user: $email');
      
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const ServerFailure('การสร้างบัญชีล้มเหลว');
      }

      final user = credential.user!;
      print('✅ AuthRemoteDataSource: Firebase Auth account created: ${user.uid}');

      // Update display name in Firebase
      await user.updateDisplayName('$firstName $lastName');

      // Create profile model with all registration data
      final profile = ProfileModel(
        id: user.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        profileImageUrl: null,
        department: department,
        studentId: studentId,
        educationLevel: educationLevel,
        campus: campus,
        faculty: faculty,
        major: major,
        curriculum: curriculum,
        role: UserRole.student,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print('💾 AuthRemoteDataSource: Saving profile to Firestore...');
      print('   - Name: $firstName $lastName');
      print('   - Student ID: $studentId');
      print('   - Faculty: $faculty');
      print('   - Major: $major');

      // Save complete profile to Firestore
      await firestoreDataSource.saveUserProfile(profile);
      print('✅ AuthRemoteDataSource: Profile saved to Firestore successfully');

      return profile;
    } on FirebaseAuthException catch (e) {
      throw ServerFailure(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw ServerFailure('เกิดข้อผิดพลาดที่ไม่คาดคิด: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      print('👋 AuthRemoteDataSource: Logging out user');
      await firebaseAuth.signOut();
      print('✅ AuthRemoteDataSource: Logout successful');
    } on FirebaseAuthException catch (e) {
      print('❌ AuthRemoteDataSource: Logout error: ${e.code}');
      throw ServerFailure(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      print('❌ AuthRemoteDataSource: Unexpected logout error: $e');
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

      print('🔍 AuthRemoteDataSource: Getting current user profile');
      print('   - User ID: ${currentUser.uid}');
      print('   - Email: ${currentUser.email}');
      
      // ดึงข้อมูลจาก Firestore เท่านั้น
      final profile = await firestoreDataSource.getUserProfile(currentUser.uid);
      
      if (profile != null) {
        print('✅ AuthRemoteDataSource: Profile loaded from Firestore');
        print('   - Name: ${profile.firstName} ${profile.lastName}');
        print('   - Student ID: ${profile.studentId}');
        print('   - Faculty: ${profile.faculty}');
        return profile;
      }

      print('❌ AuthRemoteDataSource: No profile found in Firestore');
      throw const ServerFailure('ไม่พบข้อมูลโปรไฟล์ในระบบ กรุณาติดต่อผู้ดูแลระบบ');
    } catch (e) {
      print('AuthRemoteDataSource: Error in getCurrentUser: $e');
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

      print('🔄 AuthRemoteDataSource: Updating profile for user: ${currentUser.uid}');

      // Update display name in Firebase
      await currentUser.updateDisplayName('$firstName $lastName');
      if (profileImageUrl != null) {
        await currentUser.updatePhotoURL(profileImageUrl);
      }

      // Update profile in Firestore
      final updateData = <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (department != null) updateData['department'] = department;
      if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;

      await firestoreDataSource.updateUserProfile(currentUser.uid, updateData);
      print('✅ AuthRemoteDataSource: Profile updated in Firestore');

      // ดึงข้อมูลล่าสุดจาก Firestore
      final updatedProfile = await firestoreDataSource.getUserProfile(currentUser.uid);
      if (updatedProfile == null) {
        throw const ServerFailure('ไม่สามารถดึงข้อมูลที่อัปเดตได้');
      }

      return updatedProfile;
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
