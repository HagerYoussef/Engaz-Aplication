import 'dart:async';
import 'package:engaz_app/features/home_screen/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/otp_services.dart';

enum OtpStatus {
  idle,
  loading,
  success,
  failure,
}

class OtpViewModel extends ChangeNotifier {
  int minutes = 0;
  int seconds = 0;
  Timer? _timer;
  final int maxMinutes = 2;
  String? userId;
  String? code;

  OtpStatus _status = OtpStatus.idle;
  String? _errorMessage;
  String _message = '';
  List<String> otpValues = List.generate(4, (_) => '');

  OtpStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get message => _message;
  bool get isLoading => _status == OtpStatus.loading;

  final OtpService _otpService = OtpService();

  // Function to verify the OTP
  Future<void> verifyOtp(BuildContext context) async {
    String otpCode = otpValues.join('');
    print("codeotp: $otpCode");


    if (otpCode.length != 4) {
      print("يرجى إدخال رمز التفعيل");
      return;
    }

    _setStatus(OtpStatus.loading);

    try {
      final response = await _otpService.verifyOtp(code: otpCode);

      if (response.success) {
        _message = "تم التحقق من رمز التفعيل بنجاح";
        _setStatus(OtpStatus.success);


        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('token', response.token);
        });

      print('token${response.token}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        _setError(response.message.isNotEmpty ? response.message : "رمز التفعيل غير صحيح أو منتهي");
      }
    } catch (e) {
      _setError("حدث خطأ أثناء الاتصال بالسيرفر");
    }
  }


  void _setStatus(OtpStatus status) {
    _status = status;
    notifyListeners();
  }


  void _setError(String message) {
    _errorMessage = message;
    _message = message;
    _setStatus(OtpStatus.failure);
    print("Error: $message");
  }


  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (minutes == maxMinutes && seconds == 59) {
        _timer?.cancel();
      } else if (seconds == 59) {
        minutes++;
        seconds = 0;
      } else {
        seconds++;
      }
      notifyListeners();
    });
  }


  void resetTimer() {
    _timer?.cancel();
    minutes = 0;
    seconds = 0;
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
