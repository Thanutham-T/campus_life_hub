import 'package:cloud_firestore/cloud_firestore.dart';


class ScheduleSlotModel {
  final String id;          // unique per slot
  final String dayOfWeek;   
  final String startTime;   // format "HH:mm"
  final String endTime;     
  final String room;
  final String origin;      // "course" | "custom"
  final bool isActive;      
  final bool isCustom;      // true ถ้า user แก้จาก default

  ScheduleSlotModel({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    this.origin = "course",
    this.isActive = true,
    this.isCustom = false,
  });

  factory ScheduleSlotModel.fromFirestore(DocumentSnapshot doc) {
    final data = Map<String, dynamic>.from(doc.data() as Map);
    return ScheduleSlotModel(
      id: doc.id,
      dayOfWeek: data['dayOfWeek'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      room: data['room'],
      origin: data['origin'] ?? "course",
      isActive: data['isActive'] ?? true,
      isCustom: data['isCustom'] ?? false,
    );
  }
}
