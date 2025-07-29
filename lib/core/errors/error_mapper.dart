import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'exceptions.dart';
import 'failures.dart';

class ErrorMapper {
  /// Map exceptions to failures
  static Failure mapExceptionToFailure(Exception exception) {
    switch (exception.runtimeType) {
      case ServerException:
        final serverException = exception as ServerException;
        return ServerFailure(serverException.message, code: serverException.code);
        
      case NetworkException:
        final networkException = exception as NetworkException;
        return NetworkFailure(networkException.message, code: networkException.code);
        
      case CacheException:
        final cacheException = exception as CacheException;
        return CacheFailure(cacheException.message, code: cacheException.code);
        
      case AuthException:
        final authException = exception as AuthException;
        return AuthFailure(authException.message, code: authException.code);
        
      case ValidationException:
        final validationException = exception as ValidationException;
        return ValidationFailure(validationException.message, code: validationException.code);
        
      case PermissionException:
        final permissionException = exception as PermissionException;
        return PermissionFailure(permissionException.message, code: permissionException.code);
        
      case TimeoutException:
        return const TimeoutFailure();
        
      case SocketException:
        return const NetworkFailure('ไม่สามารถเชื่อมต่อเครือข่ายได้');
        
      case FormatException:
        return const ParseFailure('ข้อมูลที่ได้รับไม่ถูกต้อง');
        
      default:
        return const UnknownFailure();
    }
  }
  
  /// Map Firebase Auth exceptions
  static AuthFailure mapFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return const AuthFailure('ไม่พบผู้ใช้งาน');
      case 'wrong-password':
        return const AuthFailure('รหัสผ่านไม่ถูกต้อง');
      case 'email-already-in-use':
        return const AuthFailure('อีเมลนี้ถูกใช้งานแล้ว');
      case 'weak-password':
        return const AuthFailure('รหัสผ่านไม่ปลอดภัย');
      case 'invalid-email':
        return const AuthFailure('รูปแบบอีเมลไม่ถูกต้อง');
      case 'user-disabled':
        return const AuthFailure('บัญชีนี้ถูกระงับการใช้งาน');
      case 'too-many-requests':
        return const AuthFailure('คำขอมากเกินไป กรุณาลองใหม่ภายหลัง');
      case 'operation-not-allowed':
        return const AuthFailure('การดำเนินการนี้ไม่ได้รับอนุญาต');
      case 'network-request-failed':
        return const AuthFailure('ไม่สามารถเชื่อมต่อเครือข่ายได้');
      default:
        return AuthFailure('เกิดข้อผิดพลาด: ${exception.message}');
    }
  }
  
  /// Map HTTP status codes to failures
  static Failure mapHttpStatusToFailure(int statusCode, String message) {
    switch (statusCode) {
      case 400:
        return ValidationFailure('ข้อมูลไม่ถูกต้อง: $message');
      case 401:
        return const AuthFailure('ไม่ได้รับอนุญาต');
      case 403:
        return const PermissionFailure('ไม่มีสิทธิ์เข้าถึง');
      case 404:
        return ServerFailure('ไม่พบข้อมูล: $message');
      case 408:
        return const TimeoutFailure();
      case 422:
        return ValidationFailure('ข้อมูลไม่ผ่านการตรวจสอบ: $message');
      case 429:
        return const ServerFailure('คำขอมากเกินไป กรุณาลองใหม่ภายหลัง');
      case 500:
        return const ServerFailure('เซิร์ฟเวอร์ไม่พร้อมใช้งาน');
      case 502:
        return const ServerFailure('เซิร์ฟเวอร์ไม่สามารถเชื่อมต่อได้');
      case 503:
        return const ServerFailure('เซิร์ฟเวอร์ไม่พร้อมใช้งานชั่วคราว');
      case 504:
        return const TimeoutFailure();
      default:
        return ServerFailure('เกิดข้อผิดพลาดเซิร์ฟเวอร์: $message');
    }
  }
}
