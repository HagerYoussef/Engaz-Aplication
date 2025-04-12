import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryOptions extends StatefulWidget {
  final Function(String?)? onDeliveryMethodSelected;
  final Function(String?)? onAddressSelected;
  DeliveryOptions({
    required this.onDeliveryMethodSelected,
    required this.onAddressSelected,
  });
  @override
  _DeliveryOptionsState createState() => _DeliveryOptionsState();
}

class _DeliveryOptionsState extends State<DeliveryOptions> {
  String? deliveryMethod;
  String? selectedOption;
  Position? _currentPosition;
  String? selectedAddress;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("خدمة الموقع غير مفعلة، يرجى تشغيلها!")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم رفض إذن الوصول للموقع!")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
            Text("إذن الموقع مرفوض نهائيًا، قم بتفعيله من الإعدادات!")),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      String address =
          "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}";

      setState(() {
        _currentPosition = position;
        selectedAddress = address;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تعذر تحديد الموقع، حاول مرة أخرى.")),
      );
    }
  }

  void _submitOrder() {
    if (deliveryMethod == 'توصيل' && selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الرجاء اختيار عنوان التوصيل')),
      );
      return;
    }
    String address = selectedAddress ?? "لم يتم تحديد الموقع بعد";
    print("تم اختيار: $deliveryMethod، الموقع: $address");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio(
              value: 'استلام من الفرع',
              groupValue: deliveryMethod,
              activeColor: const Color(0xff409EDC),
              onChanged: (value) {
                setState(() {
                  deliveryMethod = value;
                  selectedOption = null;
                  _currentPosition = null;
                  selectedAddress = null;
                });
              },
            ),
            const Text('استلام من الشركة'),
            Radio(
              value: 'توصيل',
              groupValue: deliveryMethod,
              activeColor: const Color(0xff409EDC),
              onChanged: (value) {
                setState(() {
                  deliveryMethod = value;
                  selectedOption = null;
                  _currentPosition = null;
                  selectedAddress = null;
                });
                _getCurrentLocation();
              },
            ),
            const Text('توصيل'),
          ],
        ),
        const SizedBox(height: 8),
        if (deliveryMethod == "توصيل") ...[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: RadioListTile<String>(
              activeColor: const Color(0xff409EDC),
              contentPadding: EdgeInsets.zero,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('المنزل',
                      style: TextStyle(
                          color: Color(0xff409EDC),
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  if (selectedOption == 'المنزل' && selectedAddress != null ||
                      (selectedAddress != null && selectedOption == null))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "الموقع :",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              selectedAddress ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              value: 'المنزل',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: RadioListTile<String>(
              activeColor: const Color(0xff409EDC),
              contentPadding: EdgeInsets.zero,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('العمل',
                      style: TextStyle(
                          color: Color(0xff409EDC),
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  if (selectedOption == 'العمل' && selectedAddress != null ||
                      (selectedAddress != null && selectedOption == null))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "الموقع :",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              selectedAddress ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              value: 'العمل',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),
          ),
        ],
        const SizedBox(height: 10),
      ],
    );
  }
}

