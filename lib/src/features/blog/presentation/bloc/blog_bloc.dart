import 'dart:io';

import 'package:blogapp/src/core/usecase/usecase.dart';
import 'package:blogapp/src/features/blog/domain/entities/blog.dart';
import 'package:blogapp/src/features/blog/domain/usescases/get_all_blogs.dart';
import 'package:blogapp/src/features/blog/domain/usescases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlogUseCase _uploadBlogUseCase;
  final GetAllBlogsUseCase _getAllBlogsUseCase;
  BlogBloc({
    required UploadBlogUseCase uploadBlogUseCase,
    required GetAllBlogsUseCase getAllBlogsUseCase,
  })  : _uploadBlogUseCase = uploadBlogUseCase,
        _getAllBlogsUseCase = getAllBlogsUseCase,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFecthAllBlogs>(_onFetchAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final result = await _uploadBlogUseCase(UploadBlogParams(
      posterId: event.posterId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));
    result.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blog) => emit(BlogUploadSuccess()),
    );
  }

  void _onFetchAllBlogs(
      BlogFecthAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogsUseCase(NoParams());
    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blogs) => emit(BlogDisplaySuccess(blogs)),
    );
  }
}
