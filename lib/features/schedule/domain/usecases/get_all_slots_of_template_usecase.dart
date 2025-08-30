import '../entities/schedule_slot_entity.dart';
import '../repositories/schedule_repository.dart';


class GetAllSlotsOfTemplateUseCase {
  final ScheduleRepository repository;

  GetAllSlotsOfTemplateUseCase(this.repository);

  Future<List<ScheduleSlotEntity>> call(String templateId) async {
    return await repository.getSlotsOfTemplate(templateId);
  }
}