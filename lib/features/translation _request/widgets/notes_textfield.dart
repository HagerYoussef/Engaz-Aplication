import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/translation_request_viewmodel.dart';

class NotesTextField extends StatelessWidget {
  const NotesTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TranslationRequestViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الملاحظات',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: 343,
          height: 109,
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            maxLines: 3,
            controller: TextEditingController(text: viewModel.notes)
              ..selection = TextSelection.collapsed(offset: viewModel.notes.length),
            onChanged: viewModel.setNotes,
            decoration: const InputDecoration(
              hintText: 'ادخل الملاحظات الخاصة بك إن وجدت',
              hintStyle: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFFB3B3B3),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
