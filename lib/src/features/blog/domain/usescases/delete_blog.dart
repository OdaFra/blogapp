import 'package:blogapp/src/core/error/failure.dart';
import 'package:blogapp/src/core/usecase/usecase.dart';
import 'package:blogapp/src/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlogUseCase implements Usecase<void, String> {
  final BlogRepository blogRepository;
  DeleteBlogUseCase({
    required this.blogRepository,
  });

  @override
  Future<Either<Failure, void>> call(String blogId) async {
    return await blogRepository.deleteBlog(blogId);
  }
}
