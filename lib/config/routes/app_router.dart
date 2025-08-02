import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/user/presentation/pages/login_page.dart';
import '../../features/user/presentation/pages/register_page.dart';
import '../../features/user/presentation/pages/profile_page.dart';
import '../../features/user/presentation/pages/home_page.dart';
import '../../features/course_schedule/presentation/pages/schedule_page.dart';
import '../../features/campus_event/presentation/pages/event_page.dart';
import '../../features/study_group/presentation/pages/study_group_page.dart';
import '../../features/campus_map/presentation/pages/campus_map_page.dart';
import '../../features/announcement/presentation/pages/announcement_page.dart';
import '../../main.dart';

// Import dashboard_page แบบตรงๆ
import '../../features/dashboard/presentation/pages/dashboard_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Routes without bottom navigation
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/map',
      name: 'map',
      builder: (context, state) => const CampusMapPage(),
    ),

    // Routes with bottom navigation - using ShellRoute
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/schedule',
          name: 'schedule',
          builder: (context, state) => const SchedulePage(),
        ),
        GoRoute(
          path: '/events',
          name: 'events',
          builder: (context, state) => const EventPage(),
        ),
        GoRoute(
          path: '/groups',
          name: 'groups',
          builder: (context, state) => const StudyGroupPage(),
        ),
        GoRoute(
          path: '/announcements',
          name: 'announcements',
          builder: (context, state) => const AnnouncementPage(
            showBackButton: false,
            showBottomNav: false,
          ),
        ),
        GoRoute(
          path: '/campus-map',
          name: 'campus-map',
          builder: (context, state) => const CampusMapPage(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),

    // Deprecated routes (for backward compatibility)
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      redirect: (context, state) => '/',
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(path: '/home/:index', redirect: (context, state) => '/'),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('ไม่พบหน้าที่ต้องการ: ${state.matchedLocation}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/splash'),
            child: const Text('กลับไปหน้าแรก'),
          ),
        ],
      ),
    ),
  ),
);
