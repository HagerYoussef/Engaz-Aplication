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
                  DeliveryInfoSection(delivery: order.delivery, order: order,),
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
    return  Card(
        elevation: 0,
        color: Colors.white,
        child: Padding(
        padding: const EdgeInsets.all(12.0),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('رقم الطلب ',
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${order.number}', style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('تاريخ الطلب ',
              style:
              TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text('${order.data}'),
        ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('وقت الطلب',
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('${order.time}'),
              ]),
        

        ],
      ),
    ));
  }
}

class DeliveryInfoSection extends StatelessWidget {
  final Delivery delivery;
  final OrderModel order;

  const DeliveryInfoSection({super.key, required this.delivery, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${order.status}'),
              SizedBox(height: 10,),
              Text('نوع التوصيل: ${delivery.type}'),
            ],
          ),

          InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ChatScreen()));
            },
            child: CircleAvatar(
                backgroundColor: const Color(0xff409EDC),
                child: Image.asset("assets/images/img19.png")),
          ),

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
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اللغة المراد ترجمتها',
              style: TextStyle(fontSize: 15, color: Color(0xffB3B3B3))),
          Text('$from',style:  TextStyle(color: Color(0xff409EDC),)),
          const SizedBox(height: 8),
          Text('اللغات المراد الترجمة إليها:',
              style: TextStyle(fontSize: 15, color: Color(0xffB3B3B3))), ...to.map((lang) => Text(
            '${lang.arabicName} (${lang.name}) - ${lang.cost} جنيه', style: TextStyle(color: Color(0xff409EDC))),
          ),
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
          const Text('المرفقات',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),  ...files.map((file) => Row(
            children: [
               Image.asset("assets/images/img10.png"),
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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CancelOrder()),
          );
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          minimumSize: const Size(164, 5),
          backgroundColor: Color(0xffE50930),
        ),
        child: const Text(
          'الغاء الطلب',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }}
class CancelOrder extends StatelessWidget {
  final TextEditingController _reasonController = TextEditingController();

  Future<void> _cancelOrder(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // final orderId = prefs.getInt('orderId');
    // if (orderId == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Order ID not found')),
    //   );
    //   return;
    // }

    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('من فضلك أدخل سبب الإلغاء')),
      );
      return;
    }


    final orderId = 73;
    final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YWJkMWIzNi0xZGQxLTQ2MDktYTE2NC1kZTg5YmM1YWYwMWQiLCJ1c2VybmFtZSI6IkJhc3NlbCBTYWxsYW0iLCJlbWFpbCI6ImJhc3NlbGEuc2FsYW1AZ21haWwuY29tIiwidmVyZmllZCI6dHJ1ZSwiaWF0IjoxNzQyNzY2OTkzfQ.-LuSsU2AombLwf1YUm91fNe_VmXtfIDEn9Z8h3N1PAc';  // تأكد من استخدام التوكن الصحيح

    final url = Uri.parse('https://wckb4f4m-3000.euw.devtunnels.ms/api/order/$orderId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'reason': reason,
      }),
    );

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "الغاء الطلب ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset("assets/images/img23.png"),
        ),
      ),
      body: Column(
        children: [
          Center(child: Image.asset("assets/images/img24.png")),
          const SizedBox(height: 30),
          const Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  "سبب الالغاء",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: 'توضيح سبب الالغاء',
                  hintStyle: const TextStyle(color: Color(0xffB3B3B3)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffF2F2F2), width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                maxLines: 5,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                onPressed: () {
                  _cancelOrder(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE50930), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  minimumSize: const Size(164, 5),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'الغاء',
                  style: TextStyle(
                    color: Color(0xFFE50930),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff409EDC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  minimumSize: const Size(164, 5),
                ),
                child: const Text(
                  'تراجع',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
