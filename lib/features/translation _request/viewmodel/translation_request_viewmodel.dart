import 'dart:convert';

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
  }) async {
    final uri = Uri.parse('$_baseUrl/order/translation');

    try {
      var request = http.MultipartRequest('POST', uri);


      request.fields['fileLanguage'] = fileLanguage;
      request.fields['translationLanguages'] = jsonEncode(translationLanguages);
      request.fields['notes'] = notes;
      request.fields['methodDelivery'] = deliveryMethod;

      if (deliveryMethod == 'توصيل' && address != null) {
        request.fields['Address'] = address;
      }


      for (var file in files) {
        if (file.path != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'otherDocs',
            file.path!,
            filename: file.name,
          ));
        }
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print('API Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('API Exception: $e');
      return false;
    }
  }
}
