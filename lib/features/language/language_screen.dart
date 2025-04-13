import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  Image.asset("assets/images/img23.png"),
        title: const Text('لغة التطبيق'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildLanguageOption(
                    context,
                    'English',
                    'assets/images/img46.png',
                    false,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildLanguageOption(
                    context,
                    'اللغة العربية',
                    'assets/images/img47.png',
                    true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xff28C1ED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff28C1ED),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: const Text(
                  'تأكيد',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String label, String asset, bool selected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xff28C1ED).withOpacity(.2)
            : const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? const Color(0xff409EDC) : const Color(0xffF2F2F2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Image.asset(asset, height: 40),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}