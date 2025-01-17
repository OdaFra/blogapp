import 'package:blogapp/src/core/error/exceptions.dart';
import 'package:blogapp/src/core/error/failure.dart';
import 'package:blogapp/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blogapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(
    this.remoteDataSource,
  );
  @override
  Future<Either<Failure, String>> loginWithEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final userId = await remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        unsername: username,
      );
      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
