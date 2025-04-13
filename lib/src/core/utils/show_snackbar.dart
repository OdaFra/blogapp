import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = Colors.redAccent,
  Color textColor = Colors.white,
  double borderRadius = 12.0,
  Duration duration = const Duration(seconds: 3),
  SnackBarBehavior behavior = SnackBarBehavior.floating,
  EdgeInsetsGeometry margin = const EdgeInsets.all(20.0),
  IconData? icon,
  Color? iconColor,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                color: iconColor ?? textColor,
              ),
            if (icon != null) const SizedBox(width: 8),
            Expanded(
              child: Center(
                child: Text(
                  message,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: behavior,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        margin: behavior == SnackBarBehavior.floating ? margin : null,
      ),
    );
}
