import 'dart:io';

import 'package:blogapp/src/core/error/failure.dart';
import 'package:blogapp/src/core/usecase/usecase.dart';
import 'package:blogapp/src/features/blog/domain/entities/blog.dart';
import 'package:blogapp/src/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlogUseCase implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlogUseCase({required this.blogRepository});
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
