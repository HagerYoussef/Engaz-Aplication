import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class PrinterRequestViewModel extends ChangeNotifier {
  final List<String> availableLanguages = ['الوان', 'ابيض واسود'];
  final List<String> availableLanguages2 = ['مجلد', '..'];

  String? selectedLanguage;
  String? selectedLanguage2;
  String? selectedDelivery;

  final TextEditingController pagesController = TextEditingController();
  final TextEditingController copiesController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  List<PlatformFile> selectedFiles = [];

  void selectLanguage(String? value) {
    selectedLanguage = value;
    notifyListeners();
  }

  void selectLanguage2(String? value) {
    selectedLanguage2 = value;
    notifyListeners();
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        selectedFiles.add(result.files.first);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  void submitForm() {
    if (canSubmit()) {
      // Navigate to next screen
    } else {
      // Show an error message
    }
  }

  bool canSubmit() {
    return selectedLanguage != null && selectedFiles.isNotEmpty;
  }
}
