
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:campus_life_hub/core/widgets/custom_bottom_navigation_bar.dart';

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
    }

    // Get page title based on current route
    String pageTitle = 'Campus Life Hub';
    if (location.startsWith(Routes.schedule)) {
      pageTitle = 'Course Schedule';
    } else if (location.startsWith(Routes.events)) {
      pageTitle = 'Campus Events';
    } else if (location.startsWith(Routes.studyGroups)) {
      pageTitle = 'Study Groups';
    } else if (location.startsWith(Routes.announcements)) {
      pageTitle = 'Announcements';
    } else if (location.startsWith(Routes.campusMap)) {
      pageTitle = 'Campus Map';
    } else if (location.startsWith(Routes.profile)) {
      pageTitle = 'Profile';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // AppColors.backgroundGrey
      appBar: _buildAppBar(context, pageTitle, location),
      body: widget.child,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onNavigationTap,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title, String location) {
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
    );
  }
}
