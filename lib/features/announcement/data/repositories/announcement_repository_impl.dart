import 'package:campus_life_hub/features/announcement/data/datasources/announcement_remote_data_source.dart';
import 'package:campus_life_hub/features/announcement/data/datasources/user_announcement_data_source.dart';
import 'package:campus_life_hub/features/announcement/data/models/announcement_model.dart';
import 'package:campus_life_hub/features/announcement/domain/entities/announcement.dart';
import 'package:campus_life_hub/features/announcement/domain/repositories/announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource _remoteDataSource;
  final UserAnnouncementDataSource _userDataSource;

  AnnouncementRepositoryImpl({
    required AnnouncementRemoteDataSource remoteDataSource,
    required UserAnnouncementDataSource userDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _userDataSource = userDataSource;

  @override
  Future<List<Announcement>> getAllAnnouncements() async {
    try {
      final announcementModels = await _remoteDataSource.getAnnouncements();
      return announcementModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get announcements: $e');
    }
  }

  @override
  Future<List<Announcement>> getAnnouncementsByCategory(String category) async {
    try {
      final announcementModels = await _remoteDataSource.getAnnouncementsByCategory(category);
      return announcementModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get announcements by category: $e');
    }
  }

  @override
  Future<List<Announcement>> getAnnouncementsByPriority(String priority) async {
    try {
      final announcementModels = await _remoteDataSource.getAnnouncementsByPriority(priority);
      return announcementModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get announcements by priority: $e');
    }
  }

  @override
  Future<List<Announcement>> getUnreadAnnouncements(String userId) async {
    try {
      final allAnnouncements = await _remoteDataSource.getAnnouncements();
      final announcementIds = allAnnouncements.map((a) => a.id).toList();
      final readStatus = await _userDataSource.getReadStatus(userId, announcementIds);
      
      final unreadAnnouncements = allAnnouncements.where((announcement) {
        return readStatus[announcement.id] != true;
      }).toList();
      
      return unreadAnnouncements.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get unread announcements: $e');
    }
  }

  @override
  Future<List<Announcement>> searchAnnouncements(String query) async {
    try {
      final announcementModels = await _remoteDataSource.searchAnnouncements(query);
      return announcementModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search announcements: $e');
    }
  }

  @override
  Future<Announcement?> getAnnouncementById(String id) async {
    try {
      final announcementModel = await _remoteDataSource.getAnnouncementById(id);
      return announcementModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get announcement by id: $e');
    }
  }

  @override
  Future<String> createAnnouncement(Announcement announcement, String adminId) async {
    try {
      final announcementModel = AnnouncementModel.fromEntity(announcement);
      return await _remoteDataSource.createAnnouncement(announcementModel);
    } catch (e) {
      throw Exception('Failed to create announcement: $e');
    }
  }

  @override
  Future<void> updateAnnouncement(Announcement announcement, String adminId) async {
    try {
      final announcementModel = AnnouncementModel.fromEntity(announcement);
      await _remoteDataSource.updateAnnouncement(announcementModel);
    } catch (e) {
      throw Exception('Failed to update announcement: $e');
    }
  }

  @override
  Future<void> deleteAnnouncement(String id, String adminId) async {
    try {
      await _remoteDataSource.deleteAnnouncement(id);
    } catch (e) {
      throw Exception('Failed to delete announcement: $e');
    }
  }

  @override
  Future<void> markAsRead(String announcementId, String userId) async {
    try {
      await _userDataSource.markAsRead(userId, announcementId);
    } catch (e) {
      throw Exception('Failed to mark as read: $e');
    }
  }

  @override
  Future<void> markAsUnread(String announcementId, String userId) async {
    try {
      await _userDataSource.markAsUnread(userId, announcementId);
    } catch (e) {
      throw Exception('Failed to mark as unread: $e');
    }
  }

  @override
  Future<void> toggleBookmark(String announcementId, String userId) async {
    try {
      final isCurrentlyBookmarked = await _userDataSource.isBookmarked(userId, announcementId);
      
      if (isCurrentlyBookmarked) {
        await _userDataSource.removeBookmark(userId, announcementId);
      } else {
        await _userDataSource.addBookmark(userId, announcementId);
      }
    } catch (e) {
      throw Exception('Failed to toggle bookmark: $e');
    }
  }

  @override
  Future<Map<String, bool>> getReadStatus(String userId, List<String> announcementIds) async {
    try {
      return await _userDataSource.getReadStatus(userId, announcementIds);
    } catch (e) {
      throw Exception('Failed to get read status: $e');
    }
  }

  @override
  Future<List<String>> getBookmarkedAnnouncements(String userId) async {
    try {
      return await _userDataSource.getBookmarkedAnnouncements(userId);
    } catch (e) {
      throw Exception('Failed to get bookmarked announcements: $e');
    }
  }

  @override
  Future<List<Announcement>> getAnnouncementsWithUserData(String userId) async {
    try {
      final allAnnouncements = await _remoteDataSource.getAnnouncements();
      // For now, just return announcements. User-specific data (read status, bookmarks)
      // will be handled separately in the presentation layer
      return allAnnouncements.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get announcements with user data: $e');
    }
  }
}
