import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../layouts/main_layout.dart';
import '../routes/app_routes.dart';
import '../routes/app_route_builders.dart';
import '../routes/middleware.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/user/presentation/pages/login_page.dart';
import '../../features/user/presentation/pages/register_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/campus_event/presentation/pages/event_page.dart';
import '../../features/campus_event/presentation/pages/event_detail_page.dart';
import '../../features/campus_map/presentation/pages/campus_map_page.dart';
import '../../features/announcement/presentation/pages/announcement_page.dart';
import '../../features/announcement/presentation/pages/create_announcement_page.dart';
import '../../features/announcement/presentation/bloc/announcement_bloc.dart';
import '../../features/announcement/domain/repositories/announcement_repository.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/study_group/presentation/pages/study_group_chat_page.dart';
import '../../features/study_group/presentation/bloc/chat_bloc.dart';
import '../../features/study_group/presentation/bloc/chat_event.dart';
import '../../features/study_group/domain/repositories/chat_repository.dart';
import '../di/injector.dart' as di;
import '../../features/campus_event/domain/entities/event_model.dart';
import '../../features/campus_event/di/campus_event_di.dart';

class AppRouter {
  AppRouter._();

  static final AppRouter instance = AppRouter._();

  final GoRouter _router = GoRouter(
    initialLocation: Routes.splash,
    routerNeglect: false,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
        String? redirectPath = await Middleware().routeMiddleware(state);
        return redirectPath;
    },
    routes: [
      GoRoute(path: Routes.splash, name: 'splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: Routes.onboarding, name: 'onboarding', builder: (context, state) => const OnBoardingPage()),
      GoRoute(path: Routes.login, name: 'login', builder: (context, state) => const LoginPage()),
      GoRoute(path: Routes.register, name: 'register', builder: (context, state) => const RegisterPage()),

      // Routes with MainLayout
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(path: Routes.dashboard, name: 'dashboard', builder: (context, state) => const DashboardPage()),
          GoRoute(path: Routes.profile, name: 'profile', builder: (context, state) => const ProfilePage()),
          GoRoute(path: Routes.schedule, name: 'schedule', builder: (context, state) => RouteBuilders.buildSchedulePageWithBloc()),
          GoRoute(path: Routes.course, name: 'course', builder: (context, state) => RouteBuilders.buildCoursePageWithBloc()),
          GoRoute(path: Routes.events, name: 'events', builder: (context, state) => const EventPage()),
          GoRoute(
            path: '${Routes.events}/:eventId', 
            name: 'event-detail', 
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return FutureBuilder<Event?>(
                future: CampusEventDI.getEventById(eventId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                    // Error or event not found, redirect to events page
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go(Routes.events);
                    });
                    return const Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, size: 64, color: Colors.red),
                            SizedBox(height: 16),
                            Text('ไม่พบ Event ที่ต้องการ'),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  return EventDetailPage(event: snapshot.data!);
                },
              );
            },
          ),
          GoRoute(path: Routes.studyGroups, name: 'groups', builder: (context, state) => RouteBuilders.buildStudyGroupPageWithBloc()),
          GoRoute(
            path: '/studyGroups/:groupId/chat',
            name: 'study-group-chat',
            builder: (context, state) {
              final groupId = state.pathParameters['groupId']!;
              final groupName = state.uri.queryParameters['groupName'] ?? 'กลุ่มศึกษา';
              return BlocProvider(
                create: (_) => ChatBloc(repository: di.sl<ChatRepository>())
                  ..add(GetChatMessagesEvent(groupId)),
                child: StudyGroupChatPage(
                  studyGroupId: groupId,
                  groupName: groupName,
                ),
              );
            },
          ),
          GoRoute(path: Routes.campusMap, name: 'map', builder: (context, state) => const CampusMapPage()),
          GoRoute(
            path: Routes.announcements, 
            name: 'announcements', 
            builder: (context, state) => BlocProvider(
              create: (context) => AnnouncementBloc(
                repository: GetIt.instance<AnnouncementRepository>(),
                auth: GetIt.instance<FirebaseAuth>(),
              ),
              child: const AnnouncementPage(),
            ),
          ),
          GoRoute(
            path: Routes.createAnnouncement,
            name: 'create-announcement',
            builder: (context, state) => const CreateAnnouncementPage(),
          ),
          GoRoute(path: Routes.settings, name: 'settings', builder: (context, state) => const SettingsPage()),
        ]
      ),
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
              onPressed: () => context.go(Routes.dashboard),
              child: const Text('กลับไปหน้าแรก'),
            ),
          ],
        ),
      ),
    ),
  );

  GoRouter get router => _router;
}
