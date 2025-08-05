import 'package:get_it/get_it.dart';

import '../data/datasources/local/course_local_datasource.dart';
import '../data/repositories/course_repository_impl.dart';
import '../domain/repositories/course_repository.dart';
import '../domain/usecases/get_course_detail.dart';
import '../domain/usecases/get_course_from_search.dart';
import '../domain/usecases/get_course_from_semester.dart';
import '../domain/usecases/get_enrol_course.dart';
import '../domain/usecases/enrol_course.dart';
import '../domain/usecases/withdrawn_course.dart';
import '../presentation/bloc/course_bloc.dart';


final sl = GetIt.instance;

Future<void> registerCourseDI() async {
  // Data Sources
  sl.registerLazySingletonAsync<CourseDataSource>(() async => FakeCourseDataSource());

  // Repositories
  sl.registerLazySingletonAsync<CourseRepository>(() async => CourseRepositoryImpl(await sl.getAsync<CourseDataSource>()));

  // Use Cases
  sl.registerLazySingletonAsync<GetCourseDetail>(() async => GetCourseDetail(await sl.getAsync<CourseRepository>()));
  sl.registerLazySingletonAsync<GetCourseFromSearch>(() async => GetCourseFromSearch(await sl.getAsync<CourseRepository>()));
  sl.registerLazySingletonAsync<GetCourseFromSemester>(() async => GetCourseFromSemester(await sl.getAsync<CourseRepository>()));
  sl.registerLazySingletonAsync<GetEnrolledCourses>(() async => GetEnrolledCourses(await sl.getAsync<CourseRepository>()));
  sl.registerLazySingletonAsync<EnrolCourse>(() async => EnrolCourse(await sl.getAsync<CourseRepository>()));
  sl.registerLazySingletonAsync<WithdrawnCourse>(() async => WithdrawnCourse(await sl.getAsync<CourseRepository>()));

  // Bloc
  sl.registerFactoryAsync<CourseBloc>(() async => CourseBloc(
        getCourseFromSearch: await sl.getAsync<GetCourseFromSearch>(),
        getCourseFromSemester: await sl.getAsync<GetCourseFromSemester>(),
        getCourseDetail: await sl.getAsync<GetCourseDetail>(),
        getEnrolledCourses: await sl.getAsync<GetEnrolledCourses>(),
        enrolCourse: await sl.getAsync<EnrolCourse>(),
        withdrawnCourse: await sl.getAsync<WithdrawnCourse>(),
  ));
}