import '../repositories/course_repository.dart';
import '../entities/course_entity.dart';


class GetCoursesWithEnrollStatus {
  final CourseRepository repository;

  GetCoursesWithEnrollStatus(this.repository);

  Future<List<CourseEntity>> call(String userId) async {
    return await repository.getCoursesWithEnrollStatus(userId);
  }
}