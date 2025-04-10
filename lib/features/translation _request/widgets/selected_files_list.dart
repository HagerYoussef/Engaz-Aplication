import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SelectedFilesList extends StatelessWidget {
  final List<PlatformFile> files;

  const SelectedFilesList({Key? key, required this.files}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: files.map((file) {
          String extension = file.extension ?? "";
          String iconPath = getFileIcon(extension);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(iconPath, width: 60, height: 60),
          );
        }).toList(),
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
}
