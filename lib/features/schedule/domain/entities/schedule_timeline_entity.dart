import 'package:flutter/material.dart';

class ScheduleTimelineEntity {
  final String courseCode;
  final String courseNameEng;
  final String courseNameTh;
  final String sectionCode;
  final String room;
  final TimeOfDay startTime; // "HH:mm" format for UI
  final TimeOfDay endTime;   // "HH:mm" format for UI
  final bool isCheckin;    // "active", "cancelled", etc.

  ScheduleTimelineEntity({
    required this.courseCode,
    required this.courseNameEng,
    required this.courseNameTh,
    required this.sectionCode,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.isCheckin,
  });
}