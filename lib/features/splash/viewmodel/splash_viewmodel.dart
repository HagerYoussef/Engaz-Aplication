import 'package:engaz_app/features/auth/login/view/login_screen.dart';
import 'package:flutter/material.dart';
class SplashViewModel extends ChangeNotifier {
  Future<void> handleStartup(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
  }
}
