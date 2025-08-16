import '../repositories/course_repository.dart';


class EnrollCourse {
  final CourseRepository repo;
  EnrollCourse(this.repo);

  Future<void> call(String courseId, String sectionId, String userId) => repo.enrollCourse(courseId, sectionId, userId);
}
