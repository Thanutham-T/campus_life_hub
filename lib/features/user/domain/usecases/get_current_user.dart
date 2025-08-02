import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<ProfileEntity, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

