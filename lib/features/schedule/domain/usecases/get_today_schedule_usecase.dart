import '../entities/schedule_timeline_entity.dart';
import '../repositories/schedule_repository.dart';


class GetTodayScheduleUseCase {
  final ScheduleRepository repo;
  GetTodayScheduleUseCase(this.repo);

  Future<List<ScheduleTimelineEntity>> call(String userId) async {
    return await repo.getDaySchedule(userId, DateTime.now());
  }
}
