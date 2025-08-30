import '../entities/schedule_slot_entity.dart';


class ScheduleTemplateEntity {
  final String id;
  final String userId;
  final String courseId;
  final String courseCode;
  final String courseNameEng;
  final String courseNameTh;
  final String sectionId;
  final String sectionCode;
  final String instructor;
  final DateTime createdAt;
  final List<ScheduleSlotEntity> slots; // list of slots for this template

  ScheduleTemplateEntity({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseCode,
    required this.courseNameEng,
    required this.courseNameTh,
    required this.sectionId,
    required this.sectionCode,
    required this.instructor,
    required this.createdAt,
    this.slots = const [],
  });
}