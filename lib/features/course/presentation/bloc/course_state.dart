import 'package:campus_life_hub/features/course/domain/entities/course_entity.dart';


abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<CourseEntity> courses;
  final List<CourseEntity> queryCourses;
  final bool isEnrolledView;

  CourseLoaded(this.courses, this.queryCourses, {this.isEnrolledView = false});
}

class CourseEnrolling extends CourseState {}

class CourseWithdrawn extends CourseState {}

class CourseSuccess extends CourseState {}

class CourseError extends CourseState {
  final String message;
  CourseError(this.message);
}