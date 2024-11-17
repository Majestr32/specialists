import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specialists_analyzer/app/consts/colors.dart';
import 'package:specialists_analyzer/presentation/bloc/specialists_diagrams/specialists_diagrams_cubit.dart';
import 'package:specialists_analyzer/presentation/pages/home.dart';
import 'package:specialists_analyzer/presentation/widgets/dialogs/dialog_with_textfield.dart';

Future<void> showEditSpecialistPopup(BuildContext context, {required String name, required String id}) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogWithTextField(
          defaultText: name,
            title: "Введи ім'я", onSubmit: (val) {
          context.read<SpecialistsDiagramsCubit>().editSpecialist(name: val, id: id);
          Navigator.of(context).pop();
        }, buttonText: "Змінити");
      });
}