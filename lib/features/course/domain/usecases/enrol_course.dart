import '../repositories/course_repository.dart';


class EnrolCourse {
  final CourseRepository repo;
  EnrolCourse(this.repo);

  Future<void> call(String sectionId) => repo.enrolCourse(sectionId);
}
