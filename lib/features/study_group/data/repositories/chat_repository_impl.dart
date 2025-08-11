import 'package:dartz/dartz.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/remote/chat_remote_data_source.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Either<String, List<ChatMessage>>> getChatMessages(String studyGroupId) async* {
    try {
      yield* remoteDataSource.getChatMessages(studyGroupId).map((models) =>
          Right(models.map((model) => model.toDomain()).toList()));
    } catch (e) {
      yield Left('Failed to get chat messages: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> sendMessage(String studyGroupId, ChatMessage message) async {
    try {
      final model = ChatMessageModel.fromDomain(message);
      await remoteDataSource.sendMessage(studyGroupId, model);
      return const Right(null);
    } catch (e) {
      return Left('Failed to send message: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteMessage(String studyGroupId, String messageId) async {
    try {
      await remoteDataSource.deleteMessage(studyGroupId, messageId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to delete message: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> updateMessage(String studyGroupId, ChatMessage message) async {
    try {
      final model = ChatMessageModel.fromDomain(message);
      await remoteDataSource.updateMessage(studyGroupId, model);
      return const Right(null);
    } catch (e) {
      return Left('Failed to update message: ${e.toString()}');
    }
  }

  @override
  Stream<Either<String, List<ChatMessage>>> getRecentMessages(String studyGroupId, int limit) async* {
    try {
      yield* remoteDataSource.getRecentMessages(studyGroupId, limit).map((models) =>
          Right(models.map((model) => model.toDomain()).toList()));
    } catch (e) {
      yield Left('Failed to get recent messages: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ChatMessage?>> getMessageById(String studyGroupId, String messageId) async {
    try {
      final model = await remoteDataSource.getMessageById(studyGroupId, messageId);
      return Right(model?.toDomain());
    } catch (e) {
      return Left('Failed to get message: ${e.toString()}');
    }
  }

  @override
  Stream<Either<String, List<ChatMessage>>> getMessagesByUser(String studyGroupId, String userId) async* {
    try {
      yield* remoteDataSource.getMessagesByUser(studyGroupId, userId).map((models) =>
          Right(models.map((model) => model.toDomain()).toList()));
    } catch (e) {
      yield Left('Failed to get messages by user: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> markMessageAsRead(String studyGroupId, String messageId, String userId) async {
    try {
      await remoteDataSource.markMessageAsRead(studyGroupId, messageId, userId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to mark message as read: ${e.toString()}');
    }
  }

  @override
  Stream<Either<String, int>> getUnreadMessageCount(String studyGroupId, String userId) async* {
    try {
      yield* remoteDataSource.getUnreadMessageCount(studyGroupId, userId).map((count) =>
          Right(count));
    } catch (e) {
      yield Left('Failed to get unread message count: ${e.toString()}');
    }
  }
}
