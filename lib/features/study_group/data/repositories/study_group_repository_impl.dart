import 'package:dartz/dartz.dart';
import '../../domain/entities/study_group.dart';
import '../../domain/repositories/study_group_repository.dart';
import '../datasources/remote/study_group_remote_data_source.dart';
import '../models/study_group_model.dart';

class StudyGroupRepositoryImpl implements StudyGroupRepository {
  final StudyGroupRemoteDataSource remoteDataSource;

  StudyGroupRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Either<String, List<StudyGroup>>> getStudyGroups() async* {
    try {
      yield* remoteDataSource.getStudyGroups().map((models) =>
          Right(models.map((model) => model.toDomain()).toList()));
    } catch (e) {
      yield Left('Failed to get study groups: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, StudyGroup?>> getStudyGroupById(String id) async {
    try {
      final model = await remoteDataSource.getStudyGroupById(id);
      return Right(model?.toDomain());
    } catch (e) {
      return Left('Failed to get study group: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> createStudyGroup(StudyGroup studyGroup) async {
    try {
      final model = StudyGroupModel.fromDomain(studyGroup);
      final id = await remoteDataSource.createStudyGroup(model);
      return Right(id);
    } catch (e) {
      return Left('Failed to create study group: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> updateStudyGroup(StudyGroup studyGroup) async {
    try {
      final model = StudyGroupModel.fromDomain(studyGroup);
      await remoteDataSource.updateStudyGroup(model);
      return const Right(null);
    } catch (e) {
      return Left('Failed to update study group: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteStudyGroup(String id) async {
    try {
      await remoteDataSource.deleteStudyGroup(id);
      return const Right(null);
    } catch (e) {
      return Left('Failed to delete study group: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> joinStudyGroup(String groupId, String userId) async {
    try {
      await remoteDataSource.joinStudyGroup(groupId, userId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to join study group: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> leaveStudyGroup(String groupId, String userId) async {
    try {
      await remoteDataSource.leaveStudyGroup(groupId, userId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to leave study group: ${e.toString()}');
    }
  }

  @override
  Stream<Either<String, List<StudyGroup>>> getStudyGroupsByCategory(String category) async* {
    try {
      yield* remoteDataSource.getStudyGroupsByCategory(category).map((models) =>
          Right(models.map((model) => model.toDomain()).toList()));
    } catch (e) {
      yield Left('Failed to get study groups by category: ${e.toString()}');
    }
  }

  @override
  Stream<Either<String, List<StudyGroup>>> getUserStudyGroups(String userId) async* {
    try {
      yield* remoteDataSource.getUserStudyGroups(userId).map((models) =>
          Right(models.map((model) => model.toDomain()).toList()));
    } catch (e) {
      yield Left('Failed to get user study groups: ${e.toString()}');
    }
  }

  @override
  Stream<Either<String, List<StudyGroup>>> searchStudyGroups(String query) async* {
    try {
      yield* remoteDataSource.searchStudyGroups(query).map((models) =>
          Right(models.map((model) => model.toDomain()).toList()));
    } catch (e) {
      yield Left('Failed to search study groups: ${e.toString()}');
    }
  }
}
