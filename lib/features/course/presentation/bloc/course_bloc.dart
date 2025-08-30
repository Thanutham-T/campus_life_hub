import 'package:campus_life_hub/features/course/domain/entities/course_entity.dart';
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
        final queryCourses = courses;
        emit(CourseLoaded(courses, queryCourses, isEnrolledView: false));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });

    on<LoadEnrolledCourses>((event, emit) async {
      emit(CourseLoading());
      try {
        final courses = await getEnrolledCourses(event.userId);
        final queryCourses = courses;
        emit(CourseLoaded(courses, queryCourses, isEnrolledView: true));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });

    on<SearchCourses>((event, emit) async {
      final currentState = state;
      if (currentState is CourseLoaded) {
        emit(CourseLoading());
        try {
          final allCourses = currentState.courses;
          List<CourseEntity> queryCourses;
          if (event.query.isEmpty) {
            queryCourses = allCourses;
          } else {
            final query = event.query.trim().toLowerCase();
            queryCourses = allCourses.where((course) {
              return course.nameEn.toLowerCase().contains(query) ||
              course.nameTh.toLowerCase().contains(query) ||
              course.code.toLowerCase().contains(query);
            }).toList();
          }
          emit(CourseLoaded(allCourses, queryCourses, isEnrolledView: event.isEnrolledView));
        } catch (e) {
          emit(CourseError(e.toString()));
        }
      }
    });

    on<EnrollToCourse>((event, emit) async {
      emit(CourseEnrolling());
      try {
        await enrollCourse(event.courseId, event.sectionId, event.userId);
        emit(CourseSuccess());
        final courses = await getCourseWithEnrollStatus(event.userId);
        final queryCourses = courses;
        emit(CourseLoaded(courses, queryCourses));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });

    on<WithdrawFromCourse>((event, emit) async {
      emit(CourseLoading());
      try {
        await withdrawnCourse(event.userId, event.sectionId);
        emit(CourseSuccess());
        final courses = await getCourseWithEnrollStatus(event.userId);
        final queryCourses = courses;
        emit(CourseLoaded(courses, queryCourses));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });

    on<LoadCourseWithEnrollStatus>((event, emit) async {
      emit(CourseLoading());
      try {
        final courses = await getCourseWithEnrollStatus(event.userId);
        final queryCourses = courses;
        emit(CourseLoaded(courses, queryCourses, isEnrolledView: false));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });
  }
}
