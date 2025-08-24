class ScheduleLogEntity {
  final String id;
  final String courseId;
  final String courseNameEng;
  final String courseNameTh;
  final String status;       // "present", "absent", "late"
  final DateTime date;       // วันจริงของ log
  final DateTime? checkInAt; // เวลาเช็คชื่อจริง
  final String? note;

  ScheduleLogEntity({
    required this.id,
    required this.courseId,
    required this.courseNameEng,
    required this.courseNameTh,
    required this.status,
    required this.date,
    this.checkInAt,
    this.note,
  });
}