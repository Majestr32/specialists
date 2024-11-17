import 'package:flutter/material.dart';
import 'package:specialists_analyzer/app/consts/colors.dart';

class AppTableRow extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isSelected;
  final List<Widget> suffixWidgets;
  final Widget? prefixWidget;

  const AppTableRow(
      {super.key, required this.text, this.prefixWidget, this.onTap, required this.isSelected, this.suffixWidgets = const [
      ]});

  @override
  State<AppTableRow> createState() => _AppTableRowState();
}

class _AppTableRowState extends State<AppTableRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        cursor: SystemMouseCursors.click,
        child: Container(
          width: double.infinity,
          color: widget.isSelected || _isHovered ? AppColors.highlight : Colors
              .transparent,
          height: 30,
          padding: EdgeInsets.only(right: 22),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  width: 44,
                  child: widget.prefixWidget,
                ),
                Expanded(child: Text(widget.text, maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),)),
                if(_isHovered)
                  ...widget.suffixWidgets
              ],
            ),
          ),
        ),
      ),
    );
  }
}
