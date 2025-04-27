import 'package:blogapp/src/core/error/error.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailAndPassword({
    required String unsername,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerException(message: 'User is null');
      }

      return UserModel.fromJson(
        response.user!.toJson(),
      );
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String unsername,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'username': unsername},
      );
      if (response.user == null) {
        throw ServerException(message: 'User is null');
      }

      return UserModel.fromJson(
        response.user!.toJson(),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    return null;
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
      // Limpiar cualquier dato local persistente
      final session = supabaseClient.auth.currentSession;
      if (session != null) {
        throw Exception('La sesión no se cerró correctamente');
      }
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
      throw ServerException(message: 'Error al cerrar sesión');
    }
  }
}
