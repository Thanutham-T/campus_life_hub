import '../entities/schedule_timeline_entity.dart';
import '../entities/schedule_template_entity.dart';


abstract class ScheduleRepository {
  Future<List<ScheduleTimelineEntity>> getDaySchedule(String userId, DateTime date);
  Future<void> checkInClass(String templateId, String slotId, String logId);
  Future<void> updateClassInfo(String templateId, String slotId, String logId, String newRoom, String newNote);
  Future<List<ScheduleTemplateEntity>> getAllScheduleTemplates(String userId);
}
