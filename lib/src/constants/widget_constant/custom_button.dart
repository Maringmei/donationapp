import 'package:donationapp/src/constants/widget_constant/text_widget.dart';
import 'package:flutter/material.dart';

import '../common_constant/color_constant.dart';

class CustomButton extends StatelessWidget {
  final text;
  final c_color;
  final fontWeight;
  final fontSize;
  final backColor;
  CustomButton({required this.text, required this.c_color, required this.fontWeight, required this.fontSize,required this.backColor});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 40,
      width: double.infinity,
      // decoration: BoxDecoration(
      //     border: Border.all(color: c_black) ,
      //     boxShadow: <BoxShadow>[
      //       BoxShadow(
      //           color: Colors.black54,
      //           //blurRadius: 1.0,
      //           offset: Offset(4, 4)
      //       )
      //     ],
      //     color: backColor
      // ),
      decoration: BoxDecoration(
          border: Border.all(color: c_black) ,
          color: backColor
      ),
      child: Center(child: TextWidget(text: text, t_color: c_color, fontWeight: fontWeight, fontSize: fontSize)),
    );
  }
}
