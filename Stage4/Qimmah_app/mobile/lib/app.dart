import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/locale/locale_viewmodel.dart';
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
import 'features/favorites/data/favorites_repository.dart';
import 'features/favorites/viewmodels/favorites_viewmodel.dart';
import 'features/reviews/data/reviews_repository.dart';
import 'features/admin/data/admin_repository.dart';
import 'l10n/app_localizations.dart';

class QimmahApp extends StatelessWidget {
  // اللغة تنقرأ في main() قبل ما يبدأ التطبيق
  final LocaleViewModel localeViewModel;

  const QimmahApp({super.key, required this.localeViewModel});

  @override
  Widget build(BuildContext context) {
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage);
    final trailsRepository = TrailsRepository(apiClient);

    return MultiProvider(
      providers: [
        Provider<TrailsRepository>.value(value: trailsRepository),
        Provider<ReviewsRepository>.value(value: ReviewsRepository(apiClient)),
        Provider<AdminRepository>.value(value: AdminRepository(apiClient)),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider<LocaleViewModel>.value(value: localeViewModel),
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
      child: Consumer2<ThemeViewModel, LocaleViewModel>(
        builder: (context, themeVm, localeVm, _) {
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context).appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeVm.mode,

            // اتجاه الواجهة (RTL/LTR) يتبع اللغة تلقائياً
            locale: localeVm.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,

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