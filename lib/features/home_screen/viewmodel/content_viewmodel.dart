import 'package:flutter/material.dart';
import '../../printing_request/view/printer_request_page.dart';
import '../../translation _request/view/translation_request_page.dart';

class ContentViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  final List<String> images = [
    'assets/images/img7.png',
    'assets/images/img7.png',
    'assets/images/img7.png',
  ];

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'الترجمة',
      'description': 'نقدم أفضل خدمات الترجمة لأكثر من 10 لغات حول العالم',
      'image': 'assets/images/img5.png',
      'page': TranslationRequestPage(),
    },
    {
      'title': 'الطباعة',
      'description': 'نقدم أفضل جودة للطباعة بأسعار تنافسية',
      'image': 'assets/images/img6.png',
      'page': PrinterRequestPage(),
    },
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
