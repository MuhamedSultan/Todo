import 'package:flutter/material.dart';

typedef myValidator = String? Function(String?);

class CustomFormField extends StatelessWidget {
  String label;
  bool isPassword;
  int lines;
  myValidator? validator;
  TextEditingController controller;
  TextInputType keyboardType;

  CustomFormField(
      {required this.label,
        required this.validator,
        required this.controller,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,this.lines=1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: lines,
      minLines: lines,
      controller: controller,
      validator:validator,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
