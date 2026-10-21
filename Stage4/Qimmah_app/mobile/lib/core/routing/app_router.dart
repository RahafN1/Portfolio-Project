import 'package:flutter/material.dart';

import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/otp_screen.dart';
import '../../features/auth/views/signup_screen.dart';
import '../../features/splash/views/splash_screen.dart';
import '../../features/trails/views/explore_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String signupSuccess = '/signup-success';
  static const String explore = '/explore';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    otp: (context) => const OtpScreen(),
    signupSuccess: (context) => const SignupSuccessScreen(),
    explore: (context) => const ExploreScreen(),
  };
}
