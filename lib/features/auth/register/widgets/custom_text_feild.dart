import 'package:engaz_app/features/auth/login/viewmodel/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../localization/change_lang.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final Function(String)? onChanged;

  const CustomTextField({Key? key, required this.hintText, this.onChanged})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LocalizationProvider>().locale.languageCode;

    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color.fromRGBO(64, 157, 220, 1),
              selectionColor: Color.fromRGBO(64, 157, 220, 1),
              selectionHandleColor: Color.fromRGBO(64, 157, 220, 1),
            ),
          ),
          child: TextFormField(
            controller: _controller,
            cursorColor: Color.fromRGBO(64, 157, 220, 1),
            textDirection: langCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            textAlign: langCode == 'ar' ? TextAlign.right : TextAlign.left,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              viewModel.setUserInput(value);
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                if (widget.hintText == Translations.getText('enter_first_name', langCode)) {
                  return Translations.getText('first_name_required', langCode);
                } else if (widget.hintText == Translations.getText('enter_last_name', langCode)) {
                  return Translations.getText('last_name_required', langCode);
                } else if (widget.hintText == Translations.getText('enter_phone', langCode)) {
                  return Translations.getText('phone_required', langCode);
                } else if (widget.hintText == Translations.getText('enter_email', langCode)) {
                  return Translations.getText('email_required', langCode);
                }
                return Translations.getText('field_required', langCode);
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: const Color(0xffB3B3B3),
                fontWeight: FontWeight.w500,
                fontFamily: 'IBM_Plex_Sans_Arabic',
                fontSize: 13,
              ),
              hintTextDirection: langCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              filled: true,
              fillColor: const Color(0xffFAFAFA),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        );
      },
    );
  }
}