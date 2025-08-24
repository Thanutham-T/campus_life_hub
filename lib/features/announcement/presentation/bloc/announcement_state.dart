import 'package:equatable/equatable.dart';
import '../../domain/entities/announcement.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();

  @override
  List<Object?> get props => [];
}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementLoading extends AnnouncementState {}

class AnnouncementLoaded extends AnnouncementState {
  final List<Announcement> announcements;
  final List<Announcement> filteredAnnouncements;
  final String selectedCategory;
  final List<String> bookmarkedIds;
  final String searchQuery;

  const AnnouncementLoaded({
    required this.announcements,
    required this.filteredAnnouncements,
    this.selectedCategory = 'ทั้งหมด',
    this.bookmarkedIds = const [],
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
    announcements,
    filteredAnnouncements,
    selectedCategory,
    bookmarkedIds,
    searchQuery,
  ];

  AnnouncementLoaded copyWith({
    List<Announcement>? announcements,
    List<Announcement>? filteredAnnouncements,
    String? selectedCategory,
    List<String>? bookmarkedIds,
    String? searchQuery,
  }) {
    return AnnouncementLoaded(
      announcements: announcements ?? this.announcements,
      filteredAnnouncements: filteredAnnouncements ?? this.filteredAnnouncements,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      bookmarkedIds: bookmarkedIds ?? this.bookmarkedIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AnnouncementError extends AnnouncementState {
  final String message;

  const AnnouncementError(this.message);

  @override
  List<Object> get props => [message];
}

class BookmarkedAnnouncementsLoaded extends AnnouncementState {
  final List<Announcement> bookmarkedAnnouncements;

  const BookmarkedAnnouncementsLoaded(this.bookmarkedAnnouncements);

  @override
  List<Object> get props => [bookmarkedAnnouncements];
}
