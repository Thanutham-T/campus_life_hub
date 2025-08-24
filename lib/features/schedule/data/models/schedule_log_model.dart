import 'package:cloud_firestore/cloud_firestore.dart';


class ScheduleLogModel {
  final String id;          // unique per log
  final Timestamp date;      
  final String status;      // "present", "absent", "late"
  final Timestamp? checkInAt; 
  final String? note;

  ScheduleLogModel({
    required this.id,
    required this.date,
    required this.status,
    this.checkInAt,
    this.note,
  });

  factory ScheduleLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = Map<String, dynamic>.from(doc.data() as Map);
    return ScheduleLogModel(
      id: doc.id,
      date: data['date'],
      status: data['status'],
      checkInAt: data['checkInAt'],
      note: data['note'],
    );
  }
}
