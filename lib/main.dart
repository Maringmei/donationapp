import 'package:donationapp/src/screen/LandingPage/landingfirstpage.dart';
import 'package:donationapp/src/screen/LandingPage/landingfirstpage_web.dart';
import 'package:donationapp/src/screen/LandingPage/landingpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return screenwidth > 500 ? MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Donation ll",
      theme: ThemeData(
          useMaterial3: true
      ),
      home: LandingFirstPageWeb(),
    ) : FlutterWebFrame(
      builder: (BuildContext context) {
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Donation App",
          theme: ThemeData(
            useMaterial3: true
          ),
          home: LandingFirstPage(),
        );
      },
      maximumSize: const Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey,
    );
  }
}
