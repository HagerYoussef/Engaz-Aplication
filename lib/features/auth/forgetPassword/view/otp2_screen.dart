import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../login/viewmodel/login_viewmodel.dart';
import 'otp_screen.dart';

class OtpScreen2 extends StatefulWidget {
  final String phone;
  final String email;

  const OtpScreen2({required this.phone, required this.email});

  @override
  State<OtpScreen2> createState() => _OtpScreen2State();
}

class _OtpScreen2State extends State<OtpScreen2> {
  int? selectedImageIndex;

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
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: screenWidth > 600 ? 150 : 130),
                        Center(
                          child: Image.asset('assets/images/img1.png',
                              width: imageWidth, height: imageWidth * 0.37),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "رمز التفعيل",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IBM_Plex_Sans_Arabic'),
                        ),
                        const Text(
                          "اختر وسيلة استلام رمز التفعيل الخاص بك لتفعيل حسابك",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xffB3B3B3),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'IBM_Plex_Sans_Arabic'),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImageIndex = 1;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.only(right: 60, left: 60),
                            decoration: BoxDecoration(
                              border: selectedImageIndex == 1
                                  ? Border.all(
                                  color: const Color(0xff409EDC), width: 1)
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/images/img3.png',
                              width: imageWidth,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImageIndex = 2;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.only(right: 60, left: 60),
                            decoration: BoxDecoration(
                              border: selectedImageIndex == 2
                                  ? Border.all(
                                  color: const Color(0xff409EDC), width: 1)
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/images/img4.png',
                              width: imageWidth,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedImageIndex == null) {
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpScreen(
                                    contactInfo: selectedImageIndex == 1
                                        ? widget.phone
                                        : widget.email,
                                    contactType: selectedImageIndex == 1
                                        ? 'phone'
                                        : 'email',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(64, 157, 220, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "تأكيد",
                              style: TextStyle(
                                fontSize: 16,
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
                Positioned(
                  top: 60,
                  left: padding,
                  child: SizedBox(
                    width: screenWidth * .9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/img2.png',
                          width: screenWidth > 600 ? 120 : 98,
                          height: screenWidth > 600 ? 40 : 33,
                        ),
                        Row(
                          children: [
                            const Text(
                              "رمز التفعيل ",
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