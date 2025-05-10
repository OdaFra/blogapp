// En tu archivo constants.dart o donde tengas definidos los temas
import 'package:flutter/material.dart';

class Constants {
  static const List<String> topics = [
    'Tecnología',
    'Programación',
    'Entretenimiento',
    'Negocios',
    'Ciencia',
    'Deportes'
  ];

  // Mapa de colores para cada tema
  static const Map<String, Color> topicColors = {
    'Tecnología': Colors.blueAccent,
    'Programación': Colors.indigo,
    'Entretenimiento': Colors.purple,
    'Negocios': Colors.teal,
    'Ciencia': Colors.green,
    'Deportes': Colors.redAccent,
  };

  // Mapa de íconos para cada tema
  static const Map<String, IconData> topicIcons = {
    'Tecnología': Icons.computer,
    'Programación': Icons.code,
    'Entretenimiento': Icons.movie,
    'Negocios': Icons.business_center,
    'Ciencia': Icons.science,
    'Deportes': Icons.sports_soccer,
  };

  static const noConnectionErrorMessage = 'Sin conexión a Internet';
}
