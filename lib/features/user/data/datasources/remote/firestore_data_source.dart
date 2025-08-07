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
      print('💾 FirestoreDataSource: Saving user profile');
      print('   - User ID: ${profile.id}');
      print('   - Email: ${profile.email}');
      print('   - Name: ${profile.firstName} ${profile.lastName}');
      print('   - Student ID: ${profile.studentId}');
      print('   - Faculty: ${profile.faculty}');
      print('   - Major: ${profile.major}');

      // Convert profile to JSON and remove the 'id' field (document ID handles this)
      final data = profile.toJson();
      data.remove('id');

      await _firestore
          .collection('users')
          .doc(profile.id)
          .set(data);

      print('✅ FirestoreDataSource: Profile saved successfully');
    } catch (e) {
      print('❌ FirestoreDataSource: Error saving profile: $e');
      throw Exception('Failed to save user profile: $e');
    }
  }

  @override
  Future<ProfileModel?> getUserProfile(String userId) async {
    try {
      print('🔍 FirestoreDataSource: Getting user profile for userId: $userId');
      
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      
      print('📄 FirestoreDataSource: Document exists: ${doc.exists}');
      
      if (!doc.exists || doc.data() == null) {
        print('❌ FirestoreDataSource: No document found for user: $userId');
        return null;
      }

      final data = doc.data()!;
      print('📋 FirestoreDataSource: Raw document data:');
      data.forEach((key, value) {
        print('   - $key: $value (${value.runtimeType})');
      });

      // Add the document ID to the data
      data['id'] = userId;

      final profile = ProfileModel.fromJson(data);
      print('✅ FirestoreDataSource: Profile parsed successfully');
      print('   - Name: ${profile.firstName} ${profile.lastName}');
      print('   - Student ID: ${profile.studentId}');
      print('   - Faculty: ${profile.faculty}');

      return profile;
    } catch (e) {
      print('❌ FirestoreDataSource: Error getting profile: $e');
      return null;
    }
  }

  @override
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      print('🔄 FirestoreDataSource: Updating user profile for userId: $userId');
      print('📝 FirestoreDataSource: Update data: $data');

      await _firestore
          .collection('users')
          .doc(userId)
          .update(data);

      print('✅ FirestoreDataSource: Profile updated successfully');
    } catch (e) {
      print('❌ FirestoreDataSource: Error updating profile: $e');
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    try {
      print('🗑️ FirestoreDataSource: Deleting user profile for userId: $userId');

      await _firestore
          .collection('users')
          .doc(userId)
          .delete();

      print('✅ FirestoreDataSource: Profile deleted successfully');
    } catch (e) {
      print('❌ FirestoreDataSource: Error deleting profile: $e');
      throw Exception('Failed to delete user profile: $e');
    }
  }
}
