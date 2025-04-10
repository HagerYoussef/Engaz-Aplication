import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/translation_request_viewmodel.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TranslationRequestViewModel>(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          if (viewModel.canSubmit()) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const OrderDetailsPage()),
            // );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('يرجى تعبئة جميع الحقول المطلوبة قبل الإرسال'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: const Text(
          'إرسال الطلب',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
