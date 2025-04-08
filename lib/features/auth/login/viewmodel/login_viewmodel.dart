import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool isPhoneSelected = true;
  String userInput = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  String email = '';

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
}
