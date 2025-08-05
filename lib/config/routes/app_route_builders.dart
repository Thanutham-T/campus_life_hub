import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/injector.dart';

// import '../../features/schedule/presentation/pages/schedule_page.dart';
// import '../../features/schedule/presentation/bloc/schedule_event.dart';
// import '../../features/schedule/presentation/bloc/schedule_bloc.dart';

import '../../features/course/presentation/pages/course_page.dart';
import '../../features/course/presentation/bloc/course_bloc.dart';
import '../../features/course/presentation/bloc/course_event.dart';


class RouteBuilders {
  // static Widget buildSchedulePageWithBloc() {
  //   return FutureBuilder<ScheduleBloc>(
  //     future: sl.getAsync<ScheduleBloc>(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         return BlocProvider.value(
  //           value: snapshot.data!..add(LoadSchedule(DateTime.now())),
  //           child: const SchedulePage(),
  //         );
  //       } else {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //     },
  //   );
  // }

  static Widget buildCoursePageWithBloc() {
    return FutureBuilder<CourseBloc>(
      future: sl.getAsync<CourseBloc>(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return BlocProvider.value(
            value: snapshot.data!..add(LoadCourseWithEnrollStatus('1')),
            child: const CoursePage(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}