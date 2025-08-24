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
}
