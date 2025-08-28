import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';

import '../../domain/usecases/get_today_schedule_usecase.dart';
import '../../domain/usecases/get_day_schedule_usecase.dart';
import '../../domain/usecases/check_in_class_usecase.dart';
import '../../domain/usecases/update_class_usecase.dart';


class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetTodayScheduleUseCase getTodaySchedule;
  final GetDayScheduleUseCase getDaySchedule;
  final CheckInClassUseCase checkInClass;
  final UpdateClassUseCase updateClass;

  ScheduleBloc({
    required this.getTodaySchedule,
    required this.getDaySchedule,
    required this.checkInClass,
    required this.updateClass,
  }) : super(ScheduleInitial()) {
    on<LoadTodaySchedule>(_onLoadTodaySchedule);
    on<LoadDaySchedule>(_onLoadDaySchedule);
    on<CheckInClass>(_onCheckInClass);
    on<UpdateClass>(_onUpdateClass);
  }

  Future<void> _onLoadTodaySchedule(LoadTodaySchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final schedules = await getTodaySchedule(event.userId);
      emit(ScheduleLoaded(schedules, DateTime.now()));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onLoadDaySchedule(LoadDaySchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final schedules = await getDaySchedule(event.userId, event.date);
      emit(ScheduleLoaded(schedules, event.date));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onCheckInClass(CheckInClass event, Emitter<ScheduleState> emit) async {
    DateTime? selectedDate;
    final currentState = state;
    if (currentState is ScheduleLoaded) {
      selectedDate = currentState.selectedDate;
    }
    try {
      await checkInClass(event.templateId, event.slotId, event.logId);
      final dateToUse = selectedDate ?? DateTime.now();
      final schedules = await getDaySchedule(event.userId, dateToUse);
      emit(ScheduleLoaded(schedules, dateToUse));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onUpdateClass(UpdateClass event, Emitter<ScheduleState> emit) async {
    DateTime? selectedDate;
    final currentState = state;
    if (currentState is ScheduleLoaded) {
      selectedDate = currentState.selectedDate;
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
      emit(ScheduleLoaded(schedules, dateToUse));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
