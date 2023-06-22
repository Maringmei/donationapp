import 'dart:js_interop';

import 'package:donationapp/src/bloc/HistoryBloc/history_cubit.dart';
import 'package:donationapp/src/bloc/LoginStatus/loginstatus_cubit.dart';
import 'package:donationapp/src/bloc/StatusBloc/status_cubit.dart';
import 'package:donationapp/src/constants/widget_constant/space.dart';
import 'package:donationapp/src/constants/widget_constant/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Storage/storage.dart';
import '../../bloc/DashboardBloc/dashboard_cubit.dart';
import '../../bloc/ProfileBloc/profile_cubit.dart';
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
                  backgroundColor: c_white.withOpacity(0.9),
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
                                            text: "Tengbang",
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
                                  Navigator.pop(context);
                                  BlocProvider.of<StatusCubit>(context)
                                      .setDonate();
                                  BlocProvider.of<DashboardCubit>(context)
                                      .refreshDashboard();
                                },
                                hoverColor: Colors.grey[200], // Set hover color
                              ),
                              ListTile(
                                title: TextWidget(
                                    text: "About",
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
                                    text: "Donate",
                                    t_color: c_black_opa,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                                onTap: () {
                                  BlocProvider.of<StatusCubit>(context)
                                      .setDonate();
                                  Navigator.pop(context);
                                },
                                hoverColor: Colors.grey[200], // Set hover color
                              ),
                              BlocBuilder<LoginstatusCubit, LoginstatusState>(
                                builder: (context, state) {
                                  return ListTile(
                                    title: TextWidget(
                                        text: "Beneficiaries",
                                        t_color: c_black_opa,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18),
                                    onTap: () {
                                      if (state.loginStatus) {
                                        Navigator.pop(context);
                                        BlocProvider.of<StatusCubit>(context)
                                            .setBenificiaries();
                                        BlocProvider.of<HistoryCubit>(context)
                                            .refreshHistory();
                                      } else {
                                        BlocProvider.of<StatusCubit>(context)
                                            .setLogin();
                                        Navigator.pop(context);
                                      }
                                    },
                                    hoverColor:
                                        Colors.grey[200], // Set hover color
                                  );
                                },
                              ),
                              BlocBuilder<LoginstatusCubit, LoginstatusState>(
                                builder: (context, state) {
                                  return ListTile(
                                    title: TextWidget(
                                        text: state.loginStatus
                                            ? "Account"
                                            : "Login",
                                        t_color: c_black_opa,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18),
                                    onTap: () async {
                                      if (state.loginStatus) {
                                        Navigator.pop(context);
                                        // await Store.clear(context);
                                        // BlocProvider.of<LoginstatusCubit>(
                                        //     context).setLogout();
                                        BlocProvider.of<StatusCubit>(context).setProfile();
                                        // BlocProvider.of<ProfileCubit>(context)
                                        //     .getProfileData().then((value){
                                        //       BlocProvider.of<StatusCubit>(context).setProfile();
                                        // });

                                        // showAlertDialogLogout(context);
                                      } else {
                                        BlocProvider.of<StatusCubit>(context)
                                            .setLogin();
                                        Navigator.pop(context);
                                      }
                                    },
                                    hoverColor:
                                        Colors.grey[200], // Set hover color
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            )));
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
        Navigator.pop(context);
      },
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
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
