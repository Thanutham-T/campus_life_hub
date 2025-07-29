import '../../models/announcement_model.dart';

/// Local data source for announcements (Local storage/Cache)
abstract class AnnouncementLocalDataSource {
  Future<List<AnnouncementModel>> getCachedAnnouncements();
  Future<void> cacheAnnouncements(List<AnnouncementModel> announcements);
  Future<void> markAsRead(String id);
  Future<void> clearCache();
}

/// Implementation of local data source
class AnnouncementLocalDataSourceImpl implements AnnouncementLocalDataSource {
  
  // In-memory cache for demo - replace with actual local storage
  static List<AnnouncementModel> _cache = [];
  
  @override
  Future<List<AnnouncementModel>> getCachedAnnouncements() async {
    // Simulate local storage read
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_cache);
  }

  @override
  Future<void> cacheAnnouncements(List<AnnouncementModel> announcements) async {
    // Simulate local storage write
    await Future.delayed(const Duration(milliseconds: 100));
    _cache = announcements;
  }

  @override
  Future<void> markAsRead(String id) async {
    // Update cache
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _cache.indexWhere((announcement) => announcement.id == id);
    if (index != -1) {
      _cache[index] = _cache[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> clearCache() async {
    await Future.delayed(const Duration(milliseconds: 50));
    _cache.clear();
  }
}
