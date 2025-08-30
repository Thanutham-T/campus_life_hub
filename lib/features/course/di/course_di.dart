import 'package:get_it/get_it.dart';

// import '../data/datasources/local/course_local_datasource.dart';
import '../data/datasources/remote/course_remote_firestore.dart';

import '../data/repositories/course_repository_impl.dart';
import '../domain/repositories/course_repository.dart';

import '../domain/usecases/get_course_detail.dart';
import '../domain/usecases/get_course_from_semester.dart';
import '../domain/usecases/get_enroll_course.dart';
import '../domain/usecases/enroll_course.dart';
import '../domain/usecases/withdrawn_course.dart';
import '../domain/usecases/get_courses_with_enroll_status.dart';

import '../presentation/bloc/course_bloc.dart';


Future<void> registerCourseDI(GetIt sl) async {
  // Data Sources
  // sl.registerLazySingletonAsync<CourseDataSource>(() async => FakeCourseDataSource());
  sl.registerLazySingletonAsync<CourseDataSource>(() async => CourseRemoteFirestore());

  // Repositories
  sl.registerLazySingletonAsync<CourseRepository>(() async => CourseRepositoryImpl(await sl.getAsync<CourseDataSource>()));

  // Use Cases
  sl.registerLazySingletonAsync<GetCourseDetail>(() async => GetCourseDetail(await sl.getAsync<CourseRepository>()));
  sl.registerLazySingletonAsync<GetCourseFromSemester>(() async => GetCourseFromSemester(await sl.getAsync<CourseRepository>()));
  sl.registerLazySingletonAsync<GetEnrolledCourses>(() async => GetEnrolledCourses(await sl.getAsync<CourseRepository>()));
  sl.registerLazySingletonAsync<EnrollCourse>(() async => EnrollCourse(await sl.getAsync<CourseRepository>()));
  sl.registerLazySingletonAsync<WithdrawnCourse>(() async => WithdrawnCourse(await sl.getAsync<CourseRepository>()));
  sl.registerLazySingletonAsync<GetCoursesWithEnrollStatus>(() async => GetCoursesWithEnrollStatus(await sl.getAsync<CourseRepository>()));

  // Bloc
  sl.registerFactoryAsync<CourseBloc>(() async => CourseBloc(
        getCourseFromSemester: await sl.getAsync<GetCourseFromSemester>(),
        getCourseDetail: await sl.getAsync<GetCourseDetail>(),
        getEnrolledCourses: await sl.getAsync<GetEnrolledCourses>(),
        enrollCourse: await sl.getAsync<EnrollCourse>(),
        withdrawnCourse: await sl.getAsync<WithdrawnCourse>(),
        getCourseWithEnrollStatus: await sl.getAsync<GetCoursesWithEnrollStatus>(),
  ));
}