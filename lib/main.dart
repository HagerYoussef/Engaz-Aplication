import 'dart:convert';
import 'package:engaz_app/features/splash/view/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:engaz_app/features/auth/login/view/login_screen.dart';
import 'package:engaz_app/features/auth/login/viewmodel/login_viewmodel.dart';
import 'package:engaz_app/features/splash/viewmodel/splash_viewmodel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/localization/change_lang.dart';
import 'features/address/view_model/add_address_view_model.dart';
import 'features/auth/forgetPassword/viewmodel/otp_viewmodel.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/*Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📥 [Background] Full message as Map → ${jsonEncode(message.toMap())}");
  print("📦 message.data → ${message.data}");
  _showNotification(message);
}
 */

void _showNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  final title = message.data['title'] ?? notification?.title ?? 'Notification';
  final body = message.data['body'] ?? notification?.body ?? '';

  if (android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  print("🔔 Title: $title");
  print("📃 Body: $body");
}

Future<void> sendTokenToBackend(String fcmToken) async {
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('fcm_token');

  if (authToken == null) {
    print("⚠️ No auth token saved, skipping FCM token upload.");
    return;
  }

  final url = Uri.parse('https://wckb4f4m-3000.euw.devtunnels.ms/api/login/token');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({"token": fcmToken}),
    );
    print("✅ Token sent → ${response.statusCode}: ${response.body}");
  } catch (e) {
    print("❌ Failed to send token: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📥 [Foreground] Full message as Map → ${jsonEncode(message.toMap())}");
    print("📦 message.data → ${message.data}");
    _showNotification(message);
  });

  final token = await FirebaseMessaging.instance.getToken();
  print("📱 FCM Token: $token");

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SplashViewModel()),
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => AddAddressViewModel()),
      ChangeNotifierProvider(create: (_) => LocalizationProvider()),
      ChangeNotifierProvider(create: (_) => OtpViewModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocalizationProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      locale: localeProvider.locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/translate': (context) =>  TranslationOrderApp(),
      },
    );
  }
}

class TranslationOrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TranslationOrderForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TranslationOrderForm extends StatefulWidget {
  @override
  _TranslationOrderFormState createState() => _TranslationOrderFormState();
}

class _TranslationOrderFormState extends State<TranslationOrderForm> {
  final _formKey = GlobalKey<FormState>();
  String? fileLanguage;
  List<String> translationLanguages = [];
  String? deliveryMethod;
  String? address;
  String? notes;
  List<XFile> uploadedFiles = [];
  bool showDeliveryError = false;

  final List<String> allLanguages = ['Arabic', 'English', 'French', 'Dutch'];
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> submitOrder() async {
    final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://wckb4f4m-3000.euw.devtunnels.ms/api/order/translation'));
    request.headers.addAll({
      "Authorization": "Bearer ${await _getToken()}",
      'Connection': 'keep-alive',
    });
    request.fields['fileLanguge'] = fileLanguage ?? '';
    request.fields['methodOfDelivery'] = deliveryMethod ?? '';
    request.fields['notes'] = notes ?? '';
    request.fields['Address'] = address ?? '';
    request.fields['translationLanguges'] = jsonEncode(translationLanguages);
    for (var file in uploadedFiles) {
      if (file.path != null) {
        request.files
            .add(await http.MultipartFile.fromPath('otherDocs', file.path!));
      }
    }

    try {
      final response = await request.send();
      final result = await response.stream.bytesToString();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text(response.statusCode == 200 || response.statusCode == 201
              ? '✅ Success: $result'
              : '❌ Error: $result'),
        ),
      );

    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text('❌ Connection error: $e')),
      );
    }
  }

  void _showLanguageDialog() async {
    final List<String> tempSelected = List.from(translationLanguages);
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Select Translation Languages'),
              content: SingleChildScrollView(
                child: Column(
                  children: allLanguages.map((lang) {
                    return CheckboxListTile(
                      title: Text(lang),
                      value: tempSelected.contains(lang),
                      onChanged: (selected) {
                        setDialogState(() {
                          selected == true
                              ? tempSelected.add(lang)
                              : tempSelected.remove(lang);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    setState(() => translationLanguages = tempSelected);
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
        builder: (context, localizationProvider, child) {
      final locale = localizationProvider.locale.languageCode;
      final textDirection =
          locale == 'ar' ? TextDirection.rtl : TextDirection.ltr;

      return Directionality(
          textDirection: textDirection,
          child: Scaffold(
            backgroundColor: const Color(0xffF8F8F8),
            appBar: AppBar(
              title:  Text(Translations.getText(
                'tranthereq',
                context.read<LocalizationProvider>().locale.languageCode,
              ),
                  style: TextStyle(color: Colors.black)),
              backgroundColor: const Color(0xffF8F8F8),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset("assets/images/img_new.png"),
                    Text(Translations.getText(
                      'newreq',
                      context.read<LocalizationProvider>().locale.languageCode,
                    ),),
                    Text(Translations.getText(
                      'langneed',
                      context.read<LocalizationProvider>().locale.languageCode,
                    ),),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        Translations.getText(
                          'edjat',
                          context.read<LocalizationProvider>().locale.languageCode,
                        ),
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText:Translations.getText(
                          'chooose',
                          context.read<LocalizationProvider>().locale.languageCode,
                        ),
                        filled: true,

                        fillColor: Colors.grey.shade200,

                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide(
                              color: Colors
                                  .transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      items: ['Arabic', 'English']
                          .map((lang) =>
                              DropdownMenuItem(value: lang, child: Text(lang)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => fileLanguage = value),
                      validator: (value) => value == null ? 'مطلوب' : null,
                    ),
                    SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            Translations.getText(
                              'attach',
                              context.read<LocalizationProvider>().locale.languageCode,
                            ),
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),

                        GestureDetector(
                          onTap: _showLanguageDialog,
                          child: AbsorbPointer(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                             labelText:Translations.getText(
                                'chooose',
                                context.read<LocalizationProvider>().locale.languageCode,
                              ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                              ),
                              value: null,
                              items: [],

                              onChanged: null,

                              validator: (value) =>
                                  translationLanguages.isEmpty ? 'مطلوب' : null,
                            ),
                          ),
                        ),

                        SizedBox(height: 5),
                        Wrap(
                          spacing: 6.0,
                          children: translationLanguages
                              .map((lang) => Chip(label: Text(lang)))
                              .toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Translations.getText(
                            'addressway',
                            context.read<LocalizationProvider>().locale.languageCode,
                          ),
                          style: TextStyle(
                               fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text('Office'),
                                value: 'Office',
                                groupValue: deliveryMethod,
                                onChanged: (value) =>
                                    setState(() => deliveryMethod = value),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text('Home'),
                                value: 'Home',
                                groupValue: deliveryMethod,
                                onChanged: (value) =>
                                    setState(() => deliveryMethod = value),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        if (showDeliveryError)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              '⚠️ يرجى اختيار طريقة التوصيل',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    if (deliveryMethod == 'Home')
                      TextFormField(
                        onChanged: (value) => address = value,
                        decoration: InputDecoration(
                          labelText: Translations.getText(
                            'address',
                            context.read<LocalizationProvider>().locale.languageCode,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLines: 3,
                      onChanged: (value) => notes = value,
                      decoration: InputDecoration(
                        labelText: Translations.getText(
                        'notess',
                        context.read<LocalizationProvider>().locale.languageCode,
                      ),
                        filled: true,
                        fillColor: Colors.grey.shade200,

                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        Translations.getText(
                          'attach',
                          context.read<LocalizationProvider>().locale.languageCode,
                        ),
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),

                        color: Colors.grey.shade200,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(
                              child: Text(
                                Translations.getText(
                                  'attach2',
                                  context.read<LocalizationProvider>().locale.languageCode,
                                ),
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final files =
                                    await openFiles(acceptedTypeGroups: [
                                  XTypeGroup(label: 'docs', extensions: [
                                    'pdf',
                                    'doc',
                                    'docx',
                                    'ppt',
                                    'pptx'
                                  ])
                                ]);
                                if (files.isNotEmpty) {
                                  setState(() => uploadedFiles = files);
                                }
                              },
                              child: Icon(Icons.file_upload,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('${uploadedFiles.length} file(s) selected'),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final isValid = _formKey.currentState!.validate();
                          FocusScope.of(context).unfocus();

                          bool hasDelivery = deliveryMethod != null;
                          bool hasLanguages = translationLanguages.isNotEmpty;
                          bool hasFiles = uploadedFiles.isNotEmpty;

                          setState(() {
                            showDeliveryError = !hasDelivery;
                          });

                          if (!isValid || !hasDelivery || !hasLanguages || !hasFiles) {
                            if (!hasLanguages) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('⚠️ اختر لغة واحدة على الأقل')),
                              );
                            }
                            if (!hasFiles) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('⚠️ قم بإرفاق ملف واحد على الأقل')),
                              );
                            }
                            return;
                          }

                          submitOrder();
                        },
                        child: Text(Translations.getText(
                          'send_req',
                          context.read<LocalizationProvider>().locale.languageCode,
                        ),
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff409EDC),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 14),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
