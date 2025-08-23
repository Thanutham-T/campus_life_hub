import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.groupId,
    required super.senderId,
    required super.senderName,
    required super.text,
    required super.timestamp,
    super.replyToId,
    super.messageType = MessageType.text,
    super.eventData,
  });

  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      groupId: data['groupId'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['createdAt'] as Timestamp?)?.toDate() ?? 
                 (data['timestamp'] as Timestamp?)?.toDate() ?? 
                 DateTime.now(),
      replyToId: data['replyToId'],
      messageType: MessageType.values.firstWhere(
        (type) => type.toString() == 'MessageType.${data['messageType'] ?? 'text'}',
        orElse: () => MessageType.text,
      ),
      eventData: data['eventData'] as Map<String, dynamic>?,
    );
  }

  factory ChatMessageModel.fromEntity(ChatMessage message) {
    return ChatMessageModel(
      id: message.id,
      groupId: message.groupId,
      senderId: message.senderId,
      senderName: message.senderName,
      text: message.text,
      timestamp: message.timestamp,
      replyToId: message.replyToId,
      messageType: message.messageType,
      eventData: message.eventData,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'groupId': groupId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'createdAt': Timestamp.fromDate(timestamp), // เพิ่ม createdAt สำหรับ orderBy
      'messageType': messageType.toString().split('.').last,
      if (replyToId != null) 'replyToId': replyToId,
      if (eventData != null) 'eventData': eventData,
    };
  }

  @override
  ChatMessageModel copyWith({
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
    return ChatMessageModel(
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

  // Convert from domain entity to model
  factory ChatMessageModel.fromDomain(ChatMessage message) {
    return ChatMessageModel(
      id: message.id,
      groupId: message.groupId,
      senderId: message.senderId,
      senderName: message.senderName,
      text: message.text,
      timestamp: message.timestamp,
      replyToId: message.replyToId,
    );
  }

  // Convert model to domain entity
  ChatMessage toDomain() {
    return ChatMessage(
      id: id,
      groupId: groupId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: timestamp,
      replyToId: replyToId,
    );
  }
}
