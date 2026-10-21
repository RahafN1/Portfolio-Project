import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // الأخضر الأساسي (اخترت نسخة سلو، غيّره لـ 0xFF164F31 لو تبي نسخة السبلاش)
  static const Color primary = Color(0xFF1F5233);
  static const Color primaryOnDark =
      Color(0xFF8CC3A0); // أخضر فاتح للوضع الداكن
  static const Color accent = Color(0xFFC97B47); // البرتقالي

  static const Color backgroundLight = Color(0xFFF6F5F1);
  static const Color backgroundDark = Color(0xFF111714);

  static const Color textLight = Color(0xFF2B2B2B);
  static const Color textDark = Color(0xFFE6EAE7);

  // ألوان مطلوبة من شاشات السبلاش والـ auth
  static const Color primaryLight = Color(0xFFE3EDE6); // خلفية الدوائر
  static const Color disabled = Color(0xFFA3B8A9); // الزر المقفل
  static const Color orange = Color(0xFFD2773F); // جبال الشعار
  static const Color background = Color(0xFFF6F6F3);
  static const Color border = Color(0xFFDDDDDA);
  static const Color grey = Color(0xFF555555);

}
