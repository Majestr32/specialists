import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specialists_analyzer/domain/repositories/app_repository_contract.dart';
import 'package:specialists_analyzer/presentation/bloc/auth/auth_cubit.dart';
import 'package:specialists_analyzer/presentation/pages/auth.dart';
import 'package:specialists_analyzer/presentation/pages/home.dart';
import 'package:specialists_analyzer/presentation/pages/loading.dart';
import 'package:specialists_analyzer/presentation/widgets/auth/auth_guard.dart';

import '../domain/repositories/app_repository_impl.dart';
import '../presentation/bloc/specialists_diagrams/specialists_diagrams_cubit.dart';

class App extends StatelessWidget {
  App({super.key});

  final AppRepository _appRepository = AppRepositoryImpl(
      db: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance,
      auth: FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          return SpecialistsDiagramsCubit(appRepository: _appRepository);
        }),
        BlocProvider(
            create: (context) => AuthCubit(appRepository: _appRepository))
      ],
      child: MaterialApp(
        home: AuthGuard(
            authenticatedPage: HomePage(),
            unauthenticatedPage: AuthPage(),
            loadingPage: LoadingPage()),
      ),
    );
  }
}
