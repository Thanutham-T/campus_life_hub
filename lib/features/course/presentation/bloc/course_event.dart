import 'package:campus_life_hub/features/course/domain/entities/course_section.dart';


abstract class CourseEvent {}

class LoadAllCourses extends CourseEvent {
  final String semester;
  LoadAllCourses(this.semester);
}

class LoadEnrolledCourses extends CourseEvent {
  final String userId;
  LoadEnrolledCourses(this.userId);
}

class SearchCourses extends CourseEvent {
  final String query;
  SearchCourses(this.query);
}

class EnrolToCourse extends CourseEvent {
  final String sectionId;
  EnrolToCourse(this.sectionId);
}

class WithdrawFromCourse extends CourseEvent {
  final String sectionId;
  WithdrawFromCourse(this.sectionId);
}
