import 'package:engaz_app/features/auth/forgetPassword/view/otp2_screen.dart';
import 'package:engaz_app/features/auth/register/widgets/custom_text_feild.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../login/viewmodel/login_viewmodel.dart';
import '../../login/view/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
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
                  child: Form(
                    key: formKey,
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
                          "انشاء حساب جديد",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IBM_Plex_Sans_Arabic'),
                        ),
                        const Text(
                          "الرجاء ملئ البيانات التالية لانشاء حسابك",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xffB3B3B3),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'IBM_Plex_Sans_Arabic'),
                        ),
                        const SizedBox(height: 16),

                        const Text(
                          "الاسم الاول",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IBM_Plex_Sans_Arabic'),
                        ),
                        CustomTextField(
                            hintText: 'ادخل الاسم الاول',
                            onChanged: (value) => Provider.of<LoginViewModel>(
                                context,
                                listen: false)
                                .setFirstName(value)),
                        const SizedBox(height: 8),
                        const Text(
                          "اسم العائله",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IBM_Plex_Sans_Arabic'),
                        ),
                        CustomTextField(
                          hintText: 'ادخل اسم العائلة',
                          onChanged: (value) => Provider.of<LoginViewModel>(
                              context,
                              listen: false)
                              .setLastName(value),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "رقم الجوال",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IBM_Plex_Sans_Arabic'),
                        ),
                        CustomTextField(
                          hintText: 'ادخل رقم الجوال',
                          onChanged: (value) => Provider.of<LoginViewModel>(
                              context,
                              listen: false)
                              .setPhone(value),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "البريد الالكتروني",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IBM_Plex_Sans_Arabic'),
                        ),
                        CustomTextField(
                          hintText: 'ادخل البريد الإلكتروني',
                          onChanged: (value) => Provider.of<LoginViewModel>(
                              context,
                              listen: false)
                              .setEmail(value),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              final viewModel = Provider.of<LoginViewModel>(
                                  context,
                                  listen: false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpScreen2(
                                    phone: viewModel.phone,
                                    email: viewModel.email,
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
                              "تسجيل",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBM_Plex_Sans_Arabic',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text.rich(TextSpan(
                          text: "لديك حساب بالفعل؟ ",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBM_Plex_Sans_Arabic',
                          ),
                          children: [
                            TextSpan(
                              text: "تسجيل الدخول",
                              style: const TextStyle(
                                color: Color(0xff409EDC),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBM_Plex_Sans_Arabic',
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const LoginScreen()),
                                  );
                                },
                            ),
                          ],
                        )),
                      ],
                    ),
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
                            "حساب جديد",
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
    );
  }
}
