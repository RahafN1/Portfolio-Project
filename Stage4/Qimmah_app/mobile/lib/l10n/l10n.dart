import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// داخل أي Widget:  context.l10n.searchHint
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// للأكواد اللي ما عندها BuildContext (ViewModels / Repositories / API).
/// [LocaleViewModel] يحدّث [locale] كل ما تتغير اللغة.
///
///   L10n.tr.loadTrailsError   // نص مترجم
///   L10n.languageCode         // 'ar' أو 'en' (نرسله للباك إند)
class L10n {
  L10n._();

  static Locale locale = const Locale('ar');

  static String get languageCode => locale.languageCode;

  static bool get isEnglish => languageCode == 'en';

  static AppLocalizations get tr => lookupAppLocalizations(locale);
}