import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/translation_request_viewmodel.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TranslationRequestViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اللغة المراد ترجمتها',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
              hint: Text(viewModel.selectedLanguage ?? 'اختر'),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: viewModel.availableLanguages
                  .map((lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang),
              ))
                  .toList(),
              onChanged: (value) {
                viewModel.selectLanguage(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
