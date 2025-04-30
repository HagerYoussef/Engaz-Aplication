
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/change_lang.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> deleteUser(String userId) async {
    final url = Uri.parse('http://localhost:3000/api/user/$userId/delete');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف الحساب بنجاح')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الحذف: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في الاتصال: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final userId = snapshot.data!;
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
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/img23.png"),
                )
              ],
              title:  Text(Translations.getText(
                  'del',
                  context
                      .read<LocalizationProvider>()
                      .locale
                      .languageCode),),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Image.asset("assets/images/img24.png"),
                  const SizedBox(height: 12),
                   Text(
                      Translations.getText(
                          'do',
                          context
                              .read<LocalizationProvider>()
                              .locale
                              .languageCode),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                   Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        Translations.getText(
                            're',
                            context
                                .read<LocalizationProvider>()
                                .locale
                                .languageCode),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Container(
                      width: 343,
                      height: 106,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Color(0xFFF2F2F2),
                          width: 1,
                        ),
                      ),
                      child:  TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: Translations.getText(
                              'pl',
                              context
                                  .read<LocalizationProvider>()
                                  .locale
                                  .languageCode),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const Spacer(),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff409EDC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          child:  Text(
                              Translations.getText(
                                  'tra',
                                  context
                                      .read<LocalizationProvider>()
                                      .locale
                                      .languageCode),
                            style:
                            TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 164,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            deleteUser(userId);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xFFE50930), width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          child:  Text(
                              Translations.getText(
                                  'del2',
                                  context
                                      .read<LocalizationProvider>()
                                      .locale
                                      .languageCode),
                            style: TextStyle(
                              color: Color(0xFFE50930),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  });
}}