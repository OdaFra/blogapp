// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:blogapp/src/core/error/exceptions.dart';
import 'package:blogapp/src/features/blog/data/models/blog_model.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
    String? currentImageUrl,
  });
  Future<List<BlogModel>> getAllBlogs();
  Future<void> deleteBlog(String blogId, {String? imagePath});
  Future<BlogModel?> getBlogById(String blogId);
  Future<BlogModel> editBlog({
    required String blogId,
    required String title,
    required String content,
    required List<String> topics,
    String? imageUrl,
  });
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl({
    required this.supabaseClient,
  });

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fronJsom(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
    String? currentImageUrl,
  }) async {
    try {
      // 1. Eliminar imagen existente si hay una URL previa
      if (currentImageUrl != null && currentImageUrl.isNotEmpty) {
        try {
          final uri = Uri.parse(currentImageUrl);
          final fileName = uri.pathSegments.last;

          // Verificación adicional para asegurar que estamos eliminando el archivo correcto
          if (fileName.isNotEmpty) {
            debugPrint('Eliminando imagen anterior: $fileName');
            await supabaseClient.storage.from('blog_images').remove([fileName]);

            // Pequeño delay para asegurar que Supabase procese la eliminación
            await Future.delayed(const Duration(milliseconds: 300));

            // Verificar eliminación (opcional)
            try {
              final exists = await supabaseClient.storage
                  .from('blog_images')
                  .createSignedUrl(fileName, 60); // Intenta generar URL
              debugPrint(
                  '¡La imagen anterior aún existe! Esto no debería pasar');
            } catch (_) {
              debugPrint('Imagen anterior eliminada con éxito');
            }
          }
        } on StorageException catch (e) {
          if (!e.message.toLowerCase().contains('not found')) {
            debugPrint('Error al eliminar imagen anterior: ${e.message}');
            rethrow;
          }
          debugPrint('Imagen anterior no existía, continuando...');
        }
      }

      // 2. Subir nueva imagen con cache busting
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uploadResponse =
          await supabaseClient.storage.from('blog_images').upload(
                '${blog.id}_$timestamp',
                image,
                fileOptions: const FileOptions(upsert: true),
              );

      debugPrint('Upload response: $uploadResponse');

      // 3. Obtener URL pública con parámetro de cache busting
      final publicUrl =
          '${supabaseClient.storage.from('blog_images').getPublicUrl('${blog.id}_$timestamp')}?t=$timestamp';

      return publicUrl;
    } on StorageException catch (e) {
      debugPrint('Error en uploadBlogImage: ${e.message}');
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles(username)');

      return blogs
          .map(
            (blog) => BlogModel.fronJsom(blog).copyWith(
              posterName: blog['profiles']['username'] as String,
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteBlog(String blogId, {String? imagePath}) async {
    try {
      // 1. Eliminar imagen del storage si se proporciona path
      if (imagePath != null) {
        try {
          // Extraer el nombre del archivo de la URL
          final uri = Uri.parse(imagePath);
          final fileName = uri.pathSegments.last;

          await supabaseClient.storage.from('blog_images').remove([fileName]);

          debugPrint('Imagen eliminada del storage: $fileName');
        } on StorageException catch (e) {
          if (!e.message.toLowerCase().contains('not found')) {
            rethrow;
          }
          // Archivo no encontrado, continuar normalmente
        }
      }

      // 2. Eliminar registro de la tabla
      await supabaseClient.from('blogs').delete().eq('id', blogId);
      debugPrint('Blog eliminado de la tabla: $blogId');
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } on StorageException catch (e) {
      throw ServerException(message: 'Error al eliminar imagen: ${e.message}');
    } catch (e) {
      throw ServerException(message: 'Error al eliminar blog: ${e.toString()}');
    }
  }

  @override
  Future<BlogModel> editBlog({
    required String blogId,
    required String title,
    required String content,
    required List<String> topics,
    String? imageUrl,
  }) async {
    try {
      final updateData = {
        'title': title,
        'content': content,
        'topics': topics,
        'updated_at': DateTime.now().toIso8601String(),
        if (imageUrl != null) 'image_url': imageUrl,
      };

      // Primero actualiza la imagen en storage (si hay nueva imagen)
      if (imageUrl != null) {
        // Forzar actualización de caché limpiando la URL antigua
        updateData['image_url'] =
            '$imageUrl&t=${DateTime.now().millisecondsSinceEpoch}';
      }

      final blogData = await supabaseClient
          .from('blogs')
          .update(updateData)
          .eq('id', blogId)
          .select();

      return BlogModel.fronJsom(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<BlogModel?> getBlogById(String blogId) async {
    try {
      final response = await supabaseClient
          .from('blogs')
          .select()
          .eq('id', blogId)
          .maybeSingle();

      return response != null ? BlogModel.fronJsom(response) : null;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    }
  }
}
