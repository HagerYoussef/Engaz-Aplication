import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderModel {
  final int number;
  final String data;
  final String time;
  final String status;
  final Delivery delivery;
  final String translationFrom;
  final List<TranslationTo> translationTo;
  final String notes;
  final List<String> files;

  OrderModel({
    required this.number,
    required this.data,
    required this.time,
    required this.status,
    required this.delivery,
    required this.translationFrom,
    required this.translationTo,
    required this.notes,
    required this.files,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      number: json['number'],
      data: json['data'],
      time: json['time'],
      status: json['status'],
      delivery: Delivery.fromJson(json['delivery']),
      translationFrom: json['translationfrom'],
      translationTo: (json['translationto'] as List)
          .map((item) => TranslationTo.fromJson(item))
          .toList(),
      notes: json['notes'] ?? '',
      files: List<String>.from(json['files']),
    );
  }
}

class Delivery {
  final String address;
  final String type;

  Delivery({
    required this.address,
    required this.type,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      address: json['address'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class TranslationTo {
  final String name;
  final String arabicName;
  final int cost;

  TranslationTo({
    required this.name,
    required this.arabicName,
    required this.cost,
  });

  factory TranslationTo.fromJson(Map<String, dynamic> json) {
    return TranslationTo(
      name: json['name'],
      arabicName: json['Arabicname'],
      cost: json['cost'],
    );
  }
}


Future<OrderModel> fetchOrderDetails() async {
  final prefs = await SharedPreferences.getInstance();
  final orderId = prefs.getInt('id');

  if (orderId == null) {
    print('رقم الطلب غير موجود في SharedPreferences');
  }

  final response = await http.get(
    Uri.parse('http://localhost:3000/api/order/$orderId'),
  );

  if (response.statusCode == 200) {
    return OrderModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('فشل في تحميل تفاصيل الطلب: ${response.statusCode}');
  }
}
