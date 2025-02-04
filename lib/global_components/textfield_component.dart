import 'package:flutter/material.dart';
import 'package:uas_flutter/themes.dart';

class TextfieldComponent extends StatelessWidget {
  const TextfieldComponent(
      {required this.controller,
      required this.inputType,
      required this.inputAction,
      required this.hint,
      this.isObscure = false,
      this.hasSuffix = false,
      this.onPressed,
      super.key});

  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final String hint;
  final bool isObscure;

  // Default Variable apabila text field nya ingin ada suffix icon nya atu tidak
  final bool hasSuffix;

  // CALLBACK METHOD UNTUK MENDEFINISIKAN YANG AKAN TERJADI JIKA SUFFIX ICON NYA DITEKAN
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: mediumText12,
      keyboardType: inputType,
      textInputAction: inputAction,
      obscureText: isObscure,
      decoration: InputDecoration(
          suffixIcon: hasSuffix
              ? IconButton(
                  onPressed: onPressed,
                  icon:
                      Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: grayColor),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: grayColor),
            borderRadius: BorderRadius.circular(5.0),
          ),
          hintText: hint,
          hintStyle: regularText12),
    );
  }
}
