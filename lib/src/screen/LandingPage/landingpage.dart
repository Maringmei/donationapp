import 'package:donationapp/src/constants/common_constant/color_constant.dart';
import 'package:donationapp/src/constants/common_constant/icons_assets.dart';
import 'package:donationapp/src/constants/widget_constant/card_widget.dart';
import 'package:donationapp/src/constants/widget_constant/custom_button.dart';
import 'package:donationapp/src/constants/widget_constant/space.dart';
import 'package:donationapp/src/constants/widget_constant/text_widget.dart';
import 'package:donationapp/src/screen/RegisterPage/register_page.dart';
import 'package:flutter/material.dart';

import '../../constants/common_constant/padding.dart';
import '../../constants/widget_constant/drawer.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.only(top: 30, right: 20, left: 20, bottom: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: "RELIEF CAMP\nDONATION",
                      t_color: c_black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: i_menu,
                  )
                ],
              ),
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
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
                    },
                    child: CustomButton(
                      backColor: _isHover == true ? c_green_light : c_white,
                        text: "Donate Now",
                        c_color: c_black,
                        fontWeight: FontWeight.w400,
                        fontSize: _isHover == true ? 19 : 17)),
              )
              // CardWidget(width: 329, height: 48, borderRadius: 0, child: Center(child: TextWidget(text: "DONATE NOW", t_color: c_black, fontWeight: FontWeight.w400, fontSize: 17)))
            ],
          )),
    );
  }
}
