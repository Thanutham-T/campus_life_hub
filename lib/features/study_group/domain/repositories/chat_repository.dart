import 'package:dartz/dartz.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  /// Get chat messages for a study group
  Stream<Either<String, List<ChatMessage>>> getChatMessages(String studyGroupId);
  
  /// Send a message to a study group
  Future<Either<String, void>> sendMessage(String studyGroupId, ChatMessage message);
  
  /// Delete a message
  Future<Either<String, void>> deleteMessage(String studyGroupId, String messageId);
  
  /// Update a message
  Future<Either<String, void>> updateMessage(String studyGroupId, ChatMessage message);
  
  /// Get recent messages with limit
  Stream<Either<String, List<ChatMessage>>> getRecentMessages(String studyGroupId, int limit);
  
  /// Get message by ID
  Future<Either<String, ChatMessage?>> getMessageById(String studyGroupId, String messageId);
  
  /// Get messages by user
  Stream<Either<String, List<ChatMessage>>> getMessagesByUser(String studyGroupId, String userId);
  
  /// Mark message as read
  Future<Either<String, void>> markMessageAsRead(String studyGroupId, String messageId, String userId);
  
  /// Get unread message count
  Stream<Either<String, int>> getUnreadMessageCount(String studyGroupId, String userId);
}
