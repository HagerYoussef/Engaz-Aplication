import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/translation_request_viewmodel.dart';

class MultiSelectLanguageDropdown extends StatelessWidget {
  const MultiSelectLanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TranslationRequestViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اللغات المراد الترجمة إليها',
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
              hint: Text(
                viewModel.selectedTargetLanguages.isEmpty ? 'اختر' : '',
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: viewModel.availableLanguages
                  .where((lang) =>
              !viewModel.selectedTargetLanguages.contains(lang))
                  .map((lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  viewModel.addTargetLanguage(value);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: viewModel.selectedTargetLanguages.map((language) {
            return Container(
              width: 155,
              height: 36,
              padding: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language, style: const TextStyle(fontSize: 9)),
                  GestureDetector(
                    onTap: () {
                      viewModel.removeTargetLanguage(language);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 1.5),
                      ),
                      child: const Icon(Icons.close, size: 16, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
