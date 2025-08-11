import 'package:campus_life_hub/features/course/domain/entities/course_entity.dart';
import 'package:campus_life_hub/features/course/domain/entities/course_section.dart';
import 'package:campus_life_hub/features/course/domain/entities/section_schedule.dart';


class CourseModel extends CourseEntity {

  final String semester;

  CourseModel({
    required super.id,
    required super.code,
    required super.nameEn,
    required super.nameTh,
    required super.description,
    required super.credit,
    required super.sections,
    required this.semester,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json['id'],
        code: json['code'],
        nameEn: json['nameEn'],
        nameTh: json['nameTh'],
        description: json['description'],
        credit: json['credit'],
        sections: (json['sections'] as List)
            .map((e) => CourseSectionModel.fromJson(e) as CourseSection)
            .toList(),
        semester: json['semester'] as String,
      );
}

class CourseSectionModel extends CourseSection {
  CourseSectionModel({
    required super.id,
    required super.sectionCode,
    required super.instructor,
    required super.schedules,
  });

  factory CourseSectionModel.fromJson(Map<String, dynamic> json) => CourseSectionModel(
        id: json['id'],
        sectionCode: json['sectionCode'],
        instructor: json['instructor'],
        schedules: (json['schedules'] as List)
            .map((e) => SectionScheduleModel.fromJson(e))
            .toList(),
      );
}

class SectionScheduleModel extends SectionSchedule {
  SectionScheduleModel({
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
    required super.room,
  });

  factory SectionScheduleModel.fromJson(Map<String, dynamic> json) => SectionScheduleModel(
        dayOfWeek: json['dayOfWeek'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        room: json['room'],
      );
}