import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/l10n.dart';

/// لغة التطبيق (عربي / إنجليزي). تنحفظ في الجهاز وترجع لنا عند فتح التطبيق.
/// الافتراضي عربي.
class LocaleViewModel extends ChangeNotifier {
  static const String _prefsKey = 'app_locale';

  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');

  Locale _locale = arabic;

  Locale get locale => _locale;

  bool get isEnglish => _locale.languageCode == 'en';

  /// نناديها مرة وحدة في main() قبل runApp عشان ما تظهر الشاشة بلغة غلط
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefsKey);
      if (code == 'en') _locale = english;
    } catch (_) {
      // لو فشلت القراءة نكمل بالعربي
    }
    L10n.locale = _locale;
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == _locale.languageCode) return;
    _locale = locale;
    L10n.locale = locale;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, locale.languageCode);
    } catch (_) {
      // الحفظ ما نجح: اللغة تشتغل بس ما تنحفظ
    }
  }

  /// للزر في السبلاش وحسابي
  Future<void> toggle() => setLocale(isEnglish ? arabic : english);
}