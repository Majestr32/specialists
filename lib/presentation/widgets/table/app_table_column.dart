import 'package:flutter/material.dart';
import 'package:specialists_analyzer/app/consts/colors.dart';
import 'package:specialists_analyzer/presentation/widgets/table/app_table_action.dart';

class AppTableColumn extends StatelessWidget {
  final String title;
  final List<Widget> rows;
  final AppTableAction? action;
  final bool loading;
  final bool showContent;

  const AppTableColumn(
      {super.key,
      required this.title,
      required this.rows,
      required this.loading,
      this.showContent = true,
      this.action});

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(color: AppColors.secondary);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(bottom: border, right: border, top: border)),
            height: 40,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(color: AppColors.secondary),
                ))),
        Container(
          height: 470,
          width: double.infinity,
          decoration:
              BoxDecoration(border: Border(bottom: border, right: border)),
          child: !showContent
              ? SizedBox.shrink()
              : loading
                  ? Center(
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                    child: Column(
                        children: [action ?? SizedBox.shrink(), ...rows],
                      ),
                  ),
        )
      ],
    );
  }
}
