import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';

import '../../domain/usecases/get_today_schedule_usecase.dart';
import '../../domain/usecases/get_day_schedule_usecase.dart';


class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetTodayScheduleUseCase getTodaySchedule;
  final GetDayScheduleUseCase getDaySchedule;

  ScheduleBloc({
    required this.getTodaySchedule,
    required this.getDaySchedule,
  }) : super(ScheduleInitial()) {
    on<LoadTodaySchedule>(_onLoadTodaySchedule);
    on<LoadDaySchedule>(_onLoadDaySchedule);
  }

  Future<void> _onLoadTodaySchedule(LoadTodaySchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final schedules = await getTodaySchedule(event.userId);
      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onLoadDaySchedule(LoadDaySchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final schedules = await getDaySchedule(event.userId, event.date);
      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
