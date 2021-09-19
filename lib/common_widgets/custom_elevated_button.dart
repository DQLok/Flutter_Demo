import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.color,
      required this.radius,
      required this.height})
      : assert(radius!=null), super(key: key);
  final Widget child;
  final VoidCallback onPressed;
  final Color color;
  final double radius;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child: ElevatedButton(
            onPressed: onPressed,
            child: child,
            style: ElevatedButton.styleFrom(
              primary: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius)),
            )));
  }
}
