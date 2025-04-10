import 'package:engaz_app/features/translation%20_request/viewmodel/translation_request_viewmodel.dart';
import 'package:engaz_app/features/translation%20_request/widgets/notes_textfeild.dart';
import 'package:engaz_app/features/translation%20_request/widgets/upload_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TranslationRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TranslationRequestViewModel(),
      child: Consumer<TranslationRequestViewModel>(
        builder: (context, viewModel, child) {
          return Directionality(
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset('assets/images/img5.png', height: 100),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'طلب ترجمة جديد',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Center(
                        child: Text(
                          'الرجاء اختيار اللغة المراد ترجمتها',
                          style: TextStyle(fontSize: 14, color: Color(0xffB3B3B3)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown('اللغة المراد ترجمتها', viewModel),
                      _buildMultiSelectDropdown('اللغات المراد الترجمة إليها', viewModel),
                      _buildRadioSelection(),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const SavedAddress()),
                          // );
                        },
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset("assets/images/img51.png")),
                      ),
                      const Text(
                        'الملاحظات',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      NotesTextField(controller: viewModel.notesController),
                      const SizedBox(height: 16),
                      const Text(
                        'المرفقات المراد ترجمتها',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      UploadButtonTranslation(
                        onPressed: viewModel.pickFile,  // استدعاء دالة pickFile من ViewModel
                      ),
                      const SizedBox(height: 8),
                      _buildSelectedFilesList(viewModel),
                      const SizedBox(height: 16),
                      _buildSubmitButton(viewModel, context),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton(TranslationRequestViewModel viewModel, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          if (viewModel.canSubmit()) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => OrderDetailsPage()),
            // );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("يرجى تعبئة جميع الحقول")),
            );
          }
        },
        child: const Text('إرسال الطلب', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildDropdown(String label, TranslationRequestViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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

  Widget _buildMultiSelectDropdown(String label, TranslationRequestViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              hint: Text(viewModel.selectedLanguages.isEmpty ? 'اختر' : ''),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: viewModel.availableLanguages
                  .where((lang) => !viewModel.selectedLanguages.contains(lang))
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  viewModel.addLanguage(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //children: [DeliveryOptions()],
    );
  }

  Widget _buildSelectedFilesList(TranslationRequestViewModel viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: viewModel.selectedFiles.map((file) {
          String extension = file.extension ?? "";
          String iconPath = viewModel.getFileIconPath(extension);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {
                  viewModel.openFile(file.path);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(iconPath, width: 60, height: 60),
                ),
              ),
              Positioned(
                top: -5,
                left: -5,
                child: GestureDetector(
                  onTap: () {
                    viewModel.removeFile(file);
                  },
                  child: Container(
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
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
