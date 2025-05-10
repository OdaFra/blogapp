// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintext;
  final int? minLines;
  const BlogEditor(
      {super.key,
      required this.controller,
      required this.hintext,
      this.minLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintext),
      maxLines: null,
      minLines: minLines,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor, introduzca algún texto para $hintext';
        }
        return null;
      },
    );
  }
}
