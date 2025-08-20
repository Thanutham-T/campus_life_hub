import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/event_model.dart';
import '../../../../core/utils/event_image_helper.dart';
import '../../../user/presentation/bloc/auth_bloc.dart';
import '../../../user/presentation/bloc/auth_state.dart';
import '../../domain/services/event_registration_service.dart';
import '../../../user/data/datasources/remote/firestore_data_source.dart';
import '../../di/campus_event_di.dart';
import 'edit_event_page.dart';
import '../widgets/share_event_dialog.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;

  const EventDetailPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool? _isRegistered;
  int? _registrationCount;
  bool _isLoading = true;
  Event? _currentEvent; // เพิ่มตัวนี้เพื่อเก็บข้อมูล Event ปัจจุบัน

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event; // เริ่มต้นด้วยข้อมูลที่ส่งมา
    _loadRegistrationData();
    _listenToEventChanges(); // ฟัง Event changes
    _listenToRegistrationChanges(); // ฟัง Registration changes
  }

  // ฟัง Registration changes แบบ real-time
  void _listenToRegistrationChanges() {
    FirebaseFirestore.instance
        .collection('event_registrations')
        .where('eventId', isEqualTo: widget.event.id)
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() {
          _registrationCount = snapshot.docs.length;
        });
        
        // ตรวจสอบว่า user ลงทะเบียนแล้วหรือยัง
        _checkUserRegistration(snapshot.docs);
      }
    });
  }

  // ตรวจสอบสถานะการลงทะเบียนของ user
  void _checkUserRegistration(List<QueryDocumentSnapshot> docs) {
    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final userId = authState.profile.id;
        final isRegistered = docs.any((doc) {
          final data = doc.data();
          return data is Map<String, dynamic> && data['userId'] == userId;
        });
        
        if (mounted) {
          setState(() {
            _isRegistered = isRegistered;
          });
        }
      }
    } catch (e) {
      print('Error checking user registration: $e');
    }
  }

  // ฟัง Event changes แบบ real-time
  void _listenToEventChanges() {
    FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && mounted) {
        try {
          final data = snapshot.data()!;
          final updatedEvent = Event(
            id: widget.event.id,
            title: data['title'] ?? widget.event.title,
            description: data['description'] ?? widget.event.description,
            location: data['location'] ?? widget.event.location,
            date: DateTime.parse(data['date'] ?? widget.event.date.toIso8601String()),
            imageUrl: data['imageUrl'],
            category: EventCategory.values.firstWhere(
              (e) => e.name == data['category'],
              orElse: () => widget.event.category,
            ),
            status: EventStatus.values.firstWhere(
              (e) => e.name == data['status'],
              orElse: () => widget.event.status,
            ),
            createdAt: widget.event.createdAt,
            updatedAt: DateTime.now(),
          );
          
          setState(() {
            _currentEvent = updatedEvent;
          });
        } catch (e) {
          print('Error parsing event data: $e');
        }
      }
    });
  }

  Future<void> _loadRegistrationData() async {
    setState(() => _isLoading = true);
    
    try {
      final isRegistered = await EventRegistrationService.isUserRegistered(widget.event.id);
      final registrationCount = await EventRegistrationService.getRegistrationCount(widget.event.id);
      
      setState(() {
        _isRegistered = isRegistered;
        _registrationCount = registrationCount;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading registration data: $e');
      setState(() {
        _isRegistered = false;
        _registrationCount = 0;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = _currentEvent ?? widget.event; // ใช้ current event หรือ fallback เป็น original
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // App Bar with Event Image
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: EventImageHelper.buildEventImage(
                imageUrl: event.imageUrl,
                eventId: event.id,
                eventTitle: event.title,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              // Share button
              IconButton(
                onPressed: () => _showShareDialog(context),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white, size: 20),
                ),
              ),
              // Registration count badge
              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '${_registrationCount ?? 0} คน',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Event Details Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Title and Status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(event.status).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getStatusColor(event.status).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getStatusText(event.status),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(event.status),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Event Info Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.calendar_today,
                            title: 'วันที่',
                            subtitle: _formatDate(event.date),
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.location_on,
                            title: 'สถานที่',
                            subtitle: event.location,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.category,
                            title: 'ประเภท',
                            subtitle: _getCategoryDisplayName(event.category),
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.people,
                            title: 'ผู้ลงทะเบียน',
                            subtitle: '${_registrationCount ?? 0} คน',
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Event Description
                    const Text(
                      'รายละเอียด',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Action Bar
      bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.login),
                  label: const Text('ล็อกอินเพื่อลงทะเบียน'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            );
          }

          final userProfile = authState.profile;
          final isAdmin = userProfile.isAdmin;
          final isStudent = userProfile.isStudent;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      children: [
                        // Student registration button
                        if (isStudent && event.status == EventStatus.upcoming) ...[
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _isRegistered == true
                                  ? _cancelRegistration()
                                  : _registerForEvent(),
                              icon: Icon(_isRegistered == true ? Icons.cancel : Icons.how_to_reg),
                              label: Text(_isRegistered == true ? 'ยกเลิกลงทะเบียน' : 'ลงทะเบียน'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isRegistered == true ? Colors.orange : Colors.green,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ]
                        // Admin buttons
                        else if (isAdmin) ...[
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showEventRegistrations(),
                              icon: const Icon(Icons.people),
                              label: Text('ผู้ลงทะเบียน (${_registrationCount ?? 0})'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _editEvent(),
                            icon: const Icon(Icons.edit),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(56, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _deleteEvent(),
                            icon: const Icon(Icons.delete),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(56, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ]
                        // Staff or other roles
                        else ...[
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: null,
                              icon: const Icon(Icons.info),
                              label: const Text('เฉพาะนักศึกษาเท่านั้น'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Registration actions
  Future<void> _registerForEvent() async {
    try {
      final success = await EventRegistrationService.registerForEvent(eventId: widget.event.id);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ลงทะเบียนสำเร็จ!')),
        );
        // ไม่ต้อง reload แล้วเพราะมี real-time listener
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ลงทะเบียนไม่สำเร็จ หรือลงทะเบียนไปแล้ว')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  Future<void> _cancelRegistration() async {
    try {
      final success = await EventRegistrationService.cancelRegistration(widget.event.id);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ยกเลิกลงทะเบียนสำเร็จ!')),
        );
        // ไม่ต้อง reload แล้วเพราะมี real-time listener
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ยกเลิกลงทะเบียนไม่สำเร็จ')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  // Admin actions
  Future<void> _showEventRegistrations() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('กำลังโหลดรายชื่อ...'),
          ],
        ),
      ),
    );

    try {
      final registrations = await EventRegistrationService.getEventRegistrations(widget.event.id);
      List<Map<String, dynamic>> registrationsWithUserData = [];
      final firestoreDataSource = FirestoreDataSourceImpl();
      
      for (final reg in registrations) {
        try {
          final userProfile = await firestoreDataSource.getUserProfile(reg.userId);
          registrationsWithUserData.add({
            'registration': reg,
            'userProfile': userProfile,
          });
        } catch (e) {
          registrationsWithUserData.add({
            'registration': reg,
            'userProfile': null,
          });
        }
      }

      // Close loading dialog
      if (context.mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (e) {
          print('Could not close loading dialog (might already be closed): $e');
        }
      }

      if (!context.mounted) return;
      
      // Show registrations dialog (reuse from EventPage)
      _showRegistrationListDialog(registrationsWithUserData);
      
    } catch (e) {
      if (context.mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (e) {
          print('Could not close loading dialog (might already be closed): $e');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      }
    }
  }

  void _showRegistrationListDialog(List<Map<String, dynamic>> registrationsWithUserData) {
    final event = _currentEvent ?? widget.event;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ผู้ลงทะเบียน - ${event.title}'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: registrationsWithUserData.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'ยังไม่มีผู้ลงทะเบียน',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: registrationsWithUserData.length,
                  itemBuilder: (context, index) {
                    final data = registrationsWithUserData[index];
                    final registration = data['registration'];
                    final userProfile = data['userProfile'];
                    
                    String displayName = 'ไม่ทราบชื่อ';
                    String detailText = '';
                    Color avatarColor = Colors.grey;
                    
                    if (userProfile != null) {
                      if (userProfile.fullName?.isNotEmpty == true) {
                        displayName = userProfile.fullName!;
                      } else if (userProfile.firstName?.isNotEmpty == true) {
                        displayName = '${userProfile.firstName} ${userProfile.lastName ?? ''}';
                      }
                      
                      if (userProfile.studentId?.isNotEmpty == true) {
                        detailText = 'รหัส: ${userProfile.studentId}';
                      } else {
                        detailText = userProfile.email ?? '';
                      }
                      
                      avatarColor = userProfile.isStudent ? Colors.blue : Colors.red;
                    }
                    
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: avatarColor.withOpacity(0.1),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: avatarColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(displayName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(detailText),
                          Text(
                            'ลงทะเบียน: ${_formatDate(registration.registeredAt)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (mounted) {
                context.pop(); // ใช้ GoRouter แทน
              }
            },
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    final event = _currentEvent ?? widget.event;
    showDialog(
      context: context,
      builder: (dialogContext) => ShareEventDialog(event: event),
    );
  }

  void _editEvent() {
    final event = _currentEvent ?? widget.event;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditEventPage(event: event),
      ),
    ).then((updated) {
      // ไม่ต้อง refresh แล้วเพราะมี real-time listener
      // if (updated == true) {
      //   _loadRegistrationData();
      // }
    });
  }

  Future<void> _deleteEvent() async {
    final event = _currentEvent ?? widget.event;
    
    // แสดง confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบ "${event.title}" หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
    
    if (shouldDelete != true) return;
    
    // เก็บ context ไว้ก่อนเริ่มการลบ
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    
    // แสดง loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('กำลังลบ Event...'),
          ],
        ),
      ),
    );
    
    try {
      // ลบ Event
      await CampusEventDI.deleteEvent(event.id);
      
      // ปิด loading dialog
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      // กลับไปหน้าก่อนหน้า
      if (mounted) {
        navigator.pop();
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('ลบ Event สำเร็จ!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error deleting event: $e');
      
      // ปิด loading dialog
      if (mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (dialogError) {
          print('Could not close loading dialog: $dialogError');
        }
      }
      
      // แสดง error message
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper methods
  String _getCategoryDisplayName(EventCategory category) {
    switch (category) {
      case EventCategory.competition:
        return 'การแข่งขัน';
      case EventCategory.academic:
        return 'วิชาการ';
      case EventCategory.sports:
        return 'กีฬา';
      case EventCategory.cultural:
        return 'วัฒนธรรม';
      case EventCategory.general:
        return 'ทั่วไป';
    }
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return AppColors.orangeGradientStart;
      case EventStatus.ongoing:
        return AppColors.greenGradientStart;
      case EventStatus.completed:
        return AppColors.textSecondary;
      case EventStatus.cancelled:
        return AppColors.redGradientStart;
    }
  }

  String _getStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return 'เร็วๆ นี้';
      case EventStatus.ongoing:
        return 'กำลังดำเนินการ';
      case EventStatus.completed:
        return 'เสร็จสิ้น';
      case EventStatus.cancelled:
        return 'ยกเลิก';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'วันนี้';
    } else if (difference == 1) {
      return 'พรุ่งนี้';
    } else if (difference > 1 && difference <= 7) {
      return 'ใน $difference วัน';
    } else {
      final months = [
        'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
        'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year + 543}';
    }
  }
}
