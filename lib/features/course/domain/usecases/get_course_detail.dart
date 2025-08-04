import '../repositories/course_repository.dart';
import '../entities/course_entity.dart';


class GetCourseDetail {
  final CourseRepository repo;
  GetCourseDetail(this.repo);

  Future<CourseEntity> call(String courseId) => repo.getCourseDetail(courseId);
}