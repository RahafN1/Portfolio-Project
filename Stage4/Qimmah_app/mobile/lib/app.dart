import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/routing/app_router.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'features/trails/data/trails_repository.dart';
import 'features/trails/viewmodels/explore_viewmodel.dart';

class QimmaApp extends StatelessWidget {
  const QimmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // نجهز الأدوات مرة وحدة ونعطيها للـ ViewModels
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(AuthRepository(apiClient, tokenStorage)),
        ),
        ChangeNotifierProvider(
          create: (_) => ExploreViewModel(TrailsRepository(apiClient)),
        ),
      ],
      child: MaterialApp(
        title: 'قمّة',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        // التطبيق بالعربي (من اليمين لليسار)
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        initialRoute: AppRouter.splash,
        routes: AppRouter.routes,
      ),
    );
  }
}
