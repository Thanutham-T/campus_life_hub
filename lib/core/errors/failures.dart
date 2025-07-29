// Base failure class for error handling in the app
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  
  const Failure(this.message, {this.code});
  
  @override
  List<Object?> get props => [message, code];
}

// Server failure
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

// Cache failure
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

// Network failure  
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}
