import 'package:campus_life_hub/features/course/presentation/bloc/course_event.dart';
import 'package:campus_life_hub/features/course/presentation/bloc/course_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/course_bloc.dart';
import '../widgets/course_card.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              final bloc = context.read<CourseBloc>();
              final state = bloc.state;
              final isEnrolledView =
                  state is CourseLoaded && state.isEnrolledView == true;
              bloc.add(
                SearchCourses(
                  query,
                  isEnrolledView,
                  FirebaseAuth.instance.currentUser!.uid,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<bool>(
                isExpanded: true,
                icon: const Icon(Icons.filter_list, color: Colors.blue),
                hint: const Text(
                  'Filter by',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                value: context.select<CourseBloc, bool>(
                  (bloc) =>
                      bloc.state is CourseLoaded &&
                          (bloc.state as CourseLoaded).isEnrolledView == true
                      ? true
                      : false,
                ),
                items: const [
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Row(
                      children: [
                        Icon(Icons.list_alt, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('All Courses'),
                      ],
                    ),
                  ),
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Enrolled Courses'),
                      ],
                    ),
                  ),
                ],
                onChanged: (bool? value) {
                  if (value == true) {
                    context.read<CourseBloc>().add(
                      LoadEnrolledCourses(
                        FirebaseAuth.instance.currentUser!.uid,
                      ),
                    );
                  } else {
                    context.read<CourseBloc>().add(
                      LoadCourseWithEnrollStatus(
                        FirebaseAuth.instance.currentUser!.uid,
                      ),
                    );
                  }
                },
              ),
            ),
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
                final courses = state.queryCourses;
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
                                        content: Text(
                                          'You can enroll just one section.',
                                        ),
                                      ),
                                    );
                                  }
                                : () {
                                    var userId =
                                        FirebaseAuth
                                            .instance
                                            .currentUser
                                            ?.uid ??
                                        '';
                                    context.read<CourseBloc>().add(
                                      EnrollToCourse(
                                        course.id,
                                        section.id,
                                        userId,
                                      ),
                                    );
                                  },
                            onWithdrawn: section.isEnrolled
                                ? () {
                                    var userId =
                                        FirebaseAuth
                                            .instance
                                            .currentUser
                                            ?.uid ??
                                        '';
                                    context.read<CourseBloc>().add(
                                      WithdrawFromCourse(userId, section.id),
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
    );
  }
}
