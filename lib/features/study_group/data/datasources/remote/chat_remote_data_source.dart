import '../../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatMessageModel>> getChatMessages(String studyGroupId);
  Future<void> sendMessage(String studyGroupId, ChatMessageModel message);
  Future<void> deleteMessage(String studyGroupId, String messageId);
  Future<void> updateMessage(String studyGroupId, ChatMessageModel message);
  Stream<List<ChatMessageModel>> getRecentMessages(String studyGroupId, int limit);
  Future<ChatMessageModel?> getMessageById(String studyGroupId, String messageId);
  Stream<List<ChatMessageModel>> getMessagesByUser(String studyGroupId, String userId);
  Future<void> markMessageAsRead(String studyGroupId, String messageId, String userId);
  Stream<int> getUnreadMessageCount(String studyGroupId, String userId);
}
