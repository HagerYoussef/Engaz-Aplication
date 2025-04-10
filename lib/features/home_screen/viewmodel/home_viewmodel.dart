import 'package:flutter/material.dart';
import '../view/home_content.dart';

class HomeViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomeContent(),
    const Placeholder(fallbackHeight: 200), // OrdersScreen(),
    const Placeholder(fallbackHeight: 200), // SettingsScreen(),
  ];

  void changeTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}