import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/localization/change_lang.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  String _termsText = '';
  bool _isLoading = true;

  Future<void> fetchTerms(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse(
        'https://wckb4f4m-3000.euw.devtunnels.ms/api/dashboard/terms/conditions');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = langCode == 'ar'
            ? data['terms']['ArabicTerms']
            : data['terms']['EnglishTerms'];

        setState(() {
          _termsText = text;
          _isLoading = false;
        });
      } else {
        setState(() {
          _termsText = 'فشل تحميل الشروط والأحكام';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _termsText = 'حدث خطأ أثناء الاتصال بالسيرفر';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final lang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    fetchTerms(lang);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        final locale = localizationProvider.locale.languageCode;
        final textDirection =
        locale == 'ar' ? TextDirection.rtl : TextDirection.ltr;

        return Directionality(
          textDirection: textDirection,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(Translations.getText(
                'term',
                context.read<LocalizationProvider>().locale.languageCode,
              )),
              leading: const Icon(Icons.arrow_back_ios),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                      child:
                      Image.asset('assets/images/img1.png', height: 80)),
                  const SizedBox(height: 16),
                  Container(
                    width: 346,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                      child: Text(
                        _termsText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1D1D1D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}