import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_message_widget.dart';

class StudyGroupChatPage extends StatefulWidget {
  final String studyGroupId;
  final String? groupName;

  const StudyGroupChatPage({
    super.key, 
    required this.studyGroupId,
    this.groupName,
  });
  State<StudyGroupChatPage> createState() => _StudyGroupChatPageState();
}

class _StudyGroupChatPageState extends State<StudyGroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Get current user ID
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
  
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
                      final isCurrentUser = message.senderId == _currentUserId;
                      
                      return ChatMessageWidget(
                        message: message,
                        isCurrentUser: isCurrentUser,
                        currentUserId: _currentUserId,
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
}
