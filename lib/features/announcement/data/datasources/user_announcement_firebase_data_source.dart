import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_announcement_data_source.dart';

class UserAnnouncementFirebaseDataSource implements UserAnnouncementDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _userCollection = 'users';
  static const String _readAnnouncementsField = 'readAnnouncements';
  static const String _bookmarkedAnnouncementsField = 'bookmarkedAnnouncements';

  UserAnnouncementFirebaseDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<void> markAsRead(String userId, String announcementId) async {
    try {
      // ใช้ current user ID แทน userId parameter
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // ตรวจสอบว่า announcementId ไม่ว่าง
      if (announcementId.isEmpty) {
        throw Exception('Announcement ID cannot be empty');
      }

      // ดึงข้อมูล readAnnouncements ปัจจุบัน
      final doc = await _firestore.collection(_userCollection).doc(currentUserId).get();
      Map<String, dynamic> currentReadAnnouncements = {};
      
      if (doc.exists) {
        final data = doc.data();
        currentReadAnnouncements = Map<String, dynamic>.from(
          data?[_readAnnouncementsField] as Map<String, dynamic>? ?? {}
        );
      }
      
      // เพิ่ม announcement ที่อ่านแล้ว
      currentReadAnnouncements[announcementId] = true;
      
      // บันทึกข้อมูล
      await _firestore.collection(_userCollection).doc(currentUserId).set({
        _readAnnouncementsField: currentReadAnnouncements,
      }, SetOptions(merge: true));
      
      print('Successfully marked announcement $announcementId as read');
    } catch (e) {
      print('Error in markAsRead: $e');
      throw Exception('Failed to mark as read: $e');
    }
  }

  @override
  Future<void> markAsUnread(String userId, String announcementId) async {
    try {
      // ใช้ current user ID แทน userId parameter
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // ตรวจสอบว่า announcementId ไม่ว่าง
      if (announcementId.isEmpty) {
        throw Exception('Announcement ID cannot be empty');
      }

      // ดึงข้อมูล readAnnouncements ปัจจุบัน
      final doc = await _firestore.collection(_userCollection).doc(currentUserId).get();
      Map<String, dynamic> currentReadAnnouncements = {};
      
      if (doc.exists) {
        final data = doc.data();
        currentReadAnnouncements = Map<String, dynamic>.from(
          data?[_readAnnouncementsField] as Map<String, dynamic>? ?? {}
        );
      }
      
      // เพิ่ม announcement ที่ยังไม่อ่าน
      currentReadAnnouncements[announcementId] = false;
      
      // บันทึกข้อมูล
      await _firestore.collection(_userCollection).doc(currentUserId).set({
        _readAnnouncementsField: currentReadAnnouncements,
      }, SetOptions(merge: true));
      
      print('Successfully marked announcement $announcementId as unread');
    } catch (e) {
      print('Error in markAsUnread: $e');
      throw Exception('Failed to mark as unread: $e');
    }
  }

  @override
  Future<Map<String, bool>> getReadStatus(String userId, List<String> announcementIds) async {
    try {
      // ใช้ current user ID แทน userId parameter
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        return {};
      }

      final doc = await _firestore.collection(_userCollection).doc(currentUserId).get();
      
      if (!doc.exists) {
        return {};
      }

      final data = doc.data();
      final readAnnouncements = data?[_readAnnouncementsField] as Map<String, dynamic>?;
      
      if (readAnnouncements == null) {
        return {};
      }

      final result = <String, bool>{};
      for (final announcementId in announcementIds) {
        result[announcementId] = readAnnouncements[announcementId] == true;
      }

      return result;
    } catch (e) {
      throw Exception('Failed to get read status: $e');
    }
  }

  @override
  Future<List<String>> getBookmarkedAnnouncements(String userId) async {
    try {
      // ใช้ current user ID แทน userId parameter
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        return [];
      }

      final doc = await _firestore.collection(_userCollection).doc(currentUserId).get();
      
      if (!doc.exists) {
        return [];
      }

      final data = doc.data();
      final bookmarkedAnnouncements = data?[_bookmarkedAnnouncementsField] as List<dynamic>?;
      
      return bookmarkedAnnouncements?.cast<String>() ?? [];
    } catch (e) {
      throw Exception('Failed to get bookmarked announcements: $e');
    }
  }

  @override
  Future<void> addBookmark(String userId, String announcementId) async {
    try {
      // ใช้ current user ID แทน userId parameter
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // ดึงข้อมูลปัจจุบันก่อนแล้วเพิ่ม bookmark
      final doc = await _firestore.collection(_userCollection).doc(currentUserId).get();
      List<String> currentBookmarks = [];
      
      if (doc.exists) {
        final data = doc.data();
        final bookmarkedList = data?[_bookmarkedAnnouncementsField] as List<dynamic>?;
        currentBookmarks = bookmarkedList?.cast<String>() ?? [];
      }
      
      if (!currentBookmarks.contains(announcementId)) {
        currentBookmarks.add(announcementId);
        
        await _firestore.collection(_userCollection).doc(currentUserId).set({
          _bookmarkedAnnouncementsField: currentBookmarks,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error in addBookmark: $e');
      throw Exception('Failed to add bookmark: $e');
    }
  }

  @override
  Future<void> removeBookmark(String userId, String announcementId) async {
    try {
      // ใช้ current user ID แทน userId parameter
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // ดึงข้อมูลปัจจุบันก่อนแล้วลบ bookmark
      final doc = await _firestore.collection(_userCollection).doc(currentUserId).get();
      
      if (doc.exists) {
        final data = doc.data();
        final bookmarkedList = data?[_bookmarkedAnnouncementsField] as List<dynamic>?;
        List<String> currentBookmarks = bookmarkedList?.cast<String>() ?? [];
        
        currentBookmarks.remove(announcementId);
        
        await _firestore.collection(_userCollection).doc(currentUserId).set({
          _bookmarkedAnnouncementsField: currentBookmarks,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error in removeBookmark: $e');
      throw Exception('Failed to remove bookmark: $e');
    }
  }

  @override
  Future<bool> isBookmarked(String userId, String announcementId) async {
    try {
      // ใช้ current user ID แทน userId parameter
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        return false;
      }

      final bookmarked = await getBookmarkedAnnouncements(currentUserId);
      return bookmarked.contains(announcementId);
    } catch (e) {
      throw Exception('Failed to check bookmark status: $e');
    }
  }
}
