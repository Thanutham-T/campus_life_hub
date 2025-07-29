import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  
  const Failure(this.message, {this.code});
  
  @override
  List<Object?> get props => [message, code];
}

/// Server failure
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Permission failure
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.code});
}

/// Timeout failure
class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('หมดเวลาการเชื่อมต่อ');
}

/// Parse failure
class ParseFailure extends Failure {
  const ParseFailure(super.message, {super.code});
}

/// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure() : super('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ');
}
