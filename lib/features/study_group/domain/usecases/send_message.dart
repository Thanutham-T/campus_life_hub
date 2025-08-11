import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<String, void>> call(SendMessageParams params) async {
    try {
      final result = await repository.sendMessage(params.studyGroupId, params.message);
      return result;
    } catch (e) {
      return Left('Failed to send message: ${e.toString()}');
    }
  }
}

class SendMessageParams extends Equatable {
  final String studyGroupId;
  final ChatMessage message;

  const SendMessageParams({
    required this.studyGroupId,
    required this.message,
  });

  @override
  List<Object> get props => [studyGroupId, message];
}
