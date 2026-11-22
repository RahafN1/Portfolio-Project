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
import 'features/trails/data/trails_repository.dart';
import 'features/trails/viewmodels/explore_viewmodel.dart';
import 'features/favorites/data/favorites_repository.dart';
import 'features/favorites/viewmodels/favorites_viewmodel.dart';
import 'features/reviews/data/reviews_repository.dart';
import 'features/admin/data/admin_repository.dart';
import 'l10n/app_localizations.dart';
import 'features/splash/views/intro_splash_screen.dart';

class QimmahApp extends StatefulWidget {
  // اللغة تنقرأ في main() قبل ما يبدأ التطبيق
  final LocaleViewModel localeViewModel;

  const QimmahApp({super.key, required this.localeViewModel});

  @override
  State<QimmahApp> createState() => _QimmahAppState();
}

class _QimmahAppState extends State<QimmahApp> {
  // نحتاجه عشان نتنقل من خارج الواجهة (لما تنتهي الجلسة)
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // ننشئها مرة وحدة هنا، مو داخل build، عشان ما تنعاد مع كل rebuild
  late final TokenStorage _tokenStorage;
  late final ApiClient _apiClient;
  late final TrailsRepository _trailsRepository;
  late final ReviewsRepository _reviewsRepository;
  late final AdminRepository _adminRepository;
  late final FavoritesRepository _favoritesRepository;
  late final AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();

    _tokenStorage = TokenStorage();
    _apiClient = ApiClient(_tokenStorage);
    _trailsRepository = TrailsRepository(_apiClient);
    _reviewsRepository = ReviewsRepository(_apiClient);
    _adminRepository = AdminRepository(_apiClient);
    _favoritesRepository = FavoritesRepository(_apiClient);
    _authViewModel = AuthViewModel(AuthRepository(_apiClient, _tokenStorage));

    // لما تنتهي الجلسة: نصفّر المستخدم ونرجّعه لتسجيل الدخول
    _apiClient.onSessionExpired = () {
      _authViewModel.handleSessionExpired();
      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRouter.login,
        (route) => false,
      );
    };
  }

  @override
  void dispose() {
    _apiClient.onSessionExpired = null;
    _authViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TrailsRepository>.value(value: _trailsRepository),
        Provider<ReviewsRepository>.value(value: _reviewsRepository),
        Provider<AdminRepository>.value(value: _adminRepository),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider<LocaleViewModel>.value(
          value: widget.localeViewModel,
        ),
        ChangeNotifierProvider<AuthViewModel>.value(value: _authViewModel),
        ChangeNotifierProvider(
          create: (_) => ExploreViewModel(_trailsRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesViewModel(_favoritesRepository),
        ),
      ],
      child: Consumer2<ThemeViewModel, LocaleViewModel>(
        builder: (context, themeVm, localeVm, _) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
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
                  builder: (context) => const IntroSplashScreen(),
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