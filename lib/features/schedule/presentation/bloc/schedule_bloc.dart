import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';

import '../../domain/usecases/get_today_schedule_usecase.dart';
import '../../domain/usecases/get_day_schedule_usecase.dart';
import '../../domain/usecases/check_in_class_usecase.dart';


class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetTodayScheduleUseCase getTodaySchedule;
  final GetDayScheduleUseCase getDaySchedule;
  final CheckInClassUseCase checkInClass;

  ScheduleBloc({
    required this.getTodaySchedule,
    required this.getDaySchedule,
    required this.checkInClass,
  }) : super(ScheduleInitial()) {
    on<LoadTodaySchedule>(_onLoadTodaySchedule);
    on<LoadDaySchedule>(_onLoadDaySchedule);
    on<CheckInClass>(_onCheckInClass);
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
    emit(ScheduleLoading());
    try {
      await checkInClass(event.templateId, event.slotId, event.logId);
      final dateToUse = selectedDate ?? DateTime.now();
      final schedules = await getDaySchedule(event.userId, dateToUse);
      emit(ScheduleLoaded(schedules, dateToUse));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
