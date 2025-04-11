import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/register_model.dart';

class SignUpService {

  Future<Map<String, dynamic>> signUp(BuildContext context, SignUpModel signUpModel) async {
    final url = Uri.parse('https://wckb4f4m-3000.euw.devtunnels.ms/api/signup');

    try {

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(signUpModel.toJson()),
      );


      if (response.statusCode == 200 || response.statusCode == 201) {

        return {'success': true, 'message': 'Register Success'};
      }
      else if (response.statusCode ==400) {

        return {'success': false, 'message': 'Email or phone is already taken'};
      }
      else {
        final res = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Register Failed')),
        );
        return {'success': false, 'message': res['message'] ?? 'Register Failed'};
      }
    } catch (e) {
      debugPrint('Signup error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر الاتصال بالخادم')),
      );
      return {'success': false, 'message': 'تعذر الاتصال بالخادم'};
    }
  }
}
