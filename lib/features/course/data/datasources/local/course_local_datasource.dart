import '../../models/course_model.dart';


abstract class CourseDataSource {
  Future<List<CourseModel>> fetchCoursesFromSemester(String semester);
  Future<CourseModel> fetchCourseDetail(String courseId);
  Future<void> enrollToSection(String sectionId);
  Future<List<CourseModel>> fetchEnrolledCourses(String userId);
  Future<void> withdrawFromSection(String sectionId);
}

class FakeCourseDataSource implements CourseDataSource {
  final List<CourseModel> _mockCourses = [
    CourseModel(
      id: 'C001',
      code: 'CS101',
      nameEn: 'Introduction to Flutter',
      nameTh: 'การแนะนำ Flutter',
      description: 'Learn Flutter basics.',
      credit: 3,
      semester: '1/2569',
      sections: [
        CourseSectionModel(
          id: 'S001',
          sectionCode: 'A',
          instructor: ['Dr. Smith'],
          schedules: [
            SectionScheduleModel(
              dayOfWeek: 'Monday',
              startTime: '09:00',
              endTime: '10:30',
              room: 'Room 101',
            ),
            SectionScheduleModel(
              dayOfWeek: 'Wednesday',
              startTime: '09:00',
              endTime: '10:30',
              room: 'Room 101',
            ),
          ],
        ),
      ],
    ),
    CourseModel(
      id: 'C002',
      code: 'CS102',
      nameEn: 'Advanced Flutter',
      nameTh: 'Flutter ขั้นสูง',
      description: 'Deep dive into Flutter.',
      credit: 3,
      semester: '1/2569',
      sections: [
        CourseSectionModel(
          id: 'S002',
          sectionCode: 'A',
          instructor: ['Prof. Johnson'],
          schedules: [
            SectionScheduleModel(
              dayOfWeek: 'Tuesday',
              startTime: '11:00',
              endTime: '12:30',
              room: 'Room 202',
            ),
            SectionScheduleModel(
              dayOfWeek: 'Thursday',
              startTime: '11:00',
              endTime: '12:30',
              room: 'Room 202',
            ),
          ],
          ),
          CourseSectionModel(
            id: 'S003',
            sectionCode: 'B',
            instructor: ['Dr. Brown'],
            schedules: [
              SectionScheduleModel(
                dayOfWeek: 'Friday',
                startTime: '09:00',
                endTime: '10:30',
                room: 'Room 303',
              ),
            ],
          ),
      ],
    ),
  ];

  final Set<String> _registeredSectionIds = {"S002"};

  @override
  Future<List<CourseModel>> fetchCoursesFromSemester(String semester) async =>
      _mockCourses.where((course) => course.semester == semester).toList();

  @override
  Future<CourseModel> fetchCourseDetail(String courseId) async =>
      _mockCourses.firstWhere((c) => c.id == courseId);

  @override
  Future<void> enrollToSection(String sectionId) async {
    _registeredSectionIds.add(sectionId);
    print('Enrolled in section: $sectionId');
  }

  @override
  Future<List<CourseModel>> fetchEnrolledCourses(String userId) async {
    // Find courses where any section is registered, and keep only the registered sections in each course
    return _mockCourses
      .where((course) => course.sections.any((section) => _registeredSectionIds.contains(section.id)))
      .map((course) {
      final enrolledSections = course.sections
        .where((section) => _registeredSectionIds.contains(section.id))
        .toList();
      return CourseModel(
        id: course.id,
        code: course.code,
        nameEn: course.nameEn,
        nameTh: course.nameTh,
        description: course.description,
        credit: course.credit,
        semester: course.semester,
        sections: enrolledSections,
      );
      })
      .toList();
  }

  @override
  Future<void> withdrawFromSection(String sectionId) async {
    if (_registeredSectionIds.contains(sectionId)) {
      _registeredSectionIds.remove(sectionId);
      print('Withdrawn from section: $sectionId');
    } else {
      throw Exception('Section not found');
    }
  }
}