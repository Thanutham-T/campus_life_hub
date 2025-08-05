import 'package:campus_life_hub/features/course/domain/entities/course_entity.dart';
import 'package:campus_life_hub/features/course/domain/repositories/course_repository.dart';


class GetEnrolledCourses {
  final CourseRepository repository;

  GetEnrolledCourses(this.repository);

  Future<List<CourseEntity>> call(String userId) async {
    return await repository.getEnrolledCourses(userId);
  }
}
