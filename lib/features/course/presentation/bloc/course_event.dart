abstract class CourseEvent {}

class LoadAllCourses extends CourseEvent {
  final String semester;
  LoadAllCourses(this.semester);
}

class LoadCourseWithEnrollStatus extends CourseEvent {
  final String userId;
  LoadCourseWithEnrollStatus(this.userId);
}

class LoadEnrolledCourses extends CourseEvent {
  final String userId;
  LoadEnrolledCourses(this.userId);
}

class SearchCourses extends CourseEvent {
  final String query;
  SearchCourses(this.query);
}

class EnrollToCourse extends CourseEvent {
  final String sectionId;
  EnrollToCourse(this.sectionId);
}

class WithdrawFromCourse extends CourseEvent {
  final String sectionId;
  WithdrawFromCourse(this.sectionId);
}
