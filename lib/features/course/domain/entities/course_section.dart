import 'section_schedule.dart';


class CourseSection {
  final String id;
  final String sectionCode;
  final String instructor;
  final bool isEnrolled;
  final List<SectionSchedule> schedules;

  CourseSection({
    required this.id,
    required this.sectionCode,
    required this.instructor,
    required this.schedules,
    this.isEnrolled = false,
  });

  CourseSection copyWith({
    String? id,
    String? sectionCode,
    String? instructor,
    List<SectionSchedule>? schedules,
    bool? isEnrolled,
  }) {
    return CourseSection(
      id: id ?? this.id,
      sectionCode: sectionCode ?? this.sectionCode,
      instructor: instructor ?? this.instructor,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      schedules: schedules ?? this.schedules,
    );
  }
}
