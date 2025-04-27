// En auth/domain/usescases/user_logout.dart
import 'package:blogapp/src/core/error/failure.dart';
import 'package:blogapp/src/core/usecase/usecase.dart';
import 'package:blogapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogoutUseCase implements Usecase<void, NoParams> {
  final AuthRepository authRepository;
  const UserLogoutUseCase({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.logout();
  }
}
