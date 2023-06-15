import 'dart:js_interop';

import 'package:donationapp/src/bloc/BeneficiariesBLoc/beneficiaries_cubit.dart';
import 'package:donationapp/src/bloc/DashboardBloc/dashboard_cubit.dart';
import 'package:donationapp/src/constants/common_constant/color_constant.dart';
import 'package:donationapp/src/constants/widget_constant/card_widget.dart';
import 'package:donationapp/src/constants/widget_constant/text_widget.dart';
import 'package:donationapp/src/service/DashboardApi/dashboard_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../SizedConfig.dart';
import '../../Storage/storage.dart';
import '../../bloc/LoginStatus/loginstatus_cubit.dart';
import '../../constants/widget_constant/custom_button.dart';
import '../../constants/widget_constant/space.dart';
import '../DonatePage/donatepage.dart';

class LandingFirstPageWeb extends StatelessWidget {
  LandingFirstPageWeb({Key? key}) : super(key: key);

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
                              "assets/images/1.png",
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                child: Image.asset(
                              "assets/images/transparent.png",
                              width: double.infinity,
                              height: double.infinity,
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
                              "assets/images/2.png",
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                child: Image.asset(
                              "assets/images/transparent.png",
                              width: double.infinity,
                              height: double.infinity,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.spaceBetween,
                      children: [
                        Space(
                          height: 1,
                        ),
                        Column(
                          children: [
                            Text(
                                "Support and Contribute towards Displaced\nMeitei Victims at Relief Camps",
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                        height: 1,
                                        color: c_white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 48)
                                    .copyWith()),
                            Space(
                              height: 50,
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(60),
                              height: getProportionateScreenWidth(13),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    // showDialog<void>(
                                    //   barrierDismissible: false,
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return AlertDialog(
                                    //       title: TextWidget(
                                    //           text: "Beneficiaries List",
                                    //           t_color: c_black,
                                    //           fontWeight: FontWeight.w400,
                                    //           fontSize: 15),
                                    //       content: SingleChildScrollView(
                                    //         child: Column(
                                    //           mainAxisSize: MainAxisSize.min,
                                    //           children: [
                                    //             Container(
                                    //               width: 600,
                                    //               child: Column(
                                    //                 children: [
                                    //                   Container(
                                    //                     width: 600,
                                    //                     height:
                                    //                         getProportionateScreenWidth(
                                    //                             100),
                                    //                     child: ListView.builder(
                                    //                         itemCount: 10,
                                    //                         itemBuilder:
                                    //                             (BuildContext
                                    //                                     context,
                                    //                                 int index) {
                                    //                           return Card(
                                    //                             child: ListTile(
                                    //                               title: Text(
                                    //                                 "Maringmei Shengang Kabui Maringmei Shengang",
                                    //                                 style: TextStyle(
                                    //                                     color:
                                    //                                         c_black,
                                    //                                     fontWeight:
                                    //                                         FontWeight
                                    //                                             .w700,
                                    //                                     fontSize:
                                    //                                         15),
                                    //                               ),
                                    //                               trailing:
                                    //                                   Text(
                                    //                                 "50000",
                                    //                                 style: TextStyle(
                                    //                                     color:
                                    //                                         c_black,
                                    //                                     fontWeight:
                                    //                                         FontWeight
                                    //                                             .w700,
                                    //                                     fontSize:
                                    //                                         15),
                                    //                               ),
                                    //                             ),
                                    //                           );
                                    //                         }),
                                    //                   ),
                                    //                   Space(
                                    //                     height: 10,
                                    //                   ),
                                    //                   Row(
                                    //                     mainAxisAlignment:
                                    //                         MainAxisAlignment
                                    //                             .end,
                                    //                     crossAxisAlignment:
                                    //                         CrossAxisAlignment
                                    //                             .center,
                                    //                     children: [
                                    //                       Column(
                                    //                         crossAxisAlignment:
                                    //                             CrossAxisAlignment
                                    //                                 .end,
                                    //                         children: [
                                    //                           TextWidget(
                                    //                               text:
                                    //                                   "Net Amount : ",
                                    //                               t_color:
                                    //                                   c_black,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w600,
                                    //                               fontSize: 13),
                                    //                           TextWidget(
                                    //                               text:
                                    //                                   "Tax : ",
                                    //                               t_color:
                                    //                                   c_black,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w600,
                                    //                               fontSize: 13),
                                    //                           TextWidget(
                                    //                               text:
                                    //                                   "Grand Amount : ",
                                    //                               t_color:
                                    //                                   c_black,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w600,
                                    //                               fontSize: 13),
                                    //                         ],
                                    //                       ),
                                    //                       Column(
                                    //                         crossAxisAlignment:
                                    //                             CrossAxisAlignment
                                    //                                 .end,
                                    //                         children: [
                                    //                           TextWidget(
                                    //                               text:
                                    //                                   "100000",
                                    //                               t_color:
                                    //                                   c_black,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w600,
                                    //                               fontSize: 13),
                                    //                           TextWidget(
                                    //                               text: "50000",
                                    //                               t_color:
                                    //                                   c_black,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w600,
                                    //                               fontSize: 13),
                                    //                           TextWidget(
                                    //                               text:
                                    //                                   "1500000",
                                    //                               t_color:
                                    //                                   c_black,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w600,
                                    //                               fontSize: 13),
                                    //                         ],
                                    //                       )
                                    //                     ],
                                    //                   )
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       actions: <Widget>[
                                    //         InkWell(
                                    //           onTap: () {
                                    //             Navigator.pop(context);
                                    //           },
                                    //           child: CustomButton(
                                    //               backColor: c_black,
                                    //               text: "Okay",
                                    //               c_color: c_white,
                                    //               fontWeight: FontWeight.w400,
                                    //               fontSize: 17),
                                    //         ),
                                    //       ],
                                    //     );
                                    //   },
                                    // );

                                    Route route = MaterialPageRoute(
                                        builder: (context) => DonatePage());
                                    Navigator.push(context, route);

                                    String? token = await Store.getToken();
                                    if (token.isNull) {
                                      BlocProvider.of<LoginstatusCubit>(context)
                                          .setLogout();
                                    } else {
                                      BlocProvider.of<LoginstatusCubit>(context)
                                          .setLogin();
                                    }

                                    //

                                    // showDialog<void>(
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return AlertDialog(
                                    //       title:
                                    //           const Text('Basic dialog title'),
                                    //       content: Column(
                                    //         mainAxisSize: MainAxisSize.min,
                                    //         children: [
                                    //           Container(
                                    //             width: double.maxFinite,
                                    //             height: 100,
                                    //             child: Expanded(
                                    //               child: ListView.builder(
                                    //                   itemCount: 100,
                                    //                   itemBuilder:
                                    //                       (BuildContext context,
                                    //                           int index) {
                                    //                     return Container(
                                    //                       child: Row(
                                    //                         children: [
                                    //
                                    //                         ],
                                    //                       ),
                                    //                     );
                                    //                   }),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       actions: <Widget>[
                                    //         TextButton(
                                    //           style: TextButton.styleFrom(
                                    //             textStyle: Theme.of(context)
                                    //                 .textTheme
                                    //                 .labelLarge,
                                    //           ),
                                    //           child: const Text('Disable'),
                                    //           onPressed: () {
                                    //             Navigator.of(context).pop();
                                    //           },
                                    //         ),
                                    //         TextButton(
                                    //           style: TextButton.styleFrom(
                                    //             textStyle: Theme.of(context)
                                    //                 .textTheme
                                    //                 .labelLarge,
                                    //           ),
                                    //           child: const Text('Enable'),
                                    //           onPressed: () {
                                    //             Navigator.of(context).pop();
                                    //           },
                                    //         ),
                                    //       ],
                                    //     );
                                    //   },
                                    // );
                                  },
                                  child: TextWidget(
                                      text: "Donate Now",
                                      t_color: c_black,
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          getProportionateScreenWidth(6))),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: BlocBuilder<DashboardCubit, DashboardState>(
                            builder: (context, state) {
                              if (state is DashboardInitial) {
                                BlocProvider.of<DashboardCubit>(context)
                                    .getDashboard();
                                return Row(
                                  children: [
                                    Space(
                                      width: 40,
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: CardWidget(
                                            width: double.infinity,
                                            height: 180,
                                            borderRadius: 13,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: state.response == null
                                                        ? "--"
                                                        : state
                                                            .response["donor"],
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            10)),
                                                Space(
                                                  height: 30,
                                                ),
                                                TextWidget(
                                                    text: "Donors",
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            9)),
                                              ],
                                            ))),
                                    Space(
                                      width: 80,
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: CardWidget(
                                            width: double.infinity,
                                            height: 180,
                                            borderRadius: 13,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: state.response == null
                                                        ? "--"
                                                        : state.response[
                                                            "donated"],
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            10)),
                                                Space(
                                                  height: 30,
                                                ),
                                                TextWidget(
                                                    text: "Donated",
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            9)),
                                              ],
                                            ))),
                                    Space(
                                      width: 80,
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: CardWidget(
                                            width: double.infinity,
                                            height: 180,
                                            borderRadius: 13,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: state.response == null
                                                        ? "--"
                                                        : state.response[
                                                            "beneficiary"],
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            10)),
                                                Space(
                                                  height: 30,
                                                ),
                                                TextWidget(
                                                    text: "Beneficiaries",
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            9)),
                                              ],
                                            ))),
                                    Space(
                                      width: 40,
                                    ),
                                  ],
                                );
                              }
                              //loaded
                              if (state is DashboardLoaded) {
                                return Row(
                                  children: [
                                    Space(
                                      width: 40,
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: CardWidget(
                                            width: double.infinity,
                                            height: 180,
                                            borderRadius: 13,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: state.response == null
                                                        ? "--"
                                                        : state
                                                            .response["donor"]
                                                            .toString(),
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            10)),
                                                Space(
                                                  height: 30,
                                                ),
                                                TextWidget(
                                                    text: "Donors",
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            9)),
                                              ],
                                            ))),
                                    Space(
                                      width: 80,
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: CardWidget(
                                            width: double.infinity,
                                            height: 180,
                                            borderRadius: 13,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: state.response == null
                                                        ? "--"
                                                        : indianRupeesFormat
                                                            .format(
                                                                state.response[
                                                                    "donated"]),
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            10)),
                                                Space(
                                                  height: 30,
                                                ),
                                                TextWidget(
                                                    text: "Donated",
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            9)),
                                              ],
                                            ))),
                                    Space(
                                      width: 80,
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: CardWidget(
                                            width: double.infinity,
                                            height: 180,
                                            borderRadius: 13,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                    text: state.response == null
                                                        ? "--"
                                                        : state.response[
                                                                "beneficiary"]
                                                            .toString(),
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            10)),
                                                Space(
                                                  height: 30,
                                                ),
                                                TextWidget(
                                                    text: "Beneficiaries",
                                                    t_color: c_white,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            9)),
                                              ],
                                            ))),
                                    Space(
                                      width: 40,
                                    ),
                                  ],
                                );
                              }
                              //return
                              return Row(
                                children: [
                                  Space(
                                    width: 40,
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: CardWidget(
                                          width: double.infinity,
                                          height: 180,
                                          borderRadius: 13,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextWidget(
                                                  text: state.response == null
                                                      ? "--"
                                                      : state.response["donor"],
                                                  t_color: c_white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          10)),
                                              Space(
                                                height: 30,
                                              ),
                                              TextWidget(
                                                  text: "Donors",
                                                  t_color: c_white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          9)),
                                            ],
                                          ))),
                                  Space(
                                    width: 80,
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: CardWidget(
                                          width: double.infinity,
                                          height: 180,
                                          borderRadius: 13,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextWidget(
                                                  text: state.response == null
                                                      ? "--"
                                                      : state
                                                          .response["donated"],
                                                  t_color: c_white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          10)),
                                              Space(
                                                height: 30,
                                              ),
                                              TextWidget(
                                                  text: "Donated",
                                                  t_color: c_white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          9)),
                                            ],
                                          ))),
                                  Space(
                                    width: 80,
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: CardWidget(
                                          width: double.infinity,
                                          height: 180,
                                          borderRadius: 13,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextWidget(
                                                  text: state.response == null
                                                      ? "--"
                                                      : state.response[
                                                          "beneficiary"],
                                                  t_color: c_white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          10)),
                                              Space(
                                                height: 30,
                                              ),
                                              TextWidget(
                                                  text: "Beneficiaries",
                                                  t_color: c_white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          9)),
                                            ],
                                          ))),
                                  Space(
                                    width: 40,
                                  ),
                                ],
                              );
                            },
                          ),
                        )
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
                                  fontSize: 20))))
                ],
              ))
        ],
      ),
    );
  }
}
