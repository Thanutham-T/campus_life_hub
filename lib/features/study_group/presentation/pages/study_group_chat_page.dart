import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_state.dart';
import '../bloc/chat_event.dart';

class StudyGroupChatPage extends StatefulWidget {
  final String studyGroupId;
  final String? groupName;

  const StudyGroupChatPage({
    super.key, 
    required this.studyGroupId,
    this.groupName,
  });  @override
  State<StudyGroupChatPage> createState() => _StudyGroupChatPageState();
}

class _StudyGroupChatPageState extends State<StudyGroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Get current user ID
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
  
  // Get current user name
  String get _currentUserName {
    final user = FirebaseAuth.instance.currentUser;
    print('Firebase User: ${user?.uid}');
    print('Display Name: ${user?.displayName}');
    print('Email: ${user?.email}');
    
    // Return display name first, then email prefix, then UID prefix, then fallback
    return user?.displayName ?? 
           user?.email?.split('@')[0] ?? 
           (user?.uid.length != null && user!.uid.length > 6 ? user.uid.substring(0, 6) : null) ??
           'ผู้ใช้';
  }

  // Get user name from Firestore (async version)
  Future<String> _getCurrentUserNameFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return 'ผู้ใช้';

      // Try to get displayName from Firebase Auth first
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        return user.displayName!;
      }

      // If no displayName, try to get from Firestore users collection
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        
        // Prefer firstName only for cleaner display
        if (data['firstName'] != null) {
          return data['firstName'];
        } else if (data['displayName'] != null) {
          return data['displayName'];
        } else if (data['firstName'] != null && data['lastName'] != null) {
          return '${data['firstName']} ${data['lastName']}';
        }
      }

      // Fallback to email prefix or UID
      return user.email?.split('@')[0] ?? 
             (user.uid.length > 6 ? user.uid.substring(0, 6) : user.uid);
             
    } catch (e) {
      print('Error getting user name from Firestore: $e');
      return FirebaseAuth.instance.currentUser?.email?.split('@')[0] ?? 'ผู้ใช้';
    }
  }

  // Helper method to get user name for display (for messages that might not have proper senderName)
  String _getDisplayName(String senderName, String senderId) {
    // If senderName is empty, just default values, or "คุณ", try to create a better name
    if (senderName.isEmpty || senderName == 'ผู้ใช้' || senderName == 'คุณ') {
      // If it's current user, use current user name (sync version)
      if (senderId == _currentUserId) {
        return _currentUserName;
      }
      // For other users, use partial UID as fallback
      return senderId.length > 6 ? senderId.substring(0, 6) : senderId;
    }
    return senderName;
  }

  @override
  void initState() {
    super.initState();
    // Load chat messages
    context.read<ChatBloc>().add(GetChatMessagesEvent(widget.studyGroupId));
    
    // Update display name if not set
    _updateDisplayNameIfNeeded();
  }

  // Auto scroll to bottom when messages are loaded
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _updateDisplayNameIfNeeded() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && (user.displayName == null || user.displayName!.isEmpty)) {
      try {
        // Extract name from email or use UID prefix
        String displayName = user.email?.split('@')[0] ?? 
                           (user.uid.length > 6 ? user.uid.substring(0, 6) : user.uid);
        
        await user.updateDisplayName(displayName);
        await user.reload(); // Reload to get updated data
        print('Updated display name to: $displayName');
      } catch (e) {
        print('Failed to update display name: $e');
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    print('Sending message:');
    print('Current User ID: $_currentUserId');
    
    // Get user name from Firestore
    final senderName = await _getCurrentUserNameFromFirestore();
    print('Current User Name: $senderName');

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      groupId: widget.studyGroupId,
      senderId: _currentUserId, // ใช้ current user ID จริง
      senderName: senderName, // ใช้ชื่อจาก Firestore
      text: _messageController.text.trim(),
      timestamp: DateTime.now(),
    );

    print('Message created: ${message.senderId} - ${message.senderName}');

    context.read<ChatBloc>().add(SendMessageEvent(widget.studyGroupId, message));
    _messageController.clear();
    
    // Auto scroll to bottom after sending message
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat messages
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatMessagesLoaded) {
                  // Auto scroll to bottom when messages are loaded
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                  
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isCurrentUser = message.senderId == _currentUserId; // ใช้ current user ID จริง
                      print('Message: ${message.senderId} vs Current: $_currentUserId = $isCurrentUser');
                      
                      return Align(
                        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
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
                        ),
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'เกิดข้อผิดพลาด: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ChatBloc>().add(GetChatMessagesEvent(widget.studyGroupId));
                          },
                          child: const Text('ลองใหม่'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('ไม่มีข้อความ'));
              },
            ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'พิมพ์ข้อความ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else {
      return 'เมื่อสักครู่';
    }
  }

  Color _getUserColor(String userId) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.brown,
    ];
    
    // Generate consistent color based on userId
    final hash = userId.hashCode;
    return colors[hash.abs() % colors.length];
  }
}
