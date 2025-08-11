import 'package:cloud_firestore/cloud_firestore.dart';

class MockDataService {
  final FirebaseFirestore firestore;

  MockDataService({required this.firestore});

  Future<void> createMockData() async {
    try {
      // Mock study groups data
      final studyGroups = [
        {
          'name': 'กลุ่มศึกษาแคลคูลัส 1',
          'subject': 'Calculus I',
          'description': 'เรียนรู้พื้นฐานแคลคูลัสและการประยุกต์ใช้ในชีวิตจริง',
          'category': 'mathematics',
          'difficulty': 'intermediate',
          'location': 'ห้องสมุดกลาง ชั้น 2',
          'schedule': 'จันทร์-พุธ 14:00-16:00',
          'maxMembers': 10,
          'memberIds': ['user1', 'user2', 'user3'],
          'createdBy': 'user1',
          'createdAt': Timestamp.now(),
          'isActive': true,
        },
        {
          'name': 'English Conversation Practice',
          'subject': 'English Speaking',
          'description': 'Practice speaking English in a friendly environment',
          'category': 'english',
          'difficulty': 'beginner',
          'location': 'Language Center Room 101',
          'schedule': 'อังคาร-พฤหัส 16:00-18:00',
          'maxMembers': 8,
          'memberIds': ['user2', 'user4', 'user5'],
          'createdBy': 'user2',
          'createdAt': Timestamp.now(),
          'isActive': true,
        },
        {
          'name': 'กลุ่มเรียนฟิสิกส์',
          'subject': 'Physics I',
          'description': 'เรียนฟิสิกส์พื้นฐาน กลศาสตร์ และคลื่น',
          'category': 'science',
          'difficulty': 'intermediate',
          'location': 'อาคารวิทยาศาสตร์ ห้อง 203',
          'schedule': 'พุธ-ศุกร์ 13:00-15:00',
          'maxMembers': 12,
          'memberIds': ['user1', 'user3', 'user6', 'user7'],
          'createdBy': 'user3',
          'createdAt': Timestamp.now(),
          'isActive': true,
        },
        {
          'name': 'Art & Design Workshop',
          'subject': 'Digital Art',
          'description': 'เรียนรู้การออกแบบกราฟิกและศิลปะดิจิทัล',
          'category': 'art',
          'difficulty': 'beginner',
          'location': 'ศูนย์คอมพิวเตอร์ ห้อง 301',
          'schedule': 'เสาร์ 09:00-12:00',
          'maxMembers': 15,
          'memberIds': ['user4', 'user8', 'user9'],
          'createdBy': 'user4',
          'createdAt': Timestamp.now(),
          'isActive': true,
        },
        {
          'name': 'Thai History Study',
          'subject': 'Thai History',
          'description': 'ศึกษาประวัติศาสตร์ไทยและวัฒนธรรม',
          'category': 'social',
          'difficulty': 'intermediate',
          'location': 'ห้องประชุมใหญ่ ชั้น 3',
          'schedule': 'พฤหัส 15:00-17:00',
          'maxMembers': 20,
          'memberIds': ['user5', 'user10'],
          'createdBy': 'user5',
          'createdAt': Timestamp.now(),
          'isActive': true,
        },
      ];

      // Create study groups
      for (var groupData in studyGroups) {
        final docRef = await firestore.collection('study_groups').add(groupData);
        
        // Add some mock messages for each group
        final messages = [
          {
            'groupId': docRef.id,
            'senderId': groupData['createdBy'],
            'senderName': 'ผู้ดูแลกลุ่ม',
            'text': 'ยินดีต้อนรับเข้าสู่กลุ่มศึกษา! 🎉',
            'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2))),
            'readBy': [groupData['createdBy']],
          },
          {
            'groupId': docRef.id,
            'senderId': 'user_a',
            'senderName': 'นักเรียน A',
            'text': 'สวัสดีครับ ยินดีที่ได้รู้จักทุกคนครับ 😊',
            'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1, minutes: 30))),
            'readBy': ['user_a'],
          },
          {
            'groupId': docRef.id,
            'senderId': 'user_b',
            'senderName': 'นักเรียน B',
            'text': 'เรามีตารางเรียนเมื่อไหร่บ้างครับ? และมีเอกสารที่ต้องเตรียมมั้ย',
            'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1))),
            'readBy': ['user_b'],
          },
          {
            'groupId': docRef.id,
            'senderId': 'user_c',
            'senderName': 'นักเรียน C',
            'text': 'ผมมีหนังสือแชร์ให้อ่านได้ครับ',
            'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 45))),
            'readBy': ['user_c'],
          },
          {
            'groupId': docRef.id,
            'senderId': groupData['createdBy'],
            'senderName': 'ผู้ดูแลกลุ่ม',
            'text': 'ตารางเรียนอยู่ในรายละเอียดกลุ่มครับ ใครมีคำถามเพิ่มเติมถามได้เลย',
            'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 30))),
            'readBy': [groupData['createdBy']],
          },
          {
            'groupId': docRef.id,
            'senderId': 'user_d',
            'senderName': 'นักเรียน D',
            'text': 'ขอบคุณครับ! พรุ่งนี้เจอกันที่ห้องสมุดนะครับ 📚',
            'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 15))),
            'readBy': ['user_d'],
          },
        ];

        // Add messages to subcollection
        for (var messageData in messages) {
          await docRef.collection('messages').add(messageData);
        }
      }

      print('Mock data created successfully!');
    } catch (e) {
      print('Error creating mock data: $e');
    }
  }

  Future<void> clearMockData() async {
    try {
      // Delete all study groups and their messages
      final studyGroups = await firestore.collection('study_groups').get();
      
      for (var doc in studyGroups.docs) {
        // Delete messages subcollection
        final messages = await doc.reference.collection('messages').get();
        for (var messageDoc in messages.docs) {
          await messageDoc.reference.delete();
        }
        
        // Delete study group
        await doc.reference.delete();
      }

      print('Mock data cleared successfully!');
    } catch (e) {
      print('Error clearing mock data: $e');
    }
  }
}
