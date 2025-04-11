import 'package:flutter/material.dart';

import '../../register/model/register_model.dart';
import '../../register/services/register_services.dart';
import '../services/login_services.dart';

enum LoginState { idle, loading, success, failure }
enum RegisterState { idle, loading, success, failure }

class LoginViewModel extends ChangeNotifier {
  bool isPhoneSelected = true;
  String userInput = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  String email = '';

  LoginState loginState = LoginState.idle;
  String errorMessage = '';
  RegisterState registerState = RegisterState.idle;
  String? registerErrorMessage;

  Future<Map<String, dynamic>> loginUser() async {
    loginState = LoginState.loading;
    notifyListeners();

    LoginService loginService = LoginService();
    String method = isPhoneSelected ? 'PHONE' : 'EMAIL';
    final result = await loginService.login(method: method, id: userInput);

    if (result['success']) {
      loginState = LoginState.success;
    } else {
      loginState = LoginState.failure;
      errorMessage = result['message'];
    }

    notifyListeners();
    return result;
  }
  Future<Map<String, dynamic>> registerUser(BuildContext context) async {
    registerState = RegisterState.loading;
    notifyListeners();

    final signupService = SignUpService();

    final signUpModel = SignUpModel(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      countryCode: '+20',
    );

    final result = await signupService.signUp(context, signUpModel);

    if (result['success']) {
      registerState = RegisterState.success;
    } else {
      registerState = RegisterState.failure;
      registerErrorMessage = result['message'];
    }

    notifyListeners();
    return result;
  }

  void toggleLoginMethod() {
    isPhoneSelected = !isPhoneSelected;
    userInput = '';
    notifyListeners();
  }

  void setUserInput(String value) {
    userInput = value;
    notifyListeners();
  }

  void setFirstName(String value) {
    firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    lastName = value;
    notifyListeners();
  }

  void setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void resetLoginState() {
    loginState = LoginState.idle;
    notifyListeners();
  }
}
