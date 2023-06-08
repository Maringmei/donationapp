import 'package:flutter/material.dart';

import '../../constants/common_constant/color_constant.dart';
import '../../constants/widget_constant/custom_button.dart';
import '../../constants/widget_constant/text_widget.dart';

class DonatePage extends StatefulWidget {
  DonatePage({Key? key}) : super(key: key);

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  List amount = [
    {"amount": "20000"},
    {"amount": "10000"},
    {"amount": "50000"},
    {"amount": "1000"},
    {"amount": "500"},
  ];

  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    final widthCount = (MediaQuery.of(context).size.width ~/ 250).toInt();
    return Scaffold(
      body: Column(
        children: [
          TextWidget(
              text: "Select Amount",
              t_color: c_black,
              fontWeight: FontWeight.w600,
              fontSize: 20),
          GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widthCount
              ),
              itemCount: amount.length,
              itemBuilder: (BuildContext context, int index) {
                return  MouseRegion(
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
                );
              })
        ],
      ),
    );
  }
}
