import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:donationapp/src/bloc/StatusBloc/status_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../service/Login/loginservice.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial(message: "Init"));

  Future<bool> login(email, password,context) async {
    EasyLoading.show(status: "Logging in...");
    LoginAPI api = LoginAPI();
    final res = await api.LoginUser(email,password,context).then((value) {
      EasyLoading.dismiss();
      if (value) {

      }
      else {
        // Cloading("")
        return false;
      }
      return value;
    });
    return res;
  }
}