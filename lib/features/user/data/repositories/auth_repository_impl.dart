import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ProfileEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final profileModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      
      // Cache the user data locally
      await localDataSource.cacheUser(profileModel);
      
      return Right(profileModel);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ServerFailure('เกิดข้อผิดพลาดในการเข้าสู่ระบบ'));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? studentId,
    String? department,
  }) async {
    try {
      final profileModel = await remoteDataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        studentId: studentId,
        department: department,
      );
      
      // Cache the user data locally
      await localDataSource.cacheUser(profileModel);
      
      return Right(profileModel);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ServerFailure('เกิดข้อผิดพลาดในการสร้างบัญชี'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearAllData();
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ServerFailure('เกิดข้อผิดพลาดในการออกจากระบบ'));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getCurrentUser() async {
    try {
      // Try to get from cache first
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }
      
      // If not in cache, get from remote
      final profileModel = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(profileModel);
      return Right(profileModel);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ServerFailure('เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้'));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? department,
    String? profileImageUrl,
  }) async {
    try {
      final profileModel = await remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        department: department,
        profileImageUrl: profileImageUrl,
      );
      
      // Update cache
      await localDataSource.cacheUser(profileModel);
      
      return Right(profileModel);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ServerFailure('เกิดข้อผิดพลาดในการอัปเดตโปรไฟล์'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ServerFailure('เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await remoteDataSource.resetPassword(email: email);
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ServerFailure('เกิดข้อผิดพลาดในการรีเซ็ตรหัสผ่าน'));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ServerFailure('เกิดข้อผิดพลาดในการส่งอีเมลยืนยัน'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String verificationCode,
  }) async {
    try {
      await remoteDataSource.verifyEmail(verificationCode: verificationCode);
      return const Right(null);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(ServerFailure('เกิดข้อผิดพลาดในการยืนยันอีเมล'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      return const Left(CacheFailure('เกิดข้อผิดพลาดในการตรวจสอบสถานะการเข้าสู่ระบบ'));
    }
  }

  @override
  Future<Either<Failure, void>> clearLocalData() async {
    try {
      await localDataSource.clearAllData();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('เกิดข้อผิดพลาดในการล้างข้อมูลท้องถิ่น'));
    }
  }
}
