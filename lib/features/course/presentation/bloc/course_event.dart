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
  final bool isEnrolledView;
  final String userId;
  SearchCourses(this.query, this.isEnrolledView, this.userId);
}

class EnrollToCourse extends CourseEvent {
  final String courseId;
  final String sectionId;
  final String userId;
  EnrollToCourse(this.courseId, this.sectionId, this.userId);
}

class WithdrawFromCourse extends CourseEvent {
  final String userId;
  final String sectionId;
  WithdrawFromCourse(this.userId, this.sectionId);
}
