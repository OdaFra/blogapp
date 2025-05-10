import 'dart:io';

import 'package:blogapp/src/core/error/failure.dart';
import 'package:blogapp/src/core/usecase/usecase.dart';
import 'package:blogapp/src/features/blog/domain/entities/blog.dart';
import 'package:blogapp/src/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class EditBlogParams {
  final String blogId;
  final File? image;
  final String title;
  final String content;
  final List<String> topics;

  EditBlogParams({
    required this.blogId,
    this.image,
    required this.title,
    required this.content,
    required this.topics,
  });
}

class EditBlogUseCase implements Usecase<Blog, EditBlogParams> {
  final BlogRepository blogRepository;
  EditBlogUseCase({
    required this.blogRepository,
  });

  @override
  Future<Either<Failure, Blog>> call(EditBlogParams params) async {
    return await blogRepository.editBlog(
      blogId: params.blogId,
      image: params.image,
      title: params.title,
      content: params.content,
      topics: params.topics,
    );
  }
}
