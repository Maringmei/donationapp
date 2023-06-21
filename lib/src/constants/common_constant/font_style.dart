import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle custom_font(color,fontWeight,fontSize){
  return GoogleFonts.poppins(
      height: 1,
      color: color, fontWeight: fontWeight, fontSize: fontSize)
      .copyWith();
}