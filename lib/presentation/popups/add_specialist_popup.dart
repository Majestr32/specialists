import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specialists_analyzer/app/consts/colors.dart';
import 'package:specialists_analyzer/presentation/bloc/specialists_diagrams/specialists_diagrams_cubit.dart';
import 'package:specialists_analyzer/presentation/pages/home.dart';
import 'package:specialists_analyzer/presentation/widgets/dialogs/dialog_with_textfield.dart';

Future<void> showAddSpecialistPopup(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogWithTextField(
            title: "Введи ім'я", onSubmit: (val) {
              final selectedChallengeId = context.read<SpecialistsDiagramsCubit>().state.selectedChallengeId;
              context.read<SpecialistsDiagramsCubit>().addSpecialist(name: val, challengeId: selectedChallengeId!);
              Navigator.of(context).pop();
        }, buttonText: "Створити");
      });
}
