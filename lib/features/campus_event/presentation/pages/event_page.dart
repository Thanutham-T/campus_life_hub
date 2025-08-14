import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimens.dart';
import '../../domain/entities/event_model.dart';
import '../../../../core/utils/event_image_helper.dart';
import '../../../user/presentation/bloc/auth_bloc.dart';
import '../../../user/presentation/bloc/auth_state.dart';
import '../../../user/presentation/bloc/auth_event.dart';
import '../../../user/domain/entities/profile_entity.dart';
import '../../domain/services/event_registration_service.dart';
import '../../di/campus_event_di.dart';
import 'event_detail_page.dart';
import '../../../../core/services/firebase_storage_service.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with AutomaticKeepAliveClientMixin {
  Map<String, bool> _registrationStatus = {};
  Map<String, int> _registrationCounts = {};
  Future<Map<String, dynamic>>? _dataFuture;
  List<Event> _events = []; // เพิ่มตัวแปรเก็บ events แบบ real-time

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('EventPage initState called');
    // Initialize data loading immediately
    _initializeData();
    _listenToEventChanges(); // ฟัง Event changes แบบ real-time
    _listenToRegistrationChanges(); // ฟัง Registration changes แบบ real-time
  }

  // ฟัง Registration changes แบบ real-time
  void _listenToRegistrationChanges() {
    FirebaseFirestore.instance
        .collection('event_registrations')
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        // สร้าง Map เก็บจำนวนการลงทะเบียนแต่ละ event
        Map<String, int> registrationCounts = {};
        
        // นับจำนวน registration ของแต่ละ event
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final eventId = data['eventId'] as String?;
          if (eventId != null) {
            registrationCounts[eventId] = (registrationCounts[eventId] ?? 0) + 1;
          }
        }
        
        setState(() {
          _registrationCounts.clear();
          _registrationCounts.addAll(registrationCounts);
        });
        
        // อัพเดทสถานะการลงทะเบียนของ current user
        _updateUserRegistrationStatus(snapshot.docs);
      }
    });
  }

  // อัพเดทสถานะการลงทะเบียนของ current user
  void _updateUserRegistrationStatus(List<QueryDocumentSnapshot> docs) {
    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final userId = authState.profile.id;
        
        // สร้าง Set ของ eventId ที่ user ลงทะเบียนแล้ว
        final userRegisteredEvents = <String>{};
        
        for (final doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final docUserId = data['userId'] as String?;
          final eventId = data['eventId'] as String?;
          
          if (docUserId == userId && eventId != null) {
            userRegisteredEvents.add(eventId);
          }
        }
        
        // อัพเดทสถานะทุก event
        final newRegistrationStatus = <String, bool>{};
        for (final event in _events) {
          newRegistrationStatus[event.id] = userRegisteredEvents.contains(event.id);
        }
        
        if (mounted) {
          setState(() {
            _registrationStatus.clear();
            _registrationStatus.addAll(newRegistrationStatus);
          });
        }
      }
    } catch (e) {
      print('Error updating user registration status: $e');
    }
  }

  // ฟัง Event changes แบบ real-time
  void _listenToEventChanges() {
    FirebaseFirestore.instance
        .collection('events')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        final events = snapshot.docs.map((doc) {
          final data = doc.data();
          return Event(
            id: doc.id,
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            location: data['location'] ?? '',
            date: DateTime.parse(data['date'] ?? DateTime.now().toIso8601String()),
            imageUrl: data['imageUrl'],
            category: EventCategory.values.firstWhere(
              (e) => e.name == data['category'],
              orElse: () => EventCategory.general,
            ),
            status: EventStatus.values.firstWhere(
              (e) => e.name == data['status'],
              orElse: () => EventStatus.upcoming,
            ),
            createdAt: data['createdAt'] != null 
                ? DateTime.parse(data['createdAt']) 
                : DateTime.now(),
            updatedAt: data['updatedAt'] != null 
                ? DateTime.parse(data['updatedAt']) 
                : DateTime.now(),
          );
        }).toList();
        
        setState(() {
          _events = events;
        });
      }
    });
  }

  void _initializeData() {
    // Wait for AuthBloc to be ready before creating the future
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final authState = context.read<AuthBloc>().state;
        print('EventPage _initializeData: AuthState is ${authState.runtimeType}');
        
        // If not loaded yet or still loading, trigger auth check
        if (authState is! AuthAuthenticated) {
          context.read<AuthBloc>().add(AuthStatusRequested());
        }
        
        // Create the future for loading data
        setState(() {
          _dataFuture = _loadAllData();
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('EventPage didChangeDependencies called');
  }

  Future<Map<String, dynamic>> _loadAllData() async {
    try {
      // Load events from Firestore first (they can be shown to everyone)
      final events = await CampusEventDI.getAllEvents();
      print('Loaded ${events.length} events');
      
      // Load registration status and counts for each event
      Map<String, bool> registrationStatus = {};
      Map<String, int> registrationCounts = {};
      
      for (final event in events) {
        // Check if user is registered for each event
        registrationStatus[event.id] = 
            await EventRegistrationService.isUserRegistered(event.id);
        
        // Get registration count for each event
        registrationCounts[event.id] = 
            await EventRegistrationService.getRegistrationCount(event.id);
            
        print('Event ${event.title}: registered=${registrationStatus[event.id]}, count=${registrationCounts[event.id]}');
      }
      
      return {
        'events': events,
        'registrationStatus': registrationStatus,
        'registrationCounts': registrationCounts,
      };
    } catch (e) {
      print('Error loading events: $e');
      throw e;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _dataFuture = _loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Container(
      color: const Color(0xFFF5F7FA), // Background color
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          print('EventPage AuthState: ${authState.runtimeType}');
          
          // Show loading while AuthBloc is initializing
          if (authState is AuthLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5D4E75)),
                  ),
                  SizedBox(height: 16),
                  Text('กำลังตรวจสอบการเข้าสู่ระบบ...'),
                ],
              ),
            );
          }
          
          if (authState is! AuthAuthenticated) {
            // If data future exists, it means we're waiting for auth to complete
            if (_dataFuture != null) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5D4E75)),
                    ),
                    SizedBox(height: 16),
                    Text('กำลังตรวจสอบการเข้าสู่ระบบ...'),
                  ],
                ),
              );
            }
            
            // Try to trigger auth check
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                context.read<AuthBloc>().add(AuthStatusRequested());
                setState(() {
                  _dataFuture = _loadAllData();
                });
              }
            });
            
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5D4E75)),
                  ),
                  SizedBox(height: 16),
                  Text('กำลังโหลด Events...'),
                  SizedBox(height: 8),
                  Text(
                    'โปรดรอสักครู่...',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final userProfile = authState.profile;
          final isAdmin = _isUserAdmin(userProfile);

          // ใช้ real-time data แทน FutureBuilder
          if (_events.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5D4E75)),
                  ),
                  SizedBox(height: 16),
                  Text('กำลังโหลด Events...'),
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                // Admin controls
                if (isAdmin)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.red.shade50,
                    child: Row(
                      children: [
                        const Icon(Icons.admin_panel_settings, color: Colors.red),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'โหมด Admin',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showCreateEventDialog(context, userProfile),
                          icon: const Icon(Icons.add),
                          label: const Text('สร้าง Event'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(120, 36),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Events list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: _buildEventCard(event, userProfile),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper methods to check user roles
  bool _isUserAdmin(ProfileEntity profile) {
    return profile.isAdmin;
  }

  Widget _buildEventCard(Event event, ProfileEntity userProfile) {
    final isRegistered = _registrationStatus[event.id] ?? false;
    final registrationCount = _registrationCounts[event.id] ?? 0;
    final isAdmin = userProfile.isAdmin;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: event),
          ),
        );
      },
      child: Card(
        elevation: AppDimens.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimens.radiusMedium),
              ),
              child: Stack(
                children: [
                  EventImageHelper.buildEventImage(
                    imageUrl: event.imageUrl,
                    eventId: event.id,
                    eventTitle: event.title,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  
                  // Registration count badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.people, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '$registrationCount คน',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Registration status indicator for students
                  if (userProfile.isStudent && isRegistered)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'ลงทะเบียนแล้ว',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Event Content
            Padding(
              padding: const EdgeInsets.all(AppDimens.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Event Title and Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: AppDimens.fontLarge,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(event.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(event.status).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getStatusText(event.status),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: _getStatusColor(event.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Event Description
                  Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: AppDimens.fontSmall,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: const TextStyle(
                            fontSize: AppDimens.fontSmall,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(event.date),
                        style: const TextStyle(
                          fontSize: AppDimens.fontMedium,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action indicator
                  Row(
                    children: [
                      // Admin indicator
                      if (isAdmin) ...[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.admin_panel_settings, size: 16, color: Colors.red),
                                SizedBox(width: 4),
                                Text(
                                  'คลิกเพื่อจัดการ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                      // Student indicator
                      else ...[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.touch_app, size: 16, color: Colors.blue),
                                SizedBox(width: 4),
                                Text(
                                  'คลิกเพื่อดูรายละเอียด',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Admin: Show create event dialog
  Future<void> _showCreateEventDialog(BuildContext context, ProfileEntity userProfile) async {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final descriptionController = TextEditingController();
    EventCategory selectedCategory = EventCategory.general;
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
    File? selectedImage;
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('สร้าง Event ใหม่'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image Preview Section
                  GestureDetector(
                    onTap: isUploading ? null : () async {
                      try {
                        final File? image = await FirebaseStorageService.showImageSourceDialog(context);
                        if (image != null) {
                          setState(() => selectedImage = image);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 50,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'เลือกรูปภาพ Event',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'คลิกเพื่อเลือกจากแกลเลอรี่หรือถ่ายรูป',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'ชื่อ Event',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'สถานที่',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'รายละเอียด',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<EventCategory>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'ประเภท Event',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: EventCategory.values.map((category) => 
                      DropdownMenuItem(
                        value: category,
                        child: Text(_getCategoryDisplayName(category)),
                      ),
                    ).toList(),
                    onChanged: (category) => setState(() => selectedCategory = category!),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('วันที่จัดงาน'),
                    subtitle: Text(_formatDate(selectedDate)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedDate),
                        );
                        if (time != null) {
                          setState(() {
                            selectedDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isUploading ? null : () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: (isUploading || titleController.text.isEmpty) ? null : () async {
                setState(() => isUploading = true);
                
                await _createEvent(
                  title: titleController.text,
                  location: locationController.text,
                  description: descriptionController.text,
                  category: selectedCategory,
                  date: selectedDate,
                  userProfile: userProfile,
                  imageFile: selectedImage,
                );
                
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: isUploading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('สร้าง Event'),
            ),
          ],
        ),
      ),
    );
  }

  // Create new event (admin only)
  Future<void> _createEvent({
    required String title,
    required String location,
    required String description,
    required EventCategory category,
    required DateTime date,
    required ProfileEntity userProfile,
    File? imageFile,
  }) async {
    String? imageUrl;
    
    try {
      // Upload image first if provided
      if (imageFile != null) {
        // Create a temporary event ID for the upload path
        final tempEventId = DateTime.now().millisecondsSinceEpoch.toString();
        
        print('Uploading image for event: $tempEventId');
        // Upload image to Firebase Storage with error handling
        final uploadResult = await FirebaseStorageService.uploadEventImage(tempEventId, imageFile);
        if (uploadResult != null && uploadResult.isNotEmpty) {
          imageUrl = uploadResult;
          print('Image uploaded successfully: $imageUrl');
        } else {
          print('Image upload returned null or empty URL');
        }
      }

      // Create event with or without image
      final eventId = DateTime.now().millisecondsSinceEpoch.toString();
      final event = Event(
        id: eventId,
        title: title,
        description: description,
        location: location,
        date: date,
        category: category,
        status: EventStatus.upcoming,
        imageUrl: imageUrl, // Can be null if upload failed
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add to Firestore
      final eventData = event.toFirestore();
      eventData['createdBy'] = userProfile.id;

      await CampusEventDI.addEventToFirestore(event.id, eventData);
      
      // Show success message with context check
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(imageUrl != null 
              ? 'สร้าง Event พร้อมรูปภาพสำเร็จ!' 
              : imageFile != null 
                ? 'สร้าง Event สำเร็จ! (ไม่สามารถอัพโหลดรูปได้)'
                : 'สร้าง Event สำเร็จ!'
            ),
          ),
        );
      }
      
      await _refreshData(); // Reload events
    } catch (e) {
      print('Error creating event: $e');
      print('Stack trace: ${StackTrace.current}');
      
      // Show error message with context check
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Student: Register for event

  // Student: Register for event

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
      // Format as Thai date
      final months = [
        'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
        'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year + 543}';
    }
  }
}

