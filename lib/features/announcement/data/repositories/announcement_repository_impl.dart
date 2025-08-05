import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../datasources/local/announcement_local_datasource.dart';
import '../datasources/remote/announcement_remote_datasource.dart';

/// Implementation of announcement repository
class AnnouncementRepositoryImpl implements AnnouncementRepository {
  
  final AnnouncementRemoteDataSource remoteDataSource;
  final AnnouncementLocalDataSource localDataSource;

  AnnouncementRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Announcement>> getAllAnnouncements() async {
    try {
      // Try to get from remote first
      final remoteAnnouncements = await remoteDataSource.getAllAnnouncements();
      
      // Cache the data locally
      await localDataSource.cacheAnnouncements(remoteAnnouncements);
      
      // Convert models to entities
      return remoteAnnouncements.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Fallback to local cache if remote fails
      final cachedAnnouncements = await localDataSource.getCachedAnnouncements();
      return cachedAnnouncements.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<List<Announcement>> getAnnouncementsByPriority(String priority) async {
    try {
      final announcements = await remoteDataSource.getAnnouncementsByPriority(priority);
      return announcements.map((model) => model.toEntity()).toList();
    } catch (e) {
      final cachedAnnouncements = await localDataSource.getCachedAnnouncements();
      final filtered = cachedAnnouncements.where((model) => 
          model.priority == priority).toList();
      return filtered.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<List<Announcement>> getAnnouncementsByCategory(String category) async {
    try {
      final announcements = await remoteDataSource.getAnnouncementsByCategory(category);
      return announcements.map((model) => model.toEntity()).toList();
    } catch (e) {
      final cachedAnnouncements = await localDataSource.getCachedAnnouncements();
      final filtered = cachedAnnouncements.where((model) => 
          model.category == category).toList();
      return filtered.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<List<Announcement>> getUnreadAnnouncements() async {
    try {
      final allAnnouncements = await remoteDataSource.getAllAnnouncements();
      final unread = allAnnouncements.where((model) => !model.isRead).toList();
      return unread.map((model) => model.toEntity()).toList();
    } catch (e) {
      final cachedAnnouncements = await localDataSource.getCachedAnnouncements();
      final unread = cachedAnnouncements.where((model) => !model.isRead).toList();
      return unread.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<Announcement?> getAnnouncementById(String id) async {
    try {
      final model = await remoteDataSource.getAnnouncementById(id);
      return model?.toEntity();
    } catch (e) {
      final cachedAnnouncements = await localDataSource.getCachedAnnouncements();
      try {
        final model = cachedAnnouncements.firstWhere((model) => model.id == id);
        return model.toEntity();
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      // Update on remote
      await remoteDataSource.markAsRead(id);
      
      // Update local cache
      await localDataSource.markAsRead(id);
    } catch (e) {
      // At least update local cache
      await localDataSource.markAsRead(id);
    }
  }

  @override
  Future<void> markAsUnread(String id) async {
    // Implementation for marking as unread
    // This would require similar remote/local update pattern
    await localDataSource.markAsRead(id); // For now, just update locally
  }

  @override
  Future<List<Announcement>> searchAnnouncements(String query) async {
    try {
      final announcements = await remoteDataSource.searchAnnouncements(query);
      return announcements.map((model) => model.toEntity()).toList();
    } catch (e) {
      final cachedAnnouncements = await localDataSource.getCachedAnnouncements();
      final filtered = cachedAnnouncements.where((model) {
        return model.title.toLowerCase().contains(query.toLowerCase()) ||
               model.content.toLowerCase().contains(query.toLowerCase());
      }).toList();
      return filtered.map((model) => model.toEntity()).toList();
    }
  }
}
