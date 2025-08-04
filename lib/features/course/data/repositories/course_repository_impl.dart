import 'package:campus_life_hub/features/course/domain/entities/course_entity.dart';
import 'package:campus_life_hub/features/course/domain/repositories/course_repository.dart';

import '../datasources/local/course_local_datasource.dart';


class CourseRepositoryImpl implements CourseRepository {
  final CourseDataSource dataSource;
  CourseRepositoryImpl(this.dataSource);

  @override
  Future<List<CourseEntity>> getCoursesFromSemester(String semester) async => await dataSource.fetchCoursesFromSemester(semester);

  @override
  Future<List<CourseEntity>> getCourseByCodeOrName(String query) async => await dataSource.fetchCourseByCodeOrName(query);

  @override
  Future<CourseEntity> getCourseDetail(String courseId) async => await dataSource.fetchCourseDetail(courseId);

  @override
  Future<List<CourseEntity>> getEnrolledCourses(String userId) async => await dataSource.fetchEnrolledCourses(userId);

  @override
  Future<void> enrolCourse(String sectionId) async => await dataSource.enrolToSection(sectionId);

  @override
  Future<void> withdrawFromSection(String sectionId) async => await dataSource.withdrawFromSection(sectionId);
}
