import 'package:flutter/material.dart';

import '../../../app/consts/colors.dart';

class DialogWithTwoTextFields extends StatefulWidget {
  final String title1;
  final String title2;
  final String defaultValue1;
  final String defaultValue2;
  final Function(String, String) onSubmit;
  final String buttonText;
  const DialogWithTwoTextFields({super.key, required this.onSubmit, required this.buttonText, required this.title1, required this.title2, this.defaultValue1 = "", this.defaultValue2 = ""});

  @override
  State<DialogWithTwoTextFields> createState() => _DialogWithTwoTextFieldsState();
}

class _DialogWithTwoTextFieldsState extends State<DialogWithTwoTextFields> {
  late final TextEditingController _controller1 = TextEditingController(text: widget.defaultValue1);
  late final TextEditingController _controller2 = TextEditingController(text: widget.defaultValue2);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.border,
      child: Container(
        width: 400,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title1, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),),
            TextField(
              controller: _controller1,
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
            Text(widget.title2, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),),
            TextField(
              controller: _controller2,
              style: TextStyle(color: Colors.white),
              cursorColor: AppColors.accent,
              maxLines: 10,
              minLines: 3,
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
                    if(_controller1.text.isEmpty || _controller2.text.isEmpty) return;
                    widget.onSubmit.call(_controller1.text, _controller2.text);
                  }, child: Text(widget.buttonText, style: TextStyle(color: Colors.white),)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
