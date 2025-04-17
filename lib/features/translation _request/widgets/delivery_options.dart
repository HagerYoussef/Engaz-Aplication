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
          content: Text("إذن الموقع مرفوض نهائيًا، قم بتفعيله من الإعدادات!"),
        ),
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

      // استدعاء الدالة عند تحديد العنوان
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
            Radio(
              value: 'Office',
              groupValue: deliveryMethod,
              activeColor: const Color(0xff409EDC),
              onChanged: (value) {
                setState(() {
                  deliveryMethod = value;
                  selectedOption = null;
                  _currentPosition = null;
                  selectedAddress = null;
                });
                // استدعاء الدالة عند اختيار وسيلة التوصيل
                widget.onDeliveryMethodSelected?.call(deliveryMethod);
              },
            ),
            const Text('Office'),
            Radio(
              value: 'Home',
              groupValue: deliveryMethod,
              activeColor: const Color(0xff409EDC),
              onChanged: (value) {
                setState(() {
                  deliveryMethod = value;
                  selectedOption = null;
                  _currentPosition = null;
                  selectedAddress = null;
                });
                widget.onDeliveryMethodSelected?.call(deliveryMethod);
                _getCurrentLocation();
              },
            ),
            const Text('Home'),
          ],
        ),
        const SizedBox(height: 8),
        if (deliveryMethod == "توصيل") ...[
          _buildAddressOption("المنزل"),
          _buildAddressOption("العمل"),
        ],
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildAddressOption(String optionTitle) {
    return Container(
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
            Text(
              optionTitle,
              style: const TextStyle(
                color: Color(0xff409EDC),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if ((selectedOption == optionTitle && selectedAddress != null) ||
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
        value: optionTitle,
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value;
          });
        },
      ),
    );
  }
}
