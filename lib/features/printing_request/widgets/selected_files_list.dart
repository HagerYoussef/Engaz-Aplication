import 'package:flutter/material.dart';

class SelectedFilesList extends StatelessWidget {
  final List selectedFiles;

  const SelectedFilesList({required this.selectedFiles});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: selectedFiles.map((file) {
          String extension = file.extension ?? "";
          String iconPath = "assets/images/img10.png";  // Update with your actual logic

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(iconPath, width: 60, height: 60),
          );
        }).toList(),
      ),
    );
  }
}
