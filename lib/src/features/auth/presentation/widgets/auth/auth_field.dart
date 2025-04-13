import 'package:blogapp/src/core/utils/validator_email_password.dart';
import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final String hinTex;
  final TextEditingController controller;
  final bool isObscureText;
  final bool isEmail;
  final bool isPassword;

  const AuthField({
    super.key,
    required this.hinTex,
    required this.controller,
    this.isObscureText = false,
    this.isEmail = false,
    this.isPassword = false,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isObscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: widget.hinTex,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      controller: widget.controller,
      obscureText: _obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor ingresa ${widget.hinTex}';
        }
        if (widget.isEmail && !ValidatorEmailPassword.isValidEmail(value)) {
          return 'Por favor ingresa un email válido';
        }
        if (widget.isPassword &&
            !ValidatorEmailPassword.isValidPassword(value)) {
          return 'La contraseña debe tener al menos 6 caracteres, una mayúscula y un carácter especial';
        }
        return null;
      },
    );
  }
}
