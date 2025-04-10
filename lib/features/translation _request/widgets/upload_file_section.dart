import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../viewmodel/translation_request_viewmodel.dart';

class UploadFileSection extends StatelessWidget {
  const UploadFileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TranslationRequestViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المرفقات المراد ترجمتها',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: 343,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "الرجاء إضافة المرفقات المراد ترجمتها",
                  style: TextStyle(fontSize: 14, color: Color(0xffB3B3B3)),
                ),
              ),
              IconButton(
                onPressed: viewModel.pickFile,
                icon: Image.asset("assets/images/img18.png"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.selectedFiles.length,
            itemBuilder: (context, index) {
              PlatformFile file = viewModel.selectedFiles[index];
              String iconPath =
              viewModel.getFileIconPath(file.extension ?? "");

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () => viewModel.openFile(file.path!),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(iconPath, width: 60, height: 60),
                    ),
                  ),
                  Positioned(
                    top: -5,
                    left: -5,
                    child: GestureDetector(
                      onTap: () => viewModel.removeFile(file),
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
            },
          ),
        ),
      ],
    );
  }
}
