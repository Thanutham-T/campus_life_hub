import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_routes.dart';
import '../routes/app_route_builders.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/user/presentation/pages/login_page.dart';
import '../../features/user/presentation/pages/register_page.dart';
// import '../../features/user/presentation/pages/profile_page.dart';
import '../../features/campus_event/presentation/pages/event_page.dart';
import '../../features/study_group/presentation/pages/study_group_page.dart';
import '../../features/campus_map/presentation/pages/campus_map_page.dart';
import '../../features/announcement/presentation/pages/announcement_page.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: Routes.course,
  routes: [
    // GoRoute(path: '/', name: 'onboarding', redirect: (context, state) => const OnBoardingPage()),
    GoRoute(path: Routes.login, name: 'login', builder: (context, state) => const LoginPage()),
    GoRoute(path: Routes.register, name: 'register', builder: (context, state) => const RegisterPage()),
    GoRoute(path: Routes.dashboard, name: 'dashboard', builder: (context, state) => const DashboardPage()),
    // GoRoute(path: Routes.profile, name: 'profile', builder: (context, state) => const ProfilePage()),
    // GoRoute(path: Routes.schedule, name: 'schedule', builder: (context, state) => RouteBuilders.buildSchedulePageWithBloc()),
    GoRoute(path: Routes.course, name: 'course', builder: (context, state) => RouteBuilders.buildCoursePageWithBloc()),
    GoRoute(path: Routes.events, name: 'events', builder: (context, state) => const EventPage()),
    GoRoute(path: Routes.studyGroups, name: 'groups', builder: (context, state) => const StudyGroupPage()),
    GoRoute(path: Routes.campusMap, name: 'map', builder: (context, state) => const CampusMapPage()),
    GoRoute(path: Routes.announcements, name: 'announcements', builder: (context, state) => const AnnouncementPage()),
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
            onPressed: () => context.go(context.namedLocation('dashboard')),
            child: const Text('กลับไปหน้าแรก'),
          ),
        ],
      ),
    ),
  ),
);