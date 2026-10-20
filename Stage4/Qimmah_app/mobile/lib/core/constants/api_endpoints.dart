class ApiEndpoints {
  // رابط الباك اند
  // محاكي أندرويد: http://10.0.2.2:5000
  // كروم أو iOS: http://localhost:5000
  static const String baseUrl = 'http://10.0.2.2:5000';

  static const String register = '/api/auth/register';
  static const String verifyEmail = '/api/auth/verify-email';
  static const String resendCode = '/api/auth/resend-code';
  static const String login = '/api/auth/login';

  static const String trails = '/api/trails';
}
