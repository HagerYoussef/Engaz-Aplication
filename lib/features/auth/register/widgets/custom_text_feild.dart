import 'package:engaz_app/features/auth/login/viewmodel/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color.fromRGBO(64, 157, 220, 1), // لون المؤشر
            selectionColor:
            Color.fromRGBO(64, 157, 220, 1), // لون التحديد
            selectionHandleColor: Color.fromRGBO(
                64, 157, 220, 1), // لون "اليد" أو مقبض التحديد
          ),
        ),
        child: TextFormField(
          controller: _controller,
          cursorColor: Color.fromRGBO(64, 157, 220, 1),
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            viewModel.setUserInput(value); // تحديث عام للعرض
            if (widget.onChanged != null) {
              widget.onChanged!(value); // تخصيص التغيير للحقل المناسب
            }
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              if (widget.hintText.contains('الاسم الاول')) {
                return 'يرجى إدخال الاسم الأول';
              } else if (widget.hintText.contains('اسم العائلة')) {
                return 'يرجى إدخال اسم العائلة';
              } else if (widget.hintText.contains('رقم الجوال')) {
                return 'يرجى إدخال رقم الجوال';
              } else if (widget.hintText.contains('البريد الإلكتروني') || widget.hintText.contains('البريد الالكتروني')) {
                return 'يرجى إدخال البريد الإلكتروني';
              }
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Color(0xffB3B3B3),
              fontWeight: FontWeight.w500,
              fontFamily: 'IBM_Plex_Sans_Arabic',
              fontSize: 13,
            ),
            filled: true,
            fillColor: const Color(0xffFAFAFA),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      );
    },
  ),
  );
}
}
