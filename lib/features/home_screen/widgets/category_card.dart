import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/change_lang.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final Widget destinationPage;

  const CategoryCard({super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.destinationPage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff409EDC),
                      fontFamily: 'IBM_Plex_Sans_Arabic',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                      fontFamily: 'IBM_Plex_Sans_Arabic',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 152,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => destinationPage,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                              color: Color(0xff409EDC), width: 1),
                        ),
                      ),
                      child:  Text(
                          Translations.getText(
                            'req2',
                            context.read<LocalizationProvider>().locale.languageCode,
                          ),
                        style: TextStyle(
                            color: Color(0xff0409EDC),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Image.asset(image, width: 123, height: 123),
          ],
        ),
      ),
    );
  }
}
