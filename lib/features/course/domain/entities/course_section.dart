import 'section_schedule.dart';


class CourseSection {
  final String id;
  final String sectionCode;
  final String instructor;
  final List<SectionSchedule> schedules;

  CourseSection({
    required this.id,
    required this.sectionCode,
    required this.instructor,
    required this.schedules,
  });
}
