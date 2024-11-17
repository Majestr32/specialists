import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specialists_analyzer/presentation/bloc/auth/auth_cubit.dart';

class AuthGuard extends StatelessWidget {
  final Widget authenticatedPage;
  final Widget unauthenticatedPage;
  final Widget loadingPage;
  const AuthGuard({super.key, required this.authenticatedPage, required this.unauthenticatedPage, required this.loadingPage});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    if(authState.status == AuthStatus.authenticated){
      return authenticatedPage;
    }else if(authState.status == AuthStatus.unauthenticated){
      return unauthenticatedPage;
    }else{
      return loadingPage;
    }
  }
}