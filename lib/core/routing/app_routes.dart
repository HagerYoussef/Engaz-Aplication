import 'package:engaz_app/features/auth/login/view/login_screen.dart';
import 'package:flutter/material.dart';
import '../../features/auth/register/view/register_screen.dart';
import '../../features/contact_us/contactus_screen.dart';
import '../../features/delete_account/delete_account_screen.dart';
import '../../features/edit_profile/edit_profile_screen.dart';
import '../../features/home_screen/view/home_view.dart';
import '../../features/language/language_screen.dart';
import '../../features/order_details/order_details_page.dart';
import '../../features/printing_with_api/print.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../main.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/': (context) => const SplashScreen(),
    '/login': (context) => const LoginScreen(),
    '/translate': (context) => TranslationOrderApp(),
    '/print': (context) => PrinterRequestPageWithApi(),
    '/home': (context) => HomePage(),
    '/profile': (context) => EditProfileScreen(),
    '/settings': (context) => const SettingsScreen(),
    '/contact': (context) => const ContactUsScreen(),
    '/order-details': (context) => OrderDetailsPage(orderNumber: '1',),
    '/register': (context) => const RegisterScreen(),
    '/language': (context) => const LanguageScreen(),
    '/delete-account': (context) => const DeleteAccountScreen(),
  };
}