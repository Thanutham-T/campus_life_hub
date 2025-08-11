import 'package:equatable/equatable.dart';
import '../../domain/entities/study_group.dart';

abstract class StudyGroupEvent extends Equatable {
  const StudyGroupEvent();

  @override
  List<Object?> get props => [];
}

class GetStudyGroupsEvent extends StudyGroupEvent {}

class GetStudyGroupsByCategory extends StudyGroupEvent {
  final String category;

  const GetStudyGroupsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class GetUserStudyGroups extends StudyGroupEvent {
  final String userId;

  const GetUserStudyGroups(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SearchStudyGroups extends StudyGroupEvent {
  final String query;

  const SearchStudyGroups(this.query);

  @override
  List<Object?> get props => [query];
}

class CreateStudyGroupEvent extends StudyGroupEvent {
  final StudyGroup studyGroup;

  const CreateStudyGroupEvent(this.studyGroup);

  @override
  List<Object?> get props => [studyGroup];
}

class UpdateStudyGroupEvent extends StudyGroupEvent {
  final StudyGroup studyGroup;

  const UpdateStudyGroupEvent(this.studyGroup);

  @override
  List<Object?> get props => [studyGroup];
}

class DeleteStudyGroupEvent extends StudyGroupEvent {
  final String id;

  const DeleteStudyGroupEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class JoinStudyGroupEvent extends StudyGroupEvent {
  final String groupId;
  final String userId;

  const JoinStudyGroupEvent(this.groupId, this.userId);

  @override
  List<Object?> get props => [groupId, userId];
}

class LeaveStudyGroupEvent extends StudyGroupEvent {
  final String groupId;
  final String userId;

  const LeaveStudyGroupEvent(this.groupId, this.userId);

  @override
  List<Object?> get props => [groupId, userId];
}

class GetStudyGroupByIdEvent extends StudyGroupEvent {
  final String id;

  const GetStudyGroupByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}
