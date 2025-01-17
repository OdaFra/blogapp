import 'package:blogapp/src/features/auth/domain/usescases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;

  AuthBloc({required UserSignUp userSignUp})
      : _userSignUp = userSignUp,
        super(
          AuthInitial(),
        ) {
    on<AuthSignUp>((event, emit) async {
      final res = await _userSignUp(
        UserSignUpParams(
          username: event.username,
          email: event.email,
          password: event.password,
        ),
      );

      res.fold(
        (failure) => emit(
          AuthFailure(failure.message),
        ),
        (uid) => emit(
          AuthSuccess(uid),
        ),
      );
    });
  }
}
