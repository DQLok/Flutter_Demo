import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    required String text,
    required Color colorBackgroud,
    required Color textColor,
    required VoidCallback onPressed,
  }) : super(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 16.0),
            ),
            onPressed: onPressed,
            color: colorBackgroud,
            height: 40.0,
            radius: 20);
}
