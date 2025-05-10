import 'package:blogapp/src/core/common/entity/user.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/error.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();

  Future<Either<Failure, void>> logout();
}
