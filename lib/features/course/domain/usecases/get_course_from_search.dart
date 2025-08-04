import 'package:campus_life_hub/features/course/domain/entities/course_entity.dart';
import 'package:campus_life_hub/features/course/domain/repositories/course_repository.dart';


class GetCourseFromSearch {
  final CourseRepository repository;

  GetCourseFromSearch(this.repository);

  Future<List<CourseEntity>> call(String query) async {
    return await repository.getCourseByCodeOrName(query);
  }
}