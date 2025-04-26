import 'package:blogapp/src/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlog({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
  void deleteLocalBlog(String blogId);
  void updateLocalBlog(BlogModel blog);
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;

  BlogLocalDataSourceImpl(this.box);
  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fronJsom(box.get(i.toString())));
      }
    });
    return blogs;
  }

  @override
  void uploadLocalBlog({required List<BlogModel> blogs}) {
    box.clear();

    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(
          'blog${i.toString()}',
          blogs[i].toJson(),
        );
      }
    });
  }

  @override
  void deleteLocalBlog(String blogId) {
    box.delete(blogId);
  }

  @override
  void updateLocalBlog(BlogModel blog) {
    box.put(blog.id, blog.toJson());
  }
}
