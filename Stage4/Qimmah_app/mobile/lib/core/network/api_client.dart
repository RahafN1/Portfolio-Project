import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_endpoints.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

// هنا كل الطلبات اللي تروح للباك اند
class ApiClient {
  final TokenStorage tokenStorage;

  ApiClient(this.tokenStorage);

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.baseUrl + path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> get(String path) async {
    final token = await tokenStorage.getToken();
    final response = await http.get(
      Uri.parse(ApiEndpoints.baseUrl + path),
      headers: {
        'Content-Type': 'application/json',
        // إذا مسجل دخول نرسل التوكن، الضيف ما عنده توكن
        if (token != null) 'Authorization': 'Bearer $token',
      },
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
