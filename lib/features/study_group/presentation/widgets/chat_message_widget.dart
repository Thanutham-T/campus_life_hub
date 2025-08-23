import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/chat_message.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;
  final String currentUserId;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: message.isEventMessage 
            ? _buildEventMessage(context)
            : _buildTextMessage(context),
      ),
    );
  }

  Widget _buildTextMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser 
          ? Theme.of(context).primaryColor
          : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: isCurrentUser ? const Radius.circular(18) : const Radius.circular(4),
          bottomRight: isCurrentUser ? const Radius.circular(4) : const Radius.circular(18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getUserColor(message.senderId),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getDisplayName(message.senderName, message.senderId).isNotEmpty 
                        ? _getDisplayName(message.senderName, message.senderId)[0].toUpperCase()
                        : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _getDisplayName(message.senderName, message.senderId),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getUserColor(message.senderId),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Text(
            message.text,
            style: TextStyle(
              color: isCurrentUser ? Colors.white : Colors.black87,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: isCurrentUser 
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey[600],
                ),
              ),
              if (isCurrentUser) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.done_all,
                  size: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventMessage(BuildContext context) {
    final eventData = message.eventData;
    if (eventData == null) return _buildTextMessage(context);

    return GestureDetector(
      onTap: () {
        // Navigate to event detail page
        final eventId = eventData['eventId'] as String?;
        if (eventId != null) {
          context.push('/events/$eventId');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with sender info (if not current user)
            if (!isCurrentUser)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getUserColor(message.senderId),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getDisplayName(message.senderName, message.senderId).isNotEmpty 
                            ? _getDisplayName(message.senderName, message.senderId)[0].toUpperCase()
                            : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getDisplayName(message.senderName, message.senderId),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getUserColor(message.senderId),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.share, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            
            // Event content
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
                bottom: Radius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Image
                  if (eventData['imageUrl'] != null && eventData['imageUrl'] != '')
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      child: Image.network(
                        eventData['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.event,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                      ),
                    ),
                  
                  // Event Details
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Title
                        Text(
                          eventData['title'] ?? 'ไม่มีชื่อกิจกรรม',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        
                        // Event Date
                        if (eventData['date'] != null)
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                _formatEventDate(eventData['date']),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 4),
                        
                        // Event Location
                        if (eventData['location'] != null && eventData['location'] != '')
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  eventData['location'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        
                        // Tap to view hint
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'แตะเพื่อดูรายละเอียด',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Message timestamp
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(message.timestamp),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  if (isCurrentUser) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.done_all,
                      size: 12,
                      color: Colors.grey,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getUserColor(String senderId) {
    // Create a color based on sender ID
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
    ];
    
    final index = senderId.hashCode % colors.length;
    return colors[index.abs()];
  }

  String _getDisplayName(String senderName, String senderId) {
    if (senderName.isNotEmpty) {
      return senderName;
    }
    
    // Fallback to senderId prefix if no name
    return senderId.length > 6 ? senderId.substring(0, 6) : senderId;
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'เมื่อสักครู่';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else if (difference.inDays < 1) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} วันที่แล้ว';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatEventDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      const monthNames = [
        'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
        'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
      ];
      
      return '${date.day} ${monthNames[date.month - 1]} ${date.year + 543}';
    } catch (e) {
      return dateString;
    }
  }
}
