import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatMessagesLoaded extends ChatState {
  final List<ChatMessage> messages;

  const ChatMessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatMessageSent extends ChatState {
  final ChatMessage message;

  const ChatMessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMessageUpdated extends ChatState {
  final ChatMessage message;

  const ChatMessageUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatActionSuccess extends ChatState {
  final String message;

  const ChatActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class UnreadMessageCountUpdated extends ChatState {
  final int count;

  const UnreadMessageCountUpdated(this.count);

  @override
  List<Object?> get props => [count];
}
