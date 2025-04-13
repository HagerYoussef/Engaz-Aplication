import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'الإشعارات',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 8,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Container(
              width: 345,
              height: 75.5,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'هذا النص هو نص بديل يمكن أن يستبدل',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1D1D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '1 ساعة',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFFB3B3B3),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.lock_clock,
                              size: 9,
                              color: Color(0xFFB3B3B3),
                            ),
                            SizedBox(width: 4),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.delete_outline, color: Color(0xFFE50930)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}