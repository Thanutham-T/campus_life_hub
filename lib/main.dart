import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';

import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'injection_container.dart' as di;
import 'features/user/presentation/bloc/auth_bloc.dart';
import 'features/user/presentation/bloc/auth_event.dart';
import 'core/widgets/custom_bottom_navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(AppStarted()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Campus Life Hub',
        theme: AppTheme.lightTheme,
        
        // Localization
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('th', 'TH'), // Default to Thai
        
        // Navigation
        routerDelegate: appRouter.routerDelegate,
        routeInformationParser: appRouter.routeInformationParser,
        routeInformationProvider: appRouter.routeInformationProvider,
      ),
    );
  }
}

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
        context.go('/');
        break;
      case 1:
        context.go('/schedule');
        break;
      case 2:
        context.go('/events');
        break;
      case 3:
        context.go('/groups');
        break;
      case 4:
        context.go('/announcements');
        break;
      case 5:
        context.go('/campus-map');
        break;
      case 6:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update current index based on current route
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    
    if (location == '/') {
      currentIndex = 0;
    } else if (location.startsWith('/schedule')) {
      currentIndex = 1;
    } else if (location.startsWith('/events')) {
      currentIndex = 2;
    } else if (location.startsWith('/groups')) {
      currentIndex = 3;
    } else if (location.startsWith('/announcements')) {
      currentIndex = 4;
    } else if (location.startsWith('/campus-map')) {
      currentIndex = 5;
    } else if (location.startsWith('/profile')) {
      currentIndex = 6;
    }

    // Get page title based on current route
    String pageTitle = 'Campus Life Hub';
    if (location.startsWith('/schedule')) {
      pageTitle = 'Course Schedule';
    } else if (location.startsWith('/events')) {
      pageTitle = 'Campus Events';
    } else if (location.startsWith('/groups')) {
      pageTitle = 'Study Groups';
    } else if (location.startsWith('/announcements')) {
      pageTitle = 'Announcements';
    } else if (location.startsWith('/campus-map')) {
      pageTitle = 'Campus Map';
    } else if (location.startsWith('/profile')) {
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
      leading: location == '/' 
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
            onPressed: () => context.go('/'),
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
