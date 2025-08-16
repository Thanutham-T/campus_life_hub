import '../entities/course_entity.dart';


abstract class CourseRepository {
  Future<List<CourseEntity>> getCoursesFromSemester(String semester);
  Future<CourseEntity> getCourseDetail(String code);
  Future<List<CourseEntity>> getEnrolledCourses(String userId);
  Future<void> enrollCourse(String courseId, String sectionId, String userId);
  Future<void> withdrawFromSection(String userId, String sectionId);
  Future<List<CourseEntity>> getCoursesWithEnrollStatus(String userId);
}
