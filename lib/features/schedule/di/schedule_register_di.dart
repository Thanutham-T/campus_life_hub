import 'package:get_it/get_it.dart';

// import '../data/datasources/local/course_local_datasource.dart';
import '../data/datasources/remotes/schedule_remote_firestore.dart';

import '../data/repositories/schedule_repository_impl.dart';
import '../domain/repositories/schedule_repository.dart';

import '../domain/usecases/get_today_schedule_usecase.dart';
import '../domain/usecases/get_day_schedule_usecase.dart';

import '../presentation/bloc/schedule_bloc.dart';


Future<void> registerScheduleDI(GetIt sl) async {
  // Data Sources
  // sl.registerLazySingletonAsync<CourseDataSource>(() async => FakeCourseDataSource());
  sl.registerLazySingletonAsync<ScheduleRemoteDataSource>(() async => ScheduleRemoteFirestoreImpl());

  // Repositories
  sl.registerLazySingletonAsync<ScheduleRepository>(() async => ScheduleRepositoryImpl(await sl.getAsync<ScheduleRemoteDataSource>()));

  // Use Cases
  sl.registerLazySingletonAsync<GetTodayScheduleUseCase>(() async => GetTodayScheduleUseCase(await sl.getAsync<ScheduleRepository>()));
  sl.registerLazySingletonAsync<GetDayScheduleUseCase>(() async => GetDayScheduleUseCase(await sl.getAsync<ScheduleRepository>()));

  // Bloc
  sl.registerFactoryAsync<ScheduleBloc>(() async => ScheduleBloc(
        getTodaySchedule: await sl.getAsync<GetTodayScheduleUseCase>(),
        getDaySchedule: await sl.getAsync<GetDayScheduleUseCase>(),
      ));
}