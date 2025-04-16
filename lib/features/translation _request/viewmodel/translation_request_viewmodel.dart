import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://wckb4f4m-3000.euw.devtunnels.ms/api';

  static Future<bool> submitTranslationRequest({
    required String fileLanguage,
    required List<String> translationLanguages,
    required String notes,
    required String deliveryMethod,
    String? address,
    required List<PlatformFile> files,
    required String token,
  }) async {
    final uri = Uri.parse('$_baseUrl/order/translation');

    try {
      var request = http.MultipartRequest('POST', uri);

      // إعداد الهيدرات
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // 1. تحويل fileLanguage
      final Map<String, String> languageMap = {
        'Arabic': 'Arabic',
        'English': 'English',
        'Dutch': 'Dutch',
        'French': 'French',
        'Italian': 'Italian',
        'Japanese': 'Japanese',
      };
      request.fields['fileLanguage'] = languageMap[fileLanguage]!;

      // 2. إرسال كل لغة كحقل منفصل ✅
      for (var lang in translationLanguages) {
        String? apiLang = languageMap[lang];
        if (apiLang != null) {
          request.files.add(
            await http.MultipartFile.fromString(
              'translationLanguages', // نفس الاسم لكل لغة
              apiLang,
            ),
          );
        }
      }

      // 3. تحويل deliveryMethod
      request.fields['methodOfDelivery'] = _mapDeliveryMethod(deliveryMethod);

      // 4. إضافة الملاحظات والعنوان
      request.fields['notes'] = notes.isNotEmpty ? notes : "";
      if (deliveryMethod == 'توصيل' && address != null) {
        request.fields['Address'] = address!;
      }

      // 5. إضافة الملفات
      for (var file in files) {
        if (file.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'otherDocs',
              file.path!,
              filename: file.name,
            ),
          );
        }
      }

      // طباعة البيانات للإشكال
      print("Request Fields: ${request.fields}");
      print("Request Files: ${request.files.map((f) => '${f.field}: ${f.filename}').join(', ')}");

      // إرسال الطلب
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('API Error: ${response.statusCode}');
        print('Response body: $responseBody');
        return false;
      }
    } catch (e) {
      print('API Exception: $e');
      return false;
    }
  }

  static String _mapDeliveryMethod(String method) {
    switch (method) {
      case 'استلام من الفرع':
        return 'branch_pickup';
      case 'توصيل':
        return 'delivery';
      case 'Office':
        return 'office'; // تأكد من أن الـ API يدعم هذه القيمة
      default:
        throw Exception('طريقة التوصيل غير صالحة: $method');
    }
  }
}