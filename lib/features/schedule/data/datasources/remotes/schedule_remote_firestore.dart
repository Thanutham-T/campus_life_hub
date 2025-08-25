import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:campus_life_hub/core/core_modules.dart';

import '../../models/schedule_template_model.dart';
import '../../models/schedule_slots_model.dart';
import '../../models/schedule_log_model.dart';


abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleTemplateModel>> getTemplates(String userId);
  Future<List<ScheduleSlotModel>> getSlots(String templateId);
  Future<List<ScheduleLogModel>> getLogs(String templateId, String slotId);

  Future<void> addTemplate(ScheduleTemplateModel template);
  Future<void> addSlot(String templateId, ScheduleSlotModel slot);
  Future<void> addLog(String templateId, String slotId, ScheduleLogModel log);

  /// Add template plus its slots in one operation (use when enrolling)
  Future<void> addTemplateWithSlots(ScheduleTemplateModel template, List<ScheduleSlotModel> slots);

  /// Delete templates (and their slots/logs) for a user by section id
  Future<void> deleteTemplateBySection(String userId, String sectionId);
}

class ScheduleRemoteFirestoreImpl implements ScheduleRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

@override
  Future<List<ScheduleTemplateModel>> getTemplates(String userId) async {
    final query = await _firestore
        .collection('schedules')
        .where('userId', isEqualTo: userId)
        .get();

    return query.docs.map((doc) => ScheduleTemplateModel.fromFirestore(doc)).toList();
  }

  @override
  Future<void> addTemplate(ScheduleTemplateModel template) async {
    await _firestore.collection('schedules').doc(template.id).set({
      'userId': template.userId,
      'courseId': template.courseId,
      'courseNameEng': template.courseNameEng,
      'courseNameTh': template.courseNameTh,
      'sectionId': template.sectionId,
      'sectionCode': template.sectionCode,
      'instructor': template.instructor,
      'createdAt': template.createdAt,
    });
  }

  // ---------- Slots ----------
  @override
  Future<List<ScheduleSlotModel>> getSlots(String templateId) async {
    final query = await _firestore
        .collection('schedules')
        .doc(templateId)
        .collection('slots')
        .get();

    return query.docs.map((doc) => ScheduleSlotModel.fromFirestore(doc)).toList();
  }

  @override
  Future<void> addSlot(String templateId, ScheduleSlotModel slot) async {
    await _firestore
        .collection('schedules')
        .doc(templateId)
        .collection('slots')
        .doc(slot.id)
        .set({
      'dayOfWeek': slot.dayOfWeek,
      'startTime': slot.startTime,
      'endTime': slot.endTime,
      'room': slot.room,
      'origin': slot.origin,
      'isActive': slot.isActive,
      'isCustom': slot.isCustom,
    });
  }

  // ---------- Logs ----------
  @override
  Future<List<ScheduleLogModel>> getLogs(String templateId, String slotId) async {
    final query = await _firestore
        .collection('schedules')
        .doc(templateId)
        .collection('slots')
        .doc(slotId)
        .collection('logs')
        .get();

    return query.docs.map((doc) => ScheduleLogModel.fromFirestore(doc)).toList();
  }

  @override
  Future<void> addLog(String templateId, String slotId, ScheduleLogModel log) async {
    await _firestore
        .collection('schedules')
        .doc(templateId)
        .collection('slots')
        .doc(slotId)
        .collection('logs')
        .doc(log.id)
        .set({
      'date': log.date,
      'status': log.status,
      'checkInAt': log.checkInAt,
      'note': log.note,
    });
  }

  /// Add template and its slots atomically and logs
  @override
  Future<void> addTemplateWithSlots(ScheduleTemplateModel template, List<ScheduleSlotModel> slots) async {
    final batch = _firestore.batch();
    final templateRef = _firestore.collection('schedules').doc(template.id);

    batch.set(templateRef, {
      'userId': template.userId,
      'courseId': template.courseId,
      'courseNameEng': template.courseNameEng,
      'courseNameTh': template.courseNameTh,
      'sectionId': template.sectionId,
      'sectionCode': template.sectionCode,
      'instructor': template.instructor,
      'createdAt': template.createdAt,
    });

    for (final slot in slots) {
      final slotRef = templateRef.collection('slots').doc(slot.id);
      batch.set(slotRef, {
        'dayOfWeek': slot.dayOfWeek,
        'startTime': slot.startTime,
        'endTime': slot.endTime,
        'room': slot.room,
        'origin': slot.origin,
        'isActive': slot.isActive,
        'isCustom': slot.isCustom,
      });


      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

      final dayOfWeekMap = {
          'monday': 1,
          'tuesday': 2,
          'wednesday': 3,
          'thursday': 4,
          'friday': 5,
          'saturday': 6,
          'sunday': 7,
        };
        
      // Add logs for each day in the week matching the slot's dayOfWeek
      for (int i = 0; i < 7; i++) {
        final date = startOfWeek.add(Duration(days: i));
        
        final slotWeekday = dayOfWeekMap[slot.dayOfWeek.toLowerCase()];
        if (date.weekday == slotWeekday) {
          final logId = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          final logRef = slotRef.collection('logs').doc(logId);
          batch.set(logRef, {
            'date': date,
            'status': 'pending',
            'checkInAt': null,
            'note': '',
          });
        }
      }
    }

    await batch.commit();
  }

  /// New: delete template(s) by userId + sectionId, including slots and logs
  @override
  Future<void> deleteTemplateBySection(String userId, String sectionId) async {
    final query = await _firestore
        .collection('schedules')
        .where('userId', isEqualTo: userId)
        .where('sectionId', isEqualTo: sectionId)
        .get();

    for (final tplDoc in query.docs) {
      final tplRef = tplDoc.reference;

      // delete slots and their logs
      final slotsSnap = await tplRef.collection('slots').get();
      for (final slotDoc in slotsSnap.docs) {
        final slotRef = slotDoc.reference;

        final logsSnap = await slotRef.collection('logs').get();
        // delete logs
        final logDeletes = logsSnap.docs.map((d) => d.reference.delete());
        await Future.wait(logDeletes);

        // delete slot
        await slotRef.delete();
      }

      // delete template document
      await tplRef.delete();
    }
  }
}
