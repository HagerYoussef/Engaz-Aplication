import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../localization/change_lang.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
              'contactus',
              context.read<LocalizationProvider>().locale.languageCode,
            )),
            leading: const Icon(Icons.arrow_back_ios),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Image.asset('assets/images/img1.png', height: 80)),
                const SizedBox(height: 16),
                Center(
                    child: Text(
                        Translations.getText(
                          'contactus',
                          context
                              .read<LocalizationProvider>()
                              .locale
                              .languageCode,
                        ),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
                const SizedBox(height: 8),
                 Center(
                    child: Text( Translations.getText(
                      'through',
                      context
                          .read<LocalizationProvider>()
                          .locale
                          .languageCode,
                    ),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xff676767)))),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/img55.png"),
                    const SizedBox(width: 8),
                    Image.asset("assets/images/img50.png"),
                    const SizedBox(width: 8),
                    Image.asset("assets/images/img49.png"),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                    child: Text(Translations.getText(
                  'or',
                  context.read<LocalizationProvider>().locale.languageCode,
                ))),
                const SizedBox(height: 16),
                Text(
                  Translations.getText(
                    'name',
                    context.read<LocalizationProvider>().locale.languageCode,
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  width: 343.24,
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Translations.getText(
                        'name2',
                        context
                            .read<LocalizationProvider>()
                            .locale
                            .languageCode,
                      ),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  Translations.getText(
                    'address2',
                    context.read<LocalizationProvider>().locale.languageCode,
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  width: 343.24,
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Translations.getText(
                        'plss',
                        context
                            .read<LocalizationProvider>()
                            .locale
                            .languageCode,
                      ),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  Translations.getText(
                    'msst',
                    context.read<LocalizationProvider>().locale.languageCode,
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  width: 343.24,
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: Translations.getText(
                        'ent',
                        context
                            .read<LocalizationProvider>()
                            .locale
                            .languageCode,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 343.24,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff409EDC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      Translations.getText(
                        's',
                        context
                            .read<LocalizationProvider>()
                            .locale
                            .languageCode,
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
