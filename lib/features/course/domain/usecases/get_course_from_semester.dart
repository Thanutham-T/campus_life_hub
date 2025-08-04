import '../repositories/course_repository.dart';
import '../entities/course_entity.dart';


class GetCourseFromSemester {
  final CourseRepository repo;
  GetCourseFromSemester(this.repo);

  Future<List<CourseEntity>> call(String semester) => repo.getCoursesFromSemester(semester);
}
