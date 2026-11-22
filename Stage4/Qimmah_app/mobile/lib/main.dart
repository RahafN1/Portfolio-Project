import 'package:flutter/material.dart';

import 'app.dart';
import 'core/locale/locale_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // نقرأ اللغة المحفوظة قبل أول شاشة
  final localeViewModel = LocaleViewModel();
  await localeViewModel.load();

  runApp(QimmahApp(localeViewModel: localeViewModel));
}