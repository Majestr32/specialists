import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specialists_analyzer/app/consts/colors.dart';
import 'package:specialists_analyzer/presentation/bloc/auth/auth_cubit.dart';
import 'package:specialists_analyzer/presentation/bloc/specialists_diagrams/specialists_diagrams_cubit.dart';
import 'package:specialists_analyzer/presentation/pages/home.dart';
import 'package:specialists_analyzer/presentation/widgets/dialogs/dialog_with_textfield.dart';
import 'package:specialists_analyzer/presentation/widgets/dialogs/dialog_with_two_textfields.dart';

Future<void> showAddChallengePopup(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogWithTwoTextFields(
            title1: "Назва випробування",
            title2: "Опис вимог щодо діаграм",
            onSubmit: (val1, val2) {
              final userId = context.read<AuthCubit>().state.user!.uid;
              context.read<SpecialistsDiagramsCubit>().addChallenge(userId: userId, name: val1, requirements: val2);
          Navigator.of(context).pop();
        }, buttonText: "Створити");
      });
}
