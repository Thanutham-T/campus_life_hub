import 'package:campus_life_hub/features/course/domain/entities/course_entity.dart';
import 'package:campus_life_hub/features/course/domain/repositories/course_repository.dart';

import '../datasources/local/course_local_datasource.dart';


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
        name: course.name,
        description: course.description,
        sections: course.sections.map((section) => section.copyWith(isEnrolled: true)).toList(),
      );
    }).toList();
  }

  @override
  Future<void> enrollCourse(String sectionId) async => await dataSource.enrollToSection(sectionId);

  @override
  Future<void> withdrawFromSection(String sectionId) async => await dataSource.withdrawFromSection(sectionId);

  @override
  Future<List<CourseEntity>> getCoursesWithEnrollStatus(String userId) async {
    final courses = await dataSource.fetchCoursesFromSemester('1/2569'); // Example semester, adjust as needed
    final enrolledCourses = await dataSource.fetchEnrolledCourses(userId);

    return courses.map((course) {
      return CourseEntity(
        id: course.id,
        code: course.code,
        name: course.name,
        description: course.description,
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
