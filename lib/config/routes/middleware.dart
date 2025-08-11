import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_routes.dart';
import 'package:campus_life_hub/core/core_modules.dart';


class Middleware {
  Future<String?> routeMiddleware(GoRouterState state) async {
    // get the route path
    var path = state.uri.path;

    // log the application path
    AppLogger.debug(path.toString());

    // check the route path and return boolean
    bool isPublicPath = path == Routes.register || path == Routes.login || path == Routes.onboarding || path == Routes.splash;

    // get the user registered token
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    // check the boolean conditions
    AppLogger.debug('Route path is: ${isPublicPath.toString()}');
    AppLogger.debug('User token: ${token.toString()}');

    // conditions to check the routes
    if(isPublicPath && (token != null || (token?.isNotEmpty ?? false))) {
      return path;
    } else if(!isPublicPath && (token == null || token.isEmpty)) {
      return Routes.login;
    }
    return null;
  }
}