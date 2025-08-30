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

  ScheduleTemplateEntity copyWith({
    String? id,
    String? userId,
    String? courseId,
    String? courseCode,
    String? courseNameEng,
    String? courseNameTh,
    String? sectionId,
    String? sectionCode,
    String? instructor,
    DateTime? createdAt,
    List<ScheduleSlotEntity>? slots,
  }) {
    return ScheduleTemplateEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      courseNameEng: courseNameEng ?? this.courseNameEng,
      courseNameTh: courseNameTh ?? this.courseNameTh,
      sectionId: sectionId ?? this.sectionId,
      sectionCode: sectionCode ?? this.sectionCode,
      instructor: instructor ?? this.instructor,
      createdAt: createdAt ?? this.createdAt,
      slots: slots ?? this.slots,
    );
  }
}