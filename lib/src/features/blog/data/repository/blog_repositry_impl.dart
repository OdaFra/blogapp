import 'dart:io';

import 'package:blogapp/src/core/constants/constants.dart';
import 'package:blogapp/src/core/error/exceptions.dart';
import 'package:blogapp/src/core/error/failure.dart';
import 'package:blogapp/src/core/network/connection_check.dart';
import 'package:blogapp/src/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blogapp/src/features/blog/data/datasources/blog_remote_data_sources.dart';
import 'package:blogapp/src/features/blog/data/models/blog_model.dart';
import 'package:blogapp/src/features/blog/domain/entities/blog.dart';
import 'package:blogapp/src/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositryImpl implements BlogRepository {
  final BlogRemoteDataSource remoteDataSource;
  final BlogLocalDataSource localDataSource;
  final ConnectionCheck connectionCheck;

  BlogRepositryImpl({
    required this.localDataSource,
    required this.connectionCheck,
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionCheck.isConnected) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await remoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );
      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlog = await remoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await connectionCheck.isConnected) {
        final blogs = localDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await remoteDataSource.getAllBlogs();
      localDataSource.uploadLocalBlog(blogs: blogs);

      return right(blogs);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteBlog(String blogId) async {
    try {
      if (!await connectionCheck.isConnected) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      // 1. Obtener el blog para extraer el image_url
      final blog = await remoteDataSource.getBlogById(blogId);

      // 2. Eliminar usando el image_url si existe
      await remoteDataSource.deleteBlog(
        blogId,
        imagePath: blog?.imageUrl,
      );

      // 3. Eliminar de la caché local
      localDataSource.deleteLocalBlog(blogId);

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Blog>> editBlog({
    required String blogId,
    File? image,
    required String title,
    required String content,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionCheck.isConnected) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      String? imageUrl;
      if (image != null) {
        // Obtener blog actual para URL de imagen existente
        final currentBlog = await remoteDataSource.getBlogById(blogId);

        // Subir nueva imagen (maneja eliminación de la anterior)
        imageUrl = await remoteDataSource.uploadBlogImage(
          image: image,
          blog: BlogModel(
            id: blogId,
            posterId: '',
            title: title,
            content: content,
            imageUrl: '',
            topics: topics,
            updatedAt: DateTime.now(),
          ),
          currentImageUrl: currentBlog?.imageUrl,
        );
      }

      // Actualizar blog con nueva URL de imagen (incluye cache busting)
      final updatedBlog = await remoteDataSource.editBlog(
        blogId: blogId,
        title: title,
        content: content,
        topics: topics,
        imageUrl: imageUrl,
      );

      // Limpiar caché local
      localDataSource.updateLocalBlog(updatedBlog);

      return right(updatedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
