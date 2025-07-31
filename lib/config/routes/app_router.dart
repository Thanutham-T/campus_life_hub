import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/user/presentation/pages/login_page.dart';
import '../../features/user/presentation/pages/register_page.dart';
import '../../features/user/presentation/pages/profile_page.dart';
import '../../features/user/presentation/pages/home_page.dart';
import '../../features/course_schedule/presentation/pages/schedule_page.dart';
import '../../features/campus_event/presentation/pages/event_page.dart';
import '../../features/study_group/presentation/pages/study_group_page.dart';
import '../../features/campus_map/presentation/pages/campus_map_page.dart';
import '../../features/announcement/presentation/pages/announcement_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
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
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(path: '/', redirect: (context, state) => '/login'),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
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
      path: '/map',
      name: 'map',
      builder: (context, state) => const CampusMapPage(),
    ),
    GoRoute(
      path: '/announcements',
      name: 'announcements',
      builder: (context, state) => const AnnouncementPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
