import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_endpoints.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

// هنا كل الطلبات اللي تروح للباك اند
class ApiClient {
  final TokenStorage tokenStorage;

  ApiClient(this.tokenStorage);

  // الهيدرز: نرسل التوكن لو موجود (الضيف ما عنده توكن)
  Future<Map<String, String>> _headers() async {
    final token = await tokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.baseUrl + path),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> get(String path) async {
    final response = await http.get(
      Uri.parse(ApiEndpoints.baseUrl + path),
      headers: await _headers(),
    );
    return _handleResponse(response);
  }

  // لتعديل البيانات (مثل تعديل الحساب)
  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse(ApiEndpoints.baseUrl + path),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // للحذف (مثل حذف تقييم)
  Future<Map<String, dynamic>> delete(String path) async {
    final response = await http.delete(
      Uri.parse(ApiEndpoints.baseUrl + path),
      headers: await _headers(),
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> data = {};
    if (response.body.isNotEmpty) {
      // utf8.decode عشان النص العربي يطلع صح
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