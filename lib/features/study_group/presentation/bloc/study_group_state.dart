import 'package:equatable/equatable.dart';
import '../../domain/entities/study_group.dart';

abstract class StudyGroupState extends Equatable {
  const StudyGroupState();

  @override
  List<Object?> get props => [];
}

class StudyGroupInitial extends StudyGroupState {}

class StudyGroupLoading extends StudyGroupState {}

class StudyGroupsLoaded extends StudyGroupState {
  final List<StudyGroup> studyGroups;

  const StudyGroupsLoaded(this.studyGroups);

  @override
  List<Object?> get props => [studyGroups];
}

class StudyGroupLoaded extends StudyGroupState {
  final StudyGroup studyGroup;

  const StudyGroupLoaded(this.studyGroup);

  @override
  List<Object?> get props => [studyGroup];
}

class StudyGroupCreated extends StudyGroupState {
  final String groupId;

  const StudyGroupCreated(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class StudyGroupActionSuccess extends StudyGroupState {
  final String message;

  const StudyGroupActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class StudyGroupError extends StudyGroupState {
  final String message;

  const StudyGroupError(this.message);

  @override
  List<Object?> get props => [message];
}

class StudyGroupSearchResults extends StudyGroupState {
  final List<StudyGroup> results;
  final String query;

  const StudyGroupSearchResults(this.results, this.query);

  @override
  List<Object?> get props => [results, query];
}
