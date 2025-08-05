import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Feature DI imports
import '../../features/user/di/injector.dart';
import '../../features/course/di/course_di.dart';

final sl = GetIt.instance;

/// Main dependency injection initialization
Future<void> init() async {
  //! Features
  await _initFeatures();

  //! Core
  await _initCore();

  //! External
  await _initExternal();
}

/// Initialize all features
Future<void> _initFeatures() async {
  // User feature
  await registerUserDI(sl);
  
  // Course feature
  await registerCourseDI();
  
  // Add other features here in the future
  // await initDashboardFeature(sl);
  // await initScheduleFeature(sl);
}

/// Initialize core dependencies
Future<void> _initCore() async {
  // Core utilities, constants, etc.
  // Add any core dependencies here
}

/// Initialize external dependencies
Future<void> _initExternal() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Firebase Auth
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
