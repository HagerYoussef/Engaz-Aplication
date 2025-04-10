import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String? selectedLanguage;
  final String? selectedLanguage2;
  final String? pages;
  final String? copies;
  final List selectedFiles;

  const SummaryCard({
    required this.selectedLanguage,
    required this.selectedLanguage2,
    required this.pages,
    required this.copies,
    required this.selectedFiles,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedLanguage != null)
              _buildSummaryItem('لون الطباعة', selectedLanguage!),
            if (selectedLanguage2 != null)
              _buildSummaryItem('نوع التغليف', selectedLanguage2!),
            if (pages != null) _buildSummaryItem('عدد الصفحات', pages!),
            if (copies != null) _buildSummaryItem('عدد النسخ', copies!),
            if (selectedFiles.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: selectedFiles.map((file) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [Image.asset("assets/images/img10.png", width: 50, height: 50)],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Color(0xffB3B3B3))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff409EDC))),
        ],
      ),
    );
  }
}
