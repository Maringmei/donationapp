import 'package:donationapp/src/bloc/MultiBloc/BlocProvider.dart';
import 'package:donationapp/src/screen/DonatePage/donatePage_mobile.dart';
import 'package:donationapp/src/screen/DonatePage/donatepage.dart';
import 'package:donationapp/src/screen/LandingPage/landingfirstpage_mobile.dart';
import 'package:donationapp/src/screen/LandingPage/landingfirstpage_web.dart';
import 'package:donationapp/src/screen/LandingPage/landingpage.dart';
import 'package:donationapp/src/screen/paginationTest.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';

void main() => runApp(MultiBloc(
      widgets: MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return screenwidth >= 1000
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Donation App",
            theme: ThemeData(useMaterial3: true),
            home: LandingFirstPageWeb(),
            builder: EasyLoading.init(),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Donation App",
            theme: ThemeData(useMaterial3: true),
            home: LandingFirstPage(),
            builder: EasyLoading.init(),
          );
  }
}
