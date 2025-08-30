class ScheduleLogEntity {
  final String templateId;
  final String slotId;
  final String logId;

  final String courseId;
  final String courseNameEng;
  final String courseNameTh;
  final String status;       // "present", "absent", "late"
  final DateTime date;       // วันจริงของ log
  final DateTime? checkInAt; // เวลาเช็คชื่อจริง
  final String? note;

  ScheduleLogEntity({
    required this.templateId,
    required this.slotId,
    required this.logId,
    
    required this.courseId,
    required this.courseNameEng,
    required this.courseNameTh,
    required this.status,
    required this.date,
    this.checkInAt,
    this.note,
  });
}