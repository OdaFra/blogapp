import 'package:blogapp/src/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogapp/src/core/network/connection_check.dart';
import 'package:blogapp/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blogapp/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blogapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:blogapp/src/features/auth/domain/usescases/current_user.dart';
import 'package:blogapp/src/features/auth/domain/usescases/user_login.dart';
import 'package:blogapp/src/features/auth/domain/usescases/user_logout.dart';
import 'package:blogapp/src/features/auth/domain/usescases/user_sign_up.dart';
import 'package:blogapp/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/src/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blogapp/src/features/blog/data/datasources/blog_remote_data_sources.dart';
import 'package:blogapp/src/features/blog/data/repository/blog_repositry_impl.dart';
import 'package:blogapp/src/features/blog/domain/repository/blog_repository.dart';
import 'package:blogapp/src/features/blog/domain/usescases/delete_blog.dart';
import 'package:blogapp/src/features/blog/domain/usescases/edit_blog.dart';
import 'package:blogapp/src/features/blog/domain/usescases/get_all_blogs.dart';
import 'package:blogapp/src/features/blog/domain/usescases/upload_blog.dart';
import 'package:blogapp/src/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/core/secrets/secrets.dart';

part 'init_dependencies.main.dart';
