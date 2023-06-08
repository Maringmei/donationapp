import 'package:donationapp/src/constants/common_constant/color_constant.dart';
import 'package:donationapp/src/constants/widget_constant/card_widget.dart';
import 'package:donationapp/src/constants/widget_constant/text_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/widget_constant/space.dart';

class LandingFirstPageWeb extends StatelessWidget {
  const LandingFirstPageWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: c_black,
        title: TextWidget(
            text: "Mateng Manipur",
            t_color: c_white,
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 9,
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Stack(
                          children: [
                            Image.asset(
                              "images/1.png",
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                child: Image.asset(
                              "images/transparent.png",
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ))
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Stack(
                          children: [
                            Image.asset(
                              "images/2.png",
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                child: Image.asset(
                              "images/transparent.png",
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned.fill(
                      child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                            text:
                                "Support and Contribute towards Displaced Meitei Victims at Relief Camps",
                            t_color: c_white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                        Space(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {},
                            child: TextWidget(
                                text: "Donate Now",
                                t_color: c_black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //         flex: 3,
                        //         child: CardWidget(width: double.infinity, height: 180, borderRadius: 13, child: Column(
                        //           children: [
                        //
                        //           ],
                        //         )))
                        //   ],
                        // )
                      ],
                    ),
                  ))
                ],
              )),
          Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Container(
                    color: c_black,
                  ),
                  Positioned(
                      child: Center(
                          child: Container(
                              color: c_black,
                              child: TextWidget(
                                  text:
                                      "Meitei Trade Bodies Coordinate Committee",
                                  t_color: c_white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13))))
                ],
              ))
        ],
      ),
    );
  }
}
