import 'package:equatable/equatable.dart';
import '../../domain/entities/schedule_timeline_entity.dart';


abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleTimelineEntity> schedules;
  final DateTime selectedDate;

  const ScheduleLoaded(this.schedules, this.selectedDate);

  @override
  List<Object?> get props => [schedules, selectedDate];
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}
