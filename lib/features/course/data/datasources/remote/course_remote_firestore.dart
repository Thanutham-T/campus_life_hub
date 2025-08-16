import 'package:cloud_firestore/cloud_firestore.dart';

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
  
  @override
  Future<List<CourseModel>> fetchCoursesFromSemester(String semester) async {
    final coursesSnapshot = await _firestore
        .collection('courses')
        .where('semester', isEqualTo: semester)
        .get();

    if (coursesSnapshot.docs.isEmpty) throw Exception("Course not found");

    final courseFutures = coursesSnapshot.docs.map((courseDoc) async {
      final courseData = courseDoc.data();
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
    }).toList();

    return Future.wait(courseFutures);
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

    final courseFutures = coursesSnapshot.docs.map((courseDoc) async {
      final courseData = courseDoc.data();
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
    }).toList();

    return Future.wait(courseFutures);
  }

  @override
  Future<CourseModel> fetchCourseDetail(String courseId) async {
    final coursesSnapshot =
        await _firestore.collection('courses').doc(courseId).get();

    if (!coursesSnapshot.exists) throw Exception("Course not found");

    final courseData = coursesSnapshot.data();
    if (courseData == null) throw Exception("Course data is null");
    courseData['id'] = coursesSnapshot.id;

    final sectionsSnapshot =
        await coursesSnapshot.reference.collection('course_sections').get();

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
  Future<void> enrollToSection(String courseId, String sectionId, String userId) async {
    await _firestore.collection('course_enrollments').add({
      'userId': userId,
      'courseId': courseId,
      'sectionId': sectionId,
      'enroll_time': FieldValue.serverTimestamp(),
    });
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
      final course = await fetchCourseDetail(courseIds[i]);
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
    final snapshot = await _firestore
        .collection('course_enrollments')
        .where('sectionId', isEqualTo: sectionId)
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
