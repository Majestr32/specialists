import 'package:flutter/material.dart';

import '../../../app/consts/colors.dart';

class ConfirmationDialog extends StatefulWidget {
  final String title;
  final String buttonText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  const ConfirmationDialog({super.key, required this.onCancel, required this.title,required this.buttonText, required this.onConfirm, required this.cancelText});

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  late final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.border,
      child: Container(
        width: 250,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),),
            SizedBox(height: 15,),
            Center(
              child: Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        widget.onConfirm.call();
                      }, child: Text(widget.buttonText, style: TextStyle(color: Colors.white),)),
                  Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                      ),
                      onPressed: () {
                        widget.onCancel.call();
                      }, child: Text(widget.cancelText, style: TextStyle(color: Colors.white),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
