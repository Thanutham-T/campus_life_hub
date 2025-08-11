import 'package:get_it/get_it.dart';

// User feature imports
import '../data/datasources/local/auth_local_data_source.dart';
import '../data/datasources/local/auth_local_data_source_impl.dart';
import '../data/datasources/remote/auth_remote_data_source.dart';
import '../data/datasources/remote/auth_remote_data_source_impl.dart';
import '../data/datasources/remote/firestore_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_current_user.dart';
import '../domain/usecases/login_user.dart';
import '../domain/usecases/register_user.dart';
import '../domain/usecases/logout_user.dart';
import '../domain/usecases/update_profile.dart';
import '../domain/usecases/change_password.dart';
import '../domain/usecases/reset_password.dart';
import '../presentation/bloc/auth_bloc.dart';


/// User Feature Dependency Injection
Future<void> registerUserDI(GetIt sl) async {
  // Data sources (bottom layer)
  sl.registerLazySingleton<FirestoreDataSource>(
    () => FirestoreDataSourceImpl(),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl.get(),
      firestoreDataSource: sl.get<FirestoreDataSource>(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl.get(),
    ),
  );

  // Repository (middle layer)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl.get<AuthRemoteDataSource>(),
      localDataSource: sl.get<AuthLocalDataSource>(),
    ),
  );

  // Use cases (top layer)
  sl.registerLazySingleton<GetCurrentUser>(
    () => GetCurrentUser(sl.get<AuthRepository>()),
  );
  sl.registerLazySingleton<LoginUser>(
    () => LoginUser(sl.get<AuthRepository>()),
  );
  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(sl.get<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUser>(
    () => LogoutUser(sl.get<AuthRepository>()),
  );
  sl.registerLazySingleton<UpdateProfile>(
    () => UpdateProfile(sl.get<AuthRepository>()),
  );
  sl.registerLazySingleton<ChangePassword>(
    () => ChangePassword(sl.get<AuthRepository>()),
  );
  sl.registerLazySingleton<ResetPassword>(
    () => ResetPassword(sl.get<AuthRepository>()),
  );

  // Bloc (presentation layer)
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      getCurrentUser: sl.get<GetCurrentUser>(),
      loginUser: sl.get<LoginUser>(),
      registerUser: sl.get<RegisterUser>(),
      logoutUser: sl.get<LogoutUser>(),
      updateProfile: sl.get<UpdateProfile>(),
      changePassword: sl.get<ChangePassword>(),
      resetPassword: sl.get<ResetPassword>(),
    ),
  );
}

