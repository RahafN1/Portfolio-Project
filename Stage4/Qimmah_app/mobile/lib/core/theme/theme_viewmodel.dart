import 'package:flutter/material.dart';

/// الوضع الفاتح/الداكن. الافتراضي يتبع الجهاز.
class ThemeViewModel extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
  }

  /// لزر القمر في البداية ومفتاح "الوضع الداكن" في حسابي
  void setDark(bool dark) => setMode(dark ? ThemeMode.dark : ThemeMode.light);
}
