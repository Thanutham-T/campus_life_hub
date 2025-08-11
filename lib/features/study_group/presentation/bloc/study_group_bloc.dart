import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/study_group.dart';
import '../../domain/repositories/study_group_repository.dart';
import 'study_group_event.dart';
import 'study_group_state.dart';

class StudyGroupBloc extends Bloc<StudyGroupEvent, StudyGroupState> {
  final StudyGroupRepository repository;

  StudyGroupBloc({
    required this.repository,
  }) : super(StudyGroupInitial()) {
    on<GetStudyGroupsEvent>(_onGetStudyGroups);
    on<GetStudyGroupByIdEvent>(_onGetStudyGroupById);
    on<CreateStudyGroupEvent>(_onCreateStudyGroup);
    on<UpdateStudyGroupEvent>(_onUpdateStudyGroup);
    on<DeleteStudyGroupEvent>(_onDeleteStudyGroup);
    on<JoinStudyGroupEvent>(_onJoinStudyGroup);
    on<LeaveStudyGroupEvent>(_onLeaveStudyGroup);
    on<GetStudyGroupsByCategory>(_onGetStudyGroupsByCategory);
    on<GetUserStudyGroups>(_onGetUserStudyGroups);
    on<SearchStudyGroups>(_onSearchStudyGroups);
  }

  void _onGetStudyGroups(GetStudyGroupsEvent event, Emitter<StudyGroupState> emit) async {
    emit(StudyGroupLoading());
    
    await emit.forEach(
      repository.getStudyGroups(),
      onData: (Either<String, List<StudyGroup>> result) {
        return result.fold(
          (error) => StudyGroupError(error),
          (studyGroups) {
            final sorted = [...studyGroups]
              ..sort((a, b) => b.lastActivityTime.compareTo(a.lastActivityTime));
            return StudyGroupsLoaded(sorted);
          },
        );
      },
      onError: (error, stackTrace) => StudyGroupError(error.toString()),
    );
  }

  void _onGetStudyGroupById(GetStudyGroupByIdEvent event, Emitter<StudyGroupState> emit) async {
    emit(StudyGroupLoading());
    
    final result = await repository.getStudyGroupById(event.id);
    
    result.fold(
      (error) => emit(StudyGroupError(error)),
      (studyGroup) {
        if (studyGroup != null) {
          emit(StudyGroupLoaded(studyGroup));
        } else {
          emit(const StudyGroupError('Study group not found'));
        }
      },
    );
  }

  void _onCreateStudyGroup(CreateStudyGroupEvent event, Emitter<StudyGroupState> emit) async {
    // อย่าเปลี่ยน state หลักของ list เพื่อให้ stream ปัจจุบันยังคงทำงานและอัปเดตอัตโนมัติ
    final result = await repository.createStudyGroup(event.studyGroup);
    result.fold(
      (error) => emit(StudyGroupError(error)),
      (_) {
        // ไม่ emit อะไร (หรือจะ emit StudyGroupActionSuccess ก็ได้ถ้าต้องการ snackbar)
      },
    );
  }

  void _onUpdateStudyGroup(UpdateStudyGroupEvent event, Emitter<StudyGroupState> emit) async {
    emit(StudyGroupLoading());
    
    final result = await repository.updateStudyGroup(event.studyGroup);
    
    result.fold(
      (error) => emit(StudyGroupError(error)),
      (_) => emit(const StudyGroupActionSuccess('Study group updated successfully')),
    );
  }

  void _onDeleteStudyGroup(DeleteStudyGroupEvent event, Emitter<StudyGroupState> emit) async {
    emit(StudyGroupLoading());
    
    final result = await repository.deleteStudyGroup(event.id);
    
    result.fold(
      (error) => emit(StudyGroupError(error)),
      (_) => emit(const StudyGroupActionSuccess('Study group deleted successfully')),
    );
  }

  void _onJoinStudyGroup(JoinStudyGroupEvent event, Emitter<StudyGroupState> emit) async {
    emit(StudyGroupLoading());
    
    final result = await repository.joinStudyGroup(event.groupId, event.userId);
    
    result.fold(
      (error) => emit(StudyGroupError(error)),
      (_) => emit(const StudyGroupActionSuccess('Joined study group successfully')),
    );
  }

  void _onLeaveStudyGroup(LeaveStudyGroupEvent event, Emitter<StudyGroupState> emit) async {
    emit(StudyGroupLoading());
    
    final result = await repository.leaveStudyGroup(event.groupId, event.userId);
    
    result.fold(
      (error) => emit(StudyGroupError(error)),
      (_) => emit(const StudyGroupActionSuccess('Left study group successfully')),
    );
  }

  void _onGetStudyGroupsByCategory(GetStudyGroupsByCategory event, Emitter<StudyGroupState> emit) async {
    emit(StudyGroupLoading());
    
    await emit.forEach(
      repository.getStudyGroupsByCategory(event.category),
      onData: (Either<String, List<StudyGroup>> result) {
        return result.fold(
          (error) => StudyGroupError(error),
          (studyGroups) {
            final sorted = [...studyGroups]
              ..sort((a, b) => b.lastActivityTime.compareTo(a.lastActivityTime));
            return StudyGroupsLoaded(sorted);
          },
        );
      },
      onError: (error, stackTrace) => StudyGroupError(error.toString()),
    );
  }

  void _onGetUserStudyGroups(GetUserStudyGroups event, Emitter<StudyGroupState> emit) async {
    emit(StudyGroupLoading());
    
    await emit.forEach(
      repository.getUserStudyGroups(event.userId),
      onData: (Either<String, List<StudyGroup>> result) {
        return result.fold(
          (error) => StudyGroupError(error),
          (studyGroups) {
            final sorted = [...studyGroups]
              ..sort((a, b) => b.lastActivityTime.compareTo(a.lastActivityTime));
            return StudyGroupsLoaded(sorted);
          },
        );
      },
      onError: (error, stackTrace) => StudyGroupError(error.toString()),
    );
  }

  void _onSearchStudyGroups(SearchStudyGroups event, Emitter<StudyGroupState> emit) async {
    emit(StudyGroupLoading());
    
    await emit.forEach(
      repository.searchStudyGroups(event.query),
      onData: (Either<String, List<StudyGroup>> result) {
        return result.fold(
          (error) => StudyGroupError(error),
          (studyGroups) {
            final sorted = [...studyGroups]
              ..sort((a, b) => b.lastActivityTime.compareTo(a.lastActivityTime));
            return StudyGroupSearchResults(sorted, event.query);
          },
        );
      },
      onError: (error, stackTrace) => StudyGroupError(error.toString()),
    );
  }
}
