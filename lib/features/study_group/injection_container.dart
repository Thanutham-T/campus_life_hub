import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

// Domain
import 'domain/repositories/study_group_repository.dart';
import 'domain/repositories/chat_repository.dart';

// Data
import 'data/repositories/study_group_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/datasources/remote/study_group_remote_data_source.dart';
import 'data/datasources/remote/study_group_remote_data_source_impl.dart';
import 'data/datasources/remote/chat_remote_data_source.dart';
import 'data/datasources/remote/chat_remote_data_source_impl.dart';

// Presentation
import 'presentation/bloc/study_group_bloc.dart';
import 'presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

Future<void> initStudyGroupFeature() async {
  // External dependencies
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  }

  // Data sources
  sl.registerLazySingleton<StudyGroupRemoteDataSource>(
    () => StudyGroupRemoteDataSourceImpl(firestore: sl()),
  );
  
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(firestore: sl()),
  );

  // Repositories
  sl.registerLazySingleton<StudyGroupRepository>(
    () => StudyGroupRepositoryImpl(remoteDataSource: sl()),
  );
  
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  // BLoCs
  sl.registerFactory(
    () => StudyGroupBloc(repository: sl()),
  );
  
  sl.registerFactory(
    () => ChatBloc(repository: sl()),
  );
}

// Helper function to clear all study group dependencies
Future<void> resetStudyGroupFeature() async {
  await sl.reset();
}
