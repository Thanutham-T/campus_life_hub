import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessages {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  Future<Either<String, Stream<Either<String, List<ChatMessage>>>>> call(GetChatMessagesParams params) async {
    try {
      final stream = repository.getChatMessages(params.groupId);
      return Right(stream);
    } catch (e) {
      return Left('Failed to get chat messages: ${e.toString()}');
    }
  }
}

class GetChatMessagesParams extends Equatable {
  final String groupId;

  const GetChatMessagesParams({required this.groupId});

  @override
  List<Object> get props => [groupId];
}
