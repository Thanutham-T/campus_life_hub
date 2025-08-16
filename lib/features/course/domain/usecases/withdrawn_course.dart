import 'package:campus_life_hub/features/course/domain/repositories/course_repository.dart';


class WithdrawnCourse {
  final CourseRepository repo;
  WithdrawnCourse(this.repo);

  Future<void> call(String userId, String sectionId) => repo.withdrawFromSection(userId, sectionId);
}