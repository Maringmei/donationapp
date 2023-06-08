import 'package:flutter/material.dart';

import '../common_constant/color_constant.dart';

class CardWidget extends StatelessWidget {
  final double width;
  final double height;
  final gradient;
  final borderRadius;
  final child;
  final color;
  const CardWidget(
      {super.key,
        this.gradient,
        this.color,
        required this.width,
        required this.height,
        required this.borderRadius,
        required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          boxShadow: [
           //  BoxShadow(
           //    color: Colors.black,
           //    blurRadius: 2.0,
           //    spreadRadius: 0.0,
           // //   offset: Offset(2.0, 2.0),
           //  ),
    ],
          color: color == null ? null : color,
          border: color == null ? gradient == null ? Border.all(color: c_black) : null : null,
          borderRadius: BorderRadius.circular(0),
          gradient: gradient == null ? null : LinearGradient(
            colors: gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: child);
  }
}