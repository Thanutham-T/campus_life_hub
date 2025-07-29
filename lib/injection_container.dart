import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// User feature
import 'features/user/data/datasources/auth_local_data_source.dart';
import 'features/user/data/datasources/auth_local_data_source_impl.dart';
import 'features/user/data/datasources/auth_remote_data_source.dart';
import 'features/user/data/datasources/auth_remote_data_source_impl.dart';
import 'features/user/data/repositories/auth_repository_impl.dart';
import 'features/user/domain/repositories/auth_repository.dart';
import 'features/user/domain/usecases/get_current_user.dart';
import 'features/user/domain/usecases/login_user.dart';
import 'features/user/domain/usecases/register_user.dart';
import 'features/user/domain/usecases/logout_user.dart';
import 'features/user/domain/usecases/update_profile.dart';
import 'features/user/domain/usecases/change_password.dart';
import 'features/user/domain/usecases/reset_password.dart';
import 'features/user/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - User
  await _initUser();

  //! Core
  await _initCore();

  //! External
  await _initExternal();
}

Future<void> _initUser() async {
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      getCurrentUser: sl(),
      loginUser: sl(),
      registerUser: sl(),
      logoutUser: sl(),
      updateProfile: sl(),
      changePassword: sl(),
      resetPassword: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
}

Future<void> _initCore() async {
  // Core utilities, constants, etc.
  // Add any core dependencies here
}

Future<void> _initExternal() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Firebase Auth
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
