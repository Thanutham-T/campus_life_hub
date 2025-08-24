abstract class UserAnnouncementDataSource {
  /// Mark announcement as read for user
  Future<void> markAsRead(String userId, String announcementId);
  
  /// Mark announcement as unread for user
  Future<void> markAsUnread(String userId, String announcementId);
  
  /// Get read status for announcements
  Future<Map<String, bool>> getReadStatus(String userId, List<String> announcementIds);
  
  /// Get bookmarked announcements for user
  Future<List<String>> getBookmarkedAnnouncements(String userId);
  
  /// Add bookmark for user
  Future<void> addBookmark(String userId, String announcementId);
  
  /// Remove bookmark for user
  Future<void> removeBookmark(String userId, String announcementId);
  
  /// Check if announcement is bookmarked by user
  Future<bool> isBookmarked(String userId, String announcementId);
}
