part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  BlogUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}

final class BlogFecthAllBlogs extends BlogEvent {}

class DeleteBlog extends BlogEvent {
  final String blogId;
  DeleteBlog(this.blogId);
}

class EditBlog extends BlogEvent {
  final String blogId;
  final File? image;
  final String title;
  final String content;
  final List<String> topics;

  EditBlog({
    required this.blogId,
    this.image,
    required this.title,
    required this.content,
    required this.topics,
  });
}
