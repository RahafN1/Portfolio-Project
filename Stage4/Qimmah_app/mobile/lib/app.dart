import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/routing/app_router.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_viewmodel.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'features/splash/views/splash_screen.dart';
import 'features/trails/data/trails_repository.dart';
import 'features/trails/viewmodels/explore_viewmodel.dart';
import 'core/constants/app_strings.dart';
import 'features/favorites/data/favorites_repository.dart';
import 'features/favorites/viewmodels/favorites_viewmodel.dart';

class QimmahApp extends StatelessWidget {
  const QimmahApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage);
    final trailsRepository = TrailsRepository(apiClient);

    return MultiProvider(
      providers: [
                // صفحة التفاصيل تحتاجه
        Provider<TrailsRepository>.value(value: trailsRepository),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(AuthRepository(apiClient, tokenStorage)),
        ),
        ChangeNotifierProvider(
          create: (_) => ExploreViewModel(trailsRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesViewModel(FavoritesRepository(apiClient)),
        ),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVm, _) {
          return MaterialApp(
           title: AppStrings.appNameAr,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeVm.mode,

            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            routes: AppRouter.routes,
            onGenerateInitialRoutes: (String initialRoute) {
              return [
                MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                  settings: const RouteSettings(name: AppRouter.splash),
                ),
              ];
            },
          );
        },
      ),
    );
  }
}