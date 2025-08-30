import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_routes.dart';


class Middleware {
  Future<String?> routeMiddleware(GoRouterState state) async {
    // get the route path
    var path = state.uri.path;

    // check the route path and return boolean
    bool isPublicPath = path == Routes.register || path == Routes.login || path == Routes.onboarding || path == Routes.splash;

    // get the user registered token
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    // conditions to check the routes
    if(isPublicPath && (token != null || (token?.isNotEmpty ?? false))) {
      return path;
    } else if(!isPublicPath && (token == null || token.isEmpty)) {
      return Routes.login;
    }
    return null;
  }
}