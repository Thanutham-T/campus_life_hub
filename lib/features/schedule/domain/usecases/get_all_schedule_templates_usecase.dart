import '../entities/schedule_template_entity.dart';
import '../repositories/schedule_repository.dart';


class GetAllScheduleTemplateUseCase{
  final ScheduleRepository repository;

  GetAllScheduleTemplateUseCase(this.repository);

  Future<List<ScheduleTemplateEntity>> call(String userId) async {
    return await repository.getAllScheduleTemplates(userId);
  }
}
