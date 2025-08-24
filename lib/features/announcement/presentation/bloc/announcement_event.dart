import 'package:equatable/equatable.dart';

abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnnouncements extends AnnouncementEvent {
  final String? category;
  final String? priority;
  
  const LoadAnnouncements({this.category, this.priority});
  
  @override
  List<Object?> get props => [category, priority];
}

class FilterAnnouncementsByCategory extends AnnouncementEvent {
  final String category;
  
  const FilterAnnouncementsByCategory(this.category);
  
  @override
  List<Object> get props => [category];
}

class MarkAsRead extends AnnouncementEvent {
  final String announcementId;
  
  const MarkAsRead(this.announcementId);
  
  @override
  List<Object> get props => [announcementId];
}

class ToggleBookmark extends AnnouncementEvent {
  final String announcementId;
  
  const ToggleBookmark(this.announcementId);
  
  @override
  List<Object> get props => [announcementId];
}

class SearchAnnouncements extends AnnouncementEvent {
  final String query;
  
  const SearchAnnouncements(this.query);
  
  @override
  List<Object> get props => [query];
}

class LoadBookmarkedAnnouncements extends AnnouncementEvent {
  const LoadBookmarkedAnnouncements();
}

class RefreshAnnouncements extends AnnouncementEvent {
  const RefreshAnnouncements();
}
