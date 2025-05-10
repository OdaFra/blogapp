// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/theme.dart';
import 'show_snackbar.dart';

class ImageHandler {
  static final ImagePicker _picker = ImagePicker();

  /// Método principal para seleccionar y recortar imagen
  static Future<File?> selectAndCropImage(BuildContext context) async {
    try {
      final pickedFile = await _pickImage();
      if (pickedFile == null) {
        debugPrint('No image selected');
        return null;
      }

      final croppedFile = await _cropImage(pickedFile);
      if (croppedFile == null) {
        debugPrint('Image cropping cancelled');
        return null;
      }

      return croppedFile;
    } catch (e, stackTrace) {
      debugPrint('Error in ImageHandler.selectAndCropImage: $e');
      debugPrint('$stackTrace');
      showSnackBar(context, 'Error seleccionando o recortando imagen');
      return null;
    }
  }

  /// Método privado para seleccionar imagen
  static Future<File?> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Comprime un poco la imagen
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      throw Exception('Error al obtener imagen: $e');
    }
    return null;
  }

  /// Método privado para recortar imagen
  static Future<File?> _cropImage(File imageFile) async {
    try {
      final CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar Imagen',
            toolbarColor: ColorTheme.gradient1,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: 'Recortar Imagen',
            cancelButtonTitle: 'Cancelar',
            doneButtonTitle: 'Hecho',
            minimumAspectRatio: 1.0,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );

      if (croppedImage == null) return null;
      return File(croppedImage.path);
    } catch (e) {
      debugPrint('Error al recortar imagen: $e');
      return null;
    }
  }
}
