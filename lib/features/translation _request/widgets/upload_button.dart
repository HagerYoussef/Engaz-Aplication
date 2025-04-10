import 'package:flutter/material.dart';

class UploadButtonTranslation extends StatelessWidget {
  final VoidCallback onPressed;

  const UploadButtonTranslation({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2), // اللون الخلفي
        borderRadius: BorderRadius.circular(16), // الحدود الدائرية
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "الرجاء إضافة المرفقات المراد ترجمتها",
            style: TextStyle(
              fontSize: 14, // حجم الخط
              color: Color(0xffB3B3B3), // اللون الرمادي
            ),
          ),
          IconButton(
            onPressed: onPressed, // عند الضغط على الزر، يتم تنفيذ onPressed
            icon: Image.asset("assets/images/img18.png"), // أيقونة الملف
          ),
        ],
      ),
    );
  }
}
