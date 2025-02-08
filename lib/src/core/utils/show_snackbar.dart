import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String message, {
  Color color = Colors.redAccent,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
}
