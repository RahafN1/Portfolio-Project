import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// نحفظ التوكن وبيانات المستخدم على الجهاز بشكل آمن
class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> saveUser(String userJson) async {
    await _storage.write(key: 'user', value: userJson);
  }

  Future<String?> getUser() async {
    return await _storage.read(key: 'user');
  }

  // تسجيل الخروج = نمسح كل شي
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
