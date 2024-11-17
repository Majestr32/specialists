import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:specialists_analyzer/domain/repositories/app_repository_contract.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AppRepository _appRepository;

  late final StreamSubscription _subscription;

  AuthCubit({required AppRepository appRepository})
      : _appRepository = appRepository,
        super(AuthState.initial()) {
    _subscription = _appRepository.users.listen((e) {
      final status =
          e == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
      emit(AuthState(status: status, user: e));
    });
  }

  Future<void> signInWithGoogle(){
    return _appRepository.signInWithGoogle();
  }

  Future<void> signOut(){
    return _appRepository.signOut();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
