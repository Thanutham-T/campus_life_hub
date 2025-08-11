import 'package:campus_life_hub/config/themes/app_theme.dart';
import 'package:campus_life_hub/config/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'config/routes/app_router.dart';
import 'config/di/injector.dart' as di;

import 'features/user/presentation/bloc/auth_bloc.dart';
import 'features/user/presentation/bloc/auth_event.dart';
import 'package:campus_life_hub/core/services/key_value_storage_service.dart'; // <-- add

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  await di.initCriticalServices();

  FlutterNativeSplash.remove();
  
  runApp(const MyApp());

  Future.microtask(() => di.initNonCriticalServices());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<KeyValueStorageService>.value(
          value: di.sl<KeyValueStorageService>(),
        ),
      ],
      child: BlocProvider(
        create: (context) => di.sl<AuthBloc>()..add(AppStarted()),
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
          routerConfig: AppRouter.instance.router,
        ),
      ),
    );
  }
}
