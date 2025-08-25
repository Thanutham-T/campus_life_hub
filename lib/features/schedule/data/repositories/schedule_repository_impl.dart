import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:campus_life_hub/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:campus_life_hub/features/schedule/domain/entities/schedule_timeline_entity.dart';

import '../datasources/remotes/schedule_remote_firestore.dart';
// import '../models/schedule_template_model.dart';
// import '../models/schedule_slots_model.dart';
import '../models/schedule_log_model.dart';


class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource datasource;

  ScheduleRepositoryImpl(this.datasource);


  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Future<List<ScheduleTimelineEntity>> getDaySchedule(String userId, DateTime date) async {
    final List<ScheduleTimelineEntity> results = [];

    // 1. โหลดทุก template ของ user
    final templates = await datasource.getTemplates(userId);

    for (final template in templates) {
      // 2. โหลด slots ของ template
      final slots = await datasource.getSlots(template.id);

      for (final slot in slots) {
        // 3. filter เฉพาะ slot ที่มี log ในวันนั้น
        final logs = await datasource.getLogs(template.id, slot.id);
        final hasLogForToday = logs.any(
          (log) =>
              log.date.toDate().year == date.year &&
              log.date.toDate().month == date.month &&
              log.date.toDate().day == date.day,
        );
        if (!hasLogForToday) continue;

        // หา log ของวันนั้น
        final logForToday = logs.firstWhere(
          (log) =>
              log.date.toDate().year == date.year &&
              log.date.toDate().month == date.month &&
              log.date.toDate().day == date.day,
          orElse: () => ScheduleLogModel(
            id: '',
            date: Timestamp.fromDate(date),
            status: 'none',
            checkInAt: null,
            note: null,
          ),
        );

        // 5. Map ออกมาเป็น ScheduleTimelineEntity
        results.add(
          ScheduleTimelineEntity(
            templateId: template.id,
            slotId: slot.id,
            logId: logForToday.id,
            courseCode: template.courseCode,
            courseNameEng: template.courseNameEng,
            courseNameTh: template.courseNameTh,
            sectionCode: template.sectionCode,
            room: slot.room,
            startTime: _parseTimeOfDay(slot.startTime),
            endTime: _parseTimeOfDay(slot.endTime),
            isCheckin: logForToday.status == "checked_in",
          ),
        );
      }
    }

    // sort ตามเวลาเริ่มต้น
    results.sort((a, b) {
      final aHour = a.startTime.hour;
      final aMinute = a.startTime.minute;
      final bHour = b.startTime.hour;
      final bMinute = b.startTime.minute;
      if (aHour != bHour) {
        return aHour.compareTo(bHour);
      }
      return aMinute.compareTo(bMinute);
    });

    return results;
  }

  @override
  Future<void> checkInClass(String templateId, String slotId, String logId) async {
    await datasource.updateCheckinLogId(templateId, slotId, logId);
  }
}
