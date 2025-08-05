import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/profile_model.dart';

abstract class FirestoreDataSource {
  Future<void> saveUserProfile(ProfileModel profile);
  Future<ProfileModel?> getUserProfile(String userId);
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data);
  Future<void> deleteUserProfile(String userId);
}

class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> saveUserProfile(ProfileModel profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.id)
          .set(profile.toJson());
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  @override
  Future<ProfileModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      
      if (doc.exists && doc.data() != null) {
        return ProfileModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update(data);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }
}
