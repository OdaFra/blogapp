import 'dart:io';

import 'package:blogapp/src/core/usecase/usecase.dart';
import 'package:blogapp/src/features/blog/domain/entities/blog.dart';
import 'package:blogapp/src/features/blog/domain/usescases/delete_blog.dart';
import 'package:blogapp/src/features/blog/domain/usescases/edit_blog.dart';
import 'package:blogapp/src/features/blog/domain/usescases/get_all_blogs.dart';
import 'package:blogapp/src/features/blog/domain/usescases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlogUseCase _uploadBlogUseCase;
  final GetAllBlogsUseCase _getAllBlogsUseCase;
  final DeleteBlogUseCase _deleteBlogUseCase;
  final EditBlogUseCase _editBlogUseCase;

  BlogBloc({
    required UploadBlogUseCase uploadBlogUseCase,
    required GetAllBlogsUseCase getAllBlogsUseCase,
    required DeleteBlogUseCase deleteBlogUseCase,
    required EditBlogUseCase editBlogUseCase,
  })  : _uploadBlogUseCase = uploadBlogUseCase,
        _getAllBlogsUseCase = getAllBlogsUseCase,
        _deleteBlogUseCase = deleteBlogUseCase,
        _editBlogUseCase = editBlogUseCase,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFecthAllBlogs>(_onFetchAllBlogs);
    on<DeleteBlog>(_onDeleteBlog);
    on<EditBlog>(_onEditBlog);
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

  void _onDeleteBlog(DeleteBlog event, Emitter<BlogState> emit) async {
    final result = await _deleteBlogUseCase(event.blogId);
    result.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (_) {
        emit(BlogDeleteSuccess());
        add(BlogFecthAllBlogs());
      },
    );
  }

  void _onEditBlog(EditBlog event, Emitter<BlogState> emit) async {
    final result = await _editBlogUseCase(EditBlogParams(
      blogId: event.blogId,
      image: event.image,
      title: event.title,
      content: event.content,
      topics: event.topics,
    ));

    result.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blog) {
        emit(BlogEditSuccess(blog));
        add(BlogFecthAllBlogs());
      },
    );
  }
}
