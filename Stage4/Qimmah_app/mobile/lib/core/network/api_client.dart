import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_endpoints.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';
import '../../l10n/l10n.dart';

class ApiClient {
  final TokenStorage tokenStorage;
  final http.Client _client = http.Client(); // اتصال واحد يُعاد استخدامه
  static const Duration _timeout = Duration(seconds: 20);

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
      _send(() async => _client.get(_uri(path), headers: await _headers()));

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) =>
      _send(() async => _client.post(_uri(path),
          headers: await _headers(), body: jsonEncode(body)));

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) =>
      _send(() async => _client.put(_uri(path),
          headers: await _headers(), body: jsonEncode(body)));

  Future<Map<String, dynamic>> patch(String path,
          [Map<String, dynamic>? body]) =>
      _send(() async => _client.patch(_uri(path),
          headers: await _headers(), body: jsonEncode(body ?? {})));

  Future<Map<String, dynamic>> delete(String path) =>
      _send(() async => _client.delete(_uri(path), headers: await _headers()));

  // كل الطلبات تمر من هنا: نفس التايم أوت ونفس معالجة الخطأ
  Future<Map<String, dynamic>> _send(
      Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(_timeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('انتهت مهلة الاتصال، حاول مرة ثانية', 408);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> data = {};
    if (response.body.isNotEmpty) {
      data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw ApiException(
      data['error']?.toString() ?? 'صار خطأ، حاول مرة ثانية',
      response.statusCode,
    );
  }
}