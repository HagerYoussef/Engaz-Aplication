import 'package:flutter/material.dart';

class NotesTextField extends StatelessWidget {
  final TextEditingController controller;

  const NotesTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 109,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2), // نفس اللون الذي تم تحديده في التصميم
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 5,
            child: Text(
              'ادخل الملاحظات الخاصة بك ان وجدت',
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.0,
                letterSpacing: 0,
                color: Color(0xFFB3B3B3), // نفس اللون
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
