// upload_file_section.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadButton extends StatelessWidget {
  final VoidCallback onPressed;

  const UploadButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "الرجاء إضافة المرفقات المراد طباعتها",
            style: TextStyle(fontSize: 14, color: Color(0xffB3B3B3)),
          ),
          IconButton(
            onPressed: onPressed,
            icon: Image.asset("assets/images/img18.png"),
          ),
        ],
      ),
    );
  }
}
