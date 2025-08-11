import 'package:dartz/dartz.dart';
import '../entities/study_group.dart';

abstract class StudyGroupRepository {
  /// Get all active study groups
  Stream<Either<String, List<StudyGroup>>> getStudyGroups();
  
  /// Get study group by ID
  Future<Either<String, StudyGroup?>> getStudyGroupById(String id);
  
  /// Create new study group
  Future<Either<String, String>> createStudyGroup(StudyGroup studyGroup);
  
  /// Update study group
  Future<Either<String, void>> updateStudyGroup(StudyGroup studyGroup);
  
  /// Delete study group
  Future<Either<String, void>> deleteStudyGroup(String id);
  
  /// Join study group
  Future<Either<String, void>> joinStudyGroup(String groupId, String userId);
  
  /// Leave study group
  Future<Either<String, void>> leaveStudyGroup(String groupId, String userId);
  
  /// Get study groups by category
  Stream<Either<String, List<StudyGroup>>> getStudyGroupsByCategory(String category);
  
  /// Get study groups that user is member of
  Stream<Either<String, List<StudyGroup>>> getUserStudyGroups(String userId);
  
  /// Search study groups
  Stream<Either<String, List<StudyGroup>>> searchStudyGroups(String query);
}
