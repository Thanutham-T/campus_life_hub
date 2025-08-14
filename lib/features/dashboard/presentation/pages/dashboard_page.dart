import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/constants/dimens.dart';
import '../../domain/entities/tool_item.dart';
import '../../../../core/widgets/tool_card.dart';
import '../../../campus_event/domain/entities/event_model.dart';
import '../../../../core/utils/event_image_helper.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Event> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupRealTimeEventListener();
  }

  void _setupRealTimeEventListener() {
    // Listen to real-time updates from Firestore
    FirebaseFirestore.instance
        .collection('events')
        .orderBy('createdAt', descending: true)
        .limit(10) // Limit to 10 most recent events for dashboard
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() {
          events = snapshot.docs
              .map((doc) => Event.fromFirestore(doc.data(), doc.id))
              .toList();
          isLoading = false;
        });
      }
    }, onError: (error) {
      print('Error listening to events: $error');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campus Events Section
            _buildEventsSection(context),
            
            // Tools Section
            _buildToolsSection(context),
            
            // Add small bottom padding for navigation bar
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimens.marginMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.campusEvents,
                style: TextStyle(
                  fontSize: AppDimens.fontXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.go(Routes.events);
                },
                child: const Text(
                  AppStrings.viewAll,
                  style: TextStyle(
                    fontSize: AppDimens.fontMedium,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimens.marginMedium),
          
          // Event Cards Horizontal Scroll
          SizedBox(
            height: 160,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : events.isEmpty
                  ? const Center(
                      child: Text(
                        'ไม่มี Event ในขณะนี้',
                        style: TextStyle(
                          fontSize: AppDimens.fontMedium,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Container(
                          width: 144, // Increased by 20% (from 120 to 144)
                          margin: EdgeInsets.only(
                            left: index == 0 ? 0 : AppDimens.marginMedium,
                            right: index == events.length - 1 ? AppDimens.marginMedium : 0,
                          ),
                          child: _buildDashboardEventCard(event),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardEventCard(Event event) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => context.go('${Routes.events}/${event.id}'),
        child: Card(
          elevation: AppDimens.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image (75% of total height)
              Expanded(
                flex: 75,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimens.radiusMedium),
                  ),
                  child: EventImageHelper.buildEventImage(
                    imageUrl: event.imageUrl,
                    eventId: event.id,
                    eventTitle: event.title,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // Event Content (25% of total height)
              Expanded(
                flex: 25,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolsSection(BuildContext context) {
    final tools = [
      ToolItem(
        title: AppStrings.schedule,
        icon: Icons.calendar_today,
        backgroundColor: Colors.red,
        onTap: () => context.go(Routes.course),
      ),
      ToolItem(
        title: AppStrings.announcements,
        icon: Icons.campaign,
        backgroundColor: Colors.orange,
        onTap: () => context.go(Routes.announcements),
      ),
      ToolItem(
        title: AppStrings.map,
        icon: Icons.location_on,
        backgroundColor: Colors.green,
        onTap: () => context.go(Routes.campusMap),
      ),
      ToolItem(
        title: 'Profile',
        icon: Icons.person,
        backgroundColor: Colors.blue,
        onTap: () => context.go(Routes.profile),
      ),
      ToolItem(
        title: AppStrings.studyGroups,
        icon: Icons.groups,
        backgroundColor: Colors.purple,
        onTap: () => context.go(Routes.studyGroups),
      ),
      ToolItem(
        title: AppStrings.setting,
        icon: Icons.settings,
        backgroundColor: Colors.grey,
        onTap: () {
          // Show settings dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Settings'),
                content: const Text('Settings feature will be implemented soon.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
      ),
    ];

    return Container(
      margin: const EdgeInsets.all(AppDimens.marginMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.tools,
            style: TextStyle(
              fontSize: AppDimens.fontXLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: AppDimens.marginMedium),
          
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 1.0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: tools.map((tool) => ToolCard(toolItem: tool)).toList(),
          ),
        ],
      ),
    );
  }
}
