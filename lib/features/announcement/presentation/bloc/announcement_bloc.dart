import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import 'announcement_event.dart';
import 'announcement_state.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final AnnouncementRepository _repository;
  final FirebaseAuth _auth;

  AnnouncementBloc({
    required AnnouncementRepository repository,
    FirebaseAuth? auth,
  }) : _repository = repository,
        _auth = auth ?? FirebaseAuth.instance,
        super(AnnouncementInitial()) {
    on<LoadAnnouncements>(_onLoadAnnouncements);
    on<FilterAnnouncementsByCategory>(_onFilterAnnouncements);
    on<MarkAsRead>(_onMarkAsRead);
    on<ToggleBookmark>(_onToggleBookmark);
    on<SearchAnnouncements>(_onSearchAnnouncements);
    on<LoadBookmarkedAnnouncements>(_onLoadBookmarkedAnnouncements);
    on<RefreshAnnouncements>(_onRefreshAnnouncements);
  }

  String? get _currentUserId => _auth.currentUser?.uid;

  Future<void> _onLoadAnnouncements(
    LoadAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(AnnouncementLoading());
    
    try {
      final announcements = await _repository.getAllAnnouncements();
      
      // Check if user is authenticated before loading bookmarks
      List<String> bookmarkedIds = [];
      if (_currentUserId != null) {
        bookmarkedIds = await _repository.getBookmarkedAnnouncements(_currentUserId!);
      }
      
      emit(AnnouncementLoaded(
        announcements: announcements,
        filteredAnnouncements: announcements,
        bookmarkedIds: bookmarkedIds,
      ));
    } catch (e) {
      emit(AnnouncementError('เกิดข้อผิดพลาดในการโหลดข้อมูล: ${e.toString()}'));
    }
  }

  Future<void> _onFilterAnnouncements(
    FilterAnnouncementsByCategory event,
    Emitter<AnnouncementState> emit,
  ) async {
    final currentState = state;
    if (currentState is AnnouncementLoaded) {
      List<Announcement> filtered;
      
      if (event.category == 'ทั้งหมด') {
        filtered = currentState.announcements;
      } else {
        final categoryMap = {
          'วิชาการ': 'academic',
          'กิจกรรม': 'event',
          'ทั่วไป': 'general',
        };
        
        filtered = currentState.announcements
            .where((announcement) => announcement.category == categoryMap[event.category])
            .toList();
      }

      emit(currentState.copyWith(
        filteredAnnouncements: filtered,
        selectedCategory: event.category,
      ));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<AnnouncementState> emit,
  ) async {
    final currentState = state;
    if (currentState is AnnouncementLoaded) {
      try {
        // Check if user is authenticated
        if (_currentUserId == null) {
          emit(AnnouncementError('กรุณาเข้าสู่ระบบก่อนใช้งาน'));
          return;
        }

        // ตรวจสอบว่า announcementId ไม่ว่าง
        if (event.announcementId.isEmpty) {
          print('Warning: Attempting to mark empty announcement ID as read');
          return;
        }

        print('Marking announcement ${event.announcementId} as read for user $_currentUserId');
        await _repository.markAsRead(event.announcementId, _currentUserId!);
        
        final updatedAnnouncements = currentState.announcements.map((announcement) {
          if (announcement.id == event.announcementId) {
            return announcement.copyWith(isRead: true);
          }
          return announcement;
        }).toList();

        final updatedFiltered = currentState.filteredAnnouncements.map((announcement) {
          if (announcement.id == event.announcementId) {
            return announcement.copyWith(isRead: true);
          }
          return announcement;
        }).toList();

        emit(currentState.copyWith(
          announcements: updatedAnnouncements,
          filteredAnnouncements: updatedFiltered,
        ));
      } catch (e) {
        emit(AnnouncementError('เกิดข้อผิดพลาดในการอัปเดตสถานะการอ่าน: ${e.toString()}'));
      }
    }
  }

  Future<void> _onToggleBookmark(
    ToggleBookmark event,
    Emitter<AnnouncementState> emit,
  ) async {
    final currentState = state;
    if (currentState is AnnouncementLoaded) {
      try {
        // Check if user is authenticated
        if (_currentUserId == null) {
          emit(AnnouncementError('กรุณาเข้าสู่ระบบก่อนใช้งาน'));
          return;
        }

        // ตรวจสอบว่า announcementId ไม่ว่าง
        if (event.announcementId.isEmpty) {
          print('Warning: Attempting to toggle bookmark for empty announcement ID');
          return;
        }

        print('Toggling bookmark for announcement ${event.announcementId} for user $_currentUserId');
        await _repository.toggleBookmark(event.announcementId, _currentUserId!);
        
        List<String> updatedBookmarks = List.from(currentState.bookmarkedIds);
        
        if (updatedBookmarks.contains(event.announcementId)) {
          updatedBookmarks.remove(event.announcementId);
        } else {
          updatedBookmarks.add(event.announcementId);
        }

        emit(currentState.copyWith(bookmarkedIds: updatedBookmarks));
      } catch (e) {
        emit(AnnouncementError('เกิดข้อผิดพลาดในการบันทึกประกาศ: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSearchAnnouncements(
    SearchAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    final currentState = state;
    if (currentState is AnnouncementLoaded) {
      List<Announcement> filtered;
      
      if (event.query.isEmpty) {
        // Apply category filter if no search query
        if (currentState.selectedCategory == 'ทั้งหมด') {
          filtered = currentState.announcements;
        } else {
          final categoryMap = {
            'วิชาการ': 'academic',
            'กิจกรรม': 'event',
            'ทั่วไป': 'general',
          };
          
          filtered = currentState.announcements
              .where((announcement) => announcement.category == categoryMap[currentState.selectedCategory])
              .toList();
        }
      } else {
        // Search in all announcements regardless of category
        filtered = currentState.announcements
            .where((announcement) =>
                announcement.title.toLowerCase().contains(event.query.toLowerCase()) ||
                announcement.content.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
      }

      emit(currentState.copyWith(
        filteredAnnouncements: filtered,
        searchQuery: event.query,
      ));
    }
  }

  Future<void> _onLoadBookmarkedAnnouncements(
    LoadBookmarkedAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    final currentState = state;
    if (currentState is AnnouncementLoaded) {
      try {
        // Check if user is authenticated
        if (_currentUserId == null) {
          emit(AnnouncementError('กรุณาเข้าสู่ระบบก่อนใช้งาน'));
          return;
        }

        final bookmarkedIds = await _repository.getBookmarkedAnnouncements(_currentUserId!);
        final bookmarked = currentState.announcements
            .where((announcement) => bookmarkedIds.contains(announcement.id))
            .toList();
        
        emit(BookmarkedAnnouncementsLoaded(bookmarked));
      } catch (e) {
        emit(AnnouncementError('เกิดข้อผิดพลาดในการโหลดประกาศที่บันทึกไว้: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRefreshAnnouncements(
    RefreshAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    // Reload announcements by calling _onLoadAnnouncements directly
    await _onLoadAnnouncements(const LoadAnnouncements(), emit);
  }
}
