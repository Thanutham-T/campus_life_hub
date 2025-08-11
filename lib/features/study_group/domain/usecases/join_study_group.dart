import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/study_group_repository.dart';

class JoinStudyGroup implements UseCase<void, JoinStudyGroupParams> {
  final StudyGroupRepository repository;

  JoinStudyGroup(this.repository);

  @override
  Future<Either<Failure, void>> call(JoinStudyGroupParams params) async {
    try {
      await repository.joinStudyGroup(params.groupId, params.userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class JoinStudyGroupParams extends Equatable {
  final String groupId;
  final String userId;

  const JoinStudyGroupParams({
    required this.groupId,
    required this.userId,
  });

  @override
  List<Object> get props => [groupId, userId];
}
