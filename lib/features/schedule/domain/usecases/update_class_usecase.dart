import '../repositories/schedule_repository.dart';


class UpdateClassUseCase {
  final ScheduleRepository repo;

  UpdateClassUseCase(this.repo);

  Future<void> call(String templateId, String slotId, String logId, String newRoom, String newNote) async {
    return await repo.updateClassInfo(templateId, slotId, logId, newRoom, newNote);
  }
}
