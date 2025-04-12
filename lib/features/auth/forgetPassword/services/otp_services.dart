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
        'https://b762efea-73b1-4221-8420-90b4e7d17125-00-2mjbzkqtyqqef.janeway.replit.dev/api/login-account/$userId/code';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'code': code}),
    );

    final data = json.decode(response.body);
    return OtpResponse.fromJson(data);
  }
}
