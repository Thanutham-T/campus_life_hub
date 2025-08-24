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
