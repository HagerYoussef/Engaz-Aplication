import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: OrdersScreen()));
}

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isTranslationSelected = true;
  late String userId;
  late Future<List<dynamic>> _ordersFuture;

  final Map<String, Map<String, dynamic>> statusDetails = {
    'Under Review': {
      'tab': 'جديد',
      'text': 'قيد المراجعة',
      'color': Colors.orange,
      'image': 'assets/images/img16.png',
      'apiStatus': 'new'
    },
    'In Progress': {
      'tab': 'حالي',
      'text': 'جاري التنفيذ',
      'color': Colors.blue,
      'image': 'assets/images/img16.png',
      'apiStatus': 'current'
    },
    'Completed': {
      'tab': 'منتهي',
      'text': 'مكتمل',
      'color': Colors.green,
      'image': 'assets/images/img16.png',
      'apiStatus': 'finished'
    },
    'Cancelled': {
      'tab': 'ملغي',
      'text': 'ملغى',
      'color': Colors.red,
      'image': 'assets/images/img16.png',
      'apiStatus': 'cancelled'
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('id') ?? '';
    });
    _ordersFuture = _fetchOrders('جديد');
  }

  Future<List<dynamic>> _fetchOrders(String tabStatus) async {
    final type = isTranslationSelected ? 'translation' : 'print';
    final statusParam = _getApiStatusForTab(tabStatus);

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/order/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'type': type,
        'status': statusParam
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
  }

  String _getApiStatusForTab(String tabStatus) {
    return statusDetails.values
        .firstWhere((detail) => detail['tab'] == tabStatus)['apiStatus'];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: const Color(0xffFAFAFA),
          appBar: AppBar(
            leading: Icon(Icons.arrow_back_ios_new),
            backgroundColor: const Color(0xffFAFAFA),
            title: const Text('طلباتي', style: TextStyle(color: Colors.black)),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/img9.png"),
              )
            ],
          ),
          body: Column(
            children: [
              Container(
                width: 360,
                height: 56,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        isTranslationSelected = true;
                        _ordersFuture = _fetchOrders('جديد');
                      }),
                      child: _buildTabButton('طلبات الترجمة', isTranslationSelected),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        isTranslationSelected = false;
                        _ordersFuture = _fetchOrders('جديد');
                      }),
                      child: _buildTabButton('طلبات الطباعة', !isTranslationSelected),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const TabBar(
                  labelColor: Color(0xff409EDC),
                  unselectedLabelColor: Color(0xffB3B3B3),
                  indicatorColor: Colors.transparent,
                  tabs: [
                    Tab(text: 'جديد'),
                    Tab(text: 'حالي'),
                    Tab(text: 'منتهي'),
                    Tab(text: 'ملغي'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: ['جديد', 'حالي', 'منتهي', 'ملغي'].map((tabStatus) {
                    return FutureBuilder<List<dynamic>>(
                      future: _fetchOrders(tabStatus),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red, size: 40),
                                SizedBox(height: 10),
                                Text('حدث خطأ في جلب البيانات'),
                              ],
                            ),
                          );
                        }

                        final orders = snapshot.data ?? [];

                        if (orders.isEmpty) {
                          return Center(child: Text('لا توجد طلبات متاحة'));
                        }

                        return ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            final details = statusDetails[order['status']] ?? {
                              'text': order['status'],
                              'color': Colors.grey,
                              'image': 'assets/images/img16.png'
                            };

                            return OrderItem(
                              orderNumber: order['number'].toString(),
                              createdAt: order['createdAt'],
                              language: order['translationfrom'],
                              filesCount: order['filescount'].toString(),
                              statusText: details['text'],
                              statusColor: details['color'],
                              statusImage: details['image'],
                              deliveryType: order['delivery'],
                              orderId: order['id'].toString(),
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xff409EDC) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String orderNumber;
  final String createdAt;
  final String language;
  final String filesCount;
  final String statusText;
  final Color statusColor;
  final String statusImage;
  final String deliveryType;
  final String orderId;

  const OrderItem({
    Key? key,
    required this.orderNumber,
    required this.createdAt,
    required this.language,
    required this.filesCount,
    required this.statusText,
    required this.statusColor,
    required this.statusImage,
    required this.deliveryType,
    required this.orderId,
  }) : super(key: key);

  String _mapDelivery(String delivery) {
    return delivery == 'Office' ? 'استلام من الفرع' : 'توصيل';
  }

  void _showOrderDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الطلب #$orderNumber'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('الحالة', statusText),
            _buildDetailItem('تاريخ الإنشاء', createdAt),
            _buildDetailItem('طريقة التسليم', _mapDelivery(deliveryType)),
            _buildDetailItem('اللغة', language),
            _buildDetailItem('عدد المرفقات', filesCount),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$title: ', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('#$orderNumber',
                  style: const TextStyle(
                      color: Color(0xff1D1D1D),
                      fontWeight: FontWeight.bold)),
              Text(createdAt,
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('اللغه:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1D1D1D))),
                  const SizedBox(width: 5),
                  Text(language,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
              Text(_mapDelivery(deliveryType),
              )  ],

              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text('عدد المرفقات:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1D1D1D))),
                  const SizedBox(width: 5),
                  Text(filesCount,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
              const Divider(color: Color(0xffF2F2F2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(statusImage, width: 20),
                      const SizedBox(width: 5),
                      Text(statusText, style: TextStyle(color: statusColor)),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _showOrderDetails(context),
                    child: Row(
                      children: [
                        Image.asset("assets/images/img17.png"),
                        const SizedBox(width: 5),
                        const Text('عرض الطلب',
                            style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}