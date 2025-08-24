import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/announcement_model.dart';
import 'announcement_remote_data_source.dart';

class AnnouncementFirebaseDataSource implements AnnouncementRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'announcements';

  AnnouncementFirebaseDataSource({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => AnnouncementModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get announcements: $e');
    }
  }

  @override
  Future<List<AnnouncementModel>> getAnnouncementsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => AnnouncementModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get announcements by category: $e');
    }
  }

  @override
  Future<List<AnnouncementModel>> getAnnouncementsByPriority(String priority) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('priority', isEqualTo: priority)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => AnnouncementModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get announcements by priority: $e');
    }
  }

  @override
  Future<List<AnnouncementModel>> searchAnnouncements(String query) async {
    try {
      // Note: Firestore doesn't support full-text search natively
      // This is a simple implementation that searches title and content
      // For production, consider using Algolia or similar service
      
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('date', descending: true)
          .get();

      final allAnnouncements = querySnapshot.docs
          .map((doc) => AnnouncementModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      // Filter by title and content containing the query (case-insensitive)
      final lowercaseQuery = query.toLowerCase();
      return allAnnouncements.where((announcement) {
        return announcement.title.toLowerCase().contains(lowercaseQuery) ||
               announcement.content.toLowerCase().contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search announcements: $e');
    }
  }

  @override
  Future<AnnouncementModel?> getAnnouncementById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      
      if (!doc.exists) {
        return null;
      }

      return AnnouncementModel.fromJson({
        'id': doc.id,
        ...doc.data()!,
      });
    } catch (e) {
      throw Exception('Failed to get announcement by id: $e');
    }
  }

  @override
  Future<String> createAnnouncement(AnnouncementModel announcement) async {
    try {
      final docRef = await _firestore.collection(_collection).add(announcement.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create announcement: $e');
    }
  }

  @override
  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(announcement.id)
          .update(announcement.toJson());
    } catch (e) {
      throw Exception('Failed to update announcement: $e');
    }
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete announcement: $e');
    }
  }
}
