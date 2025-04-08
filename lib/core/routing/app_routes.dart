import 'package:engaz_app/features/auth/login/view/login_screen.dart';
import 'package:flutter/material.dart';
import '../../features/splash/view/splash_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/': (context) => const SplashScreen(),
    '/login': (context) => const LoginScreen(),
  };
}