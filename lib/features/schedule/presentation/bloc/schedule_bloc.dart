import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';

import 'package:campus_life_hub/features/schedule/domain/entities/schedule_template_entity.dart';

import 'package:campus_life_hub/features/schedule/domain/usecases/get_today_schedule_usecase.dart';
import 'package:campus_life_hub/features/schedule/domain/usecases/get_day_schedule_usecase.dart';
import 'package:campus_life_hub/features/schedule/domain/usecases/check_in_class_usecase.dart';
import 'package:campus_life_hub/features/schedule/domain/usecases/update_class_usecase.dart';
import 'package:campus_life_hub/features/schedule/domain/usecases/get_all_schedule_templates_usecase.dart';


class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetTodayScheduleUseCase getTodaySchedule;
  final GetDayScheduleUseCase getDaySchedule;
  final CheckInClassUseCase checkInClass;
  final UpdateClassUseCase updateClass;
  final GetAllScheduleTemplateUseCase getAllScheduleTemplates;

  ScheduleBloc({
    required this.getTodaySchedule,
    required this.getDaySchedule,
    required this.checkInClass,
    required this.updateClass,
    required this.getAllScheduleTemplates,
  }) : super(ScheduleInitial()) {
    on<LoadTodaySchedule>(_onLoadTodaySchedule);
    on<LoadDaySchedule>(_onLoadDaySchedule);
    on<CheckInClass>(_onCheckInClass);
    on<UpdateClass>(_onUpdateClass);
    on<GetAllScheduleTemplates>(_onGetAllScheduleTemplates);
  }

  Future<void> _onLoadTodaySchedule(LoadTodaySchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final schedules = await getTodaySchedule(event.userId);
      emit(ScheduleLoaded([], schedules, DateTime.now()));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onLoadDaySchedule(LoadDaySchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final schedules = await getDaySchedule(event.userId, event.date);
      emit(ScheduleLoaded([], schedules, event.date));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onCheckInClass(CheckInClass event, Emitter<ScheduleState> emit) async {
    DateTime? selectedDate;
    List<ScheduleTemplateEntity> templates = [];

    final currentState = state;
    if (currentState is ScheduleLoaded) {
      selectedDate = currentState.selectedDate;
      templates = currentState.templates;
    }
    try {
      await checkInClass(event.templateId, event.slotId, event.logId);
      final dateToUse = selectedDate ?? DateTime.now();
      final schedules = await getDaySchedule(event.userId, dateToUse);
      emit(ScheduleLoaded(templates, schedules, dateToUse));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onUpdateClass(UpdateClass event, Emitter<ScheduleState> emit) async {
    DateTime? selectedDate;
    List<ScheduleTemplateEntity> templates = [];
    final currentState = state;
    if (currentState is ScheduleLoaded) {
      selectedDate = currentState.selectedDate;
      templates = currentState.templates;
    }
    try {
      await updateClass(
        event.templateId,
        event.slotId,
        event.logId,
        event.newRoom,
        event.newNote,
      );
      final dateToUse = selectedDate ?? DateTime.now();
      final schedules = await getDaySchedule(event.userId, dateToUse);
      emit(ScheduleLoaded(templates, schedules, dateToUse));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onGetAllScheduleTemplates(GetAllScheduleTemplates event, Emitter<ScheduleState> emit) async {
    DateTime? selectedDate;
    final currentState = state;
    if (currentState is ScheduleLoaded) {
      selectedDate = currentState.selectedDate;
    }
    try {
      final dateToUse = selectedDate ?? DateTime.now();
      final schedules = await getDaySchedule(event.userId, dateToUse);
      final templates = await getAllScheduleTemplates(event.userId);
      emit(ScheduleLoaded(templates, schedules, dateToUse));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

}
