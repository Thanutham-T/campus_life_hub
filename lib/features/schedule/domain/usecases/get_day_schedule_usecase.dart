import '../entities/schedule_timeline_entity.dart';
import '../repositories/schedule_repository.dart';


class GetDayScheduleUseCase {
  final ScheduleRepository repo;
  GetDayScheduleUseCase(this.repo);

  Future<List<ScheduleTimelineEntity>> call(String userId, DateTime date) async {
    return await repo.getDaySchedule(userId, date);
  }
}
