import 'package:campus_life_hub/features/course/domain/usecases/get_enrol_course.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:campus_life_hub/features/course/domain/usecases/get_course_from_semester.dart';
import 'package:campus_life_hub/features/course/domain/usecases/get_course_from_search.dart';
import 'package:campus_life_hub/features/course/domain/usecases/get_course_detail.dart';
import 'package:campus_life_hub/features/course/domain/usecases/enrol_course.dart';
import 'package:campus_life_hub/features/course/domain/usecases/withdrawn_course.dart';

import 'course_event.dart';
import 'course_state.dart';


class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCourseFromSemester getCourseFromSemester;
  final GetCourseDetail getCourseDetail;
  final GetEnrolledCourses getEnrolledCourses;
  final EnrolCourse enrolCourse;
  final GetCourseFromSearch getCourseFromSearch;
  final WithdrawnCourse withdrawnCourse;
  CourseBloc({
    required this.getCourseFromSemester,
    required this.getCourseDetail,
    required this.getEnrolledCourses,
    required this.enrolCourse,
    required this.getCourseFromSearch,
    required this.withdrawnCourse,
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
      emit(CourseLoading());
      try {
        final courses = await getCourseFromSearch(event.query);
        emit(CourseLoaded(courses));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });

    on<EnrolToCourse>((event, emit) async {
      emit(CourseEnrolling());
      try {
        await enrolCourse(event.sectionId);
        emit(CourseSuccess());
        final courses = await getCourseFromSemester('1/2569');
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
        final courses = await getCourseFromSemester('1/2569');
        emit(CourseLoaded(courses));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });
  }
}