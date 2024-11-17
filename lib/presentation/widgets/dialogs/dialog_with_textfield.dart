import 'package:flutter/material.dart';

import '../../../app/consts/colors.dart';

class DialogWithTextField extends StatefulWidget {
  final String title;
  final Function(String) onSubmit;
  final String buttonText;
  final String? defaultText;
  const DialogWithTextField({super.key, required this.title, required this.onSubmit, required this.buttonText, this.defaultText = ""});

  @override
  State<DialogWithTextField> createState() => _DialogWithTextFieldState();
}

class _DialogWithTextFieldState extends State<DialogWithTextField> {
  late final TextEditingController _controller = TextEditingController(text: widget.defaultText);

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
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              cursorColor: AppColors.accent,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.accent
                      )
                  )
              ),
            ),
            SizedBox(height: 15,),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                  onPressed: () {
                    if(_controller.text.isEmpty) return;
                    widget.onSubmit.call(_controller.text);
                  }, child: Text(widget.buttonText, style: TextStyle(color: Colors.white),)),
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
