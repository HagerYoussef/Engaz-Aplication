import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/translation_request_viewmodel.dart';

class NotesField extends StatelessWidget {
  const NotesField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationRequestViewModel>(
      builder: (context, viewModel, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الملاحظات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBM_Plex_Sans_Arabic',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 109,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextFormField(
                maxLines: 4,
                initialValue: viewModel.notes,
                onChanged: viewModel.updateNotes,
                style: const TextStyle(
                  fontFamily: 'IBM_Plex_Sans_Arabic',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: 'ادخل الملاحظات الخاصة بك ان وجدت',
                  hintStyle: TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
