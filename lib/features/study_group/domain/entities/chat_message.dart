enum MessageType {
  text,
  event,
}

class ChatMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final String? replyToId;
  final MessageType messageType;
  final Map<String, dynamic>? eventData;

  const ChatMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.replyToId,
    this.messageType = MessageType.text,
    this.eventData,
  });

  ChatMessage copyWith({
    String? id,
    String? groupId,
    String? senderId,
    String? senderName,
    String? text,
    DateTime? timestamp,
    String? replyToId,
    MessageType? messageType,
    Map<String, dynamic>? eventData,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      replyToId: replyToId ?? this.replyToId,
      messageType: messageType ?? this.messageType,
      eventData: eventData ?? this.eventData,
    );
  }

  bool get isReply => replyToId != null;
  bool get isEventMessage => messageType == MessageType.event;
}
