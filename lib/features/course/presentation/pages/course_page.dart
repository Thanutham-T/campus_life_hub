import 'package:campus_life_hub/features/course/presentation/bloc/course_event.dart';
import 'package:campus_life_hub/features/course/presentation/bloc/course_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/course_bloc.dart';
import '../widgets/course_card.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                context.read<CourseBloc>().add(SearchCourses(query));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<bool>(
                    isExpanded: true,
                    hint: const Text('Filter by'),
                    value: context.select(
                      (CourseBloc bloc) =>
                          bloc.state is CourseLoaded &&
                              (bloc.state as CourseLoaded).isEnrolledView ==
                                  true
                          ? true
                          : false,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: false,
                        child: Text('All Courses'),
                      ),
                      DropdownMenuItem(
                        value: true,
                        child: Text('Enrolled Courses'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != false) {
                        context.read<CourseBloc>().add(
                          LoadEnrolledCourses('1'),
                        );
                      } else {
                        context.read<CourseBloc>().add(
                          LoadCourseWithEnrollStatus('1'),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<CourseBloc, CourseState>(
              builder: (context, state) {
                if (state is CourseLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CourseError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is CourseLoaded) {
                  final courses = state.courses;
                  if (courses.isEmpty) {
                    return const Center(
                      child: Text('No courses found for the current term.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: Text(
                              '${course.code} - ${course.nameEn}s',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ...course.sections.map(
                            (section) => CourseCard(
                              courseCode: course.code,
                              courseNameEn: course.nameEn,
                              courseNameTh: course.nameTh,
                              courseCredit: course.credit,
                              courseSection: section.sectionCode,
                              courseSchedules: section.schedules
                                  .map(
                                    (s) => Schedule(
                                      day: s.dayOfWeek,
                                      time: '${s.startTime} - ${s.endTime}',
                                      instructor: section.instructor,
                                      room: s.room,
                                    ),
                                  )
                                  .toList(),
                              isEnrolled: section.isEnrolled,
                                onEnrol: course.sections.any((s) => s.isEnrolled)
                                  ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('You can enroll just one section.'),
                                      ),
                                    );
                                  }
                                  : () {
                                    context.read<CourseBloc>().add(
                                    EnrollToCourse(section.id),
                                    );
                                  },
                              onWithdrawn: section.isEnrolled
                                  ? () {
                                      context.read<CourseBloc>().add(
                                        WithdrawFromCourse(section.id),
                                      );
                                    }
                                  : null,
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
