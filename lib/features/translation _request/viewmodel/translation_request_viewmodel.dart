import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class TranslationRequestViewModel extends ChangeNotifier {
  final List<String> availableLanguages = [
    'إنجليزي(5 دينار /100 كلمة)',
    'فرنسي(5 دينار /100 كلمة) ',
    'اسباني(5 دينار /100 كلمة)',
    'الماني(5 دينار /100 كلمة)',
    'ايطالي(5 دينار /100 كلمة)',
    'صيني(5 دينار /100 كلمة)'
  ];

  final List<PlatformFile> selectedFiles = [];
  final List<String> selectedLanguages = [];

  String? selectedLanguage;
  String deliveryOption = '';
  List<String> selectedTargetLanguages = [];
  String notes = '';

  // إضافة controller للملاحظات
  TextEditingController notesController = TextEditingController();

  void setNotes(String value) {
    notes = value;
    notifyListeners();
  }

  void addTargetLanguage(String language) {
    if (!selectedTargetLanguages.contains(language)) {
      selectedTargetLanguages.add(language);
      notifyListeners();
    }
  }

  void removeTargetLanguage(String language) {
    selectedTargetLanguages.remove(language);
    notifyListeners();
  }

  void selectLanguage(String? language) {
    if (language != null) {
      selectedLanguage = language;
      selectedLanguages.remove(language);
      selectedLanguages.insert(0, language);
      notifyListeners();
    }
  }

  void addLanguage(String language) {
    if (!selectedLanguages.contains(language)) {
      selectedLanguages.add(language);
      notifyListeners();
    }
  }

  void removeLanguage(String language) {
    selectedLanguages.remove(language);
    notifyListeners();
  }

  void updateNotes(String value) {
    notes = value;
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

  void removeFile(PlatformFile file) {
    selectedFiles.remove(file);
    notifyListeners();
  }

  String getFileIconPath(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'assets/images/img10.png';
      case 'doc':
      case 'docx':
        return 'assets/images/img12.png';
      case 'xls':
      case 'xlsx':
        return 'assets/images/img11.png';
      default:
        return 'assets/file.png';
    }
  }

  void openFile(String? path) {
    OpenFile.open(path);
  }

  bool canSubmit() {
    return selectedLanguage != null &&
        selectedLanguages.isNotEmpty &&
        selectedFiles.isNotEmpty;
  }

  void addSelectedLanguage(String language) {
    if (!selectedLanguages.contains(language)) {
      selectedLanguages.add(language);
      notifyListeners();
    }
  }
}
