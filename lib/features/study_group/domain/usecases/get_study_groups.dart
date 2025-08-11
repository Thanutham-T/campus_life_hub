import 'package:dartz/dartz.dart';
import '../entities/study_group.dart';
import '../repositories/study_group_repository.dart';

class GetStudyGroups {
  final StudyGroupRepository repository;

  GetStudyGroups(this.repository);

  Future<Either<String, Stream<Either<String, List<StudyGroup>>>>> call() async {
    try {
      final stream = repository.getStudyGroups();
      return Right(stream);
    } catch (e) {
      return Left('Failed to get study groups: ${e.toString()}');
    }
  }
}
