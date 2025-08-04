import '../repositories/announcement_repository.dart';

/// Use case for marking announcement as read
class MarkAnnouncementAsRead {
  final AnnouncementRepository repository;

  MarkAnnouncementAsRead(this.repository);

  Future<void> call(String id) async {
    return await repository.markAsRead(id);
  }
}
