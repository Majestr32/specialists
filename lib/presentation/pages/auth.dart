import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specialists_analyzer/app/app.dart';
import 'package:specialists_analyzer/presentation/bloc/auth/auth_cubit.dart';

import '../../app/consts/colors.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(Icons.key, color: AppColors.secondary, size: 40,),
          ),
          SizedBox(
            height: 16,
          ),
          Center(
            child: Text(
              "Необхідний вхід для використання",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
              onPressed: () {
                context.read<AuthCubit>().signInWithGoogle();
              }, child: Text("Увійти з Google", style: TextStyle(color: Colors.white),))
        ],
      ),
    );
  }
}
