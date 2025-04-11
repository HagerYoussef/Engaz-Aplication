import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginService {
  static const String baseUrl = "https://wckb4f4m-3000.euw.devtunnels.ms/api";

  Future<Map<String, dynamic>> login({required String method, required String id}) async {
    final url = Uri.parse("$baseUrl/login-account");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"method": method, "id": id}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
          'userId': data['userId'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'User not found',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'تعذر الاتصال بالخادم',
      };
    }
  }
}
