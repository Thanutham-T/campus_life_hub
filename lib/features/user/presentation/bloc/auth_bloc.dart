import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/reset_password.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUser _getCurrentUser;
  final LoginUser _loginUser;
  final RegisterUser _registerUser;
  final LogoutUser _logoutUser;
  final UpdateProfile _updateProfile;
  final ChangePassword _changePassword;
  final ResetPassword _resetPassword;

  AuthBloc({
    required GetCurrentUser getCurrentUser,
    required LoginUser loginUser,
    required RegisterUser registerUser,
    required LogoutUser logoutUser,
    required UpdateProfile updateProfile,
    required ChangePassword changePassword,
    required ResetPassword resetPassword,
  })  : _getCurrentUser = getCurrentUser,
        _loginUser = loginUser,
        _registerUser = registerUser,
        _logoutUser = logoutUser,
        _updateProfile = updateProfile,
        _changePassword = changePassword,
        _resetPassword = resetPassword,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<AuthStatusRequested>(_onAuthStatusRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ProfileRequested>(_onProfileRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<PasswordChangeRequested>(_onPasswordChangeRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _getCurrentUser(NoParams());
    
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (profile) => emit(AuthAuthenticated(profile: profile)),
    );
  }

  Future<void> _onAuthStatusRequested(
    AuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUser(NoParams());
    
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (profile) => emit(AuthAuthenticated(profile: profile)),
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoginLoading());
    
    final result = await _loginUser(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    
    result.fold(
      (failure) => emit(LoginFailure(message: _mapFailureToMessage(failure))),
      (profile) => emit(LoginSuccess(profile: profile)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(RegisterLoading());
    
    final result = await _registerUser(
      RegisterParams(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        studentId: event.studentId,
        department: event.department,
      ),
    );
    
    result.fold(
      (failure) => emit(RegisterFailure(message: _mapFailureToMessage(failure))),
      (profile) => emit(RegisterSuccess(profile: profile)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _logoutUser(NoParams());
    
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProfileLoading());
    
    final result = await _getCurrentUser(NoParams());
    
    result.fold(
      (failure) => emit(ProfileFailure(message: _mapFailureToMessage(failure))),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProfileLoading());
    
    final result = await _updateProfile(
      UpdateProfileParams(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        department: event.department,
        profileImageUrl: event.profileImageUrl,
      ),
    );
    
    result.fold(
      (failure) => emit(ProfileFailure(message: _mapFailureToMessage(failure))),
      (profile) => emit(ProfileUpdateSuccess(profile: profile)),
    );
  }

  Future<void> _onPasswordChangeRequested(
    PasswordChangeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _changePassword(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      ),
    );
    
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) {
        // Get updated profile after password change
        add(ProfileRequested());
      },
    );
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _resetPassword(
      ResetPasswordParams(email: event.email),
    );
    
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        return 'เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ กรุณาลองใหม่อีกครั้ง';
      case CacheFailure _:
        return 'เกิดข้อผิดพลาดในการเข้าถึงข้อมูล';
      case NetworkFailure _:
        return 'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ';
      case ValidationFailure validationFailure:
        return validationFailure.message.isNotEmpty 
            ? validationFailure.message 
            : 'ข้อมูลไม่ถูกต้อง';
      default:
        return 'เกิดข้อผิดพลาดที่ไม่คาดคิด';
    }
  }
}

