import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;          // نسخة بالذاكرة
  bool _tokenLoaded = false;

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
    _token = token;
    _tokenLoaded = true;
  }

  Future<String?> getToken() async {
    if (_tokenLoaded) return _token;      // بدون قراءة من التخزين الآمن
    _token = await _storage.read(key: 'token');
    _tokenLoaded = true;
    return _token;
  }

  Future<void> saveUser(String userJson) async {
    await _storage.write(key: 'user', value: userJson);
  }

  Future<String?> getUser() async {
    return await _storage.read(key: 'user');
  }

  Future<void> clear() async {
    await _storage.deleteAll();
    _token = null;
    _tokenLoaded = true;
  }
}