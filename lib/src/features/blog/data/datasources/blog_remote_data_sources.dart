import 'dart:io';

import 'package:blogapp/src/core/error/exceptions.dart';
import 'package:blogapp/src/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
  Future<void> deleteBlog(String blogId);
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
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(
            blog.id,
            image,
          );
      return supabaseClient.storage.from('blog_images').getPublicUrl(
            blog.id,
          );
    } on StorageException catch (e) {
      print('Error: ${e.message}');
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
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
  Future<void> deleteBlog(String blogId) async {
    try {
      // 1. Verificar si existe la imagen en el storage
      try {
        final files =
            await supabaseClient.storage.from('blog_images').list(path: blogId);

        if (files.isNotEmpty) {
          await supabaseClient.storage.from('blog_images').remove([blogId]);

          print('Imagen eliminada del storage: $blogId');
        }
      } on StorageException catch (e) {
        if (!e.message.contains('not found')) {
          print('Error al eliminar imagen: ${e.message}');
          throw ServerException(
              message: 'Error al eliminar imagen: ${e.message}');
        }
      }

      await supabaseClient.from('blogs').delete().eq('id', blogId);
      print('Blog eliminado de la tabla: $blogId');
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(
          message: 'Error al eliminar el blog: ${e.toString()}');
    }
  }

  @override
  Future<BlogModel> editBlog(
      {required String blogId,
      required String title,
      required String content,
      required List<String> topics,
      String? imageUrl}) async {
    try {
      final updateData = {
        'title': title,
        'content': content,
        'topics': topics,
        'updated_at': DateTime.now().toIso8601String(),
        if (imageUrl != null) 'image_url': imageUrl,
      };

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
}
