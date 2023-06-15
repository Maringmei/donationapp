import 'dart:js_interop';

import 'package:donationapp/src/Storage/storage.dart';
import 'package:donationapp/src/bloc/DashboardBloc/dashboard_cubit.dart';
import 'package:donationapp/src/bloc/LoginStatus/loginstatus_cubit.dart';
import 'package:donationapp/src/constants/common_constant/color_constant.dart';
import 'package:donationapp/src/constants/widget_constant/text_widget.dart';
import 'package:donationapp/src/screen/DonatePage/donatePage_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../SizedConfig.dart';
import '../../constants/widget_constant/space.dart';

class LandingFirstPage extends StatelessWidget {
  LandingFirstPage({Key? key}) : super(key: key);
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹ ',
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
              flex: 4,
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/1.png",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/transparent.png",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                            child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                    "Support and Contribute towards Displaced Meitei Victims at Relief Camps",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                            height: 1,
                                            color: c_white,
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                getProportionateScreenWidth(16))
                                        .copyWith()),
                              ),
                              Space(
                                height: 20,
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(160),
                                height: getProportionateScreenWidth(40),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      Route route = MaterialPageRoute(
                                          builder: (context) =>
                                              DonatePageMobile());
                                      Navigator.push(context, route);

                                      String? token = await Store.getToken();
                                      if (token.isNull) {
                                        BlocProvider.of<LoginstatusCubit>(
                                                context)
                                            .setLogout();
                                      } else {
                                        BlocProvider.of<LoginstatusCubit>(
                                                context)
                                            .setLogin();
                                      }
                                    },
                                    child: TextWidget(
                                        text: "Donate Now",
                                        t_color: c_black,
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                            getProportionateScreenWidth(15))),
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              )),
          Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/2.png",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/transparent.png",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                            child: Align(
                          alignment: Alignment.center,
                          child: BlocBuilder<DashboardCubit, DashboardState>(
                            builder: (context, state) {
                              //init
                              if(state is DashboardInitial){
                                BlocProvider.of<DashboardCubit>(context).getDashboard();
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                        text: "--",
                                        t_color: c_white,
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                        getProportionateScreenWidth(20)),
                                    TextWidget(
                                        text: "Donated",
                                        t_color: c_white,
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                        getProportionateScreenWidth(13)),
                                    Space(
                                      height: 20,
                                    ),
                                    TextWidget(
                                        text: "--",
                                        t_color: c_white,
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                        getProportionateScreenWidth(20)),
                                    TextWidget(
                                        text: "Donors",
                                        t_color: c_white,
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                        getProportionateScreenWidth(13)),
                                    Space(
                                      height: 20,
                                    ),
                                    TextWidget(
                                        text: "--",
                                        t_color: c_white,
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                        getProportionateScreenWidth(20)),
                                    TextWidget(
                                      text: "Benificiaries",
                                      t_color: c_white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: getProportionateScreenWidth(13),
                                    ),
                                    Space(
                                      height: 20,
                                    ),
                                  ],
                                );
                                //loaded
                              }if(state is DashboardLoaded){
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                        text: state.response == null ? "--" : indianRupeesFormat.format(state.response["donated"]),
                                        t_color: c_white,
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                        getProportionateScreenWidth(22)),
                                    TextWidget(
                                        text: "Donated",
                                        t_color: c_white,
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                        getProportionateScreenWidth(13)),
                                    Space(
                                      height: 20,
                                    ),
                                    TextWidget(
                                        text: state.response == null ? "--" : state.response["donor"].toString(),
                                        t_color: c_white,
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                        getProportionateScreenWidth(22)),
                                    TextWidget(
                                        text: "Donors",
                                        t_color: c_white,
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                        getProportionateScreenWidth(13)),
                                    Space(
                                      height: 20,
                                    ),
                                    TextWidget(
                                        text: state.response == null ? "--" : state.response["beneficiary"].toString(),
                                        t_color: c_white,
                                        fontWeight: FontWeight.w700,
                                        fontSize:
                                        getProportionateScreenWidth(22)),
                                    TextWidget(
                                      text: "Benificiaries",
                                      t_color: c_white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: getProportionateScreenWidth(13),
                                    ),
                                    Space(
                                      height: 20,
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                      text: "--",
                                      t_color: c_white,
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                      getProportionateScreenWidth(20)),
                                  TextWidget(
                                      text: "Donated",
                                      t_color: c_white,
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                      getProportionateScreenWidth(13)),
                                  Space(
                                    height: 20,
                                  ),
                                  TextWidget(
                                      text: "--",
                                      t_color: c_white,
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                      getProportionateScreenWidth(20)),
                                  TextWidget(
                                      text: "Donors",
                                      t_color: c_white,
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                      getProportionateScreenWidth(13)),
                                  Space(
                                    height: 20,
                                  ),
                                  TextWidget(
                                      text: "--",
                                      t_color: c_white,
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                      getProportionateScreenWidth(20)),
                                  TextWidget(
                                    text: "Benificiaries",
                                    t_color: c_white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: getProportionateScreenWidth(13),
                                  ),
                                  Space(
                                    height: 20,
                                  ),
                                ],
                              );
                            },
                          ),
                        ))
                      ],
                    ),
                  )
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
