import '../models/announcement_model.dart';

abstract class AnnouncementRemoteDataSource {
  /// Get all announcements from Firebase
  Future<List<AnnouncementModel>> getAnnouncements();
  
  /// Get announcements by category
  Future<List<AnnouncementModel>> getAnnouncementsByCategory(String category);
  
  /// Get announcements by priority
  Future<List<AnnouncementModel>> getAnnouncementsByPriority(String priority);
  
  /// Search announcements by title and content
  Future<List<AnnouncementModel>> searchAnnouncements(String query);
  
  /// Get announcement by ID
  Future<AnnouncementModel?> getAnnouncementById(String id);
  
  /// Create new announcement
  Future<String> createAnnouncement(AnnouncementModel announcement);
  
  /// Update announcement
  Future<void> updateAnnouncement(AnnouncementModel announcement);
  
  /// Delete announcement
  Future<void> deleteAnnouncement(String id);
}
