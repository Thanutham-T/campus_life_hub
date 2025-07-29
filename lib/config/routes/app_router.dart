import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/dashboard/presentation/pages/main_screen.dart';
import '../../features/course_schedule/presentation/pages/schedule_page.dart';
import '../../features/campus_event/presentation/pages/event_page.dart';
import '../../features/study_group/presentation/pages/study_group_page.dart';
import '../../features/campus_map/presentation/pages/campus_map_page.dart';
import '../../features/announcement/presentation/pages/announcement_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/', builder: (context, state) => const MainScreen()),
    GoRoute(path: '/home/:index', builder: (context, state) {
      final index = int.tryParse(state.pathParameters['index'] ?? '0') ?? 0;
      return MainScreen(initialIndex: index);
    }),
    GoRoute(path: '/schedule', builder: (context, state) => const SchedulePage()),
    GoRoute(path: '/events', builder: (context, state) => const EventPage()),
    GoRoute(path: '/groups', builder: (context, state) => const StudyGroupPage()),
    GoRoute(path: '/map', builder: (context, state) => const CampusMapPage()),
    GoRoute(path: '/announcements', builder: (context, state) => const AnnouncementPage(showBackButton: true, showBottomNav: true)),
  ],
  initialLocation: '/splash',
);
