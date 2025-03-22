import 'package:blogapp/src/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogapp/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blogapp/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blogapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:blogapp/src/features/auth/domain/usescases/current_user.dart';
import 'package:blogapp/src/features/auth/domain/usescases/user_login.dart';
import 'package:blogapp/src/features/auth/domain/usescases/user_sign_up.dart';
import 'package:blogapp/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/src/features/blog/data/datasources/blog_remote_data_sources.dart';
import 'package:blogapp/src/features/blog/data/repository/blog_repositry_impl.dart';
import 'package:blogapp/src/features/blog/domain/repository/blog_repository.dart';
import 'package:blogapp/src/features/blog/domain/usescases/get_all_blogs.dart';
import 'package:blogapp/src/features/blog/domain/usescases/upload_blog.dart';
import 'package:blogapp/src/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/core/secrets/secrets.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependecies() async {
  _initAuth();
  _initBlog();

  await AppSecrets.loadEnv();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
    debug: true,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  //==>DataSources
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
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
      () => UserSignUpUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLoginUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(() => CurrentUserUseCase(
          authRepository: serviceLocator(),
        ))
    //==>Blocs
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUserUseCase: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  //==>DataSources
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(() => BlogRemoteDataSourceImpl(
          supabaseClient: serviceLocator(),
        ))
    //==>Repositories
    ..registerFactory<BlogRepository>(() => BlogRepositryImpl(
          remoteDataSource: serviceLocator(),
        ))
    //==>UseCases
    ..registerFactory(() => UploadBlogUseCase(
          blogRepository: serviceLocator(),
        ))
    ..registerFactory(() => GetAllBlogsUseCase(
          blogRepository: serviceLocator(),
        ))
    //==>Blocs
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlogUseCase: serviceLocator(),
        getAllBlogsUseCase: serviceLocator(),
      ),
    );
}
