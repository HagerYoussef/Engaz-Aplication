import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../auth/forgetPassword/view/otp_screen.dart';
import '../auth/login/view/login_screen.dart';
import '../auth/login/viewmodel/login_viewmodel.dart';

class EnterNewEmail extends StatelessWidget {
  const EnterNewEmail({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double padding = screenWidth > 600 ? 48 : 24;
            double imageWidth = screenWidth > 600 ? 250 : 204;
            double buttonHeight = screenWidth > 600 ? 60 : 50;

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: screenWidth > 600 ? 70 : 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "تغيير البريد الالكتروني ",
                              style: TextStyle(
                                color: Color(0xff1D1D1D),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                fontFamily: 'IBM_Plex_Sans_Arabic',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                        SizedBox(height: screenWidth > 600 ? 50 : 30),
                        Image.asset('assets/images/img1.png',
                            width: imageWidth, height: imageWidth * 0.37),
                        const SizedBox(height: 16),
                        const Text(
                          "البريد الالكتروني الجديد",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IBM_Plex_Sans_Arabic'),
                        ),
                        const CustomTextFeild2(),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () async {
                              final viewModel = Provider.of<LoginViewModel>(context, listen: false);
                              final email = viewModel.userInput;

                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "يرجى إدخال البريد الإلكتروني الجديد",
                                      style: TextStyle(fontFamily: 'IBM_Plex_Sans_Arabic'),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              try {
                                final prefs = await SharedPreferences.getInstance();
                                final token = prefs.getString('authToken') ?? '';
                                final userId = JwtDecoder.decode(token)['user_id'];

                                final response = await http.post(
                                  Uri.parse('http://localhost:3000/api/user/$userId/chgnageemail'),
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer $token',
                                  },
                                  body: jsonEncode({"email": email}),
                                );

                                final data = jsonDecode(response.body);

                                if (response.statusCode == 200) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        data['message'] ?? 'تم تغيير البريد الإلكتروني بنجاح',
                                        style: const TextStyle(fontFamily: 'IBM_Plex_Sans_Arabic'),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                        (route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        data['message'] ?? 'فشل في تغيير البريد الإلكتروني',
                                        style: const TextStyle(fontFamily: 'IBM_Plex_Sans_Arabic'),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'فشل الاتصال بالخادم: $e',
                                      style: const TextStyle(fontFamily: 'IBM_Plex_Sans_Arabic'),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "تأكيد",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBM_Plex_Sans_Arabic',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CustomTextFeild2 extends StatefulWidget {
  const CustomTextFeild2({super.key});

  @override
  State<CustomTextFeild2> createState() => _CustomTextFeild2State();
}

class _CustomTextFeild2State extends State<CustomTextFeild2> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    _controller.addListener(() => viewModel.setUserInput(_controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: "ادخل البريد الإلكتروني الجديد",
          hintStyle: const TextStyle(
            color: Color(0xffB3B3B3),
            fontWeight: FontWeight.w500,
            fontSize: 13,
            fontFamily: 'IBM_Plex_Sans_Arabic',
          ),
          filled: true,
          fillColor: const Color(0xffFAFAFA),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}

