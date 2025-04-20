import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../localization/change_lang.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String privacyText = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPrivacy();
  }

  Future<void> fetchPrivacy() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/dashboard/terms/privacy'),
      );

      if (response.statusCode == 200||response.statusCode == 201) {
        final data = json.decode(response.body);
        final locale = context.read<LocalizationProvider>().locale.languageCode;
        setState(() {
          privacyText = locale == 'ar'
              ? data['privacy']['ArabicPrivacy']
              : data['privacy']['EnglishPrivacy'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load privacy text');
      }
    } catch (e) {
      setState(() {
        privacyText = 'خطأ في تحميل سياسة الخصوصية.';
        isLoading = false;
      });
    }
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
                  'pol',
                  context.read<LocalizationProvider>().locale.languageCode,
                )),
                leading: const Icon(Icons.arrow_back_ios),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Center(
                        child: Image.asset('assets/images/img1.png', height: 80)),
                    const SizedBox(height: 16),
                    Container(
                      width: 346,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                        child: Text(
                          privacyText,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1D1D1D),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}