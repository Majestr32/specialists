import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specialists_analyzer/app/consts/colors.dart';
import 'package:specialists_analyzer/presentation/bloc/specialists_diagrams/specialists_diagrams_cubit.dart';
import 'package:specialists_analyzer/presentation/widgets/dialogs/confirmation_dialog.dart';
import 'package:specialists_analyzer/presentation/widgets/dialogs/dialog_with_textfield.dart';

Future<void> showSpecialistEstimationPopup(BuildContext context,
    {required String id}) {
  final specialistEstimation = context
      .read<SpecialistsDiagramsCubit>()
      .state
      .specialists!
      .firstWhere((e) => e.id == id);
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.bg,
          child: Container(
            width: 500,
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Розуміння вимог: ${specialistEstimation.estimation!.requirementsUnderstanding
                        .toStringAsFixed(2)}", style: TextStyle(color: Colors.white),),
                Text("Логічність та узгодженість: ${specialistEstimation.estimation!.logicAndCoherence
                        .toStringAsFixed(2)}", style: TextStyle(color: Colors.white),),
                Text("Структурованість та організація: ${specialistEstimation.estimation!.structuringAndOrganization
                        .toStringAsFixed(2)}", style: TextStyle(color: Colors.white),),
                SizedBox(height: 20,),
                Text(specialistEstimation.estimation!.comment ?? "", style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        );
      });
}
