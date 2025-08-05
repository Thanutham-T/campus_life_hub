import 'package:campus_life_hub/features/course/domain/usecases/get_enroll_course.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:campus_life_hub/features/course/domain/usecases/get_course_from_semester.dart';
import 'package:campus_life_hub/features/course/domain/usecases/get_course_detail.dart';
import 'package:campus_life_hub/features/course/domain/usecases/enroll_course.dart';
import 'package:campus_life_hub/features/course/domain/usecases/withdrawn_course.dart';
import 'package:campus_life_hub/features/course/domain/usecases/get_courses_with_enroll_status.dart';

import 'course_event.dart';
import 'course_state.dart';


class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCourseFromSemester getCourseFromSemester;
  final GetCourseDetail getCourseDetail;
  final GetEnrolledCourses getEnrolledCourses;
  final EnrollCourse enrollCourse;
  final WithdrawnCourse withdrawnCourse;
  final GetCoursesWithEnrollStatus getCourseWithEnrollStatus;
  CourseBloc({
    required this.getCourseFromSemester,
    required this.getCourseDetail,
    required this.getEnrolledCourses,
    required this.enrollCourse,
    required this.withdrawnCourse,
    required this.getCourseWithEnrollStatus,
  }) : super(CourseInitial()) {
    on<LoadAllCourses>((event, emit) async {
      emit(CourseLoading());
      try {
        final courses = await getCourseFromSemester(event.semester);
        emit(CourseLoaded(courses, isEnrolledView: false));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });

    on<LoadEnrolledCourses>((event, emit) async {
      emit(CourseLoading());
      try {
        final courses = await getEnrolledCourses(event.userId);
        emit(CourseLoaded(courses, isEnrolledView: true));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });

    on<SearchCourses>((event, emit) async {
      final currentState = state;
      if (currentState is CourseLoaded) {
      emit(CourseLoading());
      try {
        final query = event.query.trim().toLowerCase();
        if (query.isEmpty) {
          if (currentState.isEnrolledView) {
            final courses = await getEnrolledCourses('1');
            emit(CourseLoaded(courses, isEnrolledView: true));
          } else {
            final courses = await getCourseWithEnrollStatus('1');
            emit(CourseLoaded(courses, isEnrolledView: false));
          }
        } else {
        final filteredCourses = currentState.courses.where((course) {
          return course.name.toLowerCase().contains(query) ||
            course.code.toLowerCase().contains(query);
        }).toList();
        emit(CourseLoaded(filteredCourses, isEnrolledView: currentState.isEnrolledView));
        }
      } catch (e) {
        emit(CourseError(e.toString()));
      }
      }
    });

    on<EnrollToCourse>((event, emit) async {
      emit(CourseEnrolling());
      try {
        await enrollCourse(event.sectionId);
        emit(CourseSuccess());
        final courses = await getCourseWithEnrollStatus('1');
        emit(CourseLoaded(courses));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });

    on<WithdrawFromCourse>((event, emit) async {
      emit(CourseLoading());
      try {
        await withdrawnCourse(event.sectionId);
        emit(CourseSuccess());
        final courses = await getCourseWithEnrollStatus('1');
        emit(CourseLoaded(courses));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });
    
    on<LoadCourseWithEnrollStatus>((event, emit) async {
      emit(CourseLoading());
      try {
        final courses = await getCourseWithEnrollStatus(event.userId);
        emit(CourseLoaded(courses, isEnrolledView: false));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });
  }
}