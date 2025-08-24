import '../repositories/announcement_repository.dart';

/// Use case for marking announcement as read
class MarkAnnouncementAsRead {
  final AnnouncementRepository repository;

  MarkAnnouncementAsRead(this.repository);

  Future<void> call(String announcementId, String userId) async {
    return await repository.markAsRead(announcementId, userId);
  }
}
