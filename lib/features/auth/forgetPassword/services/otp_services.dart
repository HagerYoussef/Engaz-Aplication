import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/otp_response.dart';

class OtpService {
  Future<OtpResponse> verifyOtp({
    required String userId,
    required String code,
  }) async {
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
