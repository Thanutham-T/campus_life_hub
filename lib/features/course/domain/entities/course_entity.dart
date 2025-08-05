import 'course_section.dart';


class CourseEntity {
  final String id;
  final String code;
  final String name;
  final String description;
  final List<CourseSection> sections;

  CourseEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.sections,
  });
}
