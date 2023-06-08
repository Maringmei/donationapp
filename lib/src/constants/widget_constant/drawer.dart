import 'package:donationapp/src/constants/widget_constant/space.dart';
import 'package:donationapp/src/constants/widget_constant/text_widget.dart';
import 'package:flutter/material.dart';

import '../common_constant/color_constant.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: MouseRegion(
              cursor: SystemMouseCursors.click, // Set cursor type
              child: GestureDetector(
                // Detects gestures
                onTap: () {
                  // close the drawer
                  Navigator.pop(context);
                },
                child: Drawer(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              Container(
                                height: 100,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //   Image.asset(ImageAsset.logo,width: 42,height: 42,),
                                    Space(
                                      width: 5,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextWidget(
                                            text: "Donation App",
                                            t_color: c_black_opa,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              ListTile(
                                title: TextWidget(
                                    text: "Home",
                                    t_color: c_black_opa,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                hoverColor: Colors.grey[200], // Set hover color
                              ),
                              ListTile(
                                title: TextWidget(
                                    text: "Donations",
                                    t_color: c_black_opa,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                hoverColor: Colors.grey[200], // Set hover color
                              ),
                              ListTile(
                                title: TextWidget(
                                    text: "Login / Sign in",
                                    t_color: c_black_opa,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                hoverColor: Colors.grey[200], // Set hover color
                              ),

                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            )));
  }
}
