import '../../models/study_group_model.dart';

abstract class StudyGroupRemoteDataSource {
  Stream<List<StudyGroupModel>> getStudyGroups();
  Future<StudyGroupModel?> getStudyGroupById(String id);
  Future<String> createStudyGroup(StudyGroupModel studyGroup);
  Future<void> updateStudyGroup(StudyGroupModel studyGroup);
  Future<void> deleteStudyGroup(String id);
  Future<void> joinStudyGroup(String groupId, String userId);
  Future<void> leaveStudyGroup(String groupId, String userId);
  Stream<List<StudyGroupModel>> getStudyGroupsByCategory(String category);
  Stream<List<StudyGroupModel>> getUserStudyGroups(String userId);
  Stream<List<StudyGroupModel>> searchStudyGroups(String query);
}
