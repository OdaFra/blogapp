import 'package:blogapp/src/features/auth/domain/entity/user.dart';
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
}
