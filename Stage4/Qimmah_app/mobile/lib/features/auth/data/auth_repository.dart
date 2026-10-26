import 'dart:convert';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../models/user.dart';

// يكلم الباك اند في كل شي يخص الحساب
class AuthRepository {
  final ApiClient api;
  final TokenStorage storage;

  AuthRepository(this.api, this.storage);

  // 1) إنشاء حساب ← السيرفر يرسل الرمز للإيميل
  Future<void> register(String name, String email, String password) async {
    await api.post(ApiEndpoints.register, {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  // 2) التحقق من الرمز ← is_verified يصير true ويرجع توكن
  Future<User> verifyEmail(String email, String code) async {
    final data = await api.post(ApiEndpoints.verifyEmail, {
      'email': email,
      'code': code,
    });
    return _saveLogin(data);
  }

  // 3) إعادة إرسال الرمز
  Future<void> resendCode(String email) async {
    await api.post(ApiEndpoints.resendCode, {'email': email});
  }

  // 4) تسجيل الدخول
  Future<User> login(String email, String password) async {
    final data = await api.post(ApiEndpoints.login, {
      'email': email,
      'password': password,
    });
    return _saveLogin(data);
  }

  // نجيب المستخدم المحفوظ (لو سجل دخول قبل)
  Future<User?> getSavedUser() async {
    final token = await storage.getToken();
    final userJson = await storage.getUser();
    if (token == null || userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  Future<void> logout() async {
    await storage.clear();
  }

  // الرد شكله: { "token": "...", "user": {...} }
  Future<User> _saveLogin(Map<String, dynamic> data) async {
    final user = User.fromJson(data['user']);
    await storage.saveToken(data['token']);
    await storage.saveUser(jsonEncode(user.toJson()));
    return user;
  }
}
