import 'package:flutter/material.dart';

class ScheduleTimelineEntity {
  final String templateId;
  final String slotId;
  final String logId;

  final String courseCode;
  final String courseNameEng;
  final String courseNameTh;
  final String sectionCode;
  final String room;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String note;
  final bool isCheckin;

  ScheduleTimelineEntity({
    required this.templateId,
    required this.slotId,
    required this.logId,

    required this.courseCode,
    required this.courseNameEng,
    required this.courseNameTh,
    required this.sectionCode,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.note,
    required this.isCheckin,
  });
}