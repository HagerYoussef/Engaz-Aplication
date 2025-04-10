import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const TextFieldWidget({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 109,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
      decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 5,
            child: Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFFB3B3B3))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}
