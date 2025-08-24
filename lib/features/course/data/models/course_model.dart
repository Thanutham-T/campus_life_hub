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

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    return CourseModel(
      id: map['id'],
      code: map['code'],
      nameEn: map['nameEn'],
      nameTh: map['nameTh'],
      description: map['description'],
      credit: map['credit'],
      sections: (map['sections'] as List? ?? [])
          .map((e) => CourseSectionModel.fromAny(e))
          .toList(),
      semester: map['semester'] as String,
    );
  }

  CourseModel copyWith({
    String? id,
    String? code,
    String? nameEn,
    String? nameTh,
    String? description,
    int? credit,
    List<CourseSection>? sections,
    String? semester,
  }) {
    return CourseModel(
      id: id ?? this.id,
      code: code ?? this.code,
      nameEn: nameEn ?? this.nameEn,
      nameTh: nameTh ?? this.nameTh,
      description: description ?? this.description,
      credit: credit ?? this.credit,
      sections: sections ?? this.sections,
      semester: semester ?? this.semester,
    );
  }
}

class CourseSectionModel extends CourseSection {
  CourseSectionModel({
    required super.id,
    required super.sectionCode,
    required super.instructor,
    required super.schedules,
  });

  factory CourseSectionModel.fromAny(dynamic json) {
    if (json is CourseSectionModel) return json;
    if (json is CourseSection) return CourseSectionModel.fromEntity(json);
    final map = Map<String, dynamic>.from(json as Map);
    return CourseSectionModel(
      id: map['id'],
      sectionCode: map['sectionCode'],
      instructor: List<String>.from(map['instructor'] ?? []),
      schedules: (map['schedules'] as List? ?? [])
          .map((e) => SectionScheduleModel.fromAny(e))
          .toList(),
    );
  }

  factory CourseSectionModel.fromEntity(CourseSection e) => CourseSectionModel(
        id: e.id,
        sectionCode: e.sectionCode,
        instructor: e.instructor,
        schedules: e.schedules
            .map((s) => s is SectionScheduleModel
                ? s
                : SectionScheduleModel.fromEntity(s))
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

  factory SectionScheduleModel.fromAny(dynamic json) {
    if (json is SectionScheduleModel) return json;
    if (json is SectionSchedule) return SectionScheduleModel.fromEntity(json);
    final map = Map<String, dynamic>.from(json as Map);
    return SectionScheduleModel(
      dayOfWeek: map['dayOfWeek'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      room: map['room'],
    );
  }

  factory SectionScheduleModel.fromEntity(SectionSchedule e) =>
      SectionScheduleModel(
        dayOfWeek: e.dayOfWeek,
        startTime: e.startTime,
        endTime: e.endTime,
        room: e.room,
      );
}