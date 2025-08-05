import '../entities/course_entity.dart';


abstract class CourseRepository {
  Future<List<CourseEntity>> getCoursesFromSemester(String semester);
  Future<List<CourseEntity>> getCourseByCodeOrName(String query);
  Future<CourseEntity> getCourseDetail(String code);
  Future<List<CourseEntity>> getEnrolledCourses(String userId);
  Future<void> enrolCourse(String sectionId);
  Future<void> withdrawFromSection(String sectionId);
}
