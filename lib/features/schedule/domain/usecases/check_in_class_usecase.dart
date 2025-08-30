import '../repositories/schedule_repository.dart';


class CheckInClassUseCase {
  final ScheduleRepository repo;

  CheckInClassUseCase(this.repo);

  Future<void> call(String templateId, String slotId, String logId) async {
    return await repo.checkInClass(templateId, slotId, logId);
  }
}
