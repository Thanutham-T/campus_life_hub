import '../../models/announcement_model.dart';

/// Remote data source for announcements (API calls)
abstract class AnnouncementRemoteDataSource {
  Future<List<AnnouncementModel>> getAllAnnouncements();
  Future<List<AnnouncementModel>> getAnnouncementsByPriority(String priority);
  Future<List<AnnouncementModel>> getAnnouncementsByCategory(String category);
  Future<AnnouncementModel?> getAnnouncementById(String id);
  Future<void> markAsRead(String id);
  Future<List<AnnouncementModel>> searchAnnouncements(String query);
}

/// Implementation of remote data source
class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  
  @override
  Future<List<AnnouncementModel>> getAllAnnouncements() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data - replace with actual API call
    return [
      AnnouncementModel(
        id: '1',
        title: 'ประกาศการปิดภาคเรียน',
        content: 'มหาวิทยาลัยจะปิดภาคเรียนในวันที่ 15 สิงหาคม 2025',
        date: DateTime(2025, 7, 25),
        priority: 'high',
        category: 'academic',
        isRead: false,
      ),
      AnnouncementModel(
        id: '2',
        title: 'การเปิดรับสมัครทุนการศึกษา',
        content: 'มีทุนการศึกษาสำหรับนักศึกษาที่มีผลการเรียนดี',
        date: DateTime(2025, 7, 20),
        priority: 'medium',
        category: 'scholarship',
        isRead: true,
      ),
    ];
  }

  @override
  Future<List<AnnouncementModel>> getAnnouncementsByPriority(String priority) async {
    final allAnnouncements = await getAllAnnouncements();
    return allAnnouncements.where((announcement) => 
        announcement.priority == priority).toList();
  }

  @override
  Future<List<AnnouncementModel>> getAnnouncementsByCategory(String category) async {
    final allAnnouncements = await getAllAnnouncements();
    return allAnnouncements.where((announcement) => 
        announcement.category == category).toList();
  }

  @override
  Future<AnnouncementModel?> getAnnouncementById(String id) async {
    final allAnnouncements = await getAllAnnouncements();
    try {
      return allAnnouncements.firstWhere((announcement) => 
          announcement.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    // Simulate API call to mark as read
    await Future.delayed(const Duration(milliseconds: 200));
    // In real implementation, make API call here
  }

  @override
  Future<List<AnnouncementModel>> searchAnnouncements(String query) async {
    final allAnnouncements = await getAllAnnouncements();
    if (query.isEmpty) return allAnnouncements;
    
    return allAnnouncements.where((announcement) {
      return announcement.title.toLowerCase().contains(query.toLowerCase()) ||
             announcement.content.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
