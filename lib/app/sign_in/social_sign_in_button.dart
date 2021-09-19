import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    required String assetName,
    required String text,
    required Color colorBackgroud,
    required Color textColor,
    required VoidCallback onPressed,
  })  : assert(text != null),//dừng thực thi nếu đk false
        super(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(assetName),
                Text(text, style: TextStyle(color: textColor, fontSize: 16.0)),
                Opacity(opacity: 0.0, child: Image.asset(assetName))
              ],
            ),
            onPressed: onPressed,
            color: colorBackgroud,
            height: 40.0,
            radius: 20);
}
