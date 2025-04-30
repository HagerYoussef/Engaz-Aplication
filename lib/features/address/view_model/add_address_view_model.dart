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
 // String token=  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YWJkMWIzNi0xZGQxLTQ2MDktYTE2NC1kZTg5YmM1YWYwMWQiLCJ1c2VybmFtZSI6IkJhc3NlbCBTYWxsYW0iLCJlbWFpbCI6ImJhc3NlbGEuc2FsYW1AZ21haWwuY29tIiwidmVyZmllZCI6dHJ1ZSwiaWF0IjoxNzQyNzY2OTkzfQ.-LuSsU2AombLwf1YUm91fNe_VmXtfIDEn9Z8h3N1PAc';

  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address =
            "${place.name ?? ''}, ${place.street ?? ''}, ${place.locality ??
            ''}, ${place.country ?? ''}";

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


  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> addAddress(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final url = 'https://wckb4f4m-3000.euw.devtunnels.ms/api/address';
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await _getToken()}",
      //"Authorization": "Bearer $token",
    };

    final Map<String, dynamic> requestBody = {
      "name": "Home",
      "address": locationController.text,
      "location": locationController.text.isNotEmpty
          ? locationController.text
          : null,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestBody),
      );
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('address_id', responseBody['data']['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تمت الإضافة بنجاح ✅")),
        );
      }

      else {
        print('token${_getToken()}')
        ;
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
    String? addressId = prefs.getString('addressId');
    String? token = prefs.getString('token');
  // String? token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YWJkMWIzNi0xZGQxLTQ2MDktYTE2NC1kZTg5YmM1YWYwMWQiLCJ1c2VybmFtZSI6IkJhc3NlbCBTYWxsYW0iLCJlbWFpbCI6ImJhc3NlbGEuc2FsYW1AZ21haWwuY29tIiwidmVyZmllZCI6dHJ1ZSwiaWF0IjoxNzQyNzY2OTkzfQ.-LuSsU2AombLwf1YUm91fNe_VmXtfIDEn9Z8h3N1PAc';

    print('addressId: $addressId');
    print('token: $token');

    if (addressId == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("العنوان أو التوكن غير موجود ❌")),
      );
      isLoading = false;
      notifyListeners();
      return;
    }

    final url = 'https://wckb4f4m-3000.euw.devtunnels.ms/api/address/$addressId';
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final Map<String, dynamic> requestBody = {
      "name": "Home",
      "address": locationController.text,
      "location": locationController.text.isNotEmpty
          ? locationController.text
          : null,
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
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error during update: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء التعديل ❌")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAddress(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? addressId = prefs.getString('addressId');
   // String? addressId = '3772252d-57cd-404a-9411-e07da54deeca';

    if (addressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("لم يتم العثور على العنوان ❌")),
      );
      isLoading = false;
      notifyListeners();
      return;
    }

    final url = 'https://wckb4f4m-3000.euw.devtunnels.ms/api/address/$addressId';
    final headers = {
      "Content-Type": "application/json",
     "Authorization": "Bearer ${await _getToken()}",
    // "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YWJkMWIzNi0xZGQxLTQ2MDktYTE2NC1kZTg5YmM1YWYwMWQiLCJ1c2VybmFtZSI6IkJhc3NlbCBTYWxsYW0iLCJlbWFpbCI6ImJhc3NlbGEuc2FsYW1AZ21haWwuY29tIiwidmVyZmllZCI6dHJ1ZSwiaWF0IjoxNzQyNzY2OTkzfQ.-LuSsU2AombLwf1YUm91fNe_VmXtfIDEn9Z8h3N1PAc"

    };

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        await prefs.remove('address_id');
        //await prefs.remove(addressId);
        locationController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم حذف العنوان بنجاح ✅")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في حذف العنوان ❌")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء الحذف ❌")),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
// String? userId = '6abd1b36-1dd1-4609-a164-de89bc5af01d';
//    String? token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YWJkMWIzNi0xZGQxLTQ2MDktYTE2NC1kZTg5YmM1YWYwMWQiLCJ1c2VybmFtZSI6IkJhc3NlbCBTYWxsYW0iLCJlbWFpbCI6ImJhc3NlbGEuc2FsYW1AZ21haWwuY29tIiwidmVyZmllZCI6dHJ1ZSwiaWF0IjoxNzQyNzY2OTkzfQ.-LuSsU2AombLwf1YUm91fNe_VmXtfIDEn9Z8h3N1PAc';
//