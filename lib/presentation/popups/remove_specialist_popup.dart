import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specialists_analyzer/presentation/bloc/specialists_diagrams/specialists_diagrams_cubit.dart';
import 'package:specialists_analyzer/presentation/widgets/dialogs/confirmation_dialog.dart';
import 'package:specialists_analyzer/presentation/widgets/dialogs/dialog_with_textfield.dart';

Future<void> showRemoveSpecialistPopup(BuildContext context,
    {required String id}) {
  return showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: "Чи справді ти хочеш видалити спеціаліста?",
          onConfirm: () {
            context.read<SpecialistsDiagramsCubit>().removeSpecialist(id: id);
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
