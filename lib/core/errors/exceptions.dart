/// Base exception class for the app
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, {this.code});
  
  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Server related exceptions
class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

/// Cache-related exceptions  
class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException() : super('อีเมลหรือรหัสผ่านไม่ถูกต้อง');
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException() : super('ไม่พบผู้ใช้งาน');
}

class EmailAlreadyExistsException extends AuthException {
  const EmailAlreadyExistsException() : super('อีเมลนี้ถูกใช้งานแล้ว');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException() : super('รหัสผ่านไม่ปลอดภัย');
}

class InvalidEmailException extends AuthException {
  const InvalidEmailException() : super('รูปแบบอีเมลไม่ถูกต้อง');
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code});
}

/// Timeout exceptions
class TimeoutException extends AppException {
  const TimeoutException() : super('หมดเวลาการเชื่อมต่อ');
}

/// Parse exceptions
class ParseException extends AppException {
  const ParseException(super.message, {super.code});
}
