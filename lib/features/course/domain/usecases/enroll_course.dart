import '../repositories/course_repository.dart';


class EnrollCourse {
  final CourseRepository repo;
  EnrollCourse(this.repo);

  Future<void> call(String sectionId) => repo.enrollCourse(sectionId);
}
