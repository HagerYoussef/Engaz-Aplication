import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool isArabicSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/images/img23.png"),
        title: Text(
          Translations.getText(
            'language',
            context.read<LocalizationProvider>().locale.languageCode,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isArabicSelected = false;
                      });
                      context
                          .read<LocalizationProvider>()
                          .setLocale(Locale('en'));
                    },
                    child: _buildLanguageOption(
                      context,
                      Translations.getText(
                        'english',
                        context
                            .read<LocalizationProvider>()
                            .locale
                            .languageCode,
                      ),
                      'assets/images/img46.png',
                      !isArabicSelected,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isArabicSelected = true;
                      });
                      context
                          .read<LocalizationProvider>()
                          .setLocale(Locale('ar'));
                    },
                    child: _buildLanguageOption(
                      context,
                      Translations.getText(
                        'arabic',
                        context
                            .read<LocalizationProvider>()
                            .locale
                            .languageCode,
                      ),
                      'assets/images/img47.png',
                      isArabicSelected,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xff28C1ED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton(
                onPressed: () {
                  String selectedLang = isArabicSelected ? "ar" : "en";
                  context
                      .read<LocalizationProvider>()
                      .setLocale(Locale(selectedLang));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff28C1ED),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: Text(
                  Translations.getText(
                    'confirm',
                    context.read<LocalizationProvider>().locale.languageCode,
                  ),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String label, String asset, bool selected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xff28C1ED).withOpacity(.2)
            : const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? const Color(0xff409EDC) : const Color(0xffF2F2F2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Image.asset(asset, height: 40),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

class LocalizationProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

class Translations {
  static Map<String, Map<String, String>> translations = {
    'en': {
      "appTitle": "My App",
      "language": "Language",
      "confirm": "Confirm",
      "arabic": "Arabic",
      "english": "English",
      'profile': 'Profile',
      'addresses': 'Addresses',
      'general_settings': 'General Settings',
      'contact_us': 'Contact Us',
      'usage_policy': 'Usage Policy',
      'terms_and_conditions': 'Terms & Conditions',
      'privacy_policy': 'Privacy Policy',
      'logout': 'Log Out',
      'more': 'More',
      "follow": "Follow us on",
      "first": "First Name",
      "last": "Last Name",
      "save": "Save",
      "saved_address": "Saved addresses",
      "choose": "Choose one of your saved addresses.",
      "add_to_address": "Add a new address",
      "dilvery": "Delivery to this address",
      "general": "General Setting",
      "change": "Change Phone Number",
      "change2": "Change Email Address",
      "change3": "Change Application Language",
      "make": "Activate notifications",
      "delete": "Delete Account",
      "new_phone": "New Mobile Number",
      "pls":
          "Please enter the new mobile number to receive the activation code.",
      "pls2":
          "Please enter the new Email Address to receive the activation code.",
      "sure": "Save",
      "enter2": "Enter mobile number",
      "enter3": "Enter Email Address",
      "new_email": "New Email",
      "contactus": "Contact Us",
      "through": "Through",
      "or": "Or send us a message",
      "name": "Name",
      "name2": "Please Enter Name",
      "address2": "Message title",
      "plss": "Please clarify the subject of your message.",
      "msst": "Message text",
      "ent": "Enter Message Text",
      "s": "Send",
      "term": "Terms and Conditions",
      "use": "Usage policy",
      "pol": "privacy policy",
      "home": "Home",
      "offerr":
          "We provide the best translation services for more than 10 languages around the world.",
      "oferrr2": "We offer the best printing quality at competitive prices.",
      "cat": "Categories",
      "req": "Request",
      "req2": "Request Offer",
      "tran": "Translate",
      "pri": "Print",
      "new": "New",
      "current": "Current",
      "finish": "Finished",
      "expire": "Expired",
      "ord": "My Order",
      "tranorder": "Translate Request",
      "tranorder2": "Printing Request",
      "tranorder3": "Printing Request",
      "nn": "New Print Request",
      "please": "Please attach the files to be printed",
      "att": "Attachments to be printed",
      "please2": "Please add the attachments to be printed",
      "cho": " Choose the printer color",
      "cho2": "Choose the packaging type",
      "num": "Number of pages",
      "num2": "Number of pages to print",
      "num4": "Number of copies to print",
      "num3": "Number of copies",
      "no": "Notes",
      "en": "Enter your notes if any.",
      "se": "Send",
      "dis": "Discount code",
      "enen": "Enter the discount code",
      "reqv": "Request value",
      "v": "services Value",
      "t": "Tax",
      "tt": "Total",
      "p": "Payment",
      "ff": "Follow",
      "nnn": "New Request",
      "rrr": "Retreat", "ordsuc":"The order value has been paid successfully.",

      "editadd":"Edit Address",
      "locname":"Location Name",
      "location":"Location",
    "addadd":"Add Address",
      "savee":"Save Changes"
    },
    'ar': {
      "appTitle": "تطبيقي",
      "language": "لغة التطبيق",
      "confirm": "تأكيد",
      "arabic": "اللغة العربية",
      "english": "الإنجليزية",
      'profile': 'الملف الشخصي',
      'addresses': 'عناويني',
      'general_settings': 'إعدادات عامة',
      'contact_us': 'تواصل معنا',
      'usage_policy': 'سياسة الاستخدام',
      'terms_and_conditions': 'الشروط والأحكام',
      'privacy_policy': 'سياسة الخصوصية',
      'logout': 'تسجيل الخروج',
      'more': 'المزيد',
      "follow": "تابعنا عبر",
      "first": "الاسم الاول",
      "last": "اسم العائله",
      "save": "حفظ التعديلات",
      "saved_address": "العناوين المحفوظه",
      "choose": "اختر احد العناوين الخاصه بك",
      "add_to_address": "اضافه الي عنوان جديد",
      "dilvery": "التوصيل الي هذا العنوان",
      "general": "اعدادات عامه",
      "change": "تغيير رقم الجوال",
      "change2": "تغيير البريد الالكتروني",
      "change3": "تغيير لغه التطبيق",
      "make": "تفعيل الاشعارات",
      "delete": "حدف الحساب",
      "new_phone": "رقم الجوال الجديد",
      "pls": "الرجاء ادخال رقم الجوال الجديد لاستقبال رمز التفعيل",
      "sure": "تأكيد",
      "enter2": "ادخل رقم الجوال",
      "enter3": "ادخل البريد الالكتروني",
      "new_email": "البريد الالكتروني الجديد",
      "pls2": "الرجاء ادخال البريد الالكتروني الجديد لاستقبال رمز التفعيل",
      "contactus": "تواصل معنا",
      "through": "من خلال",
      "or": "او ارسل لنا رساله",
      "name": "الاسم",
      "name2": "ادخل الاسم فضلا",
      "address2": "عنوان الرساله",
      "plss": "الرجاء توضيح عنوان رسالتك",
      "msst": "نص الرساله",
      "ent": "ادخل نص الرساله",
      "s": "Send",
      "use": "سياسه الاستخدام",
      "term": "الشروط والأحكام",
      "pol": "سياسة الخصوصية",
      "home": "الرئيسيه",
      "offerr": "نقدم افضل خدماتالترجمه لاكثر من 10 لغات حول العالم ",
      "oferrr2": "نقدم افضل جوده للطباعه باسعار تنافسيه",
      "cat": "التصنيفات",
      "req": "طلباتي",
      "req2": "طلب الخدمه",
      "tran": "الترجمه",
      "pri": "الطباعه",
      "new": "جديد",
      "current": "حالي",
      "finish": "ملغي",
      "expire": "منتهي",
      "ord": "طلباتي",
      "tranorder": "طلبات ترجمه",
      "tranorder2": "طلبات طباعه",
      "tranorder3": "طلب طباعه",
      "nn": "طلب طباعه جديد",
      "please": " الرجاء ارفاق ابملفات المراد طباعتها",
      "att": " المرفقات المراد طباعتها",
      "please2": ".الرجاء اضافه المرفقات المراد طباعتها",
      "cho": " اختر لون الطابعه",
      "cho2": "اختر نوع التغليف",
      "num": " عدد الصفحات",
      "num2": " عدد الصفحات المراد طباعتها",
      "num3": "عدد النسخ",
      "num4": "عدد النسخ المراد طباعتها",
      "no": "الملاحظات",
      "en": " ادخل الملاحظات الخاصه بك ان وجدت",
      "se": "تاكيد الطلب",
      "dis": "كود الخصم",
      "enen": "ادخل كود الخصم",
      "reqv": "قيمه الطلب",
      "v": "قيمه الخدمات",
      "t": "الضريبه",
      "tt": "الاجمالي",
      "p": "الدفع",
      "ff": "متابعه الطلب",
      "nnn": "طلب خدمه جديده",
      "rrr": "تراجع",
      "ordsuc":"تم تسدسد قيمه الطلب بنجاح",

      "editadd":"تعديل العنوان",
      "locname":"اسم الموقع",
      "location":"الموقع"
      ,"addadd":"اضافه عنوان",
      "savee":"حفظ التعديلات"
    },
  };

  static String getText(String key, String langCode) {
    return translations[langCode]?[key] ?? key;
  }
}
