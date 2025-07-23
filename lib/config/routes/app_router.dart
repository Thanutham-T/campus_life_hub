import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/course_schedule/presentation/pages/schedule_page.dart';
import '../../features/campus_event/presentation/pages/event_page.dart';
import '../../features/study_group/presentation/pages/study_group_page.dart';
import '../../features/campus_map/presentation/pages/campus_map_page.dart';
import '../../features/announcement/presentation/pages/announcement_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    GoRoute(path: '/schedule', builder: (context, state) => const SchedulePage()),
    GoRoute(path: '/events', builder: (context, state) => const EventPage()),
    GoRoute(path: '/groups', builder: (context, state) => const StudyGroupPage()),
    GoRoute(path: '/map', builder: (context, state) => const CampusMapPage()),
    GoRoute(path: '/announcements', builder: (context, state) => const AnnouncementPage()),
  ],
);
