import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specialists_analyzer/app/consts/colors.dart';
import 'package:specialists_analyzer/presentation/bloc/specialists_diagrams/specialists_diagrams_cubit.dart';
import 'package:specialists_analyzer/presentation/pages/home.dart';
import 'package:specialists_analyzer/presentation/widgets/dialogs/dialog_with_textfield.dart';

import '../bloc/auth/auth_cubit.dart';
import '../widgets/dialogs/dialog_with_two_textfields.dart';

Future<void> showEditChallengePopup(BuildContext context, {required String challengeId}) {
  final challenge = context.read<SpecialistsDiagramsCubit>().state.challenges!.firstWhere((e) => e.id == challengeId);
  return showDialog(
      context: context,
      builder: (context) {
        return DialogWithTwoTextFields(
            title1: "Назва випробування",
            title2: "Опис вимог щодо діаграм",
            defaultValue1: challenge.name,
            defaultValue2: challenge.requirements,
            onSubmit: (val1, val2) {
              context.read<SpecialistsDiagramsCubit>().editChallenge(id: challengeId, name: val1, requirements: val2);
              Navigator.of(context).pop();
            }, buttonText: "Змінити");
      });
}