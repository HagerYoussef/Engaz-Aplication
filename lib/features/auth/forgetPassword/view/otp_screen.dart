import 'package:engaz_app/features/auth/forgetPassword/widgets/otp_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/otp_viewmodel.dart';

class OtpScreen extends StatefulWidget {
  final String contactInfo;
  final String contactType;

  const OtpScreen({required this.contactInfo, required this.contactType});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<OtpViewModel>(context, listen: false).startTimer());
  }

  @override
  void dispose() {
    Provider.of<OtpViewModel>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OtpViewModel(),
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
                    child: Consumer<OtpViewModel>(
                      builder: (context, viewModel, child) {
                        return Column(
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'IBM_Plex_Sans_Arabic'),
                            ),
                            const Text(
                              ":الرجاء ادخال رمز التفعيل المرسل عبر رقم الجوال التالي",
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xffB3B3B3),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'IBM_Plex_Sans_Arabic'),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.contactInfo,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff409EDC),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'IBM_Plex_Sans_Arabic'),
                            ),
                            const SizedBox(height: 16),
                            const OtpFields(),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: buttonHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => const HomePage()),
                                  // );
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
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textDirection: TextDirection.rtl,
                              children: [
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "لم يصلك رمز التفعيل؟ ",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'IBM_Plex_Sans_Arabic',
                                          ),
                                        ),
                                        TextSpan(
                                          text: "أعد الإرسال",
                                          style: const TextStyle(
                                            color: Color(0xff409EDC),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            fontFamily: 'IBM_Plex_Sans_Arabic',
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              viewModel.resetTimer();
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${viewModel.minutes.toString().padLeft(2, '0')}:${viewModel.seconds.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff409EDC),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
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