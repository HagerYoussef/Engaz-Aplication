import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryOptions extends StatefulWidget {
  final Function(String?)? onDeliveryMethodSelected;
  final Function(String?)? onAddressSelected;
  final String? selectedMethod;

  const DeliveryOptions({
    Key? key,
    required this.onDeliveryMethodSelected,
    required this.selectedMethod,
    required this.onAddressSelected,
  }) : super(key: key);

  @override
  _DeliveryOptionsState createState() => _DeliveryOptionsState();
}

class _DeliveryOptionsState extends State<DeliveryOptions> {
  String? deliveryMethod;
  String? selectedAddress;
  Position? _currentPosition;

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
          content: Text("إذن الموقع مرفوض نهائيًا، قم بتفعيله من الإعدادات!"),
        ),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}";

      setState(() {
        _currentPosition = position;
        selectedAddress = address;
      });

      widget.onAddressSelected?.call(selectedAddress);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تعذر تحديد الموقع، حاول مرة أخرى.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<String>(
              value: 'Office',
              groupValue: widget.selectedMethod,
              activeColor: const Color(0xff409EDC),
              onChanged: (value) {
                setState(() {
                  deliveryMethod = value;
                  selectedAddress = null;
                });
                widget.onDeliveryMethodSelected?.call(deliveryMethod);
                widget.onAddressSelected?.call(null);
              },
            ),
            const Text('Office'),
            Radio<String>(
              value: 'Home',
              groupValue: deliveryMethod,
              activeColor: const Color(0xff409EDC),
              onChanged: (value) {
                setState(() {
                  deliveryMethod = value;
                  selectedAddress = null;
                });
                widget.onDeliveryMethodSelected?.call(deliveryMethod);
                _getCurrentLocation();
              },
            ),
            const Text('Home'),
          ],
        ),
        const SizedBox(height: 10),
        if (deliveryMethod == 'Home')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() => selectedAddress = value);
                widget.onAddressSelected?.call(value);
              },
              initialValue: selectedAddress,
              decoration: InputDecoration(
                labelText: "أدخل العنوان يدويًا",
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xff409EDC), width: 2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}