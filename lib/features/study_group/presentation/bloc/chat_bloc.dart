import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc({
    required this.repository,
  }) : super(ChatInitial()) {
    on<GetChatMessagesEvent>(_onGetChatMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<UpdateMessageEvent>(_onUpdateMessage);
    on<GetRecentMessagesEvent>(_onGetRecentMessages);
    on<MarkMessageAsReadEvent>(_onMarkMessageAsRead);
    on<GetUnreadMessageCountEvent>(_onGetUnreadMessageCount);
  }

  void _onGetChatMessages(GetChatMessagesEvent event, Emitter<ChatState> emit) async {
    print('📥 ChatBloc: Loading messages for group ${event.studyGroupId}');
    emit(ChatLoading());
    
    await emit.forEach(
      repository.getChatMessages(event.studyGroupId),
      onData: (Either<String, List<ChatMessage>> result) {
        return result.fold(
          (error) {
            print('❌ ChatBloc: Load messages error: $error');
            return ChatError(error);
          },
          (messages) {
            print('✅ ChatBloc: Loaded ${messages.length} messages');
            return ChatMessagesLoaded(messages);
          },
        );
      },
      onError: (error, stackTrace) {
        print('❌ ChatBloc: Stream error: $error');
        return ChatError(error.toString());
      },
    );
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    print('🚀 ChatBloc: Sending message to group ${event.studyGroupId}');
    print('📝 Message: "${event.message.text}" from ${event.message.senderName}');
    
    final result = await repository.sendMessage(event.studyGroupId, event.message);
    
    result.fold(
      (error) {
        print('❌ ChatBloc: Send message error: $error');
        emit(ChatError(error));
      },
      (_) {
        print('✅ ChatBloc: Message sent successfully');
        // ไม่ต้อง emit ChatMessageSent เพราะ Firebase stream จะอัปเดตข้อความใหม่โดยอัตโนมัติ
        // emit(ChatMessageSent(event.message));
      },
    );
  }

  void _onDeleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) async {
    final result = await repository.deleteMessage(event.studyGroupId, event.messageId);
    
    result.fold(
      (error) => emit(ChatError(error)),
      (_) => emit(const ChatActionSuccess('Message deleted successfully')),
    );
  }

  void _onUpdateMessage(UpdateMessageEvent event, Emitter<ChatState> emit) async {
    final result = await repository.updateMessage(event.studyGroupId, event.message);
    
    result.fold(
      (error) => emit(ChatError(error)),
      (_) => emit(ChatMessageUpdated(event.message)),
    );
  }

  void _onGetRecentMessages(GetRecentMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    
    await emit.forEach(
      repository.getRecentMessages(event.studyGroupId, event.limit),
      onData: (Either<String, List<ChatMessage>> result) {
        return result.fold(
          (error) => ChatError(error),
          (messages) => ChatMessagesLoaded(messages),
        );
      },
      onError: (error, stackTrace) => ChatError(error.toString()),
    );
  }

  void _onMarkMessageAsRead(MarkMessageAsReadEvent event, Emitter<ChatState> emit) async {
    final result = await repository.markMessageAsRead(
      event.studyGroupId,
      event.messageId,
      event.userId,
    );
    
    result.fold(
      (error) => emit(ChatError(error)),
      (_) => {}, // Don't emit state for this action
    );
  }

  void _onGetUnreadMessageCount(GetUnreadMessageCountEvent event, Emitter<ChatState> emit) async {
    await emit.forEach(
      repository.getUnreadMessageCount(event.studyGroupId, event.userId),
      onData: (Either<String, int> result) {
        return result.fold(
          (error) => ChatError(error),
          (count) => UnreadMessageCountUpdated(count),
        );
      },
      onError: (error, stackTrace) => ChatError(error.toString()),
    );
  }
}
