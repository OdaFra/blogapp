import 'package:blogapp/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blogapp/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blogapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:blogapp/src/features/auth/domain/usescases/user_sign_up.dart';
import 'package:blogapp/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/core/secrets/secrets.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependecies() async {
  _initAuth();

  await AppSecrets.loadEnv();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
    debug: true,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  //==>DataSources
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        client: serviceLocator(),
      ),
    )
    //==>Repositories
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
      ),
    )
    //==>UseCases
    ..registerFactory(
      () => UserSignUp(
        authRepository: serviceLocator(),
      ),
    )
    //==>Blocs
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
      ),
    );
}
