import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  Future<Map<String, String>> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? "";

    if (token.isEmpty) throw Exception("Token not found");

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String userId = decodedToken["user_id"];

    final response = await http.get(
      Uri.parse("http://localhost:3000/api/user/$userId"),
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const Icon(Icons.arrow_back_ios_new),
          title: const Text("الملف الشخصي", textAlign: TextAlign.right),
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/img1.png",
                        height: 69,
                        width: 187,
                      ),
                      const SizedBox(height: 24),
                      const Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "الاسم الاول",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          )),
                      buildTextField("محمد", firstNameController),
                      const SizedBox(height: 16),
                      const Align(
                          alignment: Alignment.topRight,
                          child: Text("اسم العائله",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15))),
                      buildTextField("اشرف", lastNameController),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: handle save
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(343, 10),
                          backgroundColor: const Color(0xF0409EDC),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "حفظ التعديلات",
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
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Container(
      width: 343,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
