import 'package:blogapp/src/core/error/failure.dart';
import 'package:blogapp/src/core/usecase/usecase.dart';
import 'package:blogapp/src/core/common/entity/user.dart';
import 'package:blogapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUserUseCase implements Usecase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUserUseCase({
    required this.authRepository,
  });
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUserData();
  }
}
