import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('تواصل معنا'),
          leading: const Icon(Icons.arrow_back_ios),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/images/img1.png', height: 80)),
              const SizedBox(height: 16),
              const Center(
                  child: Text('تواصل معنا',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
              const SizedBox(height: 8),
              const Center(
                  child: Text('من خلال :',
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
              const Center(child: Text('أو أرسل لنا رسالة :')),
              const SizedBox(height: 16),
              const Text(
                "الاسم",
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
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'ادخل الاسم فضلا',
                  ),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "عنوان الرساله",
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
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'الرجاء توضيح عنوان رسالتك',
                  ),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "نص الرساله",
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
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'ادخل نص الرساله',
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
                  child: const Text(
                    'إرسال',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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