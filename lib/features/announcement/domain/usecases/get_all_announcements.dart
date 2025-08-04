import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

/// Use case for getting all announcements
class GetAllAnnouncements {
  final AnnouncementRepository repository;

  GetAllAnnouncements(this.repository);

  Future<List<Announcement>> call() async {
    return await repository.getAllAnnouncements();
  }
}
