import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../constants/api_endpoints.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';
import '../../l10n/l10n.dart';

class ApiClient {
  final TokenStorage tokenStorage;
  final http.Client _client = http.Client(); // اتصال واحد يُعاد استخدامه
  static const Duration _timeout = Duration(seconds: 20);
  static const Duration _uploadTimeout = Duration(seconds: 60);

  // مسارات الدخول/التسجيل: 401 فيها يعني بيانات غلط مو جلسة منتهية
  static const List<String> _authPaths = ['login', 'register', 'signin'];

  // تنادى لما تنتهي الجلسة (التطبيق يرجّع المستخدم لتسجيل الدخول)
  void Function()? onSessionExpired;

  // آخر توكن اعتبرناه منتهي. لو جاء طلب بنفس التوكن ما نبلّغ مرة ثانية،
  // وأي تسجيل دخول جديد يعطي توكن مختلف فيشتغل التنبيه من جديد
  String? _expiredAuth;

  ApiClient(this.tokenStorage);

  Future<Map<String, String>> _headers() async {
    final token = await tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String path) {
    final uri = Uri.parse(ApiEndpoints.baseUrl + path);
    return uri.replace(queryParameters: {
      ...uri.queryParameters,
      'lang': L10n.languageCode,
    });
  }

  Future<Map<String, dynamic>> get(String path) =>
      _send(path, (h) => _client.get(_uri(path), headers: h));

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) =>
      _send(path,
          (h) => _client.post(_uri(path), headers: h, body: jsonEncode(body)));

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) =>
      _send(path,
          (h) => _client.put(_uri(path), headers: h, body: jsonEncode(body)));

  Future<Map<String, dynamic>> patch(String path,
          [Map<String, dynamic>? body]) =>
      _send(
          path,
          (h) => _client.patch(_uri(path),
              headers: h, body: jsonEncode(body ?? {})));

  Future<Map<String, dynamic>> delete(String path) =>
      _send(path, (h) => _client.delete(_uri(path), headers: h));

  // كل الطلبات تمر من هنا: نفس التايم أوت ونفس معالجة الخطأ
  Future<Map<String, dynamic>> _send(
    String path,
    Future<http.Response> Function(Map<String, String> headers) request,
  ) async {
    // نقرأ الهيدر مرة وحدة، ونعرف منه هل الطلب انرسل بتوكن
    final headers = await _headers();
    try {
      final response = await request(headers).timeout(_timeout);
      return await _handleResponse(
        response,
        path: path,
        auth: headers['Authorization'],
      );
    } on TimeoutException {
      throw ApiException(L10n.tr.coreRequestTimeout, 408);
    }
  }

  // لرفع الصور
  Future<Map<String, dynamic>> postFiles(
    String path,
    String fieldName,
    List<Uint8List> files,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiEndpoints.baseUrl + path),
    );

    final token = await tokenStorage.getToken();
    final auth = token != null ? 'Bearer $token' : null;
    if (auth != null) {
      request.headers['Authorization'] = auth;
    }

    for (int i = 0; i < files.length; i++) {
      request.files.add(http.MultipartFile.fromBytes(
        fieldName,
        files[i],
        filename: 'image_$i.jpg',
      ));
    }

    try {
      final streamed = await request.send().timeout(_uploadTimeout);
      final response =
          await http.Response.fromStream(streamed).timeout(_uploadTimeout);
      return await _handleResponse(response, path: path, auth: auth);
    } on TimeoutException {
      throw ApiException(L10n.tr.coreRequestTimeout, 408);
    }
  }

  // نمسح التوكن ونبلّغ التطبيق مرة وحدة لكل توكن
  Future<void> _handleExpired(String auth) async {
    if (_expiredAuth == auth) return;
    _expiredAuth = auth;
    await tokenStorage.clear(); // ننتظر المسح قبل ما نبلّغ التطبيق
    onSessionExpired?.call();
  }

  Future<Map<String, dynamic>> _handleResponse(
    http.Response response, {
    required String path,
    required String? auth,
  }) async {
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

    // السيرفر ممكن يرجّع HTML (مثل 502) فنحمي الـ jsonDecode
    Map<String, dynamic> data = {};
    if (response.body.isNotEmpty) {
      try {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is Map<String, dynamic>) data = decoded;
      } catch (_) {
        if (isSuccess) {
          throw ApiException(L10n.tr.coreGenericError, response.statusCode);
        }
        // لو كان خطأ، نكمل بـ data فاضية ونعرض الرسالة العامة
      }
    }

    if (isSuccess) return data;

    final message = data['error']?.toString() ?? L10n.tr.coreGenericError;

    // انتهت الجلسة: الطلب كان معه توكن، وهو مو طلب دخول/تسجيل،
    // والسيرفر رجّع 401 أو رسالة فيها expired
    final isAuthRequest = _authPaths.any((p) => path.contains(p));
    final looksExpired = response.statusCode == 401 ||
        message.toLowerCase().contains('expired');
    if (auth != null && !isAuthRequest && looksExpired) {
      await _handleExpired(auth);
    }

    throw ApiException(message, response.statusCode);
  }
}