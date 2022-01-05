// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sized_box_for_whitespace, file_names

import 'package:flutter/material.dart';
class RoundedButton extends StatelessWidget {
  final Color? color;
  final Function()? onPress;
  final Text? text;
  const RoundedButton({this.color, this.onPress, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: text,
        ),
      ),
    );
  }
}
