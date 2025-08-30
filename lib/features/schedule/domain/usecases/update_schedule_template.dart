import '../repositories/schedule_repository.dart';
import '../entities/schedule_slot_entity.dart';


class UpdateScheduleTemplateUseCase {
  final ScheduleRepository repository;

  UpdateScheduleTemplateUseCase(this.repository);

  Future<void> call(String templateId, List<ScheduleSlotEntity> newSlots) async {
    await repository.updateScheduleTemplate(templateId, newSlots);
  }
}