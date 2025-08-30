import 'package:cloud_firestore/cloud_firestore.dart';


class ScheduleTemplateModel {
  final String id;
  final String userId;
  final String courseId;
  final String courseCode;
  final String courseNameEng;
  final String courseNameTh;
  final String sectionId;
  final String sectionCode;
  final List<String> instructor;
  final Timestamp createdAt;

  ScheduleTemplateModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseCode,
    required this.courseNameEng,
    required this.courseNameTh,
    required this.sectionId,
    required this.sectionCode,
    required this.instructor,
    required this.createdAt,
  });

  factory ScheduleTemplateModel.fromFirestore(DocumentSnapshot doc) {
    final data = Map<String, dynamic>.from(doc.data() as Map);
    return ScheduleTemplateModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      courseId: data['courseId'] ?? '',
      courseCode: data['courseCode'] ?? '',
      courseNameEng: data['courseNameEng'] ?? '',
      courseNameTh: data['courseNameTh'] ?? '',
      sectionId: data['sectionId'] ?? '',
      sectionCode: data['sectionCode'] ?? '',
      instructor: (data['instructor'] is List) ? List<String>.from(data['instructor']) : [],
      createdAt: data['createdAt'] is Timestamp ? data['createdAt'] as Timestamp : Timestamp.fromDate(DateTime.now()),
    );
  }
}
