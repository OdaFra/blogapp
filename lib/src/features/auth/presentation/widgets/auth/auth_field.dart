import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hinTex;
  const AuthField({super.key, required this.hinTex});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hinTex,
      ),
    );
  }
}
