import 'package:blogapp/src/core/error/failure.dart';
import 'package:blogapp/src/core/usecase/usecase.dart';
import 'package:blogapp/src/features/blog/domain/entities/blog.dart';
import 'package:blogapp/src/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogsUseCase implements Usecase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;
  GetAllBlogsUseCase({required this.blogRepository});
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
