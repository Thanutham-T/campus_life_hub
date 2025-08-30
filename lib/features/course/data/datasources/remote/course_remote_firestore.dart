import 'package:campus_life_hub/features/schedule/data/models/schedule_template_model.dart';
import 'package:campus_life_hub/features/schedule/data/models/schedule_slots_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:campus_life_hub/features/schedule/data/datasources/remotes/schedule_remote_firestore.dart';

import '../../models/course_model.dart';

abstract class CourseDataSource {
  Future<List<CourseModel>> fetchCoursesFromSemester(String semester);
  Future<List<CourseModel>> fetchCoursesWithFilter(String semester, dynamic filters);
  Future<CourseModel> fetchCourseDetail(String courseId);
  Future<void> enrollToSection(String courseId, String sectionId, String userId);
  Future<List<CourseModel>> fetchEnrolledCourses(String userId);
  Future<void> withdrawFromSection(String userId, String sectionId);
}

class CourseRemoteFirestore implements CourseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CourseModel> _buildCourseWithSectionsAndSchedules(
      DocumentSnapshot<Map<String, dynamic>> courseDoc) async {
    final courseData = courseDoc.data();
    if (courseData == null) throw Exception("Course data is null");
    courseData['id'] = courseDoc.id;

    final sectionsSnapshot =
        await courseDoc.reference.collection('course_sections').get();

    final sectionFutures = sectionsSnapshot.docs.map((sectionDoc) async {
      var sectionData = sectionDoc.data();
      sectionData['id'] = sectionDoc.id;

      final schedulesSnapshot =
          await sectionDoc.reference.collection('section_schedules').get();

      final scheduleModels = schedulesSnapshot.docs.map((schDoc) {
        var schData = schDoc.data();
        schData['id'] = schDoc.id;
        return SectionScheduleModel.fromAny(schData);
      }).toList();

      sectionData['schedules'] = scheduleModels;
      return CourseSectionModel.fromAny(sectionData);
    }).toList();

    final sectionModels = await Future.wait(sectionFutures);
    courseData['sections'] = sectionModels;

    return CourseModel.fromJson(courseData);
  }

  @override
  Future<List<CourseModel>> fetchCoursesFromSemester(String semester) async {
    final coursesSnapshot = await _firestore
        .collection('courses')
        .where('semester', isEqualTo: semester)
        .get();

    if (coursesSnapshot.docs.isEmpty) throw Exception("Course not found");

    return Future.wait(
      coursesSnapshot.docs.map((doc) => _buildCourseWithSectionsAndSchedules(doc)),
    );
  }

  @override
  Future<List<CourseModel>> fetchCoursesWithFilter(String semester, dynamic filters) async {
    var query = _firestore.collection('courses').where('semester', isEqualTo: semester);

    if (filters != null && filters is Map<String, dynamic>) {
      filters.forEach((key, value) {
        query = query.where(key, isEqualTo: value);
      });
    }

    final coursesSnapshot = await query.get();
    if (coursesSnapshot.docs.isEmpty) throw Exception("Course not found");

    return Future.wait(
      coursesSnapshot.docs.map((doc) => _buildCourseWithSectionsAndSchedules(doc)),
    );
  }

  @override
  Future<CourseModel> fetchCourseDetail(String courseId) async {
    final courseDoc = await _firestore.collection('courses').doc(courseId).get();
    if (!courseDoc.exists) throw Exception("Course not found");
    return _buildCourseWithSectionsAndSchedules(courseDoc);
  }

  @override
  Future<void> enrollToSection(String courseId, String sectionId, String userId) async {
    // record enrollment
    await _firestore.collection('course_enrollments').add({
      'userId': userId,
      'courseId': courseId,
      'sectionId': sectionId,
      'enroll_time': FieldValue.serverTimestamp(),
    });

    // build schedule template + slots from course data and enroll section
    final course = await fetchCourseDetail(courseId);

    final section = course.sections.firstWhere(
      (s) => s.id == sectionId,
      orElse: () => throw Exception('Section not found'),
    );

    // generate ids for template and slots
    final templateId = _firestore.collection('schedules').doc().id;

    final template = ScheduleTemplateModel(
      id: templateId,
      userId: userId,
      courseId: courseId,
      courseCode: course.code,
      courseNameEng: course.nameEn,
      courseNameTh: course.nameTh,
      sectionId: sectionId,
      sectionCode: section.sectionCode,
      instructor: section.instructor,
      createdAt: Timestamp.now(),
    );

    final slots = (section.schedules).map<ScheduleSlotModel>((sch) {
      final slotId = _firestore.collection('schedules').doc(templateId).collection('slots').doc().id;
      return ScheduleSlotModel(
        id: slotId,
        dayOfWeek: sch.dayOfWeek,
        startTime: sch.startTime,
        endTime: sch.endTime,
        room: sch.room,
        origin: 'course',
        isActive: true,
        isCustom: false,
      );
    }).toList();

    await ScheduleRemoteFirestoreImpl().addTemplateWithSlots(template, slots);
  }

  @override
  Future<List<CourseModel>> fetchEnrolledCourses(String userId) async {
    final query = await _firestore
        .collection('course_enrollments')
        .where('userId', isEqualTo: userId)
        .get();

    final courseIds = query.docs.map((doc) => doc['courseId']).toList();
    final sectionIds = query.docs.map((doc) => doc['sectionId']).toList();

    final courseFutures = List.generate(courseIds.length, (i) async {
      final courseDoc = await _firestore.collection('courses').doc(courseIds[i]).get();
      if (!courseDoc.exists) return null;

      final course = await _buildCourseWithSectionsAndSchedules(courseDoc);
      final enrolledSectionId = sectionIds[i];

      final filteredSections =
          course.sections.where((s) => s.id == enrolledSectionId).toList();

      if (filteredSections.isNotEmpty) {
        return course.copyWith(sections: filteredSections);
      }
      return null;
    });

    final courses = await Future.wait(courseFutures);
    return courses.whereType<CourseModel>().toList();
  }

  @override
  Future<void> withdrawFromSection(String userId, String sectionId) async {
    final querySnapshot = await _firestore
      .collection('course_enrollments')
      .where('sectionId', isEqualTo: sectionId)
      .where('userId', isEqualTo: userId)
      .get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    await ScheduleRemoteFirestoreImpl().deleteTemplateBySection(userId, sectionId);
  }
}
