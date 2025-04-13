import 'package:blogapp/src/core/common/entity/user.dart';
import 'package:blogapp/src/core/constants/constants.dart';
import 'package:blogapp/src/core/error/exceptions.dart';
import 'package:blogapp/src/core/error/failure.dart';
import 'package:blogapp/src/core/network/connection_check.dart';
import 'package:blogapp/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blogapp/src/features/auth/data/models/user_model.dart';
import 'package:blogapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionCheck connectionCheck;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionCheck,
  });

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        unsername: username,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await connectionCheck.isConnected) {
        final session = remoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure('¡Usuario no conectado!'));
        }
        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }
      final user = await remoteDataSource.getCurrentUser();
      if (user == null) {
        return left(Failure('¡Usuario no conectado!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      if (!await connectionCheck.isConnected) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final userId = await fn();
      return right(userId);
    }
    // on sb.AuthException catch (e) {
    //   return left(Failure(e.message));
    // }
    on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
