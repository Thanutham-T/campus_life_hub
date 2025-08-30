import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:campus_life_hub/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:campus_life_hub/features/schedule/domain/entities/schedule_timeline_entity.dart';
import 'package:campus_life_hub/features/schedule/domain/entities/schedule_template_entity.dart';
import 'package:campus_life_hub/features/schedule/domain/entities/schedule_slot_entity.dart';

import '../datasources/remotes/schedule_remote_firestore.dart';
// import '../models/schedule_template_model.dart';
// import '../models/schedule_slots_model.dart';
import '../models/schedule_log_model.dart';
import '../models/schedule_slots_model.dart';


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
        
        // ตรวจสอบว่า slot นี้ตรงกับวันในสัปดาห์หรือไม่
        final dayOfWeekMap = {
          'monday': 1,
          'tuesday': 2,
          'wednesday': 3,
          'thursday': 4,
          'friday': 5,
          'saturday': 6,
          'sunday': 7,
        };
        final slotDayOfWeek = slot.dayOfWeek is int
            ? slot.dayOfWeek
            : dayOfWeekMap[slot.dayOfWeek.toString().toLowerCase()] ?? 0;
        final currentDayOfWeek = date.weekday; // 1=จันทร์, 7=อาทิตย์
        // AppLogger.debug('Checking slot ${slot.id} for dayOfWeek $slotDayOfWeek against date $date (weekday $currentDayOfWeek)');

        // ถ้า dayofweek ไม่ตรงกับ slot ให้ข้าม slot นี้
        if (slotDayOfWeek != currentDayOfWeek) {
          continue;
        }

        // 3. filter เฉพาะ slot ที่มี log ในวันนั้น ถ้าไม่มีให้สร้างใหม่
        final logs = await datasource.getLogs(template.id, slot.id);
        final logForToday = logs.cast<ScheduleLogModel?>().firstWhere(
          (log) {
            final logDate = log?.date.toDate();
            return logDate?.year == date.year &&
             logDate?.month == date.month &&
             logDate?.day == date.day;
          },
          orElse: () => null,
        );

        ScheduleLogModel? log = logForToday;
        if (log == null) {
          final newLogId = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          await datasource.addLog(template.id, slot.id, newLogId, date);
          final updatedLogs = await datasource.getLogs(template.id, slot.id);
          log = updatedLogs.cast<ScheduleLogModel?>().firstWhere(
            (l) {
              final logDate = l?.date.toDate();
              return logDate?.year == date.year &&
               logDate?.month == date.month &&
               logDate?.day == date.day;
            },
            orElse: () => ScheduleLogModel(
              id: newLogId,
              date: Timestamp.fromDate(date),
              status: 'none',
              checkInAt: null,
              note: null,
            ),
          );
        }

        // 5. Map ออกมาเป็น ScheduleTimelineEntity
        results.add(
          ScheduleTimelineEntity(
            templateId: template.id,
            slotId: slot.id,
            logId: log?.id ?? '',
            courseCode: template.courseCode,
            courseNameEng: template.courseNameEng,
            courseNameTh: template.courseNameTh,
            sectionCode: template.sectionCode,
            room: slot.room,
            startTime: _parseTimeOfDay(slot.startTime),
            endTime: _parseTimeOfDay(slot.endTime),
            note: log?.note ?? '',
            isCheckin: log?.status == "checked_in",
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

    // AppLogger.debug('Loaded day schedule for $date: ${results.length} items');

    return results;
  }

  @override
  Future<void> checkInClass(String templateId, String slotId, String logId) async {
    await datasource.updateCheckinForLog(templateId, slotId, logId);
  }

  @override
  Future<void> updateClassInfo(String templateId, String slotId, String logId, String newRoom, String newNote) async {
    await datasource.updateClassForLog(templateId, slotId, logId, newRoom, newNote);
  }

  @override
  Future<List<ScheduleTemplateEntity>> getAllScheduleTemplates(String userId) async {
    final models = await datasource.getTemplates(userId);
    return models.map((model) => ScheduleTemplateEntity(
      id: model.id,
      courseCode: model.courseCode,
      courseNameEng: model.courseNameEng,
      courseNameTh: model.courseNameTh,
      sectionCode: model.sectionCode, userId: '', courseId: '', sectionId: '', instructor: '', createdAt: DateTime.now(),
      // Add other fields as needed
    )).toList();
  }

  @override
  Future<List<ScheduleSlotEntity>> getSlotsOfTemplate(String templateId) async {
    final models = await datasource.getSlots(templateId);
    // Return the first slot, or throw if none found
    if (models.isEmpty) {
      throw Exception('No slots found for template $templateId');
    }
    return models.map((model) => ScheduleSlotEntity(
      id: model.id,
      room: model.room,
      startTime: model.startTime,
      endTime: model.endTime,
      dayOfWeek: model.dayOfWeek,
    )).toList();
  }

  @override
  Future<void> updateScheduleTemplate(String templateId, List<ScheduleSlotEntity> newSlots) async {
    final slotModels = newSlots.map((entity) => ScheduleSlotModel(
      id: entity.id,
      room: entity.room,
      startTime: entity.startTime,
      endTime: entity.endTime,
      dayOfWeek: entity.dayOfWeek,
    )).toList();
    await datasource.updateScheduleTemplate(templateId, slotModels);
  }
}