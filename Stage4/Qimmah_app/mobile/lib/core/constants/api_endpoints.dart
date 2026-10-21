class ApiEndpoints {
 // رابط الباك إند المحلي
  static const String baseUrl = 'http://localhost:5000/api/trails';

  static const String register = '/api/auth/register';
  static const String verifyEmail = '/api/auth/verify-email';
  static const String resendCode = '/api/auth/resend-code';
  static const String login = '/api/auth/login';

  static const String trails = '/api/trails';
}