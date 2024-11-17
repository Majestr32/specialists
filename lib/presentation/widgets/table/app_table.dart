import 'package:flutter/material.dart';
import 'package:specialists_analyzer/app/consts/colors.dart';

class AppTable extends StatelessWidget {
  final List<Widget> columns;
  final Widget header;
  const AppTable({super.key, required this.columns, required this.header});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.bg,
        border: Border.all(color: AppColors.border, width: 4)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          Row(
            children: columns,
          ),
        ],
      )
    );
  }
}
