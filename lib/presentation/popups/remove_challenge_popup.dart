import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specialists_analyzer/app/consts/colors.dart';
import 'package:specialists_analyzer/presentation/bloc/auth/auth_cubit.dart';
import 'package:specialists_analyzer/presentation/bloc/specialists_diagrams/specialists_diagrams_cubit.dart';
import 'package:specialists_analyzer/presentation/pages/home.dart';
import 'package:specialists_analyzer/presentation/widgets/dialogs/dialog_with_textfield.dart';
import 'package:specialists_analyzer/presentation/widgets/dialogs/dialog_with_two_textfields.dart';

import '../widgets/dialogs/confirmation_dialog.dart';

Future<void> showRemoveChallengePopup(
    BuildContext context, String challengeId) {
  return showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: "Чи справді ти хочеш видалити випробування?",
          onConfirm: () {
            context
                .read<SpecialistsDiagramsCubit>()
                .removeChallenge(id: challengeId);
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
          buttonText: "Видалити",
          cancelText: "Скасувати",
        );
      });
}
