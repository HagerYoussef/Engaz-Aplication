import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/change_lang.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginTextField extends StatefulWidget {
  const LoginTextField({super.key});

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final locale = context.read<LocalizationProvider>().locale;
    debugPrint("✅ Current locale: ${locale.languageCode}");
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    _controller = TextEditingController(text: viewModel.userInput);
    _controller.addListener(() {
      viewModel.setUserInput(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final langCode = context.watch<LocalizationProvider>().locale.languageCode;
    final isPhone = viewModel.isPhoneSelected;

    return Directionality(
      textDirection: langCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFF409DDC),
            selectionColor: Color(0xFF409DDC),
            selectionHandleColor: Color(0xFF409DDC),
          ),
        ),
        child: TextFormField(
          key: ValueKey(isPhone),
          controller: _controller,
          textInputAction: TextInputAction.next,
          cursorColor: const Color(0xFF409DDC),
          keyboardType:
          isPhone ? TextInputType.phone : TextInputType.emailAddress,
          autofillHints: [
            isPhone ? AutofillHints.telephoneNumber : AutofillHints.email
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return isPhone
                  ? Translations.getText('enter2', langCode)
                  : Translations.getText('enter3', langCode);
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: isPhone
                ? Translations.getText('enter2', langCode)
                : Translations.getText('enter3', langCode),
            hintStyle: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontFamily: 'IBM_Plex_Sans_Arabic',
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ),
    );
  }
}
