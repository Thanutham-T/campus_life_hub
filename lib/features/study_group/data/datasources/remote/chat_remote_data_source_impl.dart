import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_message_model.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl({required this.firestore});

  CollectionReference _getMessagesCollection(String studyGroupId) =>
      firestore
          .collection('study_groups')
          .doc(studyGroupId)
          .collection('messages');

  @override
  Stream<List<ChatMessageModel>> getChatMessages(String studyGroupId) {
    return _getMessagesCollection(studyGroupId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> sendMessage(String studyGroupId, ChatMessageModel message) async {
    try {
  // Only add the message now (removed group summary update due to permissions)
  await _getMessagesCollection(studyGroupId).add(message.toFirestore());
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<void> deleteMessage(String studyGroupId, String messageId) async {
    try {
      await _getMessagesCollection(studyGroupId).doc(messageId).delete();
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  @override
  Future<void> updateMessage(String studyGroupId, ChatMessageModel message) async {
    try {
      await _getMessagesCollection(studyGroupId)
          .doc(message.id)
          .update(message.toFirestore());
    } catch (e) {
      throw Exception('Failed to update message: $e');
    }
  }

  @override
  Stream<List<ChatMessageModel>> getRecentMessages(String studyGroupId, int limit) {
    return _getMessagesCollection(studyGroupId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromFirestore(doc))
            .toList()
            .reversed
            .toList());
  }

  @override
  Future<ChatMessageModel?> getMessageById(String studyGroupId, String messageId) async {
    try {
      final doc = await _getMessagesCollection(studyGroupId).doc(messageId).get();
      if (doc.exists) {
        return ChatMessageModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get message: $e');
    }
  }

  @override
  Stream<List<ChatMessageModel>> getMessagesByUser(String studyGroupId, String userId) {
    return _getMessagesCollection(studyGroupId)
        .where('senderId', isEqualTo: userId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> markMessageAsRead(String studyGroupId, String messageId, String userId) async {
    try {
      await _getMessagesCollection(studyGroupId).doc(messageId).update({
        'readBy': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
  }

  @override
  Stream<int> getUnreadMessageCount(String studyGroupId, String userId) {
    return _getMessagesCollection(studyGroupId)
        .where('readBy', whereNotIn: [userId])
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
