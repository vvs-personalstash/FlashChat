import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  RoundButton(
      {required this.wColor, required this.onpressed, required this.Text1});
  final VoidCallback onpressed;
  Color wColor;
  String Text1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: wColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            Text1,
          ),
        ),
      ),
    );
  }
}
