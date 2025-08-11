import 'course_section.dart';


class CourseEntity {
  final String id;
  final String code;
  final String nameEn;
  final String nameTh;
  final String description;
  final int credit;
  final List<CourseSection> sections;

  CourseEntity({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameTh,
    required this.description,
    required this.credit,
    required this.sections,
  });
}
