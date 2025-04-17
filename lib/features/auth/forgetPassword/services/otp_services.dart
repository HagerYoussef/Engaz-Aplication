import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/otp_response.dart';

class OtpService {
  Future<OtpResponse> verifyOtp({
    required String code,
  }) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId'); // المفروض او ال user

    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }

    final url =
        'https://wckb4f4m-3000.euw.devtunnels.ms/api/login-account/$userId/code';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'code': code}),
    );

    final data = json.decode(response.body);
    return OtpResponse.fromJson(data);
  }
}
class OtpResponse {
  final bool success;
  final String message;
  final String token;

  OtpResponse({
    required this.success,
    required this.message,
    required this.token,
  });

  // Factory method to create OtpResponse from JSON
  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '', // Ensure token is correctly parsed
    );
  }
}
