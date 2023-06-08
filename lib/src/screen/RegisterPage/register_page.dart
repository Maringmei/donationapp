import 'package:donationapp/src/constants/common_constant/color_constant.dart';
import 'package:donationapp/src/constants/widget_constant/space.dart';
import 'package:donationapp/src/constants/widget_constant/text_widget.dart';
import 'package:donationapp/src/screen/DonatePage/donatepage.dart';
import 'package:flutter/material.dart';

import '../../constants/widget_constant/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          right: 20,
          left: 20
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(text: "LOGIN", t_color: c_black, fontWeight: FontWeight.w600, fontSize: 20),
            Space(height: 60,),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Email",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: c_black),
                ),
              ),
            ),
            Space(height: 10,),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: c_black),

                ),
              ),
            ),
            Space(height: 20,),
            MouseRegion(
              onHover: (event) {
                setState(() {
                  _isHover = true;
                });
              },
              onExit: (event) {
                setState(() {
                  _isHover = false;
                });
              },
              child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> DonatePage()));
                  },
                  child: CustomButton(
                      backColor: _isHover == true ? c_green_light : c_white,
                      text: "Submit",
                      c_color: c_black,
                      fontWeight: FontWeight.w400,
                      fontSize: _isHover == true ? 19 : 17)),
            )
          ],
        ),
      ),
    );
  }
}
