import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import '../viewmodel/translation_request_viewmodel.dart';

class SelectedFilesList extends StatelessWidget {
  const SelectedFilesList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TranslationRequestViewModel>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: viewModel.selectedFiles.map((file) {
          final extension = file.extension ?? '';
          final iconPath = viewModel.getFileIconPath(extension);

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
        }).toList(),
      ),
    );
  }
}
