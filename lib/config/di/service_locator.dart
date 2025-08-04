// Dependency Injection setup for the entire app
// This file configures all dependencies using service locator pattern

import 'package:get_it/get_it.dart';

// Import feature DI files
// import '../features/dashboard/di/dashboard_di.dart';
// import '../features/campus_event/di/campus_event_di.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize all feature dependencies
  // await initDashboard();
  // await initCampusEvent();
  
  // Core dependencies can be initialized here
}
