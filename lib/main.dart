import 'package:engaz_app/features/auth/login/viewmodel/login_viewmodel.dart';
import 'package:engaz_app/features/splash/viewmodel/splash_viewmodel.dart';
import 'package:engaz_app/features/translation%20_request/view/translation_request_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routing/app_routes.dart';
import 'features/address/view/address.dart';
import 'features/auth/forgetPassword/view/otp_screen.dart';
import 'features/orders/orders_screen.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SplashViewModel()),
            ChangeNotifierProvider(create: (_) => LoginViewModel()),

          ],
      child : MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      //initialRoute: '/',
      home:OrdersScreen()
      //routes: AppRoutes.routes,
    );
  }
}