import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/translation_request_viewmodel.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TranslationRequestViewModel>(context, listen: false);

    return Container(
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
              style: TextStyle(
                fontSize: 14,
                color: Color(0xffB3B3B3),
                fontFamily: 'IBM_Plex_Sans_Arabic',
              ),
            ),
          ),
          IconButton(
            onPressed: viewModel.pickFile,
            icon: Image.asset("assets/images/img18.png"),
          ),
        ],
      ),
    );
  }
}
