import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool isPass;
  final TextInputType textInputType;
  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      this.isPass = false,
      required this.hintText,
      required this.textInputType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide:
          Divider.createBorderSide(context, color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(10),
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        hintStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
