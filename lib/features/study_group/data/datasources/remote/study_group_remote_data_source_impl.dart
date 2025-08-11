import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/study_group_model.dart';
import 'study_group_remote_data_source.dart';

class StudyGroupRemoteDataSourceImpl implements StudyGroupRemoteDataSource {
  final FirebaseFirestore firestore;

  StudyGroupRemoteDataSourceImpl({required this.firestore});

  CollectionReference get _studyGroupsCollection => 
      firestore.collection('study_groups');

  @override
  Stream<List<StudyGroupModel>> getStudyGroups() {
    return _studyGroupsCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudyGroupModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<StudyGroupModel?> getStudyGroupById(String id) async {
    try {
      final doc = await _studyGroupsCollection.doc(id).get();
      if (doc.exists) {
        return StudyGroupModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get study group: $e');
    }
  }

  @override
  Future<String> createStudyGroup(StudyGroupModel studyGroup) async {
    try {
      final docRef = await _studyGroupsCollection.add(studyGroup.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create study group: $e');
    }
  }

  @override
  Future<void> updateStudyGroup(StudyGroupModel studyGroup) async {
    try {
      await _studyGroupsCollection
          .doc(studyGroup.id)
          .update(studyGroup.toFirestore());
    } catch (e) {
      throw Exception('Failed to update study group: $e');
    }
  }

  @override
  Future<void> deleteStudyGroup(String id) async {
    try {
      await _studyGroupsCollection.doc(id).update({'isActive': false});
    } catch (e) {
      throw Exception('Failed to delete study group: $e');
    }
  }

  @override
  Future<void> joinStudyGroup(String groupId, String userId) async {
    try {
      await _studyGroupsCollection.doc(groupId).update({
        'memberIds': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      throw Exception('Failed to join study group: $e');
    }
  }

  @override
  Future<void> leaveStudyGroup(String groupId, String userId) async {
    try {
      await _studyGroupsCollection.doc(groupId).update({
        'memberIds': FieldValue.arrayRemove([userId])
      });
    } catch (e) {
      throw Exception('Failed to leave study group: $e');
    }
  }

  @override
  Stream<List<StudyGroupModel>> getStudyGroupsByCategory(String category) {
    return _studyGroupsCollection
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudyGroupModel.fromFirestore(doc))
            .toList());
  }

  @override
  Stream<List<StudyGroupModel>> getUserStudyGroups(String userId) {
    return _studyGroupsCollection
        .where('memberIds', arrayContains: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudyGroupModel.fromFirestore(doc))
            .toList());
  }

  @override
  Stream<List<StudyGroupModel>> searchStudyGroups(String query) {
    // Note: Firestore doesn't support full-text search natively
    // This is a simple implementation that searches by name
    return _studyGroupsCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudyGroupModel.fromFirestore(doc))
            .where((group) => 
                group.name.toLowerCase().contains(query.toLowerCase()) ||
                group.subject.toLowerCase().contains(query.toLowerCase()) ||
                group.description.toLowerCase().contains(query.toLowerCase()))
            .toList());
  }
}
