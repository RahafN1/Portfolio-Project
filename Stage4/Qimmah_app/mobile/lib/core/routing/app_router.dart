import 'package:flutter/material.dart';

import '../../features/admin/views/admin_dashboard_screen.dart';
import '../../features/auth/views/forgot_password_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/otp_screen.dart';
import '../../features/auth/views/reset_password_screen.dart';
import '../../features/auth/views/signup_screen.dart';
import '../../features/splash/views/intro_splash_screen.dart';
import '../../features/splash/views/splash_screen.dart';
import 'main_shell.dart';

class AppRouter {
  static const String splash = '/'; // أول شاشة: الجبل يترسم
  static const String welcome = '/welcome'; // سبلاش الترحيب (للي بدون حساب)
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String signupSuccess = '/signup-success';
  static const String explore = '/explore';
  static const String admin = '/admin';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const IntroSplashScreen(),
    welcome: (context) => const SplashScreen(),
    // كان ناقص: بدونه التحويل لتسجيل الدخول ما يلقى الشاشة
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    otp: (context) => const OtpScreen(),
    signupSuccess: (context) => const SignupSuccessScreen(),
    // الرئيسية تفتح داخل الهيكل اللي فيه شريط التنقل السفلي
    explore: (context) => const MainShell(),
    // لوحة تحكم الأدمن (بدون شريط التنقل السفلي)
    admin: (context) => const AdminDashboardScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
  };
}