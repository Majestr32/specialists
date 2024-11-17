import 'package:flutter/material.dart';
import 'package:specialists_analyzer/app/consts/colors.dart';

class AppTableAction extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const AppTableAction({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: double.infinity,
          height: 40,
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.add, color: AppColors.accent, size: 16,),
                SizedBox(width: 4,),
                Text(text, style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w500),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
