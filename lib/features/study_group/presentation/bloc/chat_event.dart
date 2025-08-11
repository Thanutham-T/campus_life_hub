import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class GetChatMessagesEvent extends ChatEvent {
  final String studyGroupId;

  const GetChatMessagesEvent(this.studyGroupId);

  @override
  List<Object?> get props => [studyGroupId];
}

class SendMessageEvent extends ChatEvent {
  final String studyGroupId;
  final ChatMessage message;

  const SendMessageEvent(this.studyGroupId, this.message);

  @override
  List<Object?> get props => [studyGroupId, message];
}

class DeleteMessageEvent extends ChatEvent {
  final String studyGroupId;
  final String messageId;

  const DeleteMessageEvent(this.studyGroupId, this.messageId);

  @override
  List<Object?> get props => [studyGroupId, messageId];
}

class UpdateMessageEvent extends ChatEvent {
  final String studyGroupId;
  final ChatMessage message;

  const UpdateMessageEvent(this.studyGroupId, this.message);

  @override
  List<Object?> get props => [studyGroupId, message];
}

class GetRecentMessagesEvent extends ChatEvent {
  final String studyGroupId;
  final int limit;

  const GetRecentMessagesEvent(this.studyGroupId, this.limit);

  @override
  List<Object?> get props => [studyGroupId, limit];
}

class MarkMessageAsReadEvent extends ChatEvent {
  final String studyGroupId;
  final String messageId;
  final String userId;

  const MarkMessageAsReadEvent(this.studyGroupId, this.messageId, this.userId);

  @override
  List<Object?> get props => [studyGroupId, messageId, userId];
}

class GetUnreadMessageCountEvent extends ChatEvent {
  final String studyGroupId;
  final String userId;

  const GetUnreadMessageCountEvent(this.studyGroupId, this.userId);

  @override
  List<Object?> get props => [studyGroupId, userId];
}
