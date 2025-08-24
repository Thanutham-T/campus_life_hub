import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/injector.dart' as di;

// import '../../features/schedule/presentation/pages/schedule_page.dart';
// import '../../features/schedule/presentation/bloc/schedule_event.dart';
// import '../../features/schedule/presentation/bloc/schedule_bloc.dart';

// Course route builder
import '../../features/course/presentation/pages/course_page.dart';
import '../../features/course/presentation/bloc/course_bloc.dart';
import '../../features/course/presentation/bloc/course_event.dart';

// Schedule route builder
import '../../features/schedule/presentation/pages/schedule_page.dart';

// Study groups route builder
import '../../features/study_group/presentation/pages/study_groups_page.dart';
import '../../features/study_group/presentation/bloc/study_group_bloc.dart';
import '../../features/study_group/presentation/bloc/study_group_event.dart';


class RouteBuilders {
  static Widget buildSchedulePageWithBloc() {
    // return FutureBuilder<ScheduleBloc>(
    //   future: sl.getAsync<ScheduleBloc>(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return BlocProvider.value(
    //         value: snapshot.data!..add(LoadSchedule(DateTime.now())),
    //         child: const SchedulePage(),
    //       );
    //     } else {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
    return SchedulePage();
  }

  static Widget buildCoursePageWithBloc() {
    return FutureBuilder<CourseBloc>(
      future: di.sl.getAsync<CourseBloc>(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return BlocProvider.value(
            value: snapshot.data!..add(LoadCourseWithEnrollStatus(FirebaseAuth.instance.currentUser!.uid)),
            child: const CoursePage(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  static Widget buildStudyGroupPageWithBloc() {
    return BlocProvider(
      create: (_) => di.sl<StudyGroupBloc>()..add(GetStudyGroupsEvent()),
      child: const StudyGroupsPage(),
    );
  }
}