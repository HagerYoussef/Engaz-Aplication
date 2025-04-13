import 'package:engaz_app/features/general_settings/change_email_screen.dart';
import 'package:engaz_app/features/general_settings/change_phone_screen.dart';
import 'package:flutter/material.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  bool _isImage44 = true;

  void _toggleImage() {
    setState(() {
      _isImage44 = !_isImage44;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    Icon(Icons.arrow_back_ios, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "الإعدادات العامة",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    "assets/images/img1.png",
                    width: 120,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                          "تغيير رقم الجوال", "assets/images/img40.png",(){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>ChangePhoneScreen()));
                      }),
                      _buildSettingsItem(
                          "تغيير البريد الإلكتروني", "assets/images/img41.png",(){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>ChangeEmailScreen()));

                      }),
                      _buildSettingsItem(
                          "تغيير لغة التطبيق", "assets/images/img42.png",(){
                        //Navigator.push(context,MaterialPageRoute(builder: (context)=>LanguageScreen()));

                      }),
                      _buildSwitchItem("تفعيل الإشعارات"),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => DeleteAccountScreen()));
                  },
                  child: const Text(
                    "حذف الحساب",
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, String icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(icon, width: 24, height: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.right,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Image.asset("assets/images/img43.png", width: 24, height: 24),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap:(){
                //Navigator.push(context,MaterialPageRoute(builder: (context)=>NotificationsScreen()));
              },
              child: Text(
                title,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          GestureDetector(
            onTap: _toggleImage,
            child: Image.asset(
              _isImage44
                  ? "assets/images/img44.png"
                  : "assets/images/img45.png",
              width: 40,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}