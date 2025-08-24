import '../entities/announcement.dart';

/// Abstract repository interface for announcements
/// Define the contract for announcement data operations
abstract class AnnouncementRepository {
  
  /// Get all announcements
  Future<List<Announcement>> getAllAnnouncements();
  
  /// Get announcements by priority
  Future<List<Announcement>> getAnnouncementsByPriority(String priority);
  
  /// Get announcements by category
  Future<List<Announcement>> getAnnouncementsByCategory(String category);
  
  /// Get unread announcements for a specific user
  Future<List<Announcement>> getUnreadAnnouncements(String userId);
  
  /// Get announcement by ID
  Future<Announcement?> getAnnouncementById(String id);
  
  /// Mark announcement as read for a specific user
  Future<void> markAsRead(String announcementId, String userId);
  
  /// Mark announcement as unread for a specific user
  Future<void> markAsUnread(String announcementId, String userId);
  
  /// Search announcements
  Future<List<Announcement>> searchAnnouncements(String query);
  
  /// Create new announcement (Admin only)
  Future<String> createAnnouncement(Announcement announcement, String adminId);
  
  /// Update announcement (Admin only)
  Future<void> updateAnnouncement(Announcement announcement, String adminId);
  
  /// Delete announcement (Admin only)
  Future<void> deleteAnnouncement(String announcementId, String adminId);
  
  /// Get bookmarked announcements for user
  Future<List<String>> getBookmarkedAnnouncements(String userId);
  
  /// Toggle bookmark for announcement
  Future<void> toggleBookmark(String announcementId, String userId);
  
  /// Get read status for announcements for a specific user
  Future<Map<String, bool>> getReadStatus(String userId, List<String> announcementIds);
  
  /// Get announcements with user-specific data (read status, bookmarks)
  Future<List<Announcement>> getAnnouncementsWithUserData(String userId);
}
