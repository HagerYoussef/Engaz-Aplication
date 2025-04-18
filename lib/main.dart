import 'package:engaz_app/features/auth/login/view/login_screen.dart';
import 'package:engaz_app/features/auth/login/viewmodel/login_viewmodel.dart';
import 'package:engaz_app/features/splash/viewmodel/splash_viewmodel.dart';
import 'package:engaz_app/features/translation%20_request/view/translation_request_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/routing/app_routes.dart';
import 'features/address/view/address.dart';
import 'features/address/view_model/add_address_view_model.dart';
import 'features/auth/forgetPassword/view/otp_screen.dart';
import 'features/home_screen/view/home_view.dart';
import 'features/language/language_screen.dart' hide LanguageScreen;
import 'features/localization/change_lang.dart';
import 'features/order_details/order_details_page.dart';
import 'features/orders/orders_screen.dart';
import 'features/printing_with_api/print.dart';
import 'features/settings/settings_screen.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SplashViewModel()),
            ChangeNotifierProvider(create: (_) => LoginViewModel()),
            ChangeNotifierProvider(create: (_) => AddAddressViewModel()),
            ChangeNotifierProvider(create: (_) => LocalizationProvider()),
          ],
      child : MyApp()
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
      locale: localeProvider.locale, // تطبيق اللغة المختارة
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: [
        // تفويض الترجمة هنا
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,

      ],
      home:  OrderDetailsPage(),
    );
  }
}

// void main() => runApp(TranslationOrderApp());
//
// class TranslationOrderApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Translation Order',
//       home: TranslationOrderForm(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class TranslationOrderForm extends StatefulWidget {
//   @override
//   _TranslationOrderFormState createState() => _TranslationOrderFormState();
// }
//
// class _TranslationOrderFormState extends State<TranslationOrderForm> {
//   final _formKey = GlobalKey<FormState>();
//   String? fileLanguage;
//   List<String> translationLanguages = [];
//   String? deliveryMethod;
//   String? address;
//   String? notes;
//   List<PlatformFile> uploadedFiles = [];
//
//   final List<String> allLanguages = ['Arabic', 'English', 'French', 'Dutch'];
//
//   final authHeader = {
//     'Authorization':
//     'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YWJkMWIzNi0xZGQxLTQ2MDktYTE2NC1kZTg5YmM1YWYwMWQiLCJ1c2VybmFtZSI6IkJhc3NlbCBTYWxsYW0iLCJlbWFpbCI6ImJhc3NlbGEuc2FsYW1AZ21haWwuY29tIiwidmVyZmllZCI6dHJ1ZSwiaWF0IjoxNzQ0OTA0ODYxfQ.VqWDf8dTsutW3qCrALQkI-U_7uZvGzH2Cqs-6v99H5k'
//   };
//
//   Future<void> submitOrder() async {
//     final uri = Uri.parse('https://wckb4f4m-3000.euw.devtunnels.ms/api/order/translation');
//     final request = http.MultipartRequest('POST', uri);
//     request.headers.addAll(authHeader);
//
//     request.fields['fileLanguage'] = fileLanguage ?? '';
//     request.fields['translationLanguages'] = translationLanguages.join(','); // Send as CSV
//
//     request.fields['methodOfDelivery'] = deliveryMethod ?? '';
//     request.fields['notes'] = notes ?? '';
//     if (deliveryMethod == 'Home') {
//       request.fields['address'] = address ?? '';
//     }
//
//     for (var file in uploadedFiles) {
//       request.files.add(await http.MultipartFile.fromPath('otherDocs', file.path!));
//     }
//
//     final response = await request.send();
//     final result = await response.stream.bytesToString();
//
//     if (response.statusCode == 200) {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(content: Text('Success: $result')),
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(content: Text('Error: $result')),
//       );
//     }
//   }
//
//   void _showLanguageDialog() async {
//     final List<String> tempSelected = List.from(translationLanguages);
//
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               title: Text('Select Translation Languages'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   children: allLanguages.map((lang) {
//                     return CheckboxListTile(
//                       title: Text(lang),
//                       value: tempSelected.contains(lang),
//                       onChanged: (selected) {
//                         setDialogState(() {
//                           if (selected == true) {
//                             tempSelected.add(lang);
//                           } else {
//                             tempSelected.remove(lang);
//                           }
//                         });
//                       },
//                     );
//                   }).toList(),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       translationLanguages = tempSelected;
//                     });
//                     Navigator.pop(context);
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Translation Order')),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(labelText: 'File Language'),
//                 items: ['Arabic', 'English']
//                     .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
//                     .toList(),
//                 onChanged: (value) => setState(() => fileLanguage = value),
//                 validator: (value) => value == null ? 'Required' : null,
//               ),
//               SizedBox(height: 15),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Translation Languages", style: TextStyle(fontWeight: FontWeight.bold)),
//                   SizedBox(height: 5),
//                   ElevatedButton(
//                     onPressed: _showLanguageDialog,
//                     child: Text("Select Languages"),
//                   ),
//                   Wrap(
//                     spacing: 6.0,
//                     children: translationLanguages.map((lang) => Chip(label: Text(lang))).toList(),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 15),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(labelText: 'Method of Delivery'),
//                 items: ['Office', 'Home']
//                     .map((method) => DropdownMenuItem(value: method, child: Text(method)))
//                     .toList(),
//                 onChanged: (value) => setState(() => deliveryMethod = value),
//                 validator: (value) => value == null ? 'Required' : null,
//               ),
//               if (deliveryMethod == 'Home')
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Address'),
//                   onChanged: (value) => address = value,
//                 ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Notes'),
//                 onChanged: (value) => notes = value,
//                 maxLines: 3,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   final result = await FilePicker.platform.pickFiles(allowMultiple: true);
//                   if (result != null) {
//                     setState(() {
//                       uploadedFiles = result.files;
//                     });
//                   }
//                 },
//                 child: Text('Upload Documents'),
//               ),
//               SizedBox(height: 10),
//               Text('${uploadedFiles.length} file(s) selected'),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   bool isValid = _formKey.currentState!.validate();
//
//                   if (!isValid || translationLanguages.isEmpty || uploadedFiles.isEmpty) {
//                     if (translationLanguages.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Please select at least one translation language.')),
//                       );
//                     }
//                     if (uploadedFiles.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Please upload at least one document.')),
//                       );
//                     }
//                     return;
//                   }
//
//                   submitOrder();
//                 },
//
//                 child: Text('Submit Order'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
