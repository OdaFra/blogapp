import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hinTex;
  final TextEditingController controller;
  final bool isObscureText;
  const AuthField({
    super.key,
    required this.hinTex,
    required this.controller,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hinTex,
      ),
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter $hinTex';
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
