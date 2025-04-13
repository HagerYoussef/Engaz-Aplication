import 'dart:convert';

import 'package:engaz_app/features/order_details/view_model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        appBar: AppBar(
          backgroundColor: const Color(0xffF2F2F2),
          title: const Text('تفاصيل الطلب'),
          leading: const Icon(Icons.arrow_back_ios_new),
        ),
        body: FutureBuilder<OrderModel>(
          future: fetchOrderDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('لا توجد بيانات'));
            }

            final order = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderInfoSection(order: order),
                  const SizedBox(height: 16.0),
                  DeliveryInfoSection(delivery: order.delivery),
                  const SizedBox(height: 16.0),
                  TranslationLanguagesSection(
                    from: order.translationFrom,
                    to: order.translationTo,
                  ),
                  const SizedBox(height: 16.0),
                  NotesSection(notes: order.notes),
                  const SizedBox(height: 16.0),
                  AttachmentsSection(files: order.files),
                  const SizedBox(height: 16.0),
                  CancelOrderButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class OrderInfoSection extends StatelessWidget {
  final OrderModel order;

  const OrderInfoSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('رقم الطلب: ${order.number}'),
          Text('التاريخ: ${order.data}'),
          Text('الوقت: ${order.time}'),
          Text('الحالة: ${order.status}'),
        ],
      ),
    );
  }
}

class DeliveryInfoSection extends StatelessWidget {
  final Delivery delivery;

  const DeliveryInfoSection({super.key, required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('معلومات التوصيل:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('العنوان: ${delivery.address.isEmpty ? 'لا يوجد' : delivery.address}'),
          Text('نوع التوصيل: ${delivery.type}'),
        ],
      ),
    );
  }
}

class TranslationLanguagesSection extends StatelessWidget {
  final String from;
  final List<TranslationTo> to;

  const TranslationLanguagesSection({
    super.key,
    required this.from,
    required this.to,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الترجمة من: $from'),
          const SizedBox(height: 8),
          const Text('إلى:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...to.map((lang) => Text(
            '${lang.arabicName} (${lang.name}) - ${lang.cost} جنيه',
          )),
        ],
      ),
    );
  }
}

class NotesSection extends StatelessWidget {
  final String notes;

  const NotesSection({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty || notes.toLowerCase() == 'optional') return SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ملاحظات:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(notes),
        ],
      ),
    );
  }
}

class AttachmentsSection extends StatelessWidget {
  final List<String> files;

  const AttachmentsSection({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('المرفقات:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...files.map((file) => Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red),
              const SizedBox(width: 8),
              Text(file),
            ],
          )),
        ],
      ),
    );
  }
}

class AttachmentIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  AttachmentIcon(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: color),
        Text(label),
      ],
    );
  }
}


class CancelOrderButton extends StatelessWidget {
  const CancelOrderButton({super.key});

  Future<void> _cancelOrder(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance();
    final orderId = prefs.getString('id');

    if (orderId == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order ID not found')),
      );
      return;
    }


    final url = Uri.parse('http://localhost:3000/api/order/$orderId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {

      final responseBody = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseBody['message'])),
      );
    } else if (response.statusCode == 400) {

      final responseBody = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseBody['message'])),
      );
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          _cancelOrder(context);
        },
        child: const Text('إلغاء الطلب', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
