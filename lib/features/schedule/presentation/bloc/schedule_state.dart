import 'package:equatable/equatable.dart';

import 'package:campus_life_hub/features/schedule/domain/entities/schedule_timeline_entity.dart';
import 'package:campus_life_hub/features/schedule/domain/entities/schedule_template_entity.dart';


abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleTemplateEntity> templates;
  final List<ScheduleTimelineEntity> schedules;
  final DateTime selectedDate;

  const ScheduleLoaded(
    this.templates,
    this.schedules,
    this.selectedDate,
  );

  const ScheduleLoaded.withDefaults(
    this.schedules,
    this.selectedDate,
  ) : templates = const [];

  @override
  List<Object?> get props => [templates, schedules, selectedDate];
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}
