import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/localization/change_lang.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  Future<Map<String, String>> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // final token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YWJkMWIzNi0xZGQxLTQ2MDktYTE2NC1kZTg5YmM1YWYwMWQiLCJ1c2VybmFtZSI6IkJhc3NlbCBTYWxsYW0iLCJlbWFpbCI6ImJhc3NlbGEuc2FsYW1AZ21haWwuY29tIiwidmVyZmllZCI6dHJ1ZSwiaWF0IjoxNzQyNzY2OTkzfQ.-LuSsU2AombLwf1YUm91fNe_VmXtfIDEn9Z8h3N1PAc";
    // final userId = '6abd1b36-1dd1-4609-a164-de89bc5af01d';

    final response = await http.get(
      Uri.parse("https://wckb4f4m-3000.euw.devtunnels.ms/api/user"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return {
        "firstname": json["firstname"] ?? "",
        "lastname": json["lastname"] ?? ""
      };
    } else {
      throw Exception("Failed to load user data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();

    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        final locale = localizationProvider.locale.languageCode;
        final textDirection = locale == 'ar' ? TextDirection.rtl : TextDirection.ltr;
        final alignment = locale == 'ar' ? Alignment.topRight : Alignment.topLeft;

        return Directionality(
          textDirection: textDirection,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: const Icon(Icons.arrow_back_ios_new),
              title: Text(
                Translations.getText('profile', locale),
                textAlign: TextAlign.right,
              ),
            ),
            body: SafeArea(
              child: FutureBuilder<Map<String, String>>(
                future: fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("خطأ: ${snapshot.error}"));
                  } else {
                    final data = snapshot.data!;
                    firstNameController.text = data["firstname"]!;
                    lastNameController.text = data["lastname"]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/img1.png",
                            height: 69,
                            width: 187,
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: alignment,
                            child: Text(
                              Translations.getText('first', locale),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          buildTextField("محمد", firstNameController,locale),
                          const SizedBox(height: 16),
                          Align(
                            alignment: alignment,
                            child: Text(
                              Translations.getText('last', locale),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          buildTextField("اشرف", lastNameController,locale),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: handle save
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(343, 10),
                              backgroundColor: const Color(0xF0409EDC),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              Translations.getText('save', locale),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildTextField(String label, TextEditingController controller, String languageCode) {
  return Container(
    width: 343,
    height: 48,
    decoration: BoxDecoration(
      color: const Color(0xFFFAFAFA),
      borderRadius: BorderRadius.circular(16),
    ),
    child: TextField(
      controller: controller,
      textAlign: languageCode == 'ar' ? TextAlign.right : TextAlign.left,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      ),
      style: const TextStyle(fontSize: 14),
    ),
  );
}
