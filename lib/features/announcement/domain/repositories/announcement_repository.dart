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
  
  /// Get unread announcements
  Future<List<Announcement>> getUnreadAnnouncements();
  
  /// Get announcement by ID
  Future<Announcement?> getAnnouncementById(String id);
  
  /// Mark announcement as read
  Future<void> markAsRead(String id);
  
  /// Mark announcement as unread
  Future<void> markAsUnread(String id);
  
  /// Search announcements
  Future<List<Announcement>> searchAnnouncements(String query);
}
