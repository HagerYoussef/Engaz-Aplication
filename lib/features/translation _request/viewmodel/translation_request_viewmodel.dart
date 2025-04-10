import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class TranslationRequestViewModel extends ChangeNotifier {
  final List<String> availableLanguages = [
    'إنجليزي(5 دينار /100 كلمة)',
    'فرنسي(5 دينار /100 كلمة)',
    'اسباني(5 دينار /100 كلمة)',
    'الماني(5 دينار /100 كلمة)',
    'ايطالي(5 دينار /100 كلمة)',
    'صيني(5 دينار /100 كلمة)',
  ];

  final List<PlatformFile> selectedFiles = [];
  final List<String> selectedLanguages = [];

  String? selectedLanguage;
  String deliveryOption = ''; // استخدمها لاحقًا إذا عندك اختيارات توصيل
  List<String> selectedTargetLanguages = [];
  String notes = '';

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

  // تحديث اللغة الأساسية
  void selectLanguage(String? language) {
    if (language != null) {
      selectedLanguage = language;
      selectedLanguages.remove(language);
      selectedLanguages.insert(0, language);
      notifyListeners();
    }
  }

  // إضافة لغة من قائمة الترجمة
  void addLanguage(String language) {
    if (!selectedLanguages.contains(language)) {
      selectedLanguages.add(language);
      notifyListeners();
    }
  }

  // حذف لغة
  void removeLanguage(String language) {
    selectedLanguages.remove(language);
    notifyListeners();
  }

  // إضافة ملاحظات
  void updateNotes(String value) {
    notes = value;
    notifyListeners();
  }

  // إضافة ملف
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

  // إزالة ملف
  void removeFile(PlatformFile file) {
    selectedFiles.remove(file);
    notifyListeners();
  }

  // تحديد الأيقونة المناسبة حسب الامتداد
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

  void openFile(String path) {
    OpenFile.open(path);
  }


  // صلاحية الإرسال
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
