
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'package:campus_life_hub/core/widgets/custom_bottom_navigation_bar.dart';
import '../../features/study_group/domain/repositories/study_group_repository.dart';

import '../routes/app_routes.dart';
  

// Main Layout with Bottom Navigation
class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  void _onNavigationTap(int index) {
    switch (index) {
      case 0:
        context.go(Routes.dashboard);
        break;
      case 1:
        context.go(Routes.schedule);
        break;
      case 2:
        context.go(Routes.events);
        break;
      case 3:
        context.go(Routes.studyGroups);
        break;
      case 4:
        context.go(Routes.announcements);
        break;
      case 5:
        context.go(Routes.campusMap);
        break;
      case 6:
        context.go(Routes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update current index based on current route
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    
    if (location == Routes.dashboard) {
      currentIndex = 0;
    } else if (location.startsWith(Routes.schedule)) {
      currentIndex = 1;
    } else if (location.startsWith(Routes.events)) {
      currentIndex = 2;
    } else if (location.startsWith(Routes.studyGroups)) {
      currentIndex = 3;
    } else if (location.startsWith(Routes.announcements)) {
      currentIndex = 4;
    } else if (location.startsWith(Routes.campusMap)) {
      currentIndex = 5;
    } else if (location.startsWith(Routes.profile)) {
      currentIndex = 6;
    } else if (location.startsWith(Routes.settings)) {
      // Settings is accessed from dashboard tools, keep dashboard highlighted
      currentIndex = 0;
    }

    // Get page title based on current route
    Widget? appBarActions;
    String pageTitle = 'Campus Life Hub';
    if (location.startsWith(Routes.schedule)) {
      pageTitle = 'Course Schedule';
    } else if (location.startsWith(Routes.events)) {
      pageTitle = 'Campus Events';
    } else if (location.startsWith(Routes.studyGroups)) {
      if (location.contains('/chat')) {
        // Extract group name from query parameters or use default
        final uri = GoRouterState.of(context).uri;
        pageTitle = uri.queryParameters['groupName'] ?? 'กลุ่มศึกษา';
        
        // Add chat-specific actions
        appBarActions = PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (String value) {
            if (value == 'leave_group') {
              // Show leave group dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('ออกจากกลุ่ม'),
                    content: const Text('คุณต้องการออกจากกลุ่มนี้หรือไม่?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('ยกเลิก'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          
                          try {
                            // Get current user ID
                            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                            if (currentUserId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ไม่สามารถระบุผู้ใช้ได้'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            
                            // Extract group ID from current location string
                            final currentLocation = location;
                            print('Current location: $currentLocation'); // Debug
                            String? groupId;
                            
                            // Parse path like /studyGroups/{groupId}/chat
                            final pathSegments = currentLocation.split('/');
                            print('Path segments: $pathSegments'); // Debug
                            for (int i = 0; i < pathSegments.length; i++) {
                              if (pathSegments[i] == 'studyGroups' && i + 1 < pathSegments.length) {
                                groupId = pathSegments[i + 1];
                                print('Found group ID: $groupId'); // Debug
                                break;
                              }
                            }
                            
                            if (groupId == null || groupId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ไม่สามารถระบุกลุ่มได้'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            
                            // Use repository to leave group
                            final repository = GetIt.instance<StudyGroupRepository>();
                            final result = await repository.leaveStudyGroup(groupId, currentUserId);
                            
                            result.fold(
                              (error) {
                                // Show error message
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('เกิดข้อผิดพลาด: $error'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              (_) {
                                // Success - show message and navigate back to study groups
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('ออกจากกลุ่มเรียบร้อยแล้ว'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  // Navigate back to study groups page
                                  context.go(Routes.studyGroups);
                                }
                              },
                            );
                          } catch (e) {
                            // Handle unexpected errors
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('เกิดข้อผิดพลาดไม่คาดคิด: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('ออกจากกลุ่ม', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'leave_group',
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: Colors.red),
                  SizedBox(width: 8),
                  Text('ออกจากกลุ่ม', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        );
      } else {
        pageTitle = 'Study Groups';
      }
    } else if (location.startsWith(Routes.announcements)) {
      pageTitle = 'Announcements';
    } else if (location.startsWith(Routes.campusMap)) {
      pageTitle = 'Campus Map';
    } else if (location.startsWith(Routes.profile)) {
      pageTitle = 'Profile';
    } else if (location.startsWith(Routes.settings)) {
      pageTitle = 'Settings';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // AppColors.backgroundGrey
      appBar: _buildAppBar(context, pageTitle, location, appBarActions),
      body: widget.child,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onNavigationTap,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title, String location, Widget? actions) {
    // Import necessary constants
    const primaryBlue = Color(0xFF1B4B87);
    const textWhite = Colors.white;
    const paddingSmall = 8.0;
    const radiusSmall = 8.0;
    const fontLarge = 18.0;
    
    return AppBar(
      backgroundColor: primaryBlue,
      elevation: 0,
      leading: location == Routes.dashboard 
        ? Padding(
            padding: const EdgeInsets.all(paddingSmall),
            child: Container(
              decoration: BoxDecoration(
                color: textWhite,
                borderRadius: BorderRadius.circular(radiusSmall),
              ),
              child: const Icon(
                Icons.school,
                color: primaryBlue,
              ),
            ),
          )
        : IconButton(
            icon: const Icon(Icons.arrow_back, color: textWhite),
            onPressed: () => context.go(Routes.dashboard),
          ),
      title: Text(
        title,
        style: const TextStyle(
          color: textWhite,
          fontSize: fontLarge,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: actions != null ? [actions] : null,
    );
  }
}
