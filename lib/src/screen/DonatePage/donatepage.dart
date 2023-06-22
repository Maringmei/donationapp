import 'dart:convert';
import 'dart:js_interop';

import 'package:donationapp/src/bloc/ConfirmBloc/confirm_cubit.dart';
import 'package:donationapp/src/bloc/DashboardBloc/dashboard_cubit.dart';
import 'package:donationapp/src/bloc/HistoryBloc/history_cubit.dart';
import 'package:donationapp/src/bloc/LoginBloc/login_cubit.dart';
import 'package:donationapp/src/bloc/LoginStatus/loginstatus_cubit.dart';
import 'package:donationapp/src/bloc/PayNowBloc/pay_now_cubit.dart';
import 'package:donationapp/src/bloc/ProfileBloc/profile_cubit.dart';
import 'package:donationapp/src/bloc/StatusBloc/status_cubit.dart';
import 'package:donationapp/src/bloc/UpdateProfileBloc/update_profile_cubit.dart';
import 'package:donationapp/src/constants/common_constant/icons_assets.dart';
import 'package:donationapp/src/service/BeneUpdate/bene_update_api.dart';
import 'package:donationapp/src/service/ProfileApi/profile_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_web/razorpay_web.dart';

import '../../../SizedConfig.dart';
import '../../Storage/storage.dart';
import '../../bloc/BeneficiariesBLoc/beneficiaries_cubit.dart';
import '../../bloc/CreateAccountBloc/createaccount_cubit.dart';
import '../../bloc/SeeMoreBloc/see_mode_cubit.dart';
import '../../constants/common_constant/check_email.dart';
import '../../constants/common_constant/color_constant.dart';
import '../../constants/common_constant/currency_format.dart';
import '../../constants/common_constant/font_style.dart';
import '../../constants/payment/payment.dart';
import '../../constants/widget_constant/custom_button.dart';
import '../../constants/widget_constant/dialog_widget.dart';
import '../../constants/widget_constant/space.dart';
import '../../constants/widget_constant/text_widget.dart';
import '../../models/post.dart';
import '../../models/post_model.dart';
import '../../service/Api_url/api_urls.dart';
import 'donatePage_mobile.dart';
import 'package:http/http.dart' as http;

class DonatePage extends StatefulWidget {
  DonatePage({Key? key}) : super(key: key);

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  // At the beginning, we fetch the first 20 posts
  int _page = 1;
  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 10;

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
    // EasyLoading.show(status: "Please Wait...", dismissOnTap: false);
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res = await http.get(Uri.parse(
          "${ApiURL.baseUrl}/api/beneficiaries?_page=$_page&_limit=$_limit"));
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
        final res = await http.get(Uri.parse(
            "${ApiURL.baseUrl}/api/beneficiaries?_page=$_page&_limit=$_limit"));

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

  bool updateEnable = false;

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

  List amount = [
    {"amount": "5000"},
    {"amount": "10000"},
    {"amount": "15000"},
    {"amount": "50000"},
    {"amount": "100000"},
  ];

  bool _isHover = false;
  bool _isHoverLogout = false;
  int? _clickindex = 99999;
  int? _hoverindex = 99999;
  bool _checkBox = false;

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

  //profile
  TextEditingController profileName = TextEditingController();
  TextEditingController profileEmail = TextEditingController();
  TextEditingController profileMobileNumber = TextEditingController();
  TextEditingController profileAddress = TextEditingController();
  TextEditingController profilePassword = TextEditingController();

  bool _home = false;
  bool _about = false;
  bool _donate = false;
  bool _bene = false;
  bool _login = false;


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final screenW = MediaQuery.of(context).size.width;

    return screenW >= 1000
        ? Scaffold(
            body: Stack(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      "assets/images/donatebackground.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                        child: Image.asset(
                      "assets/images/transparent.png",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                    ))
                  ],
                ),
                Positioned(
                    child: Container(
                  padding: EdgeInsets.only(top: 40, right: 50, left: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                                text: "Mateng",
                                t_color: c_white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                            Row(
                              children: [
                                MouseRegion(
                                  onEnter: (value) {
                                    _home = true;
                                    setState(() {});
                                  },
                                  onExit: (value) {
                                    _home = false;
                                    setState(() {});
                                  },
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      BlocProvider.of<StatusCubit>(context)
                                          .setDonate();
                                      BlocProvider.of<DashboardCubit>(context)
                                          .refreshDashboard();
                                    },
                                    child: TextWidget(
                                        text: "Home",
                                        t_color:
                                            _home == true ? c_gold : c_white,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            MediaQuery.of(context).size.width >=
                                                    1500
                                                ? 15
                                                : 12),
                                  ),
                                ),
                                Space(
                                  width: 10,
                                ),
                                MouseRegion(
                                  onEnter: (value) {
                                    _about = true;
                                    setState(() {});
                                  },
                                  onExit: (value) {
                                    _about = false;
                                    setState(() {});
                                  },
                                  child: InkWell(
                                    onTap: () {},
                                    child: TextWidget(
                                        text: "About",
                                        t_color:
                                            _about == true ? c_gold : c_white,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            MediaQuery.of(context).size.width >=
                                                    1500
                                                ? 15
                                                : 12),
                                  ),
                                ),
                                Space(
                                  width: 10,
                                ),
                                BlocBuilder<LoginstatusCubit, LoginstatusState>(
                                  builder: (context, state) {
                                    return MouseRegion(
                                      onEnter: (value) {
                                        _donate = true;
                                        setState(() {});
                                      },
                                      onExit: (value) {
                                        _donate = false;
                                        setState(() {});
                                      },
                                      child: InkWell(
                                        onTap: () {
                                          if (state.loginStatus) {
                                            BlocProvider.of<StatusCubit>(
                                                    context)
                                                .setDonate();
                                          } else {
                                            BlocProvider.of<StatusCubit>(
                                                    context)
                                                .setLogin();
                                          }
                                        },
                                        child: TextWidget(
                                            text: "Donate",
                                            t_color: _donate == true
                                                ? c_gold
                                                : c_white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >=
                                                    1500
                                                ? 15
                                                : 12),
                                      ),
                                    );
                                  },
                                ),
                                Space(
                                  width: 10,
                                ),
                                BlocBuilder<LoginstatusCubit, LoginstatusState>(
                                  builder: (context, state) {
                                    return MouseRegion(
                                      onEnter: (value) {
                                        _bene = true;
                                        setState(() {});
                                      },
                                      onExit: (value) {
                                        _bene = false;
                                        setState(() {});
                                      },
                                      child: InkWell(
                                        onTap: () {
                                          if (state.loginStatus) {
                                            BlocProvider.of<StatusCubit>(
                                                    context)
                                                .setBenificiaries();
                                            // BlocProvider.of<HistoryCubit>(context)
                                            //     .refreshHistory();
                                          } else {
                                            BlocProvider.of<StatusCubit>(
                                                    context)
                                                .setLogin();
                                          }
                                        },
                                        child: TextWidget(
                                            text: "Benefiaciaries",
                                            t_color: _bene == true
                                                ? c_gold
                                                : c_white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >=
                                                    1500
                                                ? 15
                                                : 12),
                                      ),
                                    );
                                  },
                                ),
                                Space(
                                  width: 10,
                                ),
                                BlocBuilder<LoginstatusCubit, LoginstatusState>(
                                  builder: (context, state) {
                                    return MouseRegion(
                                      onEnter: (value) {
                                        _login = true;
                                        setState(() {});
                                      },
                                      onExit: (value) {
                                        _login = false;
                                        setState(() {});
                                      },
                                      child: InkWell(
                                        onTap: () {
                                          // profileName.text = "Maringmei";
                                          if (state.loginStatus) {
                                            // showAlertDialogLogout(context);
                                            BlocProvider.of<ProfileCubit>(
                                                    context)
                                                .getProfileData()
                                                .then((value) {
                                              if (value != false) {
                                                //profile
                                                 profileName.text = value["name"];
                                                 profileAddress.text =  value["address"];
                                                 profileEmail.text = value["email"];
                                                 profileMobileNumber.text = value["mobile"];

                                                BlocProvider.of<StatusCubit>(
                                                        context)
                                                    .setProfile();
                                              }
                                            });
                                          } else {
                                            BlocProvider.of<StatusCubit>(
                                                    context)
                                                .setLogin();
                                          }
                                        },
                                        child: TextWidget(
                                            text: state.loginStatus
                                                ? "Account"
                                                : "Login",
                                            t_color: _login == true
                                                ? c_gold
                                                : c_white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >=
                                                    1500
                                                ? 15
                                                : 12),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                      text: "- Donation",
                                      t_color: c_white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22),
                                  Space(
                                    height: 20,
                                  ),
                                  TextWidget(
                                      text:
                                          "Don't Let Poverty Destroy\nSomeone's Dreams",
                                      t_color: c_white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 33),
                                ],
                              )),
                          Expanded(
                              flex: 3,
                              child: Container(
                                  padding: EdgeInsets.all(40),
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height / 1.3,
                                  color: Colors.white.withOpacity(1),
                                  child: BlocBuilder<StatusCubit, StatusState>(
                                    builder: (context, state) {
                                      return Column(
                                        children: [
                                          if (state.status == 0)
                                            DonateNow(context),
                                          if (state.status == 1)
                                            CreateAccount(context),
                                          if (state.status == 2) Login(context),
                                          if (state.status == 3)
                                            BeneficiariesList(context),
                                          if (state.status == 4)
                                            Profile(context)
                                        ],
                                      );
                                    },
                                  )))
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
          )
        : DonatePageMobile();
  }

//HHH
  Expanded DonateNow(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
              text: "Donate",
              t_color: c_black,
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width >= 1500 ? 23 : 20),
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
                                                child: Column(
                                                  children: [
                                                    MediaQuery.of(context)
                                                                .size
                                                                .width >=
                                                            1500
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                flex: 7,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    TextWidget(
                                                                        text:
                                                                            "Beneficiary ID : ${state.response[index]['beneficiary_id'].toString()}",
                                                                        t_color:
                                                                            c_black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            getProportionateScreenWidth(2.5)),
                                                                    Space(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    TextWidget(
                                                                        text:
                                                                            "Name :  ${state.response[index]['name'].toString()}",
                                                                        t_color:
                                                                            c_black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            getProportionateScreenWidth(2.5)),
                                                                    Space(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    TextWidget(
                                                                        text:
                                                                            "Phone : ${state.response[index]['mobile'].toString()}",
                                                                        t_color:
                                                                            c_black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            getProportionateScreenWidth(2.5)),
                                                                    Space(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    TextWidget(
                                                                        text:
                                                                            "Address : ${state.response[index]['address'].toString()}",
                                                                        t_color:
                                                                            c_black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            getProportionateScreenWidth(2.5)),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 3,
                                                                  child:
                                                                      SizedBox(
                                                                    width:
                                                                        getProportionateScreenWidth(
                                                                            15),
                                                                    child: ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          foregroundColor:
                                                                              Colors.white,
                                                                          backgroundColor: Colors
                                                                              .black
                                                                              .withOpacity(0.5),
                                                                        ),
                                                                        onPressed: () async {
                                                                          showDialog<
                                                                              void>(
                                                                            barrierDismissible:
                                                                                false,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return AlertDialog(
                                                                                title: TextWidget(text: "User Bank Details", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 20),
                                                                                content: Container(
                                                                                  width: 600,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Name : ${state.response[index]["name"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Address : ${state.response[index]["address"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Mobile : ${state.response[index]["mobile"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Bank Name : ${state.response[index]["bank_name"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Account Name : ${state.response[index]["account_name"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Account Number : ${state.response[index]["account_number"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "IFSC : ${state.response[index]["ifsc"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                actions: <Widget>[
                                                                                  InkWell(
                                                                                    onTap: () async {
                                                                                      await Clipboard.setData(ClipboardData(
                                                                                              text: "Name : ${state.response[index]["mobile"]}\n"
                                                                                                  "Address : ${state.response[index]["address"]}\n"
                                                                                                  "Address : ${state.response[index]["address"]}\n"
                                                                                                  "Mobile : ${state.response[index]["mobile"]}\n"
                                                                                                  "Bank Name : ${state.response[index]["bank_name"]}\n"
                                                                                                  "Account Name : ${state.response[index]["account_name"]}\n"
                                                                                                  "Account Number : ${state.response[index]["account_number"]}\n"
                                                                                                  "IFSC : ${state.response[index]["ifsc"]}\n"))
                                                                                          .then((value) {
                                                                                        EasyLoading.showToast("Copied");
                                                                                      });
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: CustomButton(backColor: c_black, text: "Copy", c_color: c_white, fontWeight: FontWeight.w400, fontSize: 17),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                          BeneUpdateAPI
                                                                              api =
                                                                              BeneUpdateAPI();
                                                                          await api.BeneUpdateUser(
                                                                              "${state.response[index]['id'].toString()}");
                                                                        },
                                                                        child: TextWidget(text: "Donate", t_color: c_white, fontWeight: FontWeight.w600, fontSize: getProportionateScreenWidth(2.5))),
                                                                  ))
                                                            ],
                                                          )
                                                        : Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      getProportionateScreenWidth(
                                                                          70),
                                                                  child: TextWidget(
                                                                      text:
                                                                          "Beneficiary ID :  ${state.response[index]['beneficiary_id'].toString()}",
                                                                      t_color:
                                                                          c_black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          getProportionateScreenWidth(
                                                                              2.5)),
                                                                ),
                                                                Space(
                                                                  height: 10,
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      getProportionateScreenWidth(
                                                                          70),
                                                                  child: TextWidget(
                                                                      text:
                                                                          "Name :  ${state.response[index]['name'].toString()}",
                                                                      t_color:
                                                                          c_black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          getProportionateScreenWidth(
                                                                              2.5)),
                                                                ),
                                                                Space(
                                                                  height: 10,
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      getProportionateScreenWidth(
                                                                          70),
                                                                  child: TextWidget(
                                                                      text:
                                                                          "Phone : ${state.response[index]['mobile'].toString()}",
                                                                      t_color:
                                                                          c_black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          getProportionateScreenWidth(
                                                                              2.5)),
                                                                ),
                                                                Space(
                                                                  height: 10,
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      getProportionateScreenWidth(
                                                                          70),
                                                                  child: TextWidget(
                                                                      text:
                                                                          "Address : ${state.response[index]['address'].toString()}",
                                                                      t_color:
                                                                          c_black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          getProportionateScreenWidth(
                                                                              2.5)),
                                                                ),
                                                                Space(
                                                                  height: 10,
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      SizedBox(
                                                                    width: double
                                                                        .infinity,
                                                                    height: 25,
                                                                    child: ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          foregroundColor:
                                                                              Colors.white,
                                                                          backgroundColor: Colors
                                                                              .black
                                                                              .withOpacity(0.5),
                                                                        ),
                                                                        onPressed: () async {
                                                                          showDialog<
                                                                              void>(
                                                                            barrierDismissible:
                                                                                false,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return AlertDialog(
                                                                                title: TextWidget(text: "User Bank Details", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 20),
                                                                                content: Container(
                                                                                  width: 600,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Name : ${state.response[index]["name"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Address : ${state.response[index]["address"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Mobile : ${state.response[index]["mobile"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Bank Name : ${state.response[index]["bank_name"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Account Name : ${state.response[index]["account_name"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "Account Number : ${state.response[index]["account_number"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: getProportionateScreenWidth(200),
                                                                                        child: TextWidget(text: "IFSC : ${state.response[index]["ifsc"]}", t_color: c_black, fontWeight: FontWeight.w700, fontSize: 14),
                                                                                      ),
                                                                                      Space(
                                                                                        height: 5,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                actions: <Widget>[
                                                                                  InkWell(
                                                                                    onTap: () async {
                                                                                      await Clipboard.setData(ClipboardData(
                                                                                              text: "Name : ${state.response[index]["mobile"]}\n"
                                                                                                  "Address : ${state.response[index]["address"]}\n"
                                                                                                  "Address : ${state.response[index]["address"]}\n"
                                                                                                  "Mobile : ${state.response[index]["mobile"]}\n"
                                                                                                  "Bank Name : ${state.response[index]["bank_name"]}\n"
                                                                                                  "Account Name : ${state.response[index]["account_name"]}\n"
                                                                                                  "Account Number : ${state.response[index]["account_number"]}\n"
                                                                                                  "IFSC : ${state.response[index]["ifsc"]}\n"))
                                                                                          .then((value) {
                                                                                        EasyLoading.showToast("Copied");
                                                                                      });
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: CustomButton(backColor: c_black, text: "Copy", c_color: c_white, fontWeight: FontWeight.w400, fontSize: 17),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                          BeneUpdateAPI
                                                                              api =
                                                                              BeneUpdateAPI();
                                                                          await api.BeneUpdateUser(
                                                                              "${state.response[index]['id'].toString()}");
                                                                        },
                                                                        child: TextWidget(text: "Donate", t_color: c_white, fontWeight: FontWeight.w600, fontSize: getProportionateScreenWidth(4))),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
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
          Space(
            height: 20,
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
                onTap: () async {
                  // BlocProvider.of<StatusCubit>(context).setDonate();
                  // BlocProvider.of<DashboardCubit>(context).refreshDashboard();
                  BlocProvider.of<SeeModeCubit>(context).getSeeMore();
                },
                child: CustomButton(
                    backColor: c_black.withOpacity(0.5),
                    text: "See More",
                    c_color: c_white,
                    fontWeight: FontWeight.w400,
                    fontSize: _isHover == true ? 16 : 15)),
          ),
          Space(
            height: 20,
          ),
        ],
      ),
    );
  }

  Expanded BeneficiariesList(BuildContext context) {
    if (_posts.length == 0) {
      // EasyLoading.show(status: "Please Wait",dismissOnTap: false);
      return Expanded(child: Container());
    }
    if (_posts.length != 0) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
                text: "Beneficiaries List",
                t_color: c_black,
                fontWeight: FontWeight.w400,
                fontSize: MediaQuery.of(context).size.width >= 1500 ? 23 : 20),
            Space(
              height: 20,
            ),
            Expanded(
                child: Column(
              children: [
                Expanded(
                    child: AnimationLimiter(
                  child: ListView.builder(
                    controller: _controller,
                    padding:
                        EdgeInsets.all(MediaQuery.of(context).size.width / 150),
                    //  padding: EdgeInsets.symmetric(horizontal: 10),
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: _posts.length,
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
                                padding: EdgeInsets.only(bottom: 8.0),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width:
                                                    getProportionateScreenWidth(
                                                        150),
                                                child: TextWidget(
                                                    text:
                                                        "Name : ${_posts[index]['name'].toString()}",
                                                    t_color: c_black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            3)),
                                              ),
                                              Space(
                                                height: 10,
                                              ),
                                              // SizedBox(
                                              //   width:
                                              //       getProportionateScreenWidth(
                                              //           150),
                                              //   child: TextWidget(
                                              //       text:
                                              //           "Phone : ${_posts[index]['mobile'].toString()}",
                                              //       t_color: c_black,
                                              //       fontWeight: FontWeight.w500,
                                              //       fontSize:
                                              //           getProportionateScreenWidth(
                                              //               3)),
                                              // ),
                                              // Space(
                                              //   height: 10,
                                              // ),
                                              SizedBox(
                                                width:
                                                    getProportionateScreenWidth(
                                                        150),
                                                child: TextWidget(
                                                    text:
                                                        "Address : ${_posts[index]['address'].toString()}",
                                                    t_color: c_black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            3)),
                                              )
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
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: LinearProgressIndicator(),
                    ),
                  ),
                if (_hasNextPage == false) Container(),
              ],
            )),
            Space(
              height: 20,
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
                  onTap: () async {
                    // bool res = await showDialog(
                    //     barrierDismissible: false,
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return CustomDialog(context, "Sucess",
                    //           "You have sucessfully\n\nDonated ₹ 1,00,000/- ");
                    //     });
                    // if (res) {
                    //   BlocProvider.of<StatusCubit>(context).setDonate();
                    // }
                    BlocProvider.of<StatusCubit>(context).setDonate();
                    //BlocProvider.of<DashboardCubit>(context).refreshDashboard();
                  },
                  child: CustomButton(
                      backColor: c_black.withOpacity(0.5),
                      text: "Donate",
                      c_color: c_white,
                      fontWeight: FontWeight.w400,
                      fontSize: _isHover == true ? 16 : 15)),
            ),
            Space(
              height: 20,
            ),
          ],
        ),
      );
    }
    return Expanded(child: Container());
  }

  Column Login(BuildContext context) {
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
                fontSize: MediaQuery.of(context).size.width >= 1500 ? 20 : 17),
            InkWell(
              onTap: () {
                BlocProvider.of<StatusCubit>(context).setCreateAccount();
              },
              child: TextWidget(
                  text: "Create Account",
                  t_color: c_black,
                  fontWeight: FontWeight.w700,
                  fontSize:
                      MediaQuery.of(context).size.width >= 1500 ? 15 : 13),
            ),
          ],
        ),
        Space(height: 20),
        Column(
          children: [
            TextFormField(
              controller: loginEmail,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  hintStyle: GoogleFonts.inter(
                          height: 1,
                          color: c_black,
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.width >= 1500
                              ? 18
                              : 12)
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
                          fontSize: MediaQuery.of(context).size.width >= 1500
                              ? 18
                              : 12)
                      .copyWith(),
                  border: OutlineInputBorder()),
            ),
          ],
        ),
        Space(height: 20),
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
                        BlocProvider.of<StatusCubit>(context)
                            .setDonate();
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
                  backColor: c_black.withOpacity(0.5),
                  text: "Login",
                  c_color: c_white,
                  fontWeight: FontWeight.w400,
                  fontSize: _isHover == true ? 17 : 15)),
        ),
      ],
    );
  }

  Column CreateAccount(BuildContext context) {
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
                      backColor: c_black.withOpacity(0.5),
                      text: "Create",
                      c_color: c_white,
                      fontWeight: FontWeight.w400,
                      fontSize: _isHover == true ? 19 : 17)),
            ),
            Space(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  Column Profile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                TextWidget(
                    text: "Profile",
                    t_color: c_black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ],
            ),
            // InkWell(
            //   onTap: () {
            //     BlocProvider.of<StatusCubit>(context).setLogin();
            //   },
            //   child: TextWidget(
            //       text: "Login Instead",
            //       t_color: c_black,
            //       fontWeight: FontWeight.w700,
            //       fontSize: 15),
            // ),
          ],
        ),
        Space(height: 20),
        Column(
          children: [
            TextFormField(
              controller: profileName,
              style: custom_font(c_black,FontWeight.w500,15),

              decoration: InputDecoration(
                  enabled: updateEnable,
                label: TextWidget(text: "Name", t_color: c_black, fontWeight: FontWeight.w600, fontSize: 15),
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
              controller: profileEmail,
              style: custom_font(c_black,FontWeight.w500,15),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  enabled: false,
                  label: TextWidget(text: "Email", t_color: c_black, fontWeight: FontWeight.w600, fontSize: 15),
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
              controller: profileMobileNumber,
              style: custom_font(c_black,FontWeight.w500,15),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  enabled: updateEnable,
                  label: TextWidget(text: "Mobile Number", t_color: c_black, fontWeight: FontWeight.w600, fontSize: 15),
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
              controller: profileAddress,
              style: custom_font(c_black,FontWeight.w500,15),
              decoration: InputDecoration(
                  enabled: updateEnable,
                  label: TextWidget(text: "Address", t_color: c_black, fontWeight: FontWeight.w600, fontSize: 15),
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
          ],
        ),
        Space(height: 20),
        Column(
          children: [
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
                    if (createName.text.isEmpty ||
                        createMobileNumber.text.isEmpty ||
                        createAddress.text.isEmpty) {
                      EasyLoading.dismiss();
                      EasyLoading.showToast("Please fill all the fields");
                    } else {
                      if(!updateEnable){
                        setState(() {
                          updateEnable = true;
                        });
                      }else if(updateEnable){
                        BlocProvider.of<UpdateProfileCubit>(context).updateProfile(profileName.text, profileMobileNumber.text, profileAddress.text).then((value){
                          if(value){
                            updateEnable = false;
                            setState(() {

                            });
                          }
                        });
                      }
                    }
                  },
                  child: CustomButton(
                      backColor: c_black.withOpacity(0.5),
                      text: updateEnable == true ? "Update" : "Edit",
                      c_color: c_white,
                      fontWeight: FontWeight.w400,
                      fontSize: _isHover == true ? 19 : 17)),
            ),
            Space(
              height: 20,
            ),
            MouseRegion(
              onHover: (event) {
                setState(() {
                  _isHoverLogout = true;
                });
              },
              onExit: (event) {
                setState(() {
                  _isHoverLogout = false;
                });
              },
              child: InkWell(
                  onTap: () {
                    showAlertDialogLogout(context);
                  },
                  child: CustomButton(
                      backColor: c_black.withOpacity(0.5),
                      text: "Logout",
                      c_color: c_white,
                      fontWeight: FontWeight.w400,
                      fontSize: _isHoverLogout == true ? 19 : 17)),
            ),
          ],
        ),
      ],
    );
  }

  String? token;
  void getToken() async {
    token = await Store.getToken();
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
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget continueButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () async {
        await Store.clear(context);
        BlocProvider.of<LoginstatusCubit>(context).setLogout();
        BlocProvider.of<StatusCubit>(context).setLogin();
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: SizedBox(
        height: 100,
        width: 100,
        child: TextWidget(
            text: "Do you want to logout?",
            t_color: c_black,
            fontWeight: FontWeight.w700,
            fontSize: 15),
      ),

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
