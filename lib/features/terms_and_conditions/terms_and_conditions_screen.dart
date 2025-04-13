import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('الشروط والأحكام'),
          leading: const Icon(Icons.arrow_back_ios),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Center(child: Image.asset('assets/images/img1.png', height: 80)),
              const SizedBox(height: 16),
              Container(
                width: 346,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const SingleChildScrollView(
                  child: Text(
                    'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة '
                        'هذا النص هو نص بديل يمكن ان يستبدل بنص اخر في نفس المساحة ',
                    style: TextStyle(
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
  }
}