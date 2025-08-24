import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Feature DI imports
import '../../core/services/key_value_storage_service.dart';
import '../../features/user/di/auth_di.dart';
import '../../features/course/di/course_di.dart';
import '../../features/study_group/injection_container.dart';
import '../../features/schedule/di/schedule_register_di.dart';


final sl = GetIt.instance;

/// Main dependency injection initialization
Future<void> initCriticalServices() async {
  await registerLocalStorageDI(sl);

  //! External
  await _initExternal();
}

Future<void> initNonCriticalServices() async {
  await registerUserDI(sl);
  await registerCourseDI(sl);
  await initStudyGroupFeature();
  await registerScheduleDI(sl);
}

/// Initialize external dependencies
Future<void> _initExternal() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Firebase Auth
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
