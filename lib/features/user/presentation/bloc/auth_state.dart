import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final ProfileEntity profile;

  const AuthAuthenticated({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Login specific states
class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final ProfileEntity profile;

  const LoginSuccess({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class LoginFailure extends AuthState {
  final String message;

  const LoginFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Register specific states
class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final ProfileEntity profile;

  const RegisterSuccess({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class RegisterFailure extends AuthState {
  final String message;

  const RegisterFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Profile specific states
class ProfileLoading extends AuthState {}

class ProfileLoaded extends AuthState {
  final ProfileEntity profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateSuccess extends AuthState {
  final ProfileEntity profile;

  const ProfileUpdateSuccess({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileFailure extends AuthState {
  final String message;

  const ProfileFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

