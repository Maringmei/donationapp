import 'dart:js_interop';

import 'package:donationapp/src/bloc/HistoryBloc/history_cubit.dart';
import 'package:donationapp/src/bloc/LoginStatus/loginstatus_cubit.dart';
import 'package:donationapp/src/constants/widget_constant/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_web/razorpay_web.dart';

import '../../../SizedConfig.dart';
import '../../Storage/storage.dart';
import '../../bloc/BeneficiariesBLoc/beneficiaries_cubit.dart';
import '../../bloc/ConfirmBloc/confirm_cubit.dart';
import '../../bloc/CreateAccountBloc/createaccount_cubit.dart';
import '../../bloc/LoginBloc/login_cubit.dart';
import '../../bloc/PayNowBloc/pay_now_cubit.dart';
import '../../bloc/StatusBloc/status_cubit.dart';
import '../../constants/common_constant/check_email.dart';
import '../../constants/common_constant/color_constant.dart';
import '../../constants/common_constant/currency_format.dart';
import '../../constants/common_constant/icons_assets.dart';
import '../../constants/widget_constant/custom_button.dart';
import '../../constants/widget_constant/dialog_widget.dart';
import '../../constants/widget_constant/space.dart';
import '../../constants/widget_constant/text_widget.dart';

class DonatePageMobile extends StatefulWidget {
  DonatePageMobile({super.key});

  @override
  State<DonatePageMobile> createState() => _DonatePageMobileState();
}

class _DonatePageMobileState extends State<DonatePageMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? _clickindex = 99999;
  List amount = [
    {"amount": "5000"},
    {"amount": "10000"},
    {"amount": "15000"},
    {"amount": "50000"},
    {"amount": "100000"},
  ];
  bool _checkBox = false;
  int status = 0;

  int donationAmount = 0;

  //login
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  //select amount
  TextEditingController customAmount = TextEditingController();

  //create account
  TextEditingController createName = TextEditingController();
  TextEditingController createEmail = TextEditingController();
  TextEditingController createMobileNumber = TextEditingController();
  TextEditingController createAddress = TextEditingController();
  TextEditingController createPassword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  String? token;
  void getToken() async {
    token = await Store.getToken();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(),
        body: Stack(
          children: [
            Stack(
              children: [
                // Image.asset(
                //   "assets/images/donatebackground.png",
                //   width: double.infinity,
                //   height: double.infinity,
                //   fit: BoxFit.cover,
                // ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: c_black,
                ),
                Positioned(
                  child: Image.asset(
                    "assets/images/transparent.png",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            Positioned(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Space(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                            text: "MATENG",
                            t_color: c_white,
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
                  ),
                  Space(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                            text: "-- Donation",
                            t_color: c_white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        Space(
                          height: 10,
                        ),
                        TextWidget(
                            text: "Don't Let Poverty Destroy\nSomeone's Dreams",
                            t_color: c_white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ],
                    ),
                  ),
                  Space(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width / 0.8,
                      color: Colors.white.withOpacity(1),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<StatusCubit, StatusState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  if (state.status == 0)
                                    SelectDonationAmount(context),
                                  if (state.status == 1) createAccount(context),
                                  if (state.status == 2) login(context),
                                  if (state.status == 3)
                                    History(context),
                                ],
                              );
                            },
                          )),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Expanded History(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: TextWidget(
              text: "History",
              t_color: c_black,
              fontWeight: FontWeight.w400,
              fontSize: 23),),

          Space(
            height: 20,
          ),
          Expanded(
            flex: 10,
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                if (state is HistoryInitial) {
                  BlocProvider.of<HistoryCubit>(context).getHistory();
                  return Container();
                }
                if (state is HistoryLoaded) {
                  return AnimationLimiter(
                    child: ListView.builder(
                        itemCount: state.response.length,
                        physics:
                        BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              width: double.infinity,
                             // height: MediaQuery.of(context).size.width / 10,
                              color: c_white,
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){
                          BlocProvider.of<BeneficiariesCubit>(context).getBeneficiariesList(state.response[index]["razorpay_payment_id"].toString()).then((value){
                            if(value != false){
                              showDialog<void>(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: TextWidget(
                                        text: "Beneficiaries List",
                                        t_color: c_black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 600,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 600,
                                                  height:
                                                      getProportionateScreenWidth(
                                                          200),
                                                  child: ListView.builder(
                                                      itemCount: value["payment_details"].length,
                                                      itemBuilder:
                                                          (BuildContext
                                                                  context,
                                                              int index) {
                                                        return Card(
                                                          child: ListTile(
                                                            title: Text(
                                                              value["payment_details"][index]["name"],
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color:
                                                                      c_black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      15),
                                                            ),
                                                            trailing:
                                                                Text(
                                                                  value["payment_details"][index]["amount"],
                                                              style: TextStyle(
                                                                  color:
                                                                      c_black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      15),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                                Space(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        TextWidget(
                                                            text:
                                                                "Net Amount : ",
                                                            t_color:
                                                                c_black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            fontSize: 13),
                                                        TextWidget(
                                                            text:
                                                                "Tax : ",
                                                            t_color:
                                                                c_black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            fontSize: 13),
                                                        TextWidget(
                                                            text:
                                                                "Grand Amount : ",
                                                            t_color:
                                                                c_black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            fontSize: 13),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        TextWidget(
                                                            text:
                                                                "${ value["net_amount"]}",
                                                            t_color:
                                                                c_black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            fontSize: 13),
                                                        TextWidget(
                                                            text: "${ value["tax"]}",
                                                            t_color:
                                                                c_black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            fontSize: 13),
                                                        TextWidget(
                                                            text:
                                                            "${ value["grand_amount"]}",
                                                            t_color:
                                                                c_black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            fontSize: 13),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: CustomButton(
                                            backColor: c_black,
                                            text: "Okay",
                                            c_color: c_white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17),
                                      ),
                                    ],
                                  );
                                },
                              );

                            }
                          });
                                  },
                                  child: AnimationConfiguration.staggeredList(
                                    position: index,
                                    delay: Duration(milliseconds: 100),
                                    child: SlideAnimation(
                                      duration: Duration(milliseconds: 2500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: FadeInAnimation(
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        duration: Duration(milliseconds: 2500),
                                        child: Card(
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Donated on : ${state.response[index]["created_at"]}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: c_black,
                                                      fontSize: getProportionateScreenWidth(14),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                TextWidget(
                                                  text: "Amount : ${indianRupeesFormat.format(double.parse(state.response[index]["amount"]))}",
                                                  t_color: c_black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: getProportionateScreenWidth(14),)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ),
                              )),
                            ),
                          );
                        }),
                  );
                }
                if (state is HistoryError) {
                  return Container();
                }
                return Container();
              },
            ),
          ),
          // Space(
          //   height: 20,
          // ),
          // Row(
          //   children: [
          //     Checkbox(
          //         value: _checkBox,
          //         onChanged: (value) {
          //           _checkBox = value!;
          //           setState(() {});
          //         }),
          //     TextWidget(
          //         text: "Donate Anonymously",
          //         t_color: c_black,
          //         fontWeight: FontWeight.w600,
          //         fontSize: 18),
          //   ],
          // ),
          Space(
            height: 20,
          ),
          Expanded(
            flex: 1,
            child: MouseRegion(
              child: InkWell(
                  onTap: () async {
                    // bool res = await showDialog(
                    //     barrierDismissible: false,
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return AlertDialog(
                    //         backgroundColor: c_white.withOpacity(0.9),
                    //         elevation: 0,
                    //         content: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             TextWidget(
                    //                 text: "Sucess",
                    //                 t_color: c_black,
                    //                 fontWeight: FontWeight.w400,
                    //                 fontSize: 25),
                    //             Space(height: 23.0),
                    //             TextWidget(
                    //                 text:
                    //                     "You have sucessfully\n\nDonated ₹ 1,00,000/- ",
                    //                 t_color: c_black,
                    //                 fontWeight: FontWeight.w400,
                    //                 fontSize: 18),
                    //             Space(height: 21.0),
                    //           ],
                    //         ),
                    //         actions: [
                    //           InkWell(
                    //               onTap: () {
                    //                 Navigator.pop(context, true);
                    //                 // Navigator.push(context,
                    //                 //     MaterialPageRoute(builder: (context) => DonatePage()));
                    //               },
                    //               child: CustomButton(
                    //                   backColor: c_black,
                    //                   text: "Okay",
                    //                   c_color: c_white,
                    //                   fontWeight: FontWeight.w400,
                    //                   fontSize: 17)),
                    //         ],
                    //       );
                    //     });
                    // if (res) {
                    //   BlocProvider.of<StatusCubit>(context).setDonate();
                    // }
                    BlocProvider.of<StatusCubit>(context).setDonate();
                  },
                  child: CustomButton(
                      backColor: c_black,
                      text: "Home",
                      c_color: c_white,
                      fontWeight: FontWeight.w400,
                      fontSize: 17)),
            ),
          ),
          Space(
            height: 20,
          ),
        ],
      ),
    );
  }

  Column login(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
                text: "Login",
                t_color: c_black,
                fontWeight: FontWeight.w400,
                fontSize: 20),
            InkWell(
              onTap: () {
                BlocProvider.of<StatusCubit>(context).setCreateAccount();
              },
              child: TextWidget(
                  text: "Create Account",
                  t_color: c_black,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
            ),
          ],
        ),
        Space(height: 20),
        Column(
          children: [
            TextFormField(
              controller: loginEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  hintStyle: GoogleFonts.inter(
                          height: 1,
                          color: c_black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18)
                      .copyWith(),
                  border: OutlineInputBorder()),
            ),
            Space(
              height: 10,
            ),
            TextFormField(
              controller: loginPassword,
              obscureText: true,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  hintStyle: GoogleFonts.inter(
                          height: 1,
                          color: c_black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18)
                      .copyWith(),
                  border: OutlineInputBorder()),
            ),
          ],
        ),
        Space(height: 20),
        MouseRegion(
          child: InkWell(
              onTap: () {
                // showDialog(
                //     barrierDismissible: false,
                //     context: context,
                //     builder: (BuildContext context) {
                //       return CustomDialog(context, "Sucess",
                //           "You have sucessfully\n\nDonated ₹ 1,00,000/- ");
                //     });
                if (isEmail(loginEmail.text)) {
                  if (loginEmail.text.isEmpty || loginPassword.text.isEmpty) {
                    EasyLoading.showToast("Invalid Email or Password");
                  } else {
                    BlocProvider.of<LoginCubit>(context)
                        .login(loginEmail.text, loginPassword.text, context)
                        .then((value) {
                      if (value) {
                        BlocProvider.of<StatusCubit>(context).setDonate();
                        loginEmail.clear();
                        loginPassword.clear();
                      } else {
                        BlocProvider.of<StatusCubit>(context).setLogin();
                      }
                    });
                  }
                } else {
                  EasyLoading.showToast("Invalid Email.");
                }
              },
              child: CustomButton(
                  backColor: c_black,
                  text: "Login",
                  c_color: c_white,
                  fontWeight: FontWeight.w400,
                  fontSize: 17)),
        ),
      ],
    );
  }

  Column createAccount(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    BlocProvider.of<StatusCubit>(context).setDonate();
                  },
                  child: TextWidget(
                      text: "<- ",
                      t_color: c_black,
                      fontWeight: FontWeight.w400,
                      fontSize: 20),
                ),
                TextWidget(
                    text: "Create Account",
                    t_color: c_black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ],
            ),
            InkWell(
              onTap: () {
                BlocProvider.of<StatusCubit>(context).setLogin();
              },
              child: TextWidget(
                  text: "Login Instead",
                  t_color: c_black,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
            ),
          ],
        ),
        Space(height: 20),
        Column(
          children: [
            TextFormField(
              controller: createName,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Name',
                  hintStyle: GoogleFonts.inter(
                          height: 1,
                          color: c_black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18)
                      .copyWith(),
                  border: OutlineInputBorder()),
            ),
            Space(
              height: 10,
            ),
            TextFormField(
              controller: createEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  hintStyle: GoogleFonts.inter(
                          height: 1,
                          color: c_black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18)
                      .copyWith(),
                  border: OutlineInputBorder()),
            ),
            Space(
              height: 10,
            ),
            TextFormField(
              controller: createMobileNumber,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Mobile Number',
                  hintStyle: GoogleFonts.inter(
                          height: 1,
                          color: c_black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18)
                      .copyWith(),
                  border: OutlineInputBorder()),
            ),
            Space(
              height: 10,
            ),
            TextFormField(
              controller: createAddress,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Address',
                  hintStyle: GoogleFonts.inter(
                          height: 1,
                          color: c_black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18)
                      .copyWith(),
                  border: OutlineInputBorder()),
            ),
            Space(
              height: 10,
            ),
            TextFormField(
              controller: createPassword,
              obscureText: true,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  hintStyle: GoogleFonts.inter(
                          height: 1,
                          color: c_black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18)
                      .copyWith(),
                  border: OutlineInputBorder()),
            ),
          ],
        ),
        Space(height: 20),
        Column(
          children: [
            MouseRegion(
              child: InkWell(
                  onTap: () {
                    EasyLoading.show(
                        status: "Please wait...", dismissOnTap: false);
                    if (createName.text.isEmpty ||
                        createEmail.text.isEmpty ||
                        createMobileNumber.text.isEmpty ||
                        createAddress.text.isEmpty ||
                        createPassword.text.isEmpty) {
                      EasyLoading.dismiss();
                      EasyLoading.showToast("Please fill all the fields");
                    } else {
                      if (isEmail(createEmail.text.toString())) {
                        if (createPassword.text.length >= 8) {
                          BlocProvider.of<CreateaccountCubit>(context)
                              .createAccount(
                                  createName.text,
                                  createEmail.text,
                                  createMobileNumber.text,
                                  createAddress.text,
                                  createPassword.text)
                              .then((value) {
                            if (value) {
                              BlocProvider.of<StatusCubit>(context).setLogin();
                              createName.clear();
                              createEmail.clear();
                              createMobileNumber.clear();
                              createAddress.clear();
                              createPassword.clear();
                            }
                          });
                        } else {
                          EasyLoading.showToast(
                              "Minimum password length should be 8");
                        }
                      } else {
                        EasyLoading.dismiss();
                        EasyLoading.showToast("Invalid Email");
                      }
                    }
                  },
                  child: CustomButton(
                      backColor: c_black,
                      text: "Next",
                      c_color: c_white,
                      fontWeight: FontWeight.w400,
                      fontSize: 17)),
            ),
            Space(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  Column SelectDonationAmount(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
            text: "Select Your Donation Amount",
            t_color: c_black,
            fontWeight: FontWeight.w400,
            fontSize: 20),
        Space(height: 30),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3),
          itemCount: amount.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return MouseRegion(
              // onHover: (event){
              //   _clickindex = index;
              //   setState(() {
              //
              //   });
              //
              // },

              child: InkWell(
                onTap: () {
                  _clickindex = index;
                  donationAmount = int.parse(amount[index]["amount"]);
                  customAmount.clear();
                  setState(() {});
                  print(donationAmount);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _clickindex == index ? c_black : c_white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black54,
                          //blurRadius: 1.0,
                          offset: Offset(4, 4))
                    ],
                    border: Border.all(
                      color: c_black,
                    ),
                  ),
                  child: Center(
                      child: TextWidget(
                          text: "₹ ${amount[index]["amount"]}/-",
                          t_color: _clickindex == index ? c_white : c_black,
                          fontWeight: FontWeight.w700,
                          fontSize: getProportionateScreenWidth(15))),
                ),
              ),
            );
          },
        ),
        Space(
          height: 30,
        ),
        InkWell(
          onTap: () {
            _clickindex = 9999;
            donationAmount = 0;
            setState(() {});
          },
          child: TextFormField(
            enabled: _clickindex == 9999 ? true : false,
            controller: customAmount,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (value) {
              donationAmount = int.parse(value.toString());
            },
            decoration: InputDecoration(
                prefix: Text("₹"),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter custom amount',
                hintStyle: GoogleFonts.inter(
                        height: 1,
                        color: c_black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18)
                    .copyWith(),
                border: OutlineInputBorder()),
          ),
        ),
        Space(
          height: 20,
        ),
        MouseRegion(
          child: InkWell(onTap: () async {
            if (donationAmount == 0) {
              EasyLoading.showToast("Select Donation Amount.");
            } else if (donationAmount < 5000) {
              EasyLoading.showToast("Minimum Donation Amount is ₹5000/-");
            } else if (donationAmount != 0 || donationAmount >= 5000) {
              token = await Store.getToken();
              if (token == null) {
                BlocProvider.of<StatusCubit>(context).setCreateAccount();
              } else {
                //do something
                BlocProvider.of<PayNowCubit>(context)
                    .PayNow(donationAmount.toString())
                    .then((value) {
                  // EasyLoading.showToast(value.toString());

                  Razorpay razorpay = Razorpay();

                  var options = value;
                  // var options = {
                  //   //  'key': 'rzp_live_ILgsfZCZoFIKMb', //razor test
                  //   'key': 'rzp_test_VdO7KK713OHMLX', //globizs test
                  //   'amount': 100,
                  //   'name': 'Acme Corp.',
                  //   'description': 'Fine T-Shirt',
                  //   'retry': {'enabled': true, 'max_count': 1},
                  //   'send_sms_hash': true,
                  //   'prefill': {
                  //     'contact': '8888888888',
                  //     'email': 'test@razorpay.com'
                  //   },
                  //   'external': {
                  //     'wallets': ['paytm']
                  //   }
                  // };
                  razorpay.on(
                      Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                      handlePaymentSuccessResponse);
                  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                      handleExternalWalletSelected);
                  razorpay.open(options);
                });
              }
            }
          }, child: BlocBuilder<LoginstatusCubit, LoginstatusState>(
            builder: (context, state) {
              return CustomButton(
                  backColor: c_black,
                  text: state.loginStatus ? "PAY" : "NEXT",
                  c_color: c_white,
                  fontWeight: FontWeight.w400,
                  fontSize: 17);
            },
          )),
        )
      ],
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(
        context,
        "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.toString()}",
        "error");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    print("Payment ID : ${response.paymentId}");
    print("Order ID : ${response.orderId}");
    print("Signature ID : ${response.signature}");

    BlocProvider.of<ConfirmCubit>(context)
        .confirmPayment("${response.paymentId}", "${response.orderId}",
            "${response.signature}")
        .then((value) {
      if (value) {
        // showAlertDialog(
        //     context,
        //     "Payment Successful",
        //     "Payment ID: ${response.paymentId}\n\nOrder ID: ${response.orderId}",
        //     "success");

        BlocProvider.of<BeneficiariesCubit>(context)
            .getBeneficiariesList("${response.paymentId}")
            .then((value) {
          if (value != false) {
            EasyLoading.dismiss();
            // print(value);
            //print(value);
            Map<String, dynamic> resJson = value;

            print(resJson);


            showDialog<void>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: TextWidget(
                      text: "Beneficiaries List",
                      t_color: c_black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 600,
                          child: Column(
                            children: [
                              Container(
                                width: 600,
                                height:
                                getProportionateScreenWidth(
                                    200),
                                child: ListView.builder(
                                    itemCount: resJson["payment_details"].length,
                                    itemBuilder:
                                        (BuildContext
                                    context,
                                        int index) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                            "${resJson["payment_details"][index]["name"]}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color:
                                                c_black,
                                                fontWeight:
                                                FontWeight
                                                    .w700,
                                                fontSize:
                                                15),
                                          ),
                                          trailing:
                                          Text(
                                            "${resJson["payment_details"][index]["amount"]}",
                                            style: TextStyle(
                                                color:
                                                c_black,
                                                fontWeight:
                                                FontWeight
                                                    .w700,
                                                fontSize:
                                                15),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              Space(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .end,
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .end,
                                    children: [
                                      TextWidget(
                                          text:
                                          "Net Amount : ",
                                          t_color:
                                          c_black,
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                          fontSize: 13),
                                      TextWidget(
                                          text:
                                          "Tax : ",
                                          t_color:
                                          c_black,
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                          fontSize: 13),
                                      TextWidget(
                                          text:
                                          "Grand Amount : ",
                                          t_color:
                                          c_black,
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                          fontSize: 13),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .end,
                                    children: [
                                      TextWidget(
                                          text: "${resJson["net_amount"]}",
                                          t_color:
                                          c_black,
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                          fontSize: 13),
                                      TextWidget(
                                          text: "${resJson["tax"]}",
                                          t_color:
                                          c_black,
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                          fontSize: 13),
                                      TextWidget(
                                          text: "${resJson["grand_amount"]}",
                                          t_color:
                                          c_black,
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                          fontSize: 13),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CustomButton(
                          backColor: c_black,
                          text: "Okay",
                          c_color: c_white,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                    ),
                  ],
                );
              },
            );
          }
        });
      }
    });
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(context, "External Wallet Selected",
        "${response.walletName}", "external_account");
  }

  void showAlertDialog(
      BuildContext context, String title, String message, String dialogType) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Okay"),
      onPressed: () {
        if (dialogType == "success") {
          donationAmount = 0;
          _clickindex = 9999;
          BlocProvider.of<StatusCubit>(context).setDonate();
          Navigator.pop(context);
        } else if (dialogType == "error") {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: TextWidget(
          text: title,
          t_color: c_black,
          fontWeight: FontWeight.w700,
          fontSize: 15),
      content: TextWidget(
          text: message,
          t_color: c_black,
          fontWeight: FontWeight.w700,
          fontSize: 15),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertDialogLogout(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("CANCEL"),
      onPressed: () {},
    );

    Widget continueButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: TextWidget(
          text: "Do you want to logout?",
          t_color: c_black,
          fontWeight: FontWeight.w700,
          fontSize: 15),
      // content: TextWidget(text: message, t_color: c_black, fontWeight: FontWeight.w700, fontSize: 15),
      actions: [cancelButton, continueButton],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
