import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'dart:async';
import '../../order_details/order_details_page.dart';
import '../../printing_request/widgets/upload_button.dart';
import '../../saved_order/view/saved_order.dart';
import '../viewmodel/translation_request_viewmodel.dart';
import '../widgets/delivery_options.dart';


class TranslationRequestPage extends StatefulWidget {
  TranslationRequestPage({super.key});

  @override
  _TranslationRequestPageState createState() => _TranslationRequestPageState();
}

class _TranslationRequestPageState extends State<TranslationRequestPage> {
  String? deliveryMethod;
  String? selectedAddress;
  bool isSubmitting = false;
  final List<String> fileTypes = [
    'assets/word.png',
    'assets/excel.png',
    'assets/pdf.png'
  ];
  List<PlatformFile> selectedFiles = [];
  final List<String> availableLanguages = [
    'إنجليزي(5 دينار /100 كلمة)',
    'فرنسي(5 دينار /100 كلمة) ',
    'اسباني(5 دينار /100 كلمة)',
    'الماني(5 دينار /100 كلمة)',
    'ايطالي(5 دينار /100 كلمة)',
    'صيني(5 دينار /100 كلمة)'
  ];
  List<String> selectedLanguages = [];
  final TextEditingController notesController = TextEditingController();

  Future<void> submitTranslationRequest() async {
    if (selectedLanguage == null || selectedLanguages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار اللغة المصدر واللغات المستهدفة')),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final success = await ApiService.submitTranslationRequest(
      fileLanguage: selectedLanguage!,
      translationLanguages: selectedLanguages,
      notes: notesController.text,
      deliveryMethod: deliveryMethod ?? 'استلام من الفرع',
      address: deliveryMethod == 'توصيل' ? selectedAddress : null,
      files: selectedFiles,
    );

    setState(() => isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال الطلب بنجاح')),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في إرسال الطلب، الرجاء المحاولة لاحقًا')),
      );
    }
  }
  void _addLanguage(String language) {
    if (!selectedLanguages.contains(language)) {
      setState(() {
        selectedLanguages.add(language);
      });
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        setState(() {
          selectedFiles.add(file);
        });

        print("تم اختيار الملف: ${file.name}");
      } else {
        print("لم يتم اختيار أي ملف.");
      }
    } catch (e) {
      print("حدث خطأ أثناء اختيار الملف: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                _buildDropdown('اللغة المراد ترجمتها'),
                _buildMultiSelectDropdown('اللغات المراد الترجمة إليها'),
                _buildRadioSelection(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SavedAddress()),
                    );
                  },
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset("assets/images/img51.png")),
                ),
                const Text(
                  'الملاحظات',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                _buildTextField('ادخل الملاحظات الخاصة بك ان وجدت'),
                const SizedBox(height: 16),
                const Text(
                  'المرفقات المراد ترجمتها',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                UploadButton(
                  onPressed: () {
                    pickFile();
                  },
                ),
                const SizedBox(height: 8),
                _buildSelectedFilesList(),
                const SizedBox(height: 16),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? selectedLanguage;

  Widget _buildDropdown(String label) {
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
              hint: Text(selectedLanguage ?? 'اختر'),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: availableLanguages
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedLanguage = value;
                    selectedLanguages.remove(value);
                    selectedLanguages.insert(0, value);
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectDropdown(String label) {
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
              hint: Text(selectedLanguages.isEmpty ? 'اختر' : ''),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: availableLanguages
                  .where((lang) => !selectedLanguages.contains(lang))
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedLanguages.add(value);
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: selectedLanguages.map((language) {
            return Container(
              width: 155,
              height: 36,
              padding: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language, style: const TextStyle(fontSize: 9)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLanguages.remove(language);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 1.5),
                        ),
                        child: const Icon(Icons.close,
                            size: 16, color: Colors.red),
                      ),
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

  Widget _buildRadioSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DeliveryOptions(
          onDeliveryMethodSelected: (method) {
            setState(() {
              deliveryMethod = method;
            });
          },
          onAddressSelected: (address) {
            setState(() {
              selectedAddress = address;
            });
          },
        )
      ],
    );
  }
  Widget _buildTextField(String label) {
    return Container(
      width: 343,
      height: 109,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 5,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.0,
                letterSpacing: 0,
                color: Color(0xFFB3B3B3),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploadButton() {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: pickFile,
        icon: Image.asset("assets/images/img18.png"),
        label: const Text(
          'إضافة مرفقات',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  String getFileIcon(String extension) {
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

  Widget _buildSelectedFilesList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: selectedFiles.map((file) {
          String extension = file.extension ?? "";
          String iconPath = getFileIcon(extension);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {
                  OpenFile.open(file.path);
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
                    setState(() {
                      selectedFiles.remove(file);
                    });
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

  void openSelectedFile(String filePath) {
    OpenFile.open(filePath);
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () async {
          // if (isSubmitting) return;
          // setState(() => isSubmitting = true);
          // await submitTranslationRequest();
          // setState(() => isSubmitting = false);
Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderDetailsPage()));
        },
        child: isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          'إرسال الطلب',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}



