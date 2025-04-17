import 'package:flutter/material.dart';

import '../contact_us/contactus_screen.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../general_settings/general_settings_screen.dart';
import '../privacy_policy/privacy_policy_screen.dart';
import '../saved_order/view/saved_order.dart';
import '../terms_and_conditions/terms_and_conditions_screen.dart';
import '../usage_policy/usage_polict_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "المزيد",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Spacer(),
                    Image.asset("assets/images/img9.png", height: 40),
                  ],
                ),
                const SizedBox(height: 24),
                buildSection([
                  buildSettingItem(context, "الملف الشخصي", Icons.person,
                      "assets/images/img26.png", EditProfileScreen()
                  ),
                  buildSettingItem(context, "عناويني", Icons.info,
                      "assets/images/img27.png", SavedAddress()
                  ),
                ]),
                const SizedBox(height: 12),
                buildSection([
                  buildSettingItem(context, "إعدادات عامة", Icons.settings,
                      "assets/images/img28.png", GeneralSettingsScreen()
                  ),
                  buildSettingItem(context, "تواصل معنا", Icons.phone,
                      "assets/images/img29.png", ContactUsScreen()
                  ),
                ]),
                const SizedBox(height: 12),
                buildSection([
                  buildSettingItem(context, "سياسة الاستخدام", Icons.security,
                      "assets/images/img30.png", UsagePolicyScreen()
                  ),
                  buildSettingItem(context, "الشروط والأحكام", Icons.rule,
                      "assets/images/img31.png", TermsAndConditionsScreen()
                  ),
                  buildSettingItem(context, "سياسة الخصوصية", Icons.privacy_tip,
                      "assets/images/img32.png", PrivacyPolicyScreen()
                  ),
                ]),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap:(){
                      //Navigator.push(context,MaterialPageRoute(builder:(context)=>LogOut()));
                    },
                    child: Row(
                      children: [
                        Image.asset("assets/images/img33.png"),
                        const SizedBox(width: 8),
                        const Text("تسجيل الخروج",
                            style: TextStyle(color: Color(0xffE50930))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text("تابعنا عبر",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/images/img34.png"),
                    Image.asset("assets/images/img35.png"),
                    Image.asset("assets/images/img36.png"),
                    Image.asset("assets/images/img37.png"),
                    Image.asset("assets/images/img38.png"),
                    Image.asset("assets/images/img39.png"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSettingItem(
      BuildContext context,
      String title,
      IconData icon,
      String imagePath,
      Widget targetScreen,
      ) {
    return ListTile(
      tileColor: Colors.white,
      leading: Image.asset(imagePath, width: 24, height: 24),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
    );
  }

  Widget buildSection(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              items[index],
            ],
          );
        }),
      ),
    );
  }
}