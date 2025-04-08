import 'dart:async';
import 'package:flutter/material.dart';

class OtpViewModel extends ChangeNotifier {
  int minutes = 0;
  int seconds = 0;
  Timer? _timer;
  final int maxMinutes = 2;

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