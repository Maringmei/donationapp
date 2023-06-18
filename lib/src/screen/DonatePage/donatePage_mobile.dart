import 'dart:convert';
import 'dart:js_interop';

import 'package:donationapp/src/bloc/HistoryBloc/history_cubit.dart';
import 'package:donationapp/src/bloc/LoginStatus/loginstatus_cubit.dart';
import 'package:donationapp/src/constants/widget_constant/drawer.dart';
import 'package:flutter/foundation.dart';
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
import '../../bloc/SeeMoreBloc/see_mode_cubit.dart';
import '../../bloc/StatusBloc/status_cubit.dart';
import '../../constants/common_constant/check_email.dart';
import '../../constants/common_constant/color_constant.dart';
import '../../constants/common_constant/currency_format.dart';
import '../../constants/common_constant/icons_assets.dart';
import '../../constants/widget_constant/custom_button.dart';
import '../../constants/widget_constant/dialog_widget.dart';
import '../../constants/widget_constant/space.dart';
import '../../constants/widget_constant/text_widget.dart';
import '../../service/Api_url/api_urls.dart';
import 'package:http/http.dart' as http;

import '../../service/BeneUpdate/bene_update_api.dart';

class DonatePageMobile extends StatefulWidget {
  DonatePageMobile({super.key});

  @override
  State<DonatePageMobile> createState() => _DonatePageMobileState();
}

class _DonatePageMobileState extends State<DonatePageMobile> {

  // At the beginning, we fetch the first 20 posts
  int _page = 1;
  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 100000000;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
  List _posts = [];

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    EasyLoading.show(status: "Please Wait...",dismissOnTap: false);
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res =
      await http.get(Uri.parse("${ApiURL.baseUrl}/api/beneficiaries?_page=$_page&_limit=$_limit"));
      setState(() {
        _posts = json.decode(res.body);
      });
      EasyLoading.dismiss();
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        final res =
        await http.get(Uri.parse("${ApiURL.baseUrl}/api/beneficiaries?_page=$_page&_limit=$_limit"));

        final List fetchedPosts = json.decode(res.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    getToken();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }



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
                            text: "Tengbang",
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
                                    DonateNow(context),
                                  if (state.status == 1) createAccount(context),
                                  if (state.status == 2) login(context),
                                  if (state.status == 3)
                                    BeneficiariesList(context),
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

  Expanded BeneficiariesList(BuildContext context) {

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: TextWidget(
              text: "Beneficiaries List",
              t_color: c_black,
              fontWeight: FontWeight.w400,
              fontSize: 23),),

          Space(
            height: 20,
          ),
          Expanded(
            flex: 10,
            child:  AnimationLimiter(
          child: ListView.builder(
          itemCount: _posts.length,
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
                                      child:
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                              text:
                                              "Name : ${_posts[index]['name'].toString()}",
                                              t_color: c_black,
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                              getProportionateScreenWidth(
                                                  14)),
                                          Space(
                                            height: 10,
                                          ),
                                          TextWidget(
                                              text:
                                              "Phone : ${_posts[index]['mobile'].toString()}",
                                              t_color: c_black,
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                              getProportionateScreenWidth(
                                                  14)),
                                          Space(
                                            height: 10,
                                          ),
                                          TextWidget(
                                              text:
                                              "Address : ${_posts[index]['address'].toString()}",
                                              t_color: c_black,
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                              getProportionateScreenWidth(
                                                  14))
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
    )
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
                    BlocProvider.of<StatusCubit>(context).setDonate();
                  },
                  child: CustomButton(
                      backColor: c_black,
                      text: "Donate",
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

  Expanded DonateNow(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
              text: "Donate",
              t_color: c_black,
              fontWeight: FontWeight.w400,
              fontSize: 23),
          Space(
            height: 20,
          ),
          Expanded(
            child: BlocBuilder<SeeModeCubit, SeeModeState>(
              builder: (context, state) {
                if (state is SeeModeInitial) {
                  BlocProvider.of<SeeModeCubit>(context).getSeeMore();
                  return Container();
                }
                if (state is SeeModeLoaded) {
                  // ListView.builder(
                  //   controller: _controller,
                  //   itemCount: _posts.length,
                  //   itemBuilder: (_, index) => SizedBox(
                  //     height: 300,
                  //     child: Card(
                  //       margin: const EdgeInsets.symmetric(
                  //           vertical: 8, horizontal: 10),
                  //       child: ListTile(
                  //         title: Text(_posts[index]['id'].toString()),
                  //         subtitle: Text(_posts[index]['name'].toString()),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  return Column(
                    children: [
                      Expanded(
                          child: AnimationLimiter(
                            child: ListView.builder(
                              //   controller: _controller,
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width / 150),
                              //  padding: EdgeInsets.symmetric(horizontal: 10),
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              itemCount: state.response.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  delay: Duration(milliseconds: 100),
                                  child: SlideAnimation(
                                    duration: Duration(milliseconds: 2500),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: FadeInAnimation(
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        duration: Duration(milliseconds: 2500),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                          child: Container(
                                            width: double.infinity,
                                            //  height: MediaQuery.of(context).size.width / 25,
                                            // decoration: BoxDecoration(
                                            //     color: c_black.withOpacity(0.5),
                                            //     border: Border.all(color: c_black)),
                                            child: Center(
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Card(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 5.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets.all(10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 7,
                                                              child:  Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                TextWidget(
                                                                    text:
                                                                    "Beneficiary ID : ${state.response[index]['beneficiary_id'].toString()}",
                                                                    t_color: c_black,
                                                                    fontWeight:
                                                                    FontWeight.w700,
                                                                    fontSize:
                                                                    getProportionateScreenWidth(
                                                                        10)),
                                                                Space(
                                                                  height: 10,
                                                                ),
                                                                TextWidget(
                                                                    text:
                                                                    "Name : ${state.response[index]['name'].toString()}",
                                                                    t_color: c_black,
                                                                    fontWeight:
                                                                    FontWeight.w700,
                                                                    fontSize:
                                                                    getProportionateScreenWidth(
                                                                        10)),
                                                                Space(
                                                                  height: 10,
                                                                ),
                                                                TextWidget(
                                                                    text:
                                                                    "Phone : ${state.response[index]['mobile'].toString()}",
                                                                    t_color: c_black,
                                                                    fontWeight:
                                                                    FontWeight.w700,
                                                                    fontSize:
                                                                    getProportionateScreenWidth(
                                                                        10)),
                                                                Space(
                                                                  height: 10,
                                                                ),
                                                                TextWidget(
                                                                    text:
                                                                    "Address : ${state.response[index]['address'].toString()}",
                                                                    t_color: c_black,
                                                                    fontWeight:
                                                                    FontWeight.w700,
                                                                    fontSize:
                                                                    getProportionateScreenWidth(
                                                                        10))
                                                              ],
                                                            ),),
                                                            Expanded(
                                                                flex: 3,
                                                                child: SizedBox(
                                                              width: getProportionateScreenWidth(85),
                                                              child:
                                                              ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    foregroundColor:
                                                                    Colors.black,
                                                                    backgroundColor:
                                                                    Colors.green,
                                                                  ),
                                                                  onPressed: () async{
                                                                    showDialog<void>(
                                                                      barrierDismissible:
                                                                      false,
                                                                      context: context,
                                                                      builder:
                                                                          (BuildContext
                                                                      context) {
                                                                        return AlertDialog(
                                                                          title: TextWidget(
                                                                              text:
                                                                              "User Bank Details",
                                                                              t_color:
                                                                              c_black,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w700,
                                                                              fontSize:
                                                                              20),
                                                                          content:
                                                                          Container(
                                                                            width: 600,
                                                                            child: Column(
                                                                              crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                              mainAxisSize:
                                                                              MainAxisSize.min,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: getProportionateScreenWidth(200),
                                                                                  child: TextWidget(
                                                                                      text: "Name : ${state.response[index]["name"]}",
                                                                                      t_color: c_black,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontSize: 14),
                                                                                ),
                                                                                Space(
                                                                                  height:
                                                                                  5,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: getProportionateScreenWidth(200),
                                                                                  child: TextWidget(
                                                                                      text: "Address : ${state.response[index]["address"]}",
                                                                                      t_color: c_black,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontSize: 14),
                                                                                ),
                                                                                Space(
                                                                                  height:
                                                                                  5,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: getProportionateScreenWidth(200),
                                                                                  child: TextWidget(
                                                                                      text: "Mobile : ${state.response[index]["mobile"]}",
                                                                                      t_color: c_black,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontSize: 14),
                                                                                ),
                                                                                Space(
                                                                                  height:
                                                                                  5,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: getProportionateScreenWidth(200),
                                                                                  child: TextWidget(
                                                                                      text: "Bank Name : ${state.response[index]["bank_name"]}",
                                                                                      t_color: c_black,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontSize: 14),
                                                                                ),
                                                                                Space(
                                                                                  height:
                                                                                  5,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: getProportionateScreenWidth(200),
                                                                                  child: TextWidget(
                                                                                      text: "Account Name : ${state.response[index]["account_name"]}",
                                                                                      t_color: c_black,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontSize: 14),
                                                                                ),
                                                                                Space(
                                                                                  height:
                                                                                  5,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: getProportionateScreenWidth(200),
                                                                                  child: TextWidget(
                                                                                      text: "Account Number : ${state.response[index]["account_number"]}",
                                                                                      t_color: c_black,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontSize: 14),
                                                                                ),
                                                                                Space(
                                                                                  height:
                                                                                  5,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: getProportionateScreenWidth(200),
                                                                                  child: TextWidget(
                                                                                      text: "IFSC : ${state.response[index]["ifsc"]}",
                                                                                      t_color: c_black,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontSize: 14),
                                                                                ),
                                                                                Space(
                                                                                  height:
                                                                                  5,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          actions: <Widget>[
                                                                            InkWell(
                                                                              onTap: () async{
                                                                                await Clipboard.setData(ClipboardData(text:
                                                                                "Name : ${state.response[index]["mobile"]}\n"
                                                                                    "Address : ${state.response[index]["address"]}\n"
                                                                                    "Address : ${state.response[index]["address"]}\n"
                                                                                    "Mobile : ${state.response[index]["mobile"]}\n"
                                                                                    "Bank Name : ${state.response[index]["bank_name"]}\n"
                                                                                    "Account Name : ${state.response[index]["account_name"]}\n"
                                                                                    "Account Number : ${state.response[index]["account_number"]}\n"
                                                                                    "IFSC : ${state.response[index]["ifsc"]}\n"
                                                                                )
                                                                                ).then((value) {
                                                                                  EasyLoading.showToast("Copied");
                                                                                });
                                                                                Navigator.pop(
                                                                                    context);
                                                                              },
                                                                              child:CustomButton(
                                                                                  backColor:
                                                                                  c_black,
                                                                                  text:
                                                                                  "Copy",
                                                                                  c_color:
                                                                                  c_white,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .w400,
                                                                                  fontSize:
                                                                                  17),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                    BeneUpdateAPI api = BeneUpdateAPI();
                                                                    await api.BeneUpdateUser("${state.response[index]['id'].toString()}");
                                                                  },
                                                                  child: TextWidget(text: "Donate", t_color: c_white, fontWeight: FontWeight.w500, fontSize: getProportionateScreenWidth(9.5))),
                                                            ) )


                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        )),
                                  ),
                                );
                              },
                            ),
                          )),
                    ],
                  );


                }
                if (state is SeeModeError) {
                  return Container();
                }
                return Container();
              },
            ),
          ),

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
          MouseRegion(

            child: InkWell(
                onTap: () async {
                  // BlocProvider.of<StatusCubit>(context).setDonate();
                  // BlocProvider.of<DashboardCubit>(context).refreshDashboard();
                  BlocProvider.of<SeeModeCubit>(context).getSeeMore();
                },
                child: CustomButton(
                    backColor: c_black,
                    text: "See More",
                    c_color: c_white,
                    fontWeight: FontWeight.w400,
                    fontSize:  17)),
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
                        BlocProvider.of<StatusCubit>(context).setBenificiaries();
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
                      text: "Create",
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
