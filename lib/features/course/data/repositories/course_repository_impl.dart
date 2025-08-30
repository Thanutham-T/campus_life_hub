import 'package:campus_life_hub/core/core_modules.dart';

import 'package:campus_life_hub/features/course/domain/entities/course_entity.dart';
import 'package:campus_life_hub/features/course/domain/repositories/course_repository.dart';

import '../datasources/remote/course_remote_firestore.dart';


class CourseRepositoryImpl implements CourseRepository {
  final CourseDataSource dataSource;
  CourseRepositoryImpl(this.dataSource);

  @override
  Future<List<CourseEntity>> getCoursesFromSemester(String semester) async => await dataSource.fetchCoursesFromSemester(semester);

  @override
  Future<CourseEntity> getCourseDetail(String courseId) async => await dataSource.fetchCourseDetail(courseId);

  @override
  Future<List<CourseEntity>> getEnrolledCourses(String userId) async {
    final enrolledCourses = await dataSource.fetchEnrolledCourses(userId);
    return enrolledCourses.map((course) {
      return CourseEntity(
        id: course.id,
        code: course.code,
        nameEn: course.nameEn,
        nameTh: course.nameTh,
        description: course.description,
        credit: course.credit,
        sections: course.sections.map((section) => section.copyWith(isEnrolled: true)).toList(),
      );
    }).toList();
  }

  @override
  Future<void> enrollCourse(String userId, String courseId, String sectionId) async => await dataSource.enrollToSection(userId, courseId, sectionId);

  @override
  Future<void> withdrawFromSection(String userId, String sectionId) async => await dataSource.withdrawFromSection(userId, sectionId);

  @override
  Future<List<CourseEntity>> getCoursesWithEnrollStatus(String userId) async {
    final semester = getCurrentSemester();
    final courses = await dataSource.fetchCoursesFromSemester(semester);
    final enrolledCourses = await dataSource.fetchEnrolledCourses(userId);

    return courses.map((course) {
      return CourseEntity(
        id: course.id,
        code: course.code,
        nameEn: course.nameEn,
        nameTh: course.nameTh,
        description: course.description,
        credit: course.credit,
        sections: course.sections.map((section) {
          final isSectionEnrolled = enrolledCourses.any((enrolledCourse) =>
        enrolledCourse.sections.any((enrolledSection) => enrolledSection.id == section.id)
          );
          return section.copyWith(isEnrolled: isSectionEnrolled);
        }).toList(),
      );
        }).toList();
  }
}
