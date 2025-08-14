import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserRole {
  admin,
  student,
  teacher,
}

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final UserRole role;
  final String? studentId;
  final String? faculty;
  final String? department;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.studentId,
    this.faculty,
    this.department,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == data['role'],
        orElse: () => UserRole.student,
      ),
      studentId: data['studentId'],
      faculty: data['faculty'],
      department: data['department'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'studentId': studentId,
      'faculty': faculty,
      'department': department,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserProfile copyWith({
    String? email,
    String? displayName,
    UserRole? role,
    String? studentId,
    String? faculty,
    String? department,
  }) {
    return UserProfile(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      studentId: studentId ?? this.studentId,
      faculty: faculty ?? this.faculty,
      department: department ?? this.department,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isStudent => role == UserRole.student;
  bool get isTeacher => role == UserRole.teacher;
}

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user profile
  static Future<UserProfile?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;
      return UserProfile.fromFirestore(doc);
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Create user profile (สำหรับ admin หรือการลงทะเบียนครั้งแรก)
  static Future<bool> createUserProfile({
    required String uid,
    required String email,
    required String displayName,
    UserRole role = UserRole.student,
    String? studentId,
    String? faculty,
    String? department,
  }) async {
    try {
      final userProfile = UserProfile(
        uid: uid,
        email: email,
        displayName: displayName,
        role: role,
        studentId: studentId,
        faculty: faculty,
        department: department,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .set(userProfile.toFirestore());

      return true;
    } catch (e) {
      print('Error creating user profile: $e');
      return false;
    }
  }

  // Update user profile
  static Future<bool> updateUserProfile(UserProfile userProfile) async {
    try {
      await _firestore
          .collection('users')
          .doc(userProfile.uid)
          .update(userProfile.copyWith().toFirestore());
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Check if current user is admin
  static Future<bool> isCurrentUserAdmin() async {
    final profile = await getCurrentUserProfile();
    return profile?.isAdmin ?? false;
  }

  // Check if current user is student
  static Future<bool> isCurrentUserStudent() async {
    final profile = await getCurrentUserProfile();
    return profile?.isStudent ?? false;
  }

  // Get user by ID (for admin)
  static Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserProfile.fromFirestore(doc);
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // List all users (for admin)
  static Future<List<UserProfile>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) => UserProfile.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  // Promote user to admin (for existing admin only)
  static Future<bool> promoteUserToAdmin(String uid) async {
    try {
      final currentUser = await getCurrentUserProfile();
      if (currentUser == null || !currentUser.isAdmin) {
        print('Only admin can promote users');
        return false;
      }

      await _firestore.collection('users').doc(uid).update({
        'role': UserRole.admin.name,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      return true;
    } catch (e) {
      print('Error promoting user to admin: $e');
      return false;
    }
  }
}
