import 'package:flutter/material.dart';

class ColorTheme {
  // Fondos oscuros
  static const Color backgroundColor = Color(0xFF121212); // Negro profundo
  static const Color cardBackground = Color(0xFF1E1E1E); // Gris oscuro profundo

  // Gradientes oscuros (mismos tonos pero más saturados)
  static const Color gradient1 = Color(0xFF5E60CE); // Azul violeta vibrante
  static const Color gradient2 = Color(0xFF4EA8DE); // Azul cielo intenso
  static const Color gradient3 = Color(0xFF48BFE3); // Azul turquesa brillante

  // Bordes y divisiones oscuras
  static const Color borderColor = Color(0xFF333333); // Gris oscuro
  static const Color dividerColor = Color(0xFF252525); // Divisor más oscuro

  // Colores neutros oscuros
  static const Color whiteColor = Color(0xFFE0E0E0); // Blanco suavizado
  static const Color greyColor = Color(0xFF7A7A7A); // Gris medio

  // Colores funcionales (versiones oscuras)
  static const Color errorColor = Color(0xFFCF6679); // Rojo suave oscuro
  static const Color successColor = Color(0xFF81C784); // Verde suave oscuro
  static const Color warningColor = Color(0xFFFFB74D); // Amarillo suave oscuro

  // Transparencia
  static const Color transparentColor = Colors.transparent;

  // Textos (claros para contraste con fondo oscuro)
  static const Color textPrimary = Color(0xFFE0E0E0); // Blanco/gris claro
  static const Color textSecondary = Color(0xFFA0A0A0); // Gris claro
}
