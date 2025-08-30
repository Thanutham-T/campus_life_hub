import 'package:equatable/equatable.dart';


abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

// โหลดตารางรายวัน
class LoadTodaySchedule extends ScheduleEvent {
  final String userId;

  const LoadTodaySchedule({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadDaySchedule extends ScheduleEvent {
  final String userId;
  final DateTime date;

  const LoadDaySchedule({required this.userId, required this.date});

  @override
  List<Object?> get props => [userId, date];
}

class CheckInClass extends ScheduleEvent {
  final String userId;

  final String templateId;
  final String slotId;
  final String logId;

  const CheckInClass({
    required this.userId,
    required this.templateId,
    required this.slotId,
    required this.logId,
  });

  @override
  List<Object?> get props => [templateId, slotId, logId];
}

class UpdateClass extends ScheduleEvent {
  final String userId;
  final String templateId;
  final String slotId;
  final String logId;
  final String newRoom;
  final String newNote;

  const UpdateClass({
    required this.userId,
    required this.templateId,
    required this.slotId,
    required this.logId,
    required this.newRoom,
    required this.newNote,
  });

  @override
  List<Object?> get props => [userId, templateId, slotId, logId, newRoom, newNote];
}

class GetAllScheduleTemplates extends ScheduleEvent {
  final String userId;

  const GetAllScheduleTemplates({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class GetAllSlotsOfTemplate extends ScheduleEvent {
  final String templateId;

  const GetAllSlotsOfTemplate({
    required this.templateId,
  });

  @override
  List<Object?> get props => [templateId];
}