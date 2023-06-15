import 'package:donationapp/src/constants/widget_constant/space.dart';
import 'package:donationapp/src/constants/widget_constant/text_widget.dart';
import 'package:flutter/material.dart';

import '../common_constant/color_constant.dart';
import 'card_widget.dart';
import 'custom_button.dart';


AlertDialog CustomDialog(BuildContext context,String title,desc) {
  return AlertDialog(

    backgroundColor: c_white.withOpacity(0.5), elevation: 0,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(text: title, t_color: c_black, fontWeight: FontWeight.w400, fontSize: 25),
        Space(height: 23.0),
        TextWidget(text: desc, t_color: c_black, fontWeight: FontWeight.w400, fontSize: 18),
        Space(height: 21.0),
      ],
    ),
    actions: [
      InkWell(
          onTap: () {
            Navigator.pop(context,true);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => DonatePage()));
          },
          child: CustomButton(
              backColor: c_black,
              text: "Okay",
              c_color: c_white,
              fontWeight: FontWeight.w400,
              fontSize: 17)),
    ],
  );
}