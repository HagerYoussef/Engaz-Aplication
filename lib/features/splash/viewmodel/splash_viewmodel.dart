import 'package:flutter/material.dart';
class SplashViewModel extends ChangeNotifier {
  Future<void> handleStartup(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
