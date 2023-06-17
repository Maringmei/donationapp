import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TextWidget extends StatelessWidget {
  final text;
  final t_color;
  final fontWeight;
  final double fontSize;

  TextWidget(
      {Key? key,
        required this.text,
        required this.t_color,
        required this.fontWeight,
        required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    //  padding: EdgeInsets.zero,
      child: Text('$text',
//Libre Bodoni
          style: GoogleFonts.libreBodoni(
              height: 1,
              color: t_color, fontWeight: fontWeight, fontSize: fontSize)
              .copyWith()
            ),
    );
  }
}