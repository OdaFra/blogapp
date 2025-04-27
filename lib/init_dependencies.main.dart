part of 'init_dependencies.dart';

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

// Initialize Supabase
  serviceLocator.registerLazySingleton(() => supabase.client);

// Initialize Hive
  Hive.defaultDirectory = (await getApplicationCacheDirectory()).path;
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  // Internet Connection
  serviceLocator.registerFactory(
    () => InternetConnection(),
  );

  //core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );

  //Check Connection
  serviceLocator.registerFactory<ConnectionCheck>(
    () => ConnectionCheckImpl(
      internetConnection: serviceLocator(),
    ),
  );
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
        connectionCheck: serviceLocator(),
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
    ..registerFactory(
      () => UserLogoutUseCase(authRepository: serviceLocator()),
    )
    //==>Blocs
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUserUseCase: serviceLocator(),
        appUserCubit: serviceLocator(),
        userLogout: serviceLocator(),
      ),
    );
}

void _initBlog() {
  //==>DataSources
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(() => BlogRemoteDataSourceImpl(
          supabaseClient: serviceLocator(),
        ))
    ..registerFactory<BlogLocalDataSource>(
        () => BlogLocalDataSourceImpl(serviceLocator()))
    //==>Repositories
    ..registerFactory<BlogRepository>(() => BlogRepositryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          connectionCheck: serviceLocator(),
        ))
    //==>UseCases
    ..registerFactory(() => UploadBlogUseCase(
          blogRepository: serviceLocator(),
        ))
    ..registerFactory(() => GetAllBlogsUseCase(
          blogRepository: serviceLocator(),
        ))
    ..registerFactory(() => DeleteBlogUseCase(
          blogRepository: serviceLocator(),
        ))
    ..registerFactory(() => EditBlogUseCase(
          blogRepository: serviceLocator(),
        ))
    //==>Blocs
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlogUseCase: serviceLocator(),
        getAllBlogsUseCase: serviceLocator(),
        deleteBlogUseCase: serviceLocator(),
        editBlogUseCase: serviceLocator(),
      ),
    );
}
