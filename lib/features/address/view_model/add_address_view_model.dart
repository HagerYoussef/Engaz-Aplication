import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddressViewModel extends ChangeNotifier {
  TextEditingController locationController = TextEditingController();
  bool isLoading = false;
  LatLng selectedPosition = LatLng(24.7136, 46.6753);

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address =
            "${place.name ?? ''}, ${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";

        locationController.text = address;
      } else {
        locationController.text = "موقع غير معروف";
      }
      notifyListeners();
    } catch (e) {
      locationController.text = "موقع غير معروف";
      notifyListeners();
    }
  }

  Future<void> addAddress(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final url = 'https://wckb4f4m-3000.euw.devtunnels.ms/api/address';
    final headers = {"Content-Type": "application/json"};
    final Map<String, dynamic> requestBody = {
      "name": "Home",
      "address": locationController.text,
      "location": locationController.text.isNotEmpty ? locationController.text : null,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('address_id', responseBody['data']['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تمت الإضافة بنجاح ✅")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في الإضافة ❌")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء الإضافة ❌")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAddress(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? addressId = prefs.getString('address_id');

    if (addressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("لم يتم العثور على العنوان ❌")),
      );
      isLoading = false;
      notifyListeners();
      return;
    }

    final url = 'https://b762efea-73b1-4221-8420-90b4e7d17125-00-2mjbzkqtyqqef.janeway.replit.dev/api/address/$addressId';
    final headers = {"Content-Type": "application/json"};
    final Map<String, dynamic> requestBody = {
      "name": "Home",
      "address": locationController.text,
      "location": locationController.text.isNotEmpty ? locationController.text : null,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم التعديل بنجاح ✅")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في التعديل ❌")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء التعديل ❌")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
