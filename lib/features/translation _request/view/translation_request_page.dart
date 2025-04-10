import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/translation_request_viewmodel.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/multi_select_dropdown.dart';
import '../widgets/upload_file_section.dart';
import '../widgets/notes_field.dart';
import '../widgets/selected_files_list.dart';
import '../widgets/submit_button.dart';

class TranslationRequestPage extends StatelessWidget {
  const TranslationRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TranslationRequestViewModel(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xffF8F8F8),
          appBar: AppBar(
            leading: const Icon(Icons.arrow_back_ios),
            title: const Text('طلب ترجمة', style: TextStyle(color: Colors.black)),
            backgroundColor: const Color(0xffF8F8F8),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                SizedBox(height: 12),
                LanguageDropdown(),
                SizedBox(height: 12),
                MultiSelectDropdown(),
                SizedBox(height: 12),
                UploadFileSection(),
                SizedBox(height: 12),
                NotesField(),
                SizedBox(height: 12),
                SelectedFilesList(),
                SizedBox(height: 20),
                SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
