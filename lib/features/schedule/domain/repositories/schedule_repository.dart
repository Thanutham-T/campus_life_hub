import '../entities/schedule_timeline_entity.dart';


abstract class ScheduleRepository {
  Future<List<ScheduleTimelineEntity>> getDaySchedule(String userId, DateTime date);
}
