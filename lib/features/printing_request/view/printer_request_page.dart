import 'package:engaz_app/features/printing_request/viewmodel/printer_request_viewmodel.dart';
import 'package:engaz_app/features/printing_request/widgets/dropdown_widget.dart';
import 'package:engaz_app/features/printing_request/widgets/selected_files_list.dart';
import 'package:engaz_app/features/printing_request/widgets/submit_button.dart';
import 'package:engaz_app/features/printing_request/widgets/summary_card.dart';
import 'package:engaz_app/features/printing_request/widgets/text_field_widget.dart';
import 'package:engaz_app/features/printing_request/widgets/upload_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PrinterRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrinterRequestViewModel(),
      child: Consumer<PrinterRequestViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: const Color(0xffF8F8F8),
            appBar: AppBar(
              leading: const Icon(Icons.arrow_back_ios),
              title: const Text('طلب طباعه', style: TextStyle(color: Colors.black)),
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
                    Center(child: Image.asset('assets/images/img56.png', height: 100)),
                    const SizedBox(height: 16),
                    const Text('طلب طباعه جديد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('الرجاء ارفاق الملفات المراد طباعتها', style: TextStyle(fontSize: 14, color: Color(0xffB3B3B3))),
                    const SizedBox(height: 8),
                    UploadButton(onPressed: viewModel.pickFile),
                    const SizedBox(height: 8),
                    SelectedFilesList(selectedFiles: viewModel.selectedFiles),
                    const SizedBox(height: 16),
                    DropdownWidget(
                      label: 'اختر لون الطباعة',
                      options: viewModel.availableLanguages,
                      selectedValue: viewModel.selectedLanguage,
                      onChanged: viewModel.selectLanguage,
                    ),
                    DropdownWidget(
                      label: 'اختر نوع التغليف',
                      options: viewModel.availableLanguages2,
                      selectedValue: viewModel.selectedLanguage2,
                      onChanged: viewModel.selectLanguage2,
                    ),
                    const SizedBox(height: 16),
                    TextFieldWidget(controller: viewModel.pagesController, label: 'عدد الصفحات'),
                    TextFieldWidget(controller: viewModel.copiesController, label: 'عدد النسخ'),
                    const SizedBox(height: 16),
                    SummaryCard(
                      selectedLanguage: viewModel.selectedLanguage,
                      selectedLanguage2: viewModel.selectedLanguage2,
                      pages: viewModel.pagesController.text,
                      copies: viewModel.copiesController.text,
                      selectedFiles: viewModel.selectedFiles,
                    ),
                    const SizedBox(height: 16),
                    const Text('الملاحظات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextFieldWidget(controller: viewModel.notesController, label: 'ادخل الملاحظات الخاصة بك ان وجدت'),
                    const SizedBox(height: 16),
                    SubmitButton(onPressed: viewModel.submitForm),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
