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

      await remoteDataSource.deleteBlog(blogId);
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
        imageUrl = await remoteDataSource.uploadBlogImage(
          image: image,
          blog: BlogModel(
            id: blogId,
            posterId: '', // No necesario para la imagen
            title: title,
            content: content,
            imageUrl: '',
            topics: topics,
            updatedAt: DateTime.now(),
          ),
        );
      }

      final updatedBlog = await remoteDataSource.editBlog(
        blogId: blogId,
        title: title,
        content: content,
        topics: topics,
        imageUrl: imageUrl,
      );

      localDataSource.updateLocalBlog(updatedBlog);

      return right(updatedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
