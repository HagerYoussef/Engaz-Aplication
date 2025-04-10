import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final String? selectedLanguage;
  final ValueChanged<String?> onChanged;

  const LanguageDropdown({
    Key? key,
    required this.selectedLanguage,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اللغة المراد ترجمتها', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          width: 343,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text(selectedLanguage ?? 'اختر'),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: const [
                'إنجليزي(5 دينار /100 كلمة)',
                'فرنسي(5 دينار /100 كلمة)',
                'اسباني(5 دينار /100 كلمة)',
              ]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
